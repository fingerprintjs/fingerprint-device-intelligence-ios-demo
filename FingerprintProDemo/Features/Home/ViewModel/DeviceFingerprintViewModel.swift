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

        try? await throttleTask

        let result = await fingerprintTask
            .map(ClientResponseEventViewModel.init(response:))
            .mapError(PresentableError.init(from:))
        switch result {
        case let .success(viewModel):
            fingerprintingState = .completed(viewModel: viewModel)
        case let .failure(error):
            fingerprintingState = .failed(error: error)
        }
    }
}
