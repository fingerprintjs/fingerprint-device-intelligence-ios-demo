import SwiftUI

protocol EventPresentability {

    associatedtype FieldKey: RawRepresentable, CaseIterable where FieldKey.RawValue == LocalizedStringKey

    var loadingTitleKey: LocalizedStringKey? { get }
    var loadingDescriptionKey: LocalizedStringKey? { get }

    var presentingTitleKey: LocalizedStringKey? { get }

    var detailsHeaderKey: LocalizedStringKey { get }

    var foremostFieldKey: FieldKey { get }

    func valuePlaceholder(for key: FieldKey) -> String
}

extension EventPresentability {

    var loadingTitleKey: LocalizedStringKey? { .none }
    var loadingDescriptionKey: LocalizedStringKey? { .none }

    var presentingTitleKey: LocalizedStringKey? { .none }
}
