import struct Foundation.URL
import class UIKit.UIApplication

enum C {

    enum URLs {

        static var appSettings: URL? { URL(string: UIApplication.openSettingsURLString) }
        static var documentation: URL { .init(staticString: "https://dev.fingerprint.com/docs/ios-sdk") }
        static var privacyPolicy: URL { .init(staticString: "https://dev.fingerprint.com/docs/privacy-policy") }
        static var signIn: URL { .init(staticString: "https://dashboard.fingerprint.com/login") }
        static var signUp: URL {
            #if DEBUG
            .init(staticString: "https://fingerprint.com/mobile-app-detection/")
            #else
            guard let url = URL(string: ObfuscatedLiterals.$signUpURLString) else { preconditionFailure() }
            return url
            #endif
        }
        static var support: URL { .init(staticString: "https://fingerprint.com/support") }
        static var writeReview: URL {
            .init(staticString: "itms-apps://apple.com/app/id1644105278?action=write-review")
        }

        enum SmartSignalsOverview {

            private static var baseURL: URL {
                .init(staticString: "https://dev.fingerprint.com/docs/smart-signals-overview")
            }

            static var factoryReset: URL { baseURL.withFragment("factory-reset-detection") }
            static var frida: URL { baseURL.withFragment("frida-detection") }
            static var highActivity: URL { baseURL.withFragment("high-activity-device") }
            static var jailbreak: URL { baseURL.withFragment("jailbroken-device-detection") }
            static var geolocationSpoofing: URL { baseURL.withFragment("geolocation-spoofing-detection") }
            static var vpn: URL { baseURL.withFragment("vpn-detection-for-mobile-devices") }
            static var tampering: URL { baseURL.withFragment("tampered-request-detection-for-mobile-apps") }
            static var mitmAttack: URL { baseURL.withFragment("mitm-attack-detection") }
        }
    }
}
