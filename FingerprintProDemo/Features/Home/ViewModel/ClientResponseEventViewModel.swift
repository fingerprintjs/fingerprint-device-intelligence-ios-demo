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
        case .vpn: vpnFieldValue
        case .factoryReset: factoryResetFieldValue
        case .jailbreak: jailbreakFieldValue
        case .frida: fridaFieldValue
        case .locationSpoofing: locationSpoofingFieldValue
        case .highActivity: highActivityFieldValue
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
            return vpnFieldValue
        case .factoryReset:
            return factoryResetFieldValue
        case .jailbreak:
            return jailbreakFieldValue
        case .frida:
            return fridaFieldValue
        case .locationSpoofing:
            return locationSpoofingFieldValue
        case .highActivity:
            return highActivityFieldValue
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

    var vpnFieldValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard smartSignalsResponse.vpnDetected else { return LocalizedStrings.notDetected.rawValue }
        return .init(localized: "Device time zone is \(smartSignalsResponse.deviceTimezone)")
    }

    var factoryResetFieldValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard smartSignalsResponse.factoryResetDetected else { return LocalizedStrings.notDetected.rawValue }
        return .init(Format.Date.iso8601Full(from: smartSignalsResponse.factoryResetDate))
    }

    var jailbreakFieldValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        return LocalizedStrings.smartSignalValue(from: smartSignalsResponse.jailbreakDetected)
    }

    var fridaFieldValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        return LocalizedStrings.smartSignalValue(from: smartSignalsResponse.fridaDetected)
    }

    var locationSpoofingFieldValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
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
        return LocalizedStrings.smartSignalValue(from: smartSignalsResponse.locationSpoofingDetected)
    }

    var highActivityFieldValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        let isHighActivity = smartSignalsResponse.isHighActivityDevice
        let dailyRequests = smartSignalsResponse.deviceDailyRequests
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

        var rawValue: AttributedString {
            switch self {
            case .yes: .init(localized: "Yes")
            case .no: .init(localized: "No")
            case .detected: .init(localized: "Detected")
            case .notDetected: .init(localized: "Not detected")
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
