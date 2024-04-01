import Foundation

extension UserDefaults {

    struct ValueNotFoundError: Error, Equatable, CustomStringConvertible {
        let unknownKey: String
        var description: String { "No value associated with \(unknownKey) key." }
    }
}

extension UserDefaults: BackingStorage {

    func writeData(_ data: Data, forKey key: String) {
        setValue(data, forKey: key)
    }

    func readData(forKey key: String) throws -> Data {
        guard let data = data(forKey: key) else {
            throw ValueNotFoundError(unknownKey: key)
        }

        return data
    }

    func removeData(forKey key: String) {
        removeObject(forKey: key)
    }
}
