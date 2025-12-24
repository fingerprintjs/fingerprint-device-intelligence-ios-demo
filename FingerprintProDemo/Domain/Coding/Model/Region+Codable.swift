import FingerprintPro

extension Region: @retroactive Swift.Codable {

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.global) {
            self = .global
        } else if container.contains(.eu) {
            self = .eu
        } else if container.contains(.ap) {
            self = .ap
        } else {
            let custom = try container.decode(Custom.self, forKey: .custom)
            self = .custom(domain: custom.domain, fallback: custom.fallback)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .global:
            try container.encode(Empty(), forKey: .global)
        case .eu:
            try container.encode(Empty(), forKey: .eu)
        case .ap:
            try container.encode(Empty(), forKey: .ap)
        case let .custom(domain, fallback):
            try container.encode(
                Custom(domain: domain, fallback: fallback),
                forKey: .custom
            )
        @unknown default:
            fatalError()
        }
    }
}

private extension Region {

    enum CodingKeys: String, CodingKey {
        case global
        case eu
        case ap
        case custom
    }

    struct Custom: Codable {
        let domain: String
        let fallback: [String]
    }

    struct Empty: Encodable {}
}
