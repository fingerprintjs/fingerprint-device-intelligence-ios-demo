import Foundation

enum SettingKey: String, PersistableValueKey {
    case fingerprintCount = "settings.actions.fingerprint.count"
}

typealias ReadOnlySettingsContainer = ReadOnlyPersistenceContainer<SettingKey>
typealias SettingsContainer = PersistenceContainer<SettingKey>

extension SettingsContainer {

    static var `default`: Self {
        .init(
            persistenceStrategy: .init(
                backingStorageForKey: { key in
                    switch key {
                    case .fingerprintCount:
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

    var fingerprintCount: Int {
        get throws {
            try loadValue(forKey: .fingerprintCount)
        }
    }
}

extension SettingsContainer {

    func setFingerprintCount(_ value: Int) throws {
        try storeValue(value, forKey: .fingerprintCount)
    }
}
