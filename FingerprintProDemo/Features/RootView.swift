import SwiftUI

extension RootView where Home == HomeView, Settings == SettingsView {

    @MainActor
    init() {
        home = .init(
            deviceFingerprintViewModel: {
                guard ConfigVariable.SmartSignals.isEnabled else {
                    return .init(
                        identificationService: .default,
                        smartSignalsService: .none,
                        geolocationService: .default,
                        settingsContainer: .default
                    )
                }
                return .init(
                    identificationService: .default,
                    smartSignalsService: .none,
                    geolocationService: .default,
                    settingsContainer: .default
                )
            }()
        )
        settings = .init(
            viewModel: .init(),
            navigationDestinationHandler: .default
        )
    }
}

struct RootView<Home, Settings>: View where Home: View, Settings: View {

    private typealias Route = AppRoute

    private enum Tab: Hashable {
        case home
        case settings
    }

    @State private var selectedTab: Tab = .home

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
        TabView(selection: $selectedTab) {
            home
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)
            settings
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(Tab.settings)
        }
        .onDeepLink(to: Route.self) { route in
            switch route {
            case .home: selectedTab = .home
            case .settings: selectedTab = .settings
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
            SettingsView(
                viewModel: .preview,
                navigationDestinationHandler: .preview
            )
        }
    )
}

#endif
