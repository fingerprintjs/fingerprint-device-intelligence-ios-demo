import Foundation

extension SettingsContainer {

    static var preview: Self {
        .init(
            backingStorage: UserDefaults.preview,
            codingStrategy: CodingStrategy()
        )
    }
}
