import SwiftUI

extension EventPresentability where Self == ExtendedResponseEventPresentability {

    static var extendedResponse: Self { .init() }
}

struct ExtendedResponseEventPresentability: ClientResponseEventPresentability {

    enum FieldKey: LocalizedStringKey, PresentableFieldKey {
        case requestId = "REQUEST ID"
        case visitorId = "VISITOR ID"
        case visitorFound = "VISITOR FOUND"
        case confidence = "CONFIDENCE"
        case ipAddress = "IP ADDRESS"
        case ipLocation = "IP LOCATION"
        case firstSeenAt = "FIRST SEEN AT"
        case lastSeenAt = "PREVIOUSLY SEEN AT"
        case vpn = "VPN"
        case factoryReset = "FACTORY RESET"
        case jailbreak = "JAILBREAK"
        case frida = "FRIDA"
        case locationSpoofing = "GEOLOCATION SPOOFING"
        case highActivity = "HIGH-ACTIVITY"
    }

    let foremostFieldKey: FieldKey = .visitorId

    func badge(for key: FieldKey) -> Badge? {
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
        case .locationSpoofing:
            return .link(title, destination: C.URLs.SmartSignalsOverview.locationSpoofing)
        case .highActivity:
            return .link(title, destination: C.URLs.SmartSignalsOverview.highActivity)
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
        case .ipAddress:
            return .placeholder(length: 15)
        case .highActivity:
            return .placeholder(length: 18)
        case .requestId, .visitorId, .ipLocation:
            return .placeholder(length: 20)
        case .firstSeenAt, .lastSeenAt, .factoryReset:
            return .placeholder(length: 24)
        case .vpn:
            return .placeholder(length: 32)
        }
    }
}
