import struct Foundation.URL

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

        enum SmartSignalsOverview {

            private static var baseURL: URL {
                .init(staticString: "https://dev.fingerprint.com/docs/smart-signals-overview")
            }

            static var factoryReset: URL { baseURL.withFragment("factory-reset-detection") }
            static var frida: URL { baseURL.withFragment("frida-detection") }
            static var highActivity: URL { baseURL.withFragment("high-activity-device") }
            static var jailbreak: URL { baseURL.withFragment("jailbroken-device-detection") }
            static var locationSpoofing: URL { baseURL.withFragment("geolocation-spoofing-detection") }
            static var vpn: URL { baseURL.withFragment("vpn-detection-for-mobile-devices") }
        }
    }
}
