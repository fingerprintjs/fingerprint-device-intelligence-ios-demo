enum SettingsRoute: Hashable {
    case apiKeys
}

typealias SettingsNavigationDestinationHandler = NavigationDestinationHandler<SettingsRoute>

extension SettingsNavigationDestinationHandler {

    static var `default`: Self {
        .init { route in
            switch route {
            case .apiKeys: CustomApiKeysView(viewModel: .init())
            }
        }
    }
}
