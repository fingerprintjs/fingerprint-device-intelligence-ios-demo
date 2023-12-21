import SwiftUI

protocol PresentableFieldKey: RawRepresentable, CaseIterable where Self.RawValue == LocalizedStringKey {}

protocol EventPresentability {

    associatedtype FieldKey: PresentableFieldKey

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