import Foundation

extension SettingsContainer {

    static var preview: Self {
        .init(
            persistenceStrategy: .init(
                backingStorageForKey: { _ in UserDefaults.preview },
                valueEncoderForKey: { _ in JSONEncoder() },
                valueDecoderForKey: { _ in JSONDecoder() }
            )
        )
    }
}
