@preconcurrency import CoreLocation
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

    private let locationManager = CLLocationManager()
    private let shouldRequestPermission: Bool

    init(shouldRequestPermission: Bool = true) {
        self.shouldRequestPermission = shouldRequestPermission
        super.init()
        locationManager.delegate = self
    }
}

extension GeolocationService: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        currentAuthorizationStatus.withLock { status in
            status = manager.authorizationStatus
            guard status == .notDetermined, shouldRequestPermission else { return }
            manager.requestWhenInUseAuthorization()
        }
    }
}
