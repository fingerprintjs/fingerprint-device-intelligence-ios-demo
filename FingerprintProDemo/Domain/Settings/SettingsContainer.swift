import Foundation

enum SettingKey: String, PersistableValueKey {
    case apiKeys = "settings.requests.api_keys"
    case apiKeysEnabled = "settings.requests.api_keys.enabled"
    case fingerprintCount = "settings.actions.fingerprint.count"
    case hideSignUpTimestamp = "settings.actions.hide_sign_up.timestamp"
}

typealias ReadOnlySettingsContainer = ReadOnlyPersistenceContainer<SettingKey>
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

extension ReadOnlySettingsContainer {

    var apiKeysEnabled: Bool {
        get throws {
            try loadValue(forKey: .apiKeysEnabled)
        }
    }

    var apiKeysConfig: ApiKeysConfig {
        get throws {
            try loadValue(forKey: .apiKeys)
        }
    }

    var fingerprintCount: Int {
        get throws {
            try loadValue(forKey: .fingerprintCount)
        }
    }

    var hideSignUpTimestamp: TimeInterval {
        get throws {
            try loadValue(forKey: .hideSignUpTimestamp)
        }
    }
}

extension SettingsContainer {

    func setApiKeysEnabled(_ value: Bool) throws {
        try storeValue(value, forKey: .apiKeysEnabled)
    }

    func setApiKeysConfig(_ value: ApiKeysConfig) throws {
        try storeValue(value, forKey: .apiKeys)
    }

    func setFingerprintCount(_ value: Int) throws {
        try storeValue(value, forKey: .fingerprintCount)
    }

    func setHideSignUpTimestamp(_ value: TimeInterval) throws {
        try storeValue(value, forKey: .hideSignUpTimestamp)
    }
}
