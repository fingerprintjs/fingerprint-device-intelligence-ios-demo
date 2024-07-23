import CoreLocation

protocol GeolocationServiceProtocol {
    var hasLocationPermission: Bool { get }
}

final class GeolocationService: NSObject, GeolocationServiceProtocol {

    var hasLocationPermission: Bool {
        switch currentAuthorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways: true
        case .notDetermined, .restricted, .denied: false
        @unknown default: false
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
