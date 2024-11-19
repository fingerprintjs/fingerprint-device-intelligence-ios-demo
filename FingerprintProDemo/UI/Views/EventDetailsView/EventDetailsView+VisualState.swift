import Foundation

enum EventDetailsVisualState<FieldKey: PresentableFieldKey> {
    case loading
    case presenting(fieldValue: (FieldKey) -> AttributedString, rawDetails: String)
    case error(PresentableError, action: @MainActor () -> Void)
}

extension EventDetailsVisualState: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.presenting, .presenting), (.error, .error): true
        default: false
        }
    }
}

extension EventDetailsView {

    typealias VisualState = EventDetailsVisualState<Presentation.FieldKey>
}
