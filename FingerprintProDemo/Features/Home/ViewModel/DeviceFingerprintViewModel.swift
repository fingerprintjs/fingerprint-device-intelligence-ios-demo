import Combine
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
    @Published private(set) var shouldShowSignUp: Bool = false

    private let identificationService: any DeviceIdentificationServiceProtocol
    private let smartSignalsService: (any SmartSignalsServiceProtocol)?
    private let geolocationService: any GeolocationServiceProtocol
    private let settingsContainer: SettingsContainer

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
        showSignUpIfNeeded()
    }

    func fingerprintDevice() async {
        guard fingerprintingState != .executing else { return }

        fingerprintingState = .executing
        shouldShowSignUp = false

        async let throttleTask: Void = Task.sleep(for: .milliseconds(500))
        async let fingerprintTask = identificationService.fingerprintDevice()

        try? await throttleTask

        do {
            let fingerprintResponse = try await fingerprintTask.get()
            let smartSignalsResponse = try await smartSignalsService?
                .fetchSignals(for: fingerprintResponse.requestId)
                .get()

            fingerprintingState = .completed(
                viewModel: .init(
                    event: .init(
                        fingerprintResponse: fingerprintResponse,
                        smartSignalsResponse: smartSignalsResponse
                    ),
                    hasLocationPermission: geolocationService.hasLocationPermission
                )
            )
            showSignUpIfNeeded()
        } catch {
            fingerprintingState = .failed(error: .init(from: error))
        }

        fingerprintCount += 1
    }

    func hideSignUp() {
        shouldShowSignUp = false
        hideSignUpTimestamp = Date.now.timeIntervalSince1970
    }
}

private extension DeviceFingerprintViewModel {

    var fingerprintCount: Int {
        get {
            (try? settingsContainer.loadValue(forKey: .fingerprintCount).get()) ?? .zero
        }
        set {
            settingsContainer.storeValue(newValue, forKey: .fingerprintCount)
        }
    }

    var hideSignUpTimestamp: TimeInterval {
        get {
            (try? settingsContainer.loadValue(forKey: .hideSignUpTimestamp).get()) ?? .zero
        }
        set {
            settingsContainer.storeValue(newValue, forKey: .hideSignUpTimestamp)
        }
    }

    func showSignUpIfNeeded() {
        guard hideSignUpTimestamp > 0 else {
            shouldShowSignUp = fingerprintCount > 0
            return
        }

        let elapsedTime = Date(timeIntervalSince1970: hideSignUpTimestamp).distance(to: .now)
        guard elapsedTime > C.hideSignUpDuration else {
            shouldShowSignUp = false
            return
        }

        hideSignUpTimestamp = .zero
        shouldShowSignUp = true
    }
}

private extension C {

    static let hideSignUpDuration: TimeInterval = 604_800  // 7 days
}
