import SwiftUI

extension RootView where Home == HomeView, Settings == SettingsView {

    @MainActor
    init() {
        home = .init(
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
        settings = .init()
    }
}

struct RootView<Home, Settings>: View where Home: View, Settings: View {

    private let home: Home
    private let settings: Settings

    @MainActor
    init(
        @ViewBuilder home: () -> Home,
        @ViewBuilder settings: () -> Settings
    ) {
        self.home = home()
        self.settings = settings()
    }

    var body: some View {
        TabView {
            home
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            settings
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .tint(.accent)
    }
}

// MARK: Previews

#if DEBUG

#Preview {
    RootView(
        home: {
            HomeView(deviceFingerprintViewModel: .preview)
        },
        settings: {
            SettingsView()
        }
    )
}

#endif
