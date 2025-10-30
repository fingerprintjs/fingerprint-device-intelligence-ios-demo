import Foundation

extension Format {

    enum Date {

        static func iso8601FullWithRelativeDate(from date: Foundation.Date) -> String {
            let now = Foundation.Date()
            let components = Calendar.current.dateComponents([.month, .day, .second], from: date, to: now)
            let months = components.month ?? 0
            let seconds = components.second ?? 0
            let relativeDate: String

            if seconds < 60 {
                relativeDate = "Just now"
            } else if months >= 1 {
                relativeDate = shortDateFormatter.string(from: date)
            } else {
                relativeDate = relativeDateFormatter.localizedString(for: date, relativeTo: now)
            }

            return iso8601Full(from: date) + " (\(relativeDate))"
        }

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

    static var relativeDateFormatter: RelativeDateTimeFormatter {
        let dateFormatter = RelativeDateTimeFormatter()
        dateFormatter.unitsStyle = .full
        dateFormatter.dateTimeStyle = .numeric
        return dateFormatter
    }

    static var shortDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM")
        return dateFormatter
    }
}
