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
        case lastSeenAt = "LAST SEEN AT"
    }

    let foremostFieldKey: FieldKey = .visitorId

    func valuePlaceholder(for key: FieldKey) -> String {
        switch key {
        case .requestId, .visitorId, .ipLocation:
            return .placeholder(length: 20)
        case .visitorFound, .confidence:
            return .placeholder(length: 3)
        case .ipAddress:
            return .placeholder(length: 15)
        case .firstSeenAt, .lastSeenAt:
            return .placeholder(length: 24)
        }
    }
}
