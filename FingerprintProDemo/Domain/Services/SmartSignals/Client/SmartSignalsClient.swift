import Foundation

protocol SmartSignalsClient: Sendable {
    func request<
        Encoder: DataEncoder,
        Response: Decodable & Sendable,
        Decoder: DataDecoder
    >(
        _ endpoint: SmartSignalsEndpoint,
        payload: (any Encodable)?,
        encoder: Encoder,
        decoder: Decoder
    ) async -> Result<Response, NetworkingError>
}

extension SmartSignalsClient {

    func request<
        Encoder: DataEncoder,
        Response: Decodable & Sendable,
        Decoder: DataDecoder
    >(
        _ endpoint: SmartSignalsEndpoint,
        payload: (any Encodable)? = .none,
        encoder: Encoder = {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return encoder
        }(),
        decoder: Decoder = {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return decoder
        }()
    ) async -> Result<Response, NetworkingError> {
        await request(
            endpoint,
            payload: payload,
            encoder: encoder,
            decoder: decoder
        )
    }
}

extension HTTPClient: SmartSignalsClient {

    func request<
        Encoder: DataEncoder,
        Response: Decodable & Sendable,
        Decoder: DataDecoder
    >(
        _ endpoint: SmartSignalsEndpoint,
        payload: (any Encodable)?,
        encoder: Encoder,
        decoder: Decoder
    ) async -> Result<Response, NetworkingError> {
        await request(
            endpoint,
            method: endpoint.method,
            headerFields: endpoint.headerFields,
            payload: payload,
            encoder: encoder,
            decoder: decoder
        )
    }
}
