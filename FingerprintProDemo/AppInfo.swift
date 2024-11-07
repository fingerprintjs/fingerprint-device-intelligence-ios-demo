import Foundation

enum AppInfo {

    static var appVersionString: String {
        guard
            let infoDictionary = Bundle.main.infoDictionary,
            let versionString = infoDictionary[Keys.InfoPlist.shortVersionString] as? String
        else {
            return ""
        }

        return "v\(versionString)"
    }

    static var sdkVersionString: String {
        guard
            let bundle = Bundle(identifier: SDK.bundleIdentifier),
            let versionFileURL = bundle.url(forResource: SDK.versionFileName, withExtension: .none),
            let versionString = try? String(contentsOf: versionFileURL)
        else {
            return ""
        }

        return "v\(versionString)"
    }
}

private extension AppInfo {

    enum Keys {

        enum InfoPlist {

            static let shortVersionString = "CFBundleShortVersionString"
        }
    }

    enum SDK {

        static let bundleIdentifier = "com.fingerprintjs.FingerprintPro"
        static let versionFileName = "VERSION"
    }
}
