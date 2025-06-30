import Combine
import FingerprintPro
import Foundation

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

    private nonisolated let identificationService: any DeviceIdentificationServiceProtocol
    private nonisolated let smartSignalsService: (any SmartSignalsServiceProtocol)?
    private nonisolated let geolocationService: any GeolocationServiceProtocol
    private nonisolated let settingsContainer: SettingsContainer

    init(
        identificationService: any DeviceIdentificationServiceProtocol = .default,
        smartSignalsService: (any SmartSignalsServiceProtocol)? = .default,
        geolocationService: any GeolocationServiceProtocol = .default,
        settingsContainer: SettingsContainer = .default
    ) {
        self.identificationService = identificationService
        self.smartSignalsService = smartSignalsService
        self.geolocationService = geolocationService
        self.settingsContainer = settingsContainer
    }
}

extension DeviceFingerprintViewModel {

    func viewDidAppear() {
        guard case .completed = fingerprintingState else { return }
    }

    func fingerprintDevice() async {
        guard fingerprintingState != .executing else { return }

        fingerprintingState = .executing

        async let throttleTask: Void = Task.sleep(for: .milliseconds(500))
        async let fingerprintTask = identificationService.fingerprintDevice()

        try? await throttleTask

        do {
            let fingerprintResponse = try await fingerprintTask
            setFingerprintingState(
                fingerprintResponse: fingerprintResponse,
                smartSignalsResponse: nil
            )

            let smartSignalsResponse = try await smartSignalsService?
                .fetchSignals(for: fingerprintResponse.requestId)

            setFingerprintingState(
                fingerprintResponse: fingerprintResponse,
                smartSignalsResponse: smartSignalsResponse
            )

            fingerprintCount += 1
        } catch {
            fingerprintingState = .failed(error: .init(from: error))
        }
    }
}

private extension DeviceFingerprintViewModel {

    var hasApiKeysConfig: Bool { (try? settingsContainer.apiKeysConfig) != nil }

    var fingerprintCount: Int {
        get {
            (try? settingsContainer.fingerprintCount) ?? .zero
        }
        set {
            try? settingsContainer.setFingerprintCount(newValue)
        }
    }

    func setFingerprintingState(
        fingerprintResponse: FingerprintResponse,
        smartSignalsResponse: SmartSignalsResponse?
    ) {
        fingerprintingState = .completed(
            viewModel: .init(
                event: .init(
                    fingerprintResponse: fingerprintResponse,
                    smartSignalsResponse: smartSignalsResponse
                ),
                hasLocationPermission: geolocationService.hasLocationPermission
            )
        )
    }
}
