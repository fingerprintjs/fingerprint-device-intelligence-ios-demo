import Foundation

protocol BackingStorage: Sendable {
    func writeData(_ data: Data, forKey key: String) throws
    func readData(forKey key: String) throws -> Data
    func removeData(forKey key: String) throws
    func containsData(forKey key: String) -> Bool
}

extension BackingStorage {

    func containsData(forKey key: String) -> Bool {
        let data = try? readData(forKey: key)
        return data != nil
    }
}
