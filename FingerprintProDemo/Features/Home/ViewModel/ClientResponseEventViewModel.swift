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

    func fieldValue<Key: PresentableFieldKey>(forKey key: Key) -> String {
        switch key {
        case let key as BasicResponseEventPresentability.FieldKey:
            return fieldValue(forKey: key)
        case let key as ExtendedResponseEventPresentability.FieldKey:
            return fieldValue(forKey: key)
        default:
            return ""
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

    func fieldValue(forKey key: BasicResponseEventPresentability.FieldKey) -> String {
        switch key {
        case .requestId:
            return requestIdFieldValue
        case .visitorId:
            return visitorIdFieldValue
        case .visitorFound:
            return visitorFoundFieldValue
        case .confidence:
            return confidenceFieldValue
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

    func fieldValue(forKey key: ExtendedResponseEventPresentability.FieldKey) -> String {
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
            return fingerprintResponse.ipAddress ?? ""
        case .ipLocation:
            guard
                let location = fingerprintResponse.ipLocation,
                let countryName = location.country?.name
            else {
                return ""
            }
            guard let cityName = location.city?.name else { return "\(countryName)" }
            return "\(cityName), \(countryName)"
        case .firstSeenAt:
            guard let date = fingerprintResponse.firstSeenAt?.subscription else { return "" }
            return Format.Date.iso8601Full(from: date)
        case .lastSeenAt:
            guard let date = fingerprintResponse.lastSeenAt?.subscription else { return "" }
            return Format.Date.iso8601Full(from: date)
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

    var requestIdFieldValue: String { fingerprintResponse.requestId }

    var visitorIdFieldValue: String { fingerprintResponse.visitorId }

    var visitorFoundFieldValue: String { LocalizedStrings.value(from: fingerprintResponse.visitorFound) }

    var confidenceFieldValue: String { Format.Number.percentString(from: fingerprintResponse.confidence) }
}

private extension ClientResponseEventViewModel {

    var smartSignalsResponse: SmartSignalsResponse? { event.smartSignalsResponse }

    var vpnFieldValue: String {
        guard let smartSignalsResponse else { return "" }
        guard smartSignalsResponse.vpnDetected else { return LocalizedStrings.notDetected.rawValue }
        return .init(localized: "Device time zone is \(smartSignalsResponse.deviceTimezone)")
    }

    var factoryResetFieldValue: String {
        guard let smartSignalsResponse else { return "" }
        guard smartSignalsResponse.factoryResetDetected else { return LocalizedStrings.notDetected.rawValue }
        return Format.Date.iso8601Full(from: smartSignalsResponse.factoryResetDate)
    }

    var jailbreakFieldValue: String {
        guard let smartSignalsResponse else { return "" }
        return LocalizedStrings.smartSignalValue(from: smartSignalsResponse.jailbreakDetected)
    }

    var fridaFieldValue: String {
        guard let smartSignalsResponse else { return "" }
        return LocalizedStrings.smartSignalValue(from: smartSignalsResponse.fridaDetected)
    }

    var locationSpoofingFieldValue: String {
        guard let smartSignalsResponse else { return "" }
        guard hasLocationPermission else { return .init(localized: "Requires location permission") }
        return LocalizedStrings.smartSignalValue(from: smartSignalsResponse.locationSpoofingDetected)
    }

    var highActivityFieldValue: String {
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

    enum LocalizedStrings: String {

        case yes
        case no

        case detected
        case notDetected

        var rawValue: String {
            switch self {
            case .yes:
                return .init(localized: "Yes")
            case .no:
                return .init(localized: "No")
            case .detected:
                return .init(localized: "Detected")
            case .notDetected:
                return .init(localized: "Not detected")
            }
        }

        static func value(from boolean: Bool) -> String {
            (boolean ? Self.yes : Self.no).rawValue
        }

        static func smartSignalValue(from boolean: Bool) -> String {
            (boolean ? Self.detected : Self.notDetected).rawValue
        }
    }
}
