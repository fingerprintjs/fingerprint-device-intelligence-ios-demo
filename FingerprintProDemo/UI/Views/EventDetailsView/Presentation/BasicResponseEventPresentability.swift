import SwiftUI

extension EventPresentability where Self == BasicResponseEventPresentability {

    static var basicResponse: Self { .init() }
}

struct BasicResponseEventPresentability: ClientResponseEventPresentability {

    enum FieldKey: LocalizedStringKey, PresentableFieldKey {
        case requestId = "REQUEST ID"
        case visitorId = "VISITOR ID"
        case visitorFound = "VISITOR FOUND"
        case confidence = "CONFIDENCE"
        case vpn = "VPN"
        case factoryReset = "FACTORY RESET"
        case jailbreak = "JAILBREAK"
        case frida = "FRIDA"
        case locationSpoofing = "GEOLOCATION SPOOFING"
        case highActivity = "HIGH-ACTIVITY"
    }

    let foremostFieldKey: FieldKey = .visitorId

    func badgeLabel(for key: FieldKey) -> LocalizedStringKey? {
        switch key {
        case .vpn, .factoryReset, .jailbreak, .frida, .locationSpoofing, .highActivity:
            return "SMART SIGNAL"
        default:
            return .none
        }
    }

    func valuePlaceholder(for key: FieldKey) -> String {
        switch key {
        case .visitorFound:
            return .placeholder(length: 3)
        case .confidence:
            return .placeholder(length: 4)
        case .jailbreak, .frida, .locationSpoofing:
            return .placeholder(length: 12)
        case .highActivity:
            return .placeholder(length: 18)
        case .requestId, .visitorId:
            return .placeholder(length: 20)
        case .factoryReset:
            return .placeholder(length: 24)
        case .vpn:
            return .placeholder(length: 32)
        }
    }
}
