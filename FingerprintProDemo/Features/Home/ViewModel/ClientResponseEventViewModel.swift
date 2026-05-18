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
        case let key as ResponseEventPresenter.ItemKey: itemValue(forKey: key)
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

    func itemValue(forKey key: ResponseEventPresenter.ItemKey) -> AttributedString {
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
            return ipLocationValue
        case .ipNetworkProvider:
            return ipNetworkProviderValue
        case .ipBlocklist:
            return ipBlocklistValue
        case .firstSeenAt:
            guard let date = fingerprintResponse.firstSeenAt?.subscription else { return "" }
            return .init(Format.Date.iso8601FullWithRelativeDate(from: date))
        case .lastSeenAt:
            guard let date = fingerprintResponse.lastSeenAt?.subscription else { return "" }
            return .init(Format.Date.iso8601FullWithRelativeDate(from: date))
        case .vpn:
            return vpnItemValue
        case .proxy:
            return proxyItemValue
        case .simulator:
            return simulatorItemValue
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
        case .proximity:
            return proximityItemValue
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

    var ipLocationValue: AttributedString {
        var cityName: String?
        var countryName: String?
        var countryCode: String?

        if let location = fingerprintResponse.ipLocation, let country = location.country {
            cityName = location.city?.name
            countryName = country.name
            countryCode = country.code
        } else if let smartSignalsResponse {
            let geolocation = smartSignalsResponse.ipInfo?.v4?.geolocation
            cityName = geolocation?.cityName
            countryName = geolocation?.countryName
            countryCode = geolocation?.countryCode
        }

        if let countryCode {
            countryName = (countryName ?? "") + " \(countryFlag(fromCountryCode: countryCode))"
        }

        return .init([cityName, countryName].compactMap { $0 }.joined(separator: ", "))
    }

    var ipNetworkProviderValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let ipInfo = smartSignalsResponse.ipInfo?.v4 else { return LocalizedStrings.notDetected.rawValue }

        let name = ipInfo.asnName
        let asn = ipInfo.asn

        if let name, let asn {
            return .init("\(name) - \(asn)")
        } else if let nameOrAsn = name ?? asn {
            return .init(nameOrAsn)
        } else {
            return LocalizedStrings.notDetected.rawValue
        }
    }

    var ipBlocklistValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let ipBlocklistData = smartSignalsResponse.ipBlocklist else {
            return LocalizedStrings.notDetected.rawValue
        }
        let attackSource = ipBlocklistData.attackSource ?? false
        let emailSpam = ipBlocklistData.emailSpam ?? false
        let torNode = ipBlocklistData.torNode ?? false

        return LocalizedStrings.smartSignalValue(from: attackSource || emailSpam || torNode)
    }

    var vpnItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }

        guard let vpnDetected = smartSignalsResponse.vpn else { return LocalizedStrings.signalDisabled.rawValue }
        guard vpnDetected else { return LocalizedStrings.notDetected.rawValue }

        var detected = AttributedString(String(localized: "Detected"))

        let methods = smartSignalsResponse.vpnMethods
        var method: String?
        if methods?.publicVPN ?? false {
            method = .init(localized: "Public VPN")
        } else if methods?.timezoneMismatch ?? false {
            method = .init(localized: "Timezone mismatch")
        } else if methods?.relay ?? false {
            method = .init(localized: "Relay")
        } else if methods?.auxiliaryMobile ?? false {
            method = .init(localized: "Auxiliary mobile")
        }

        if let method {
            detected.append(AttributedString(" (\(method))"))
        }

        if let confidence = smartSignalsResponse.vpnConfidence {
            let confidenceLevel = String(localized: "Confidence: \(confidence)")
            detected.append(AttributedString("\n\(confidenceLevel)"))
        }

        if let countryCode = smartSignalsResponse.vpnOriginCountry {
            let countryName = Locale.current.localizedString(forRegionCode: countryCode) ?? ""
            let flag = countryFlag(fromCountryCode: countryCode)

            let infoText = String(localized: "Origin Country:")
            let country = AttributedString("\n" + infoText + " \(countryName)" + " \(flag)")

            var note = AttributedString("\n\(String(localized: "Note: works without location permissions"))")
            note.foregroundColor = .gray400
            note.font = .systemFont(ofSize: 12)

            detected.append(country)
            detected.append(note)
        }

        return detected
    }

    func countryFlag(fromCountryCode countryCode: String) -> String {
        let unicodeFlagOffset: UInt32 = 127397
        return countryCode.uppercased()
            .unicodeScalars
            .compactMap { UnicodeScalar(unicodeFlagOffset + $0.value) }
            .reduce(into: "") { $0.unicodeScalars.append($1) }
    }

    var proxyItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let proxyDetected = smartSignalsResponse.proxy else { return LocalizedStrings.signalDisabled.rawValue }
        guard proxyDetected, let proxyType = smartSignalsResponse.proxyDetails?.proxyType else {
            return LocalizedStrings.notDetected.rawValue
        }

        if proxyType == .dataCenter {
            return .init(localized: "Proxy Detected (Data Center IP)")
        } else {
            return .init(localized: "Proxy Detected (Residential IP)")
        }
    }

    var simulatorItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let simulatorDetected = smartSignalsResponse.simulator else {
            return LocalizedStrings.signalDisabled.rawValue
        }

        return LocalizedStrings.smartSignalValue(from: simulatorDetected)
    }

    var factoryResetItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let factoryResetTimestamp = smartSignalsResponse.factoryResetTimestamp else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        guard factoryResetTimestamp > 0 else {
            return LocalizedStrings.notDetected.rawValue
        }

        let date = Date(timeIntervalSince1970: .init(factoryResetTimestamp))
        return .init(Format.Date.iso8601FullWithRelativeDate(from: date))
    }

    var jailbreakItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let jailbroken = smartSignalsResponse.jailbroken else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: jailbroken)
    }

    var fridaItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let frida = smartSignalsResponse.frida else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: frida)
    }

    var geolocationSpoofingItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let locationSpoofing = smartSignalsResponse.locationSpoofing else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return requiresLocationPermissionString ?? LocalizedStrings.smartSignalValue(from: locationSpoofing)
    }

    var highActivityItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let isHighActivity = smartSignalsResponse.highActivityDevice else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        guard isHighActivity else {
            return LocalizedStrings.smartSignalValue(from: isHighActivity)
        }
        if let dailyRequests = smartSignalsResponse.velocity?.events?.twentyFourHours {
            return .init(localized: "\(dailyRequests) requests per day")
        }
        return LocalizedStrings.smartSignalValue(from: isHighActivity)
    }

    var tamperingItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let tampering = smartSignalsResponse.tampering else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: tampering)
    }

    var mitmAttackItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let mitmAttack = smartSignalsResponse.mitmAttack else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: mitmAttack)
    }

    var proximityItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let proximity = smartSignalsResponse.proximity
        else { return requiresLocationPermissionString ?? LocalizedStrings.notDetected.rawValue }
        let proximityId = String(localized: "Proximity id")
        let precisionRadius = String(localized: "precision radius")
        let confidence = String(localized: "confidence")
        var parts: [String] = []

        if let idValue = proximity.id {
            parts.append("\(proximityId): \(idValue)")
        }

        var detailParts: [String] = []
        if let precisionRadiusValue = proximity.precisionRadius {
            detailParts.append("\(precisionRadius): \(precisionRadiusValue)")
        }
        if let confidenceValue = proximity.confidence {
            detailParts.append("\(confidence): \(confidenceValue)")
        }
        if !detailParts.isEmpty {
            parts.append("(\(detailParts.joined(separator: ", ")))")
        }

        return .init(parts.joined(separator: " "))
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

    var requiresLocationPermissionString: AttributedString? {
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
        return nil
    }
}
