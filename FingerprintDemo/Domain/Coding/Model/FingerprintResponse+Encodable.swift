import Fingerprint

extension FingerprintResponse: Swift.Encodable {

    private enum CodingKeys: String, CodingKey {
        case version = "v"
        case eventId
        case visitorId
        case suspectScore
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(eventId, forKey: .eventId)
        try container.encode(visitorId, forKey: .visitorId)
        try container.encodeIfPresent(suspectScore, forKey: .suspectScore)
    }
}
