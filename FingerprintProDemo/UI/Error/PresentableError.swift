import Foundation

extension PresentableError {

    enum Image: String {
        case exclamationMark = "exclamationmark.circle"
    }
}

struct PresentableError: Error, Equatable {
    let image: Image
    let localizedTitle: AttributedString
    let localizedDescription: AttributedString
}
