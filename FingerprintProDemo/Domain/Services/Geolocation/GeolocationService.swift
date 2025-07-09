@preconcurrency import CoreLocation
import FingerprintPro
import os

protocol GeolocationServiceProtocol: Sendable {
    var hasLocationPermission: Bool { get }
}

final class GeolocationService: NSObject, GeolocationServiceProtocol {

    var hasLocationPermission: Bool {
        currentAuthorizationStatus.withLock { status in
            switch status {
            case .authorizedWhenInUse, .authorizedAlways: true
            case .notDetermined, .restricted, .denied: false
            @unknown default: false
            }
        }
    }

    private let currentAuthorizationStatus = OSAllocatedUnfairLock<CLAuthorizationStatus>(
        initialState: .notDetermined
    )

    private let locationHelper: LocationPermissionHelperProviding
    private let identificationService: any DeviceIdentificationServiceProtocol

    @MainActor
    init(identificationService: any DeviceIdentificationServiceProtocol) {
        self.locationHelper = FingerprintProFactory.getLocationPermissionHelperInstance()
        self.identificationService = identificationService
        super.init()
        self.locationHelper.delegate = self
    }
}

extension GeolocationService: LocationPermissionDelegate {

    func locationPermissionHelper(
        _ helper: LocationPermissionHelperProviding,
        shouldShowLocationRationale rationale: LocationPermissionRationale
    ) {
        os_log("Location rationale: %{public}@", String(describing: rationale))

        switch rationale {
        case .needInitialPermission:
            helper.requestPermission()
        case .upgradeToPrecise:
            helper.requestTemporaryPrecisePermission()
        case .needSettingsChange:
            helper.requestTemporaryPrecisePermission()
        @unknown default:
            os_log("⚠️ Received unknown rationale: %{public}@", String(describing: rationale))
        }
    }

    func locationPermissionHelper(
        _ helper: LocationPermissionHelperProviding,
        didUpdateLocationPermission status: CLAuthorizationStatus
    ) {
        currentAuthorizationStatus.withLock { $0 = status }
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            Task {
                try? await identificationService.startCollectingLocation()
            }
        default: break
        }
    }
}
