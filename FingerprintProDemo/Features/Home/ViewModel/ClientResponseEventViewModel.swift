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

    func fieldValue<Key: PresentableFieldKey>(forKey key: Key) -> AttributedString {
        switch key {
        case let key as BasicResponseEventPresentability.FieldKey: fieldValue(forKey: key)
        case let key as ExtendedResponseEventPresentability.FieldKey: fieldValue(forKey: key)
        default: ""
        }
    }
}

extension ClientResponseEventViewModel {

    var rawEventRepresentation: String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601Full
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

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

    func fieldValue(forKey key: BasicResponseEventPresentability.FieldKey) -> AttributedString {
        switch key {
        case .requestId: requestIdFieldValue
        case .visitorId: visitorIdFieldValue
        case .visitorFound: visitorFoundFieldValue
        case .confidence: confidenceFieldValue
        case .vpn: vpnSignalValue
        case .factoryReset: factoryResetSignalValue
        case .jailbreak: jailbreakSignalValue
        case .frida: fridaSignalValue
        case .locationSpoofing: locationSpoofingSignalValue
        case .highActivity: highActivitySignalValue
        }
    }
}

private extension ClientResponseEventViewModel {

    func fieldValue(forKey key: ExtendedResponseEventPresentability.FieldKey) -> AttributedString {
        switch key {
        case .requestId:
            return requestIdFieldValue
        case .visitorId:
            return visitorIdFieldValue
        case .visitorFound:
            return visitorFoundFieldValue
        case .confidence:
            return confidenceFieldValue
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
            return vpnSignalValue
        case .factoryReset:
            return factoryResetSignalValue
        case .jailbreak:
            return jailbreakSignalValue
        case .frida:
            return fridaSignalValue
        case .locationSpoofing:
            return locationSpoofingSignalValue
        case .highActivity:
            return highActivitySignalValue
        }
    }
}

private extension ClientResponseEventViewModel {

    var fingerprintResponse: FingerprintResponse { event.fingerprintResponse }

    var requestIdFieldValue: AttributedString { .init(fingerprintResponse.requestId) }

    var visitorIdFieldValue: AttributedString { .init(fingerprintResponse.visitorId) }

    var visitorFoundFieldValue: AttributedString {
        LocalizedStrings.value(from: fingerprintResponse.visitorFound)
    }

    var confidenceFieldValue: AttributedString {
        .init(Format.Number.percentString(from: fingerprintResponse.confidence))
    }
}

private extension ClientResponseEventViewModel {

    var smartSignalsResponse: SmartSignalsResponse? { event.smartSignalsResponse }

    var vpnSignalValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let vpn = smartSignalsResponse.products.vpn else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        guard vpn.data.result else {
            return LocalizedStrings.notDetected.rawValue
        }
        return .init(localized: "Device time zone is \(vpn.data.originTimezone)")
    }

    var factoryResetSignalValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let factoryReset = smartSignalsResponse.products.factoryReset else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        guard factoryReset.data.timestamp > 0 else {
            return LocalizedStrings.notDetected.rawValue
        }
        return .init(Format.Date.iso8601Full(from: factoryReset.data.time))
    }

    var jailbreakSignalValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let jailbreak = smartSignalsResponse.products.jailbreak else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: jailbreak.data.result)
    }

    var fridaSignalValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let frida = smartSignalsResponse.products.frida else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: frida.data.result)
    }

    var locationSpoofingSignalValue: AttributedString {
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

    var highActivitySignalValue: AttributedString {
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
