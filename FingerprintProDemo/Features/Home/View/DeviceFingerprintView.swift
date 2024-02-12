import SwiftUI

struct DeviceFingerprintView<Presentation: EventPresentability>: View {

    typealias ViewModel = DeviceFingerprintViewModel

    private typealias EventDetailsVisualState = EventDetailsView<Presentation>.VisualState

    @State private var eventDetailsState: EventDetailsVisualState = .loading

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
                    state: $eventDetailsState
                )
                .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                .padding(.horizontal, 16.0)
            }
            .task {
                await viewModel.fingerprintDevice()
            }
            .refreshable {
                if #available(iOS 17, *) {
                    await viewModel.fingerprintDevice()
                } else {
                    // On iOS 16, there is a bug in SwiftUI, which causes the refresh action to
                    // get cancelled when the associated view is redrawn (i.e. as a result of
                    // receiving state update from the observed object).
                    // A workaround is to wrap the asynchronous call in a new task and wait for
                    // it to complete.
                    await Task {
                        await viewModel.fingerprintDevice()
                    }.value
                }
            }
            .onReceive(viewModel.$fingerprintingState, perform: handleFingerprintingState)
        }
    }
}

private extension DeviceFingerprintView {

    func handleFingerprintingState(_ state: ViewModel.FingerprintingState) {
        withAnimation {
            switch state {
            case .executing:
                eventDetailsState = .loading
            case let .completed(viewModel):
                eventDetailsState = .presenting(
                    fieldValue: viewModel.fieldValue(forKey:),
                    rawDetails: viewModel.rawEventRepresentation
                )
            case let .failed(error):
                eventDetailsState = .error(
                    error,
                    retryAction: {
                        Task {
                            await viewModel.fingerprintDevice()
                        }
                    }
                )
            case .undefined:
                break
            }
        }
    }
}

// MARK: Previews

#Preview("Basic Response") {
    DeviceFingerprintView(
        presentation: .basicResponse,
        viewModel: .init(identificationService: .preview)
    )
}

#Preview("Extended Response") {
    DeviceFingerprintView(
        presentation: .extendedResponse,
        viewModel: .init(identificationService: .preview)
    )
}
