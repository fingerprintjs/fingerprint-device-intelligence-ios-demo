import Foundation

enum EventDetailsVisualState<ItemKey: PresentableItemKey> {
    case loading
    case presenting(itemValue: (ItemKey) -> AttributedString, rawDetails: String)
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

    typealias VisualState = EventDetailsVisualState<Presentation.ItemKey>
}
