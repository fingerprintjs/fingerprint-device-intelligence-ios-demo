import UIKit

extension UIFont {

    func weight(_ weight: Weight) -> Self {
        let descriptor = UIFontDescriptor(
            fontAttributes: [
                .size: pointSize,
                .family: familyName,
                .traits: [
                    UIFontDescriptor.TraitKey.weight: weight
                ]
            ]
        )

        return .init(descriptor: descriptor, size: .zero)
    }
}
