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
        if let location = fingerprintResponse.ipLocation, let countryName = location.country?.name {
            guard let cityName = location.city?.name else { return .init(countryName) }
            return .init("\(cityName), \(countryName)")
        }

        if let smartSignalsResponse,
            let city = smartSignalsResponse.products.ipInfo?.data?.v4?.geolocation?.city?.name,
            let country = smartSignalsResponse.products.ipInfo?.data?.v4?.geolocation?.country?.name
        {
            return .init("\(city), \(country)")
        }

        return ""
    }

    var ipNetworkProviderValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let ipInfo = smartSignalsResponse.products.ipInfo else { return LocalizedStrings.notDetected.rawValue }
        let name = ipInfo.data?.v4?.asn?.name
        let asn = ipInfo.data?.v4?.asn?.asn

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
        guard let ipBlocklistData = smartSignalsResponse.products.ipBlocklist?.data else {
            return LocalizedStrings.notDetected.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: ipBlocklistData.result ?? false)
    }

    var vpnItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let vpnData = smartSignalsResponse.products.vpn?.data
        else { return LocalizedStrings.signalDisabled.rawValue }
        guard vpnData.result ?? false else { return LocalizedStrings.notDetected.rawValue }

        let confidence: String?
        if let aConfidence = vpnData.confidence {
            confidence = String(localized: "Confidence: \(aConfidence)")
        } else {
            confidence = nil
        }

        var detectedBy = String(localized: "Detected")
        let method: String?
        let methods = vpnData.methods
        if methods?.publicVPN ?? false {
            method = .init(localized: "Public VPN")
        } else if methods?.timezoneMismatch ?? false {
            method = .init(localized: "Timezone mismatch")
        } else if methods?.relay ?? false {
            method = .init(localized: "Relay")
        } else if methods?.auxiliaryMobile ?? false {
            method = .init(localized: "Auxiliary mobile")
        } else {
            method = nil
        }

        if let method {
            detectedBy += " (\(method))"
        }

        if let confidence {
            return .init("\(detectedBy) - \(confidence)")
        } else {
            return .init(detectedBy)
        }
    }

    var proxyItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let proxyData = smartSignalsResponse.products.proxy?.data
        else { return LocalizedStrings.signalDisabled.rawValue }
        guard proxyData.result ?? false, let proxyType = proxyData.details?.proxyType else {
            return LocalizedStrings.notDetected.rawValue
        }

        if proxyType == .dataCenter {
            return .init(localized: "Proxy Detected (Data Center IP)")
        } else {
            return .init(localized: "Proxy Detected (Residential IP)")
        }
    }

    var factoryResetItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let factoryResetData = smartSignalsResponse.products.factoryReset?.data else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        guard factoryResetData.timestamp > 0 else {
            return LocalizedStrings.notDetected.rawValue
        }
        return .init(Format.Date.iso8601FullWithRelativeDate(from: factoryResetData.time))
    }

    var jailbreakItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let jailbreakData = smartSignalsResponse.products.jailbreak?.data else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: jailbreakData.result)
    }

    var fridaItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let fridaData = smartSignalsResponse.products.frida?.data else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: fridaData.result)
    }

    var geolocationSpoofingItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let locationSpoofingData = smartSignalsResponse.products.locationSpoofing?.data else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return requiresLocationPermissionString ?? LocalizedStrings.smartSignalValue(from: locationSpoofingData.result)
    }

    var highActivityItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let highActivityData = smartSignalsResponse.products.highActivity?.data else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        let isHighActivity = highActivityData.result ?? false
        let dailyRequests = highActivityData.dailyRequests
        guard isHighActivity, let dailyRequests else {
            return LocalizedStrings.smartSignalValue(from: isHighActivity)
        }
        return .init(localized: "\(dailyRequests) requests per day")
    }

    var tamperingItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let tamperingData = smartSignalsResponse.products.tampering?.data else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: tamperingData.result)
    }

    var mitmAttackItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let mitmAttackData = smartSignalsResponse.products.mitmAttack?.data else {
            return LocalizedStrings.signalDisabled.rawValue
        }
        return LocalizedStrings.smartSignalValue(from: mitmAttackData.result)
    }

    var proximityItemValue: AttributedString {
        guard let smartSignalsResponse else { return "" }
        guard let proximityData = smartSignalsResponse.products.proximity?.data
        else { return requiresLocationPermissionString ?? LocalizedStrings.notDetected.rawValue }
        let proximityId = String(localized: "Proximity id")
        let precisionRadius = String(localized: "precision radius")
        let confidence = String(localized: "confidence")
        var itemValue = "\(proximityId): \(proximityData.id) "
        itemValue += "(\(precisionRadius): \(proximityData.precisionRadius), "
        itemValue += "\(confidence): \(proximityData.confidence))"
        return .init(itemValue)
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
