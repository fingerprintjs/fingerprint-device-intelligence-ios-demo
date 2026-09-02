import Foundation

extension Format {

    enum Number {

        static func percentString(from number: Float) -> String {
            .init(format: "%.0f%%", (number * 100).rounded())
        }
    }
}
