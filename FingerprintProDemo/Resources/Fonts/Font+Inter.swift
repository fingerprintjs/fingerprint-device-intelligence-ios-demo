import SwiftUI

extension Font {

    static func inter(size: CGFloat, relativeTo textStyle: TextStyle = .body, weight: Weight = .regular) -> Self {
        .custom("Inter", size: size, relativeTo: textStyle)
        .weight(weight)
    }
}
