import SwiftUI

@main
struct FingerprintProDemoApp: App {

    init() {
        configureAppearance()
    }

    var body: some Scene {
        WindowGroup {
            HomeView(
                deviceFingerprintViewModel: {
                    guard ConfigVariable.SmartSignals.isEnabled else {
                        return .init(
                            smartSignalsService: .none,
                            geolocationService: GeolocationService(shouldRequestPermission: false)
                        )
                    }
                    return .init()
                }()
            )
        }
    }
}

private extension FingerprintProDemoApp {

    func configureAppearance() {
        UISegmentedControl.appearance().backgroundColor = .backgroundGray
        UISegmentedControl.appearance()
            .setTitleTextAttributes(
                [
                    .font: UIFont.interFont(ofSize: 12.0),
                    .kern: 0.36,
                ],
                for: .normal
            )
    }
}
