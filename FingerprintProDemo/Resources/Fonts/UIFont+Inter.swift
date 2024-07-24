import UIKit

extension UIFont {

    static func interFont(ofSize size: CGFloat, weight: Weight = .regular) -> Self {
        .init(name: "Inter", size: size)!
        .weight(weight)
    }
}
