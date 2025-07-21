import FingerprintPro
import Foundation

enum ConfigVariable {

    #if DEBUG
    private enum Developer {
        static let apiKey: String? = .none  // <- Set your Public API Key here
        static let region: Region? = .none  // <- Set your Region here
    }

    private static let apiKeyEnvVarName = "API_KEY"
    private static let regionEnvVarName = "REGION"
    #endif

    static var apiKey: String {
        #if DEBUG
        return Developer.apiKey ?? ProcessInfo.processInfo.environment[apiKeyEnvVarName] ?? ""
        #else
        ObfuscatedLiterals.$apiKey
        #endif
    }

    static var region: Region {
        #if DEBUG
        if let region = Developer.region {
            return region
        } else if let regionString = ProcessInfo.processInfo.environment[regionEnvVarName] {
            return .init(string: regionString)
        } else {
            return .global
        }
        #else
        .global
        #endif
    }
}

extension Region {

    init(string: String) {
        switch string.lowercased() {
        case "global":
            self = .global
        case "eu":
            self = .eu
        case "ap":
            self = .ap
        default:
            self = .custom(domain: string)
        }
    }
}
