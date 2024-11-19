import SwiftUI

extension PresentableError {

    enum Image: String {
        case cloudSlash = "icloud.slash"
        case exclamationMark = "exclamationmark.circle"
        case handRaised = "hand.raised"
    }

    enum ActionKind: LocalizedStringResource {

        case editApiKeys = "Go to API Keys"
        case retry = "Try again"

        var localizedString: String { .init(localized: rawValue) }
    }
}

struct PresentableError: Error, Equatable {
    let image: Image
    let localizedTitle: AttributedString
    let localizedDescription: AttributedString
    let actionKind: ActionKind
}
