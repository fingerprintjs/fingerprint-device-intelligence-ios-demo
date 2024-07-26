import Foundation

extension UserDefaults {

    static let preview: UserDefaults = {
        guard let userDefaults = UserDefaults(suiteName: #file) else {
            fatalError("Failed to initialize a user defaults object for preview.")
        }
        userDefaults.removePersistentDomain(forName: #file)
        return userDefaults
    }()
}
