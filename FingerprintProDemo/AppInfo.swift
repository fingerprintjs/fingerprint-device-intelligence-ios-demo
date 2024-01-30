import Foundation

enum AppInfo {

    private static let sdkBundleIdentifier = "com.fingerprintjs.FingerprintPro"
    private static let sdkVersionFileName = "VERSION"

    static var sdkVersionString: String {
        guard
            let bundle = Bundle(identifier: sdkBundleIdentifier),
            let versionFileURL = bundle.url(forResource: sdkVersionFileName, withExtension: .none),
            let versionString = try? String(contentsOf: versionFileURL)
        else {
            return ""
        }

        return "v\(versionString)"
    }
}
