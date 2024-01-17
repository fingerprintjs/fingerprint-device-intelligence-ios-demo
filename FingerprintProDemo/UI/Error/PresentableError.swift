import Foundation

extension PresentableError {

    enum Image: String {
        case cloudSlash = "icloud.slash"
        case exclamationMark = "exclamationmark.circle"
        case handRaised = "hand.raised"
    }
}

struct PresentableError: Error, Equatable {
    let image: Image
    let localizedTitle: AttributedString
    let localizedDescription: AttributedString
}
