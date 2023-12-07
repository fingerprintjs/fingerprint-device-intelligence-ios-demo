import SwiftUI

extension View {

    @ViewBuilder
    func redacted(if condition: @autoclosure () -> Bool, reason: RedactionReasons = .placeholder) -> some View {
        redacted(reason: condition() ? reason : [])
    }
}
