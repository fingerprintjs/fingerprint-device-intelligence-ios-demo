import Foundation

extension JSONEncoder.DateEncodingStrategy {

    static let iso8601Full: Self = .custom { date, encoder in
        let dateString = Format.Date.iso8601Full(from: date)
        var container = encoder.singleValueContainer()
        try container.encode(dateString)
    }
}
