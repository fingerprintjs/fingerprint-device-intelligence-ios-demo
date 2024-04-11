import Foundation

extension ConfigVariable {

    #if DEBUG
    /// - Note: This API is intended for internal development only.
    private enum Developer {
        static let baseURL: URL? = .none
        static let origin: String? = .none
    }
    #endif

    enum SmartSignals {

        static var baseURL: URL? {
            #if DEBUG
            Developer.baseURL
            #else
            .init(string: ObfuscatedLiterals.$smartSignalsBaseURLString)
            #endif
        }

        static var origin: String? {
            #if DEBUG
            Developer.origin
            #else
            ObfuscatedLiterals.$smartSignalsOrigin
            #endif
        }

        static var isEnabled: Bool {
            #if DEBUG
            baseURL != nil
            #else
            true
            #endif
        }
    }
}
