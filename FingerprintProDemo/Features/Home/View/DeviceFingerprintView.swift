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
                await viewModel.fingerprintDevice()
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
        viewModel: .init(identificationService: .default)
    )
}

#Preview("Extended Response") {
    DeviceFingerprintView(
        presentation: .extendedResponse,
        viewModel: .init(identificationService: .default)
    )
}
