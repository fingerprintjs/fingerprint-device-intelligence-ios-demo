import SwiftUI

@MainActor
protocol PresentableItemKey: RawRepresentable, CaseIterable, Hashable where RawValue == LocalizedStringKey {}

@MainActor
protocol EventPresentability {

    associatedtype ItemKey: PresentableItemKey

    var loadingTitleKey: LocalizedStringKey? { get }
    var loadingDescriptionKey: LocalizedStringKey? { get }

    var presentingTitleKey: LocalizedStringKey? { get }

    var detailsHeaderKey: LocalizedStringKey { get }

    var foremostItemKey: ItemKey { get }

    var emptyValueString: AttributedString? { get }

    func badge(for key: ItemKey) -> Badge?
    func valuePlaceholder(for key: ItemKey) -> String
}

extension EventPresentability {

    var loadingTitleKey: LocalizedStringKey? { .none }
    var loadingDescriptionKey: LocalizedStringKey? { .none }

    var presentingTitleKey: LocalizedStringKey? { .none }

    var emptyValueString: AttributedString? { .none }

    func badge(for key: ItemKey) -> Badge? { .none }
}
