import Foundation

struct KeychainStorage: BackingStorage {

    private static let serviceLabel: String = "com.fingerprint.demo.keychain"

    func writeData(_ data: Data, forKey key: String) throws {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Self.serviceLabel,
            kSecAttrAccount as String: key,
        ]
        var status: OSStatus

        if containsData(forKey: key) {
            let attributesToUpdate: [String: Any] = [
                kSecValueData as String: data
            ]

            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        } else {
            query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            query[kSecValueData as String] = data

            status = SecItemAdd(query as CFDictionary, nil)
        }

        guard status == errSecSuccess else {
            throw keychainError(from: status)
        }
    }

    func readData(forKey key: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Self.serviceLabel,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true,
        ]

        var dataItem: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &dataItem)

        guard status == errSecSuccess else {
            throw keychainError(from: status)
        }

        let data = dataItem as! Data

        return data
    }

    func removeData(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Self.serviceLabel,
            kSecAttrAccount as String: key,
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw keychainError(from: status)
        }
    }

    func containsData(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Self.serviceLabel,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: false,
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)

        return status == errSecSuccess
    }
}

private extension KeychainStorage {

    func keychainError(from status: OSStatus) -> any Error {
        let errorDescription = SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error"
        return NSError(
            domain: NSOSStatusErrorDomain,
            code: .init(status),
            userInfo: [NSLocalizedDescriptionKey: errorDescription]
        )
    }
}
