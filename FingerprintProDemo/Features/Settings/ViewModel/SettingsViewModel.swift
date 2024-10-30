import Combine

@MainActor
final class SettingsViewModel: ObservableObject {

    @Published private(set) var apiKeysEnabled: Bool = false

    private nonisolated let settingsContainer: any ReadOnlySettingsContainer

    init(settingsContainer: any ReadOnlySettingsContainer = SettingsContainer.default) {
        self.settingsContainer = settingsContainer
    }
}

extension SettingsViewModel {

    func viewDidAppear() {
        let apiKeysEnabled = try? settingsContainer
            .loadValue(Bool.self, forKey: .apiKeysEnabled)
            .get()
        guard let apiKeysEnabled, apiKeysEnabled != self.apiKeysEnabled else { return }
        self.apiKeysEnabled = apiKeysEnabled
    }
}
