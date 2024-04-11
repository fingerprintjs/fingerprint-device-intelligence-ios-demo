import FingerprintPro

struct ClientResponseEvent: Equatable {
    let fingerprintResponse: FingerprintResponse
    let smartSignalsResponse: SmartSignalsResponse?
}

extension ClientResponseEvent: Encodable {

    private enum CodingKeys: String, CodingKey {
        case fingerprintResponse = "identification"
        case smartSignalsResponse = "smartSignals"
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fingerprintResponse, forKey: .fingerprintResponse)
        try container.encodeIfPresent(smartSignalsResponse?.products, forKey: .smartSignalsResponse)
    }
}
