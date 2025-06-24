import SwiftUI

struct DeviceFingerprintView<Presentation: EventPresentability>: View {

    typealias ViewModel = DeviceFingerprintViewModel

    private typealias VisualState = EventDetailsVisualState<Presentation.ItemKey>

    @Environment(\.openURL) private var openURL
    @Environment(\.deepLink) private var deepLink

    @State private var state: VisualState = .loading
    @State private var showSignupView: Bool = false

    private let presentation: Presentation
    @ObservedObject private var viewModel: ViewModel

    init(presentation: Presentation, viewModel: ViewModel) {
        self.presentation = presentation
        self.viewModel = viewModel
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                EventDetailsView(
                    presentation: presentation,
                    state: $state
                ) {
                    if showSignupView {
                        signupView
                    }
                }
                .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                .padding(.horizontal, 16.0)
            }
            .onAppear {
                viewModel.viewDidAppear()
            }
            .task {
                guard viewModel.fingerprintingState == .undefined else { return }
                await viewModel.fingerprintDevice()
            }
            .refreshable {
                // There is a bug in SwiftUI, which causes the refresh action to
                // get cancelled when the associated view is redrawn (i.e. as a result of
                // receiving state update from the observed object).
                // A workaround is to wrap the asynchronous call in a new task and wait for
                // it to complete.
                // This bug was once fixed by Apple in iOS 17.0 - 17.3.1, and then reintroduced
                // in iOS 17.4 ¯\_(ツ)_/¯
                await Task {
                    await viewModel.fingerprintDevice()
                }.value
            }
            .onReceive(viewModel.$fingerprintingState, perform: handleFingerprintingState)
            .onReceive(viewModel.$shouldShowSignUp) { value in
                withAnimation {
                    showSignupView = value
                }
            }
        }
    }
}

private extension DeviceFingerprintView {

    @ViewBuilder
    var signupView: some View {
        CallToActionView(
            title: "Impressed with Fingerprint?",
            description: "Check our website for more info.",
            primaryButtonTitle: "Learn more",
            primaryAction: {
                openURL(C.URLs.signUp)
            },
            secondaryButtonTitle: "Don’t show again for a week",
            secondaryAction: {
                viewModel.hideSignUp()
            }
        )
        .transition(.asymmetric(insertion: .scale, removal: .opacity))
    }
}

private extension DeviceFingerprintView {

    func handleFingerprintingState(_ state: ViewModel.FingerprintingState) {
        withAnimation {
            switch state {
            case .executing:
                self.state = .loading
            case let .completed(viewModel):
                self.state = .presenting(
                    itemValue: viewModel.itemValue(forKey:),
                    rawDetails: viewModel.rawEventRepresentation
                )
            case let .failed(error):
                self.state = .error(
                    error,
                    action: {
                        switch error.actionKind {
                        case .editApiKeys: { deepLink(to: .settings(.apiKeys)) }
                        case .retry: { Task { await viewModel.fingerprintDevice() } }
                        }
                    }()
                )
            case .undefined:
                break
            }
        }
    }
}

// MARK: Previews

#if DEBUG

#Preview("Basic Response") {
    DeviceFingerprintView(presentation: .basicResponse, viewModel: .preview)
}

#Preview("Extended Response") {
    DeviceFingerprintView(presentation: .extendedResponse, viewModel: .preview)
}

#endif
