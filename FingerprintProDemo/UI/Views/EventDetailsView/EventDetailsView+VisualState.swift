extension EventDetailsView {

    enum VisualState {
        case loading
        case presenting(fieldValue: (Presentation.FieldKey) -> String, rawDetails: String)
    }
}

extension EventDetailsView.VisualState: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.presenting, .presenting):
            return true
        default:
            return false
        }
    }
}
