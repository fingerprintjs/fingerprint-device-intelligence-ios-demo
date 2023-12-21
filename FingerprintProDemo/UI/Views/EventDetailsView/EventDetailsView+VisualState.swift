extension EventDetailsView {

    enum VisualState {
        case loading
        case presenting(fieldValue: (Presentation.FieldKey) -> String, rawDetails: String)
        case error(PresentableError, retryAction: () -> Void)
    }
}

extension EventDetailsView.VisualState: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.presenting, .presenting), (.error, .error):
            return true
        default:
            return false
        }
    }
}
