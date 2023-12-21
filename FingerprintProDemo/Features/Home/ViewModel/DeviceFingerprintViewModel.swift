import Combine

extension DeviceFingerprintViewModel {

    enum FingerprintingState: Equatable {
        case executing
        case completed(viewModel: ClientResponseEventViewModel)
        case failed(error: PresentableError)
        case undefined
    }
}

@MainActor
final class DeviceFingerprintViewModel: ObservableObject {

    @Published private(set) var fingerprintingState: FingerprintingState = .undefined

    private let identificationService: any DeviceIdentificationServiceProtocol

    init(identificationService: any DeviceIdentificationServiceProtocol) {
        self.identificationService = identificationService
    }
}

extension DeviceFingerprintViewModel {

    func fingerprintDevice() async {
        guard fingerprintingState != .executing else { return }

        fingerprintingState = .executing

        async let throttleTask: Void = Task.sleep(for: .milliseconds(500))
        async let fingerprintTask = identificationService.fingerprintDevice()
            .map(ClientResponseEventViewModel.init(response:))
            .mapError { _ -> PresentableError in .unknownError }

        try? await throttleTask

        let result = await fingerprintTask
        switch result {
        case let .success(viewModel):
            fingerprintingState = .completed(viewModel: viewModel)
        case let .failure(error):
            fingerprintingState = .failed(error: error)
        }
    }
}

private extension PresentableError {

    static var unknownError: Self {
        .init(
            image: .exclamationMark,
            localizedTitle: .init(localized: "That was unexpected..."),
            localizedDescription: .init(
                localized: """
                             Failed to Fingerprint. Please [contact support](\(C.URLs.support, format: .url)) \
                             if this issue persists.
                             """
            )
        )
    }
}
