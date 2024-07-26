import Foundation

enum SettingKey: String, PersistableValueKey {
    case apiKeys = "settings.requests.api_keys"
    case apiKeysEnabled = "settings.requests.api_keys.enabled"
    case fingerprintCount = "settings.actions.fingerprint.count"
    case hideSignUpTimestamp = "settings.actions.hide_sign_up.timestamp"
}

typealias SettingsContainer = PersistenceContainer<SettingKey>

extension SettingsContainer {

    static var `default`: Self {
        .init(
            persistenceStrategy: .init(
                backingStorageForKey: { key in
                    switch key {
                    case .apiKeys:
                        KeychainStorage()
                    case .apiKeysEnabled, .fingerprintCount, .hideSignUpTimestamp:
                        UserDefaults.standard
                    }
                },
                valueEncoderForKey: { _ in JSONEncoder() },
                valueDecoderForKey: { _ in JSONDecoder() }
            )
        )
    }
}
