enum EventDetailsVisualState<FieldKey: PresentableFieldKey> {
    case loading
    case presenting(fieldValue: (FieldKey) -> String, rawDetails: String)
    case error(PresentableError, retryAction: () -> Void)
}

extension EventDetailsVisualState: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.presenting, .presenting), (.error, .error):
            return true
        default:
            return false
        }
    }
}

extension EventDetailsView {

    typealias VisualState = EventDetailsVisualState<Presentation.FieldKey>
}
