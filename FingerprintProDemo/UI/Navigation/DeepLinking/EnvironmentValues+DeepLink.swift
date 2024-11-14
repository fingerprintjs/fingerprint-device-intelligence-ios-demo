import SwiftUI

extension EnvironmentValues {

    #if compiler(>=6.0)
    @Entry var deepLink: DeepLinkNavigator = .default
    #else
    var deepLink: DeepLinkNavigator {
        get {
            self[__Key_deepLink.self]
        }
        set {
            self[__Key_deepLink.self] = newValue
        }
    }

    private struct __Key_deepLink: EnvironmentKey {
        static var defaultValue: DeepLinkNavigator { .default }
    }
    #endif
}
