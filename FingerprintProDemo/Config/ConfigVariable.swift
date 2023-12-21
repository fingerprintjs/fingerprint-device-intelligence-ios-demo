import FingerprintPro
import Foundation

enum ConfigVariable {

    #if DEBUG
    private static let apiKeyEnvVarName = "API_KEY"
    #endif

    static var apiKey: String {
        #if DEBUG
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
        .global
        #else
        .ap
        #endif
    }
}
