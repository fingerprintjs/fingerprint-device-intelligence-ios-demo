import FingerprintPro
import Foundation

struct ClientResponseEventViewModel: Equatable {

    private let response: FingerprintResponse

    init(response: FingerprintResponse) {
        self.response = response
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
            let jsonData = try? encoder.encode(response),
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
            return response.requestId
        case .visitorId:
            return response.visitorId
        case .visitorFound:
            return (response.visitorFound ? LocalizedStrings.yes : LocalizedStrings.no).rawValue
        case .confidence:
            return Format.Number.percentString(from: response.confidence)
        }
    }
}

private extension ClientResponseEventViewModel {

    func fieldValue(forKey key: ExtendedResponseEventPresentability.FieldKey) -> String {
        switch key {
        case .requestId:
            return response.requestId
        case .visitorId:
            return response.visitorId
        case .visitorFound:
            return (response.visitorFound ? LocalizedStrings.yes : LocalizedStrings.no).rawValue
        case .confidence:
            return Format.Number.percentString(from: response.confidence)
        case .ipAddress:
            return response.ipAddress ?? ""
        case .ipLocation:
            guard
                let location = response.ipLocation,
                let countryName = location.country?.name
            else {
                return ""
            }
            guard let cityName = location.city?.name else { return "\(countryName)" }
            return "\(cityName), \(countryName)"
        case .firstSeenAt:
            guard let date = response.firstSeenAt?.subscription else { return "" }
            return Format.Date.iso8601Full(from: date)
        case .lastSeenAt:
            guard let date = response.lastSeenAt?.subscription else { return "" }
            return Format.Date.iso8601Full(from: date)
        }
    }
}

private extension ClientResponseEventViewModel {

    enum LocalizedStrings: String {

        case yes
        case no

        var rawValue: String {
            switch self {
            case .yes:
                return .init(localized: "Yes")
            case .no:
                return .init(localized: "No")
            }
        }
    }
}
