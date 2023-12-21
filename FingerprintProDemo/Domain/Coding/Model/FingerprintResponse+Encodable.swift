import FingerprintPro

extension FingerprintResponse: Encodable {

    private enum CodingKeys: String, CodingKey {
        case version = "v"
        case requestId
        case visitorId
        case visitorFound
        case confidence
        case ipAddress = "ip"
        case ipLocation
        case firstSeenAt
        case lastSeenAt
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(requestId, forKey: .requestId)
        try container.encode(visitorId, forKey: .visitorId)
        try container.encode(visitorFound, forKey: .visitorFound)
        try container.encode(confidence, forKey: .confidence)
        try container.encodeIfPresent(ipAddress, forKey: .ipAddress)
        try container.encodeIfPresent(ipLocation, forKey: .ipLocation)
        try container.encodeIfPresent(firstSeenAt, forKey: .firstSeenAt)
        try container.encodeIfPresent(lastSeenAt, forKey: .lastSeenAt)
    }
}
