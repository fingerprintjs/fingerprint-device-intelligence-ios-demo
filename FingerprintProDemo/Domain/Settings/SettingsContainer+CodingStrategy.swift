import Foundation

extension SettingsContainer {

    struct CodingStrategy: PersistableValueCodingStrategy {
        func valueEncoder(forKey key: Key) -> any DataEncoder { JSONEncoder() }
        func valueDecoder(forKey key: Key) -> any DataDecoder { JSONDecoder() }
    }
}
