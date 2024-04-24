import SwiftUI

protocol ClientResponseEventPresentability: EventPresentability {}

extension ClientResponseEventPresentability {

    var loadingTitleKey: LocalizedStringKey? { "Hang tight," }
    var loadingDescriptionKey: LocalizedStringKey? { "generating a unique Visitor ID for your \(deviceIdiom)..." }

    var presentingTitleKey: LocalizedStringKey? { "Your Device ID" }

    var detailsHeaderKey: LocalizedStringKey { "API RESPONSE" }

    var emptyValueString: String? { .init(localized: "N/A") }
}

private extension ClientResponseEventPresentability {

    var deviceIdiom: String {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return "iPhone"
        case .pad:
            return "iPad"
        default:
            return String(localized: "device")
        }
    }
}
