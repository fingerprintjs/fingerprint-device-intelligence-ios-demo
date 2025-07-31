import FingerprintPro
import Foundation

struct ClientResponseEventViewModel: Equatable {

    private let event: ClientResponseEvent
    private let hasLocationPermission: Bool

    init(event: ClientResponseEvent, hasLocationPermission: Bool) {
        self.event = event
        self.hasLocationPermission = hasLocationPermission
    }
}

extension ClientResponseEventViewModel {

    func itemValue<Key: PresentableItemKey>(forKey key: Key) -> AttributedString {
        switch key {
        case let key as BasicResponseEventPresentability.ItemKey: itemValue(forKey: key)
        case let key as ExtendedResponseEventPresentability.ItemKey: itemValue(forKey: key)
        default: ""
        }
    }
}

extension ClientResponseEventViewModel {

    var rawEventRepresentation: String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601Full
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]

        guard
            let jsonData = try? encoder.encode(event),
            let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            return ""
        }

        return jsonString
    }
}

private extension ClientResponseEventViewModel {

    func itemValue(forKey key: BasicResponseEventPresentability.ItemKey) -> AttributedString {
        switch key {
        case .requestId: requestIdItemValue
        case .visitorId: visitorIdItemValue
        case .visitorFound: visitorFoundItemValue
        case .confidence: confidenceItemValue
        case .vpn: vpnItemValue
        case .factoryReset: factoryResetItemValue
        case .jailbreak: jailbreakItemValue
        case .frida: fridaItemValue
        case .geolocationSpoofing: geolocationSpoofingItemValue
        case .highActivity: highActivityItemValue
        case .tampering: tamperingItemValue
        case .mitmAttack: mitmAttackItemValue
        }
    }
}

private extension ClientResponseEventViewModel {

    func itemValue(forKey key: ExtendedResponseEventPresentability.ItemKey) -> AttributedString {
        switch key {
        case .requestId:
            return requestIdItemValue
        case .visitorId:
            return visitorIdItemValue
        case .visitorFound:
            return visitorFoundItemValue
        case .confidence:
            return confidenceItemValue
        case .ipAddress:
            return .init(fingerprintResponse.ipAddress ?? "")
        case .ipLocation:
            guard
                let location = fingerprintResponse.ipLocation,
                let countryName = location.country?.name
            else {
                return ""
            }
            guard let cityName = location.city?.name else { return .init(countryName) }
            return .init("\(cityName), \(countryName)")
        case .firstSeenAt:
            guard let date = fingerprintResponse.firstSeenAt?.subscription else { return "" }
            return .init(Format.Date.iso8601Full(from: date))
        case .lastSeenAt:
            guard let date = fingerprintResponse.lastSeenAt?.subscription else { return "" }
            return .init(Format.Date.iso8601Full(from: date))
        case .vpn:
            return vpnItemValue
        case .factoryReset:
            return factoryResetItemValue
        case .jailbreak:
            return jailbreakItemValue
        case .frida:
            return fridaItemValue
        case .geolocationSpoofing:
            return geolocationSpoofingItemValue
        case .highActivity:
            return highActivityItemValue
        case .tampering:
            return tamperingItemValue
        case .mitmAttack:
            return mitmAttackItemValue
        }
    }
}

private extension ClientResponseEventViewModel {

    var fingerprintResponse: FingerprintResponse { event.fingerprintResponse }

    var requestIdItemValue: AttributedString { .init(fingerprintResponse.requestId) }

    var visitorIdItemValue: AttributedString { .init(fingerprintResponse.visitorId) }

    var visitorFoundItemValue: AttributedString {
        LocalizedStrings.value(from: fingerprintResponse.visitorFound)
    }

    var confidenceItemValue: AttributedString {
        .init(Format.Number.percentString(from: fingerprintResponse.confidence))
    }
}

private extension ClientResponseEventViewModel {

    var smartSignalsResponse: SmartSignalsResponse? { event.smartSignalsResponse }

    var vpnItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let vpn = smartSignalsResponse.products.vpn else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        guard vpn.data.result else {
            return LocalizedStrings.notDetected.rawValue
        }
        if vpn.data.methods.auxiliaryMobile {
            return .init(localized: "Device has VPN enabled")
        } else {
            return .init(localized: "VPN usage suspected, device timezone is \(vpn.data.originTimezone)")
        }
    }

    var factoryResetItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let factoryReset = smartSignalsResponse.products.factoryReset else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        guard factoryReset.data.timestamp > 0 else {
            return LocalizedStrings.notDetected.rawValue
        }
        return .init(Format.Date.iso8601Full(from: factoryReset.data.time))
    }

    var jailbreakItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let jailbreak = smartSignalsResponse.products.jailbreak else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: jailbreak.data.result)
    }

    var fridaItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let frida = smartSignalsResponse.products.frida else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: frida.data.result)
    }

    var geolocationSpoofingItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let locationSpoofing = smartSignalsResponse.products.locationSpoofing else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        guard hasLocationPermission else {
            let text = String(localized: "Requires location permission")
            guard
                let url = C.URLs.appSettings,
                let value = try? AttributedString(markdown: "[\(text)](\(url))")
            else {
                return .init(text)
            }
            return value
        }
        return LocalizedStrings.smartSignalValue(from: locationSpoofing.data.result)
    }

    var highActivityItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let highActivity = smartSignalsResponse.products.highActivity else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        let isHighActivity = highActivity.data.result
        let dailyRequests = highActivity.data.dailyRequests
        guard isHighActivity, let dailyRequests else {
            return LocalizedStrings.smartSignalValue(from: isHighActivity)
        }
        return .init(localized: "\(dailyRequests) requests per day")
    }

    var tamperingItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let tampering = smartSignalsResponse.products.tampering else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: tampering.data.result)
    }

    var mitmAttackItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let mitmAttack = smartSignalsResponse.products.mitmAttack else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: mitmAttack.data.result)
    }

}

private extension ClientResponseEventViewModel {

    enum LocalizedStrings: AttributedString {

        case yes
        case no

        case detected
        case notDetected

        case signalDisabled

        var rawValue: AttributedString {
            switch self {
            case .yes:
                return .init(localized: "Yes")
            case .no:
                return .init(localized: "No")
            case .detected:
                return .init(localized: "Detected")
            case .notDetected:
                return .init(localized: "Not detected")
            case .signalDisabled:
                let text = String(localized: "Signal disabled for your app")
                var value: AttributedString = (try? .init(markdown: "*\(text)*")) ?? .init(text)
                value.foregroundColor = .gray700
                return value
            }
        }

        static func value(from boolean: Bool) -> AttributedString {
            (boolean ? Self.yes : Self.no).rawValue
        }

        static func smartSignalValue(from boolean: Bool) -> AttributedString {
            (boolean ? Self.detected : Self.notDetected).rawValue
        }
    }
}
