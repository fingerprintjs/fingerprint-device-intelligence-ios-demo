import Foundation

enum C {

    enum URLs {
        static var documentation: URL { .init(staticString: "https://dev.fingerprint.com/docs/ios-sdk") }
        static var privacyPolicy: URL { .init(staticString: "https://dev.fingerprint.com/docs/privacy-policy") }
        static var signUp: URL {
            #if DEBUG
            .init(staticString: "https://dashboard.fingerprint.com/signup")
            #else
            guard let url = URL(string: ObfuscatedLiterals.$signUpURLString) else { preconditionFailure() }
            return url
            #endif
        }
        static var support: URL { .init(staticString: "https://fingerprint.com/support") }
    }
}
