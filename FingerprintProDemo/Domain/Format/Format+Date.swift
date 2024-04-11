import Foundation

extension Format {

    enum Date {

        static func iso8601Full(from date: Foundation.Date) -> String {
            iso8601FullFormatter.string(from: date)
        }
    }
}

private extension Format.Date {

    static var iso8601FullFormatter: ISO8601DateFormatter {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [
            .withInternetDateTime,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime,
            .withTimeZone,
            .withColonSeparatorInTimeZone,
            .withFractionalSeconds,
        ]

        return dateFormatter
    }
}
