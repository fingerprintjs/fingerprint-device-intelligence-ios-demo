import SwiftUI

extension EventPresentability where Self == BasicResponseEventPresentability {

    static var basicResponse: Self { .init() }
}

struct BasicResponseEventPresentability: ClientResponseEventPresentability {

    enum ItemKey: LocalizedStringKey, PresentableItemKey {
        case requestId = "REQUEST ID"
        case visitorId = "VISITOR ID"
        case visitorFound = "VISITOR FOUND"
        case confidence = "CONFIDENCE"
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
        default:
            return .none
        }
    }

    func valuePlaceholder(for key: ItemKey) -> String {
        switch key {
        case .visitorFound: .placeholder(length: 3)
        case .confidence: .placeholder(length: 4)
        case .jailbreak, .frida, .geolocationSpoofing, .tampering, .mitmAttack: .placeholder(length: 12)
        case .highActivity: .placeholder(length: 18)
        case .requestId, .visitorId: .placeholder(length: 20)
        case .factoryReset: .placeholder(length: 24)
        case .vpn: .placeholder(length: 32)
        }
    }

    func valueFontDesign(for key: ItemKey) -> Font.Design {
        switch key {
        case .visitorId, .requestId: .monospaced
        default: .default
        }
    }
}
