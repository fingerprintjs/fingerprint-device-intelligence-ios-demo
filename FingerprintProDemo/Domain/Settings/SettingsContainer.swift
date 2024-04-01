import Foundation

enum SettingKey: String, PersistableValueKey {
    case fingerprintCount = "settings.actions.fingerprint.count"
    case hideSignUpTimestamp = "settings.actions.hide_sign_up.timestamp"
}

typealias SettingsContainer = PersistenceContainer<SettingKey>

extension SettingsContainer {

    static var `default`: Self {
        .init(
            backingStorage: UserDefaults.standard,
            codingStrategy: CodingStrategy()
        )
    }
}
