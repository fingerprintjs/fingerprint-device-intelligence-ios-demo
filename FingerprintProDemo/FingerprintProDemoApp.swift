import SwiftUI

@main
struct FingerprintProDemoApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        configureAppearance()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

private extension FingerprintProDemoApp {

    func configureAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: UIFont.interFont(ofSize: 24.0, weight: .semibold)
        ]
        UISegmentedControl.appearance().backgroundColor = .backgroundGray
        UISegmentedControl.appearance()
            .setTitleTextAttributes(
                [
                    .font: UIFont.interFont(ofSize: 12.0),
                    .kern: 0.36,
                ],
                for: .normal
            )
        UITextField.appearance().clearButtonMode = .whileEditing
    }
}
