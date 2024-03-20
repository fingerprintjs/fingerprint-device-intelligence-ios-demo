import FingerprintPro
import Foundation

enum ConfigVariable {

    #if DEBUG
    private enum Developer {
        static let apiKey: String? = .none  // <- Set your Public API Key here
        static let region: Region? = .none  // <- Set your Region here
    }

    private static let apiKeyEnvVarName = "API_KEY"
    #endif

    static var apiKey: String {
        #if DEBUG
        if let key = Developer.apiKey { return key }

        guard let key = ProcessInfo.processInfo.environment[apiKeyEnvVarName] else {
            let errorMessage = """
                Could not resolve API key. \
                Please set \(apiKeyEnvVarName) environment variable in active scheme or test plan.
                """
            fatalError(errorMessage)
        }

        return key
        #else
        ObfuscatedLiterals.$apiKey
        #endif
    }

    static var region: Region {
        #if DEBUG
        Developer.region ?? .global
        #else
        .ap
        #endif
    }
}
