import Combine

@MainActor
final class CustomApiKeysViewModel: ObservableObject {

    @Published var apiKeysEnabled: Bool = false
    @Published var publicKey: String = ""
    @Published var secretKey: String = ""
    @Published var region: PresentableRegion = .global

    private nonisolated let settingsContainer: SettingsContainer

    init(settingsContainer: SettingsContainer = .default) {
        self.settingsContainer = settingsContainer
    }
}

extension CustomApiKeysViewModel {

    func viewDidAppear() {
        let apiKeysEnabled = try? settingsContainer.apiKeysEnabled
        let apiKeysConfig = try? settingsContainer.apiKeysConfig

        guard let apiKeysEnabled else { return }
        self.apiKeysEnabled = apiKeysEnabled

        guard let apiKeysConfig else { return }
        guard let region = PresentableRegion(apiKeysConfig.region) else { return }
        self.publicKey = apiKeysConfig.publicKey
        self.secretKey = apiKeysConfig.secretKey
        self.region = region
    }

    func saveApiKeys() -> Bool {
        guard
            (!apiKeysEnabled && publicKey.isEmpty && secretKey.isEmpty) ||
                (!publicKey.isEmpty && !secretKey.isEmpty)
        else {
            return false
        }

        try? settingsContainer.setApiKeysEnabled(apiKeysEnabled)
        try? settingsContainer.setApiKeysConfig(
            .init(
                publicKey: publicKey,
                secretKey: secretKey,
                region: region.underlyingRegion
            )
        )

        return true
    }
}
