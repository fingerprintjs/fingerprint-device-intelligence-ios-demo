import SwiftUI

extension EventPresentability where Self == ExtendedResponseEventPresentability {

    static var extendedResponse: Self { .init() }
}

struct ExtendedResponseEventPresentability: ClientResponseEventPresentability {

    enum ItemKey: LocalizedStringKey, PresentableItemKey {
        case requestId = "REQUEST ID"
        case visitorId = "VISITOR ID"
        case visitorFound = "VISITOR FOUND"
        case confidence = "CONFIDENCE"
        case ipAddress = "IP ADDRESS"
        case ipLocation = "IP LOCATION"
        case ipNetworkProvider = "IP NETWORK PROVIDER"
        case ipBlocklist = "IP BLOCKLIST MATCH"
        case firstSeenAt = "FIRST SEEN AT"
        case lastSeenAt = "PREVIOUSLY SEEN AT"
        case proxy = "PROXY"
        case factoryReset = "FACTORY RESET"
        case frida = "FRIDA"
        case geolocationSpoofing = "GEOLOCATION SPOOFING"
        case highActivity = "HIGH-ACTIVITY"
        case jailbreak = "JAILBREAK"
        case mitmAttack = "MITM ATTACK"
        case tampering = "TAMPERED REQUEST"
        case vpn = "VPN"
    }

    let foremostItemKey: ItemKey = .visitorId

    func badge(for key: ItemKey) -> Badge? {
        let title = String(localized: "SMART SIGNAL")
        switch key {
        case .vpn:
            return .link(title, destination: C.URLs.SmartSignalsOverview.vpn)
        case .proxy:
            return .link(title, destination: C.URLs.SmartSignalsOverview.proxy)
        case .factoryReset:
            return .link(title, destination: C.URLs.SmartSignalsOverview.factoryReset)
        case .jailbreak:
            return .link(title, destination: C.URLs.SmartSignalsOverview.jailbreak)
        case .frida:
            return .link(title, destination: C.URLs.SmartSignalsOverview.frida)
        case .geolocationSpoofing:
            return .link(title, destination: C.URLs.SmartSignalsOverview.geolocationSpoofing)
        case .highActivity:
            return .link(title, destination: C.URLs.SmartSignalsOverview.highActivity)
        case .tampering:
            return .link(title, destination: C.URLs.SmartSignalsOverview.tampering)
        case .mitmAttack:
            return .link(title, destination: C.URLs.SmartSignalsOverview.mitmAttack)
        case .ipLocation:
            return .link(title, destination: C.URLs.SmartSignalsOverview.ipGeolocation)
        case .ipNetworkProvider:
            return .link(title, destination: C.URLs.SmartSignalsOverview.ipGeolocation)
        case .ipBlocklist:
            return .link(title, destination: C.URLs.SmartSignalsOverview.ipBlocklistMatching)
        default:
            return .none
        }
    }

    func valuePlaceholder(for key: ItemKey) -> String {
        switch key {
        case .visitorFound: .placeholder(length: 3)
        case .confidence: .placeholder(length: 4)
        case .jailbreak, .frida, .geolocationSpoofing, .tampering, .mitmAttack: .placeholder(length: 12)
        case .ipAddress: .placeholder(length: 15)
        case .ipNetworkProvider: .placeholder(length: 32)
        case .ipBlocklist: .placeholder(length: 3)
        case .highActivity: .placeholder(length: 18)
        case .requestId, .visitorId, .ipLocation: .placeholder(length: 20)
        case .firstSeenAt, .lastSeenAt, .factoryReset: .placeholder(length: 24)
        case .vpn: .placeholder(length: 32)
        case .proxy: .placeholder(length: 32)
        }
    }

    func valueFontDesign(for key: ItemKey) -> Font.Design {
        switch key {
        case .visitorId, .requestId: .monospaced
        default: .default
        }
    }
}
