import SwiftUI

extension EventPresentability where Self == BasicResponseEventPresentability {

    static var basicResponse: Self { .init() }
}

struct BasicResponseEventPresentability: ClientResponseEventPresentability {

    enum FieldKey: LocalizedStringKey, CaseIterable {
        case requestId = "REQUEST ID"
        case visitorId = "VISITOR ID"
        case visitorFound = "VISITOR FOUND"
        case confidence = "CONFIDENCE"
    }

    let foremostFieldKey: FieldKey = .visitorId

    func valuePlaceholder(for key: FieldKey) -> String {
        switch key {
        case .requestId, .visitorId:
            return .placeholder(length: 20)
        case .visitorFound, .confidence:
            return .placeholder(length: 3)
        }
    }
}
