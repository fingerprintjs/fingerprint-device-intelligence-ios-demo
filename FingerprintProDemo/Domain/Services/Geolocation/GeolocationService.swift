import CoreLocation

protocol GeolocationServiceProtocol {
    var hasLocationPermission: Bool { get }
}

final class GeolocationService: NSObject, GeolocationServiceProtocol {

    var hasLocationPermission: Bool {
        switch currentAuthorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .notDetermined, .restricted, .denied:
            return false
        @unknown default:
            return false
        }
    }

    private lazy var currentAuthorizationStatus: CLAuthorizationStatus = locationManager.authorizationStatus

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
        currentAuthorizationStatus = manager.authorizationStatus
        guard currentAuthorizationStatus == .notDetermined, shouldRequestPermission else { return }
        manager.requestWhenInUseAuthorization()
    }
}
