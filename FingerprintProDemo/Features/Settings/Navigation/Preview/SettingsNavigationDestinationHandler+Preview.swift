extension SettingsNavigationDestinationHandler {

    static var preview: Self {
        .init { route in
            switch route {
            case .apiKeys: CustomApiKeysView(viewModel: .preview)
            }
        }
    }
}
