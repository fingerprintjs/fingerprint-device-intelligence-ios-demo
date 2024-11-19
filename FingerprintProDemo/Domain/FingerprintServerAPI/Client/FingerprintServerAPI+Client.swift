import Foundation

extension FingerprintServerAPI {

    protocol Client: Sendable {
        func request<
            Encoder: DataEncoder,
            Response: Decodable & Sendable,
            Decoder: DataDecoder
        >(
            _ endpoint: Endpoint,
            payload: (any Encodable)?,
            encoder: Encoder,
            decoder: Decoder
        ) async throws -> Response
    }
}

extension FingerprintServerAPI.Client {

    func request<
        Encoder: DataEncoder,
        Response: Decodable & Sendable,
        Decoder: DataDecoder
    >(
        _ endpoint: FingerprintServerAPI.Endpoint,
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
    ) async throws -> Response {
        try await request(
            endpoint,
            payload: payload,
            encoder: encoder,
            decoder: decoder
        )
    }
}

extension HTTPClient: FingerprintServerAPI.Client {

    func request<
        Encoder: DataEncoder,
        Response: Decodable & Sendable,
        Decoder: DataDecoder
    >(
        _ endpoint: FingerprintServerAPI.Endpoint,
        payload: (any Encodable)?,
        encoder: Encoder,
        decoder: Decoder
    ) async throws -> Response {
        try await request(
            endpoint,
            method: endpoint.method,
            headerFields: endpoint.headerFields,
            payload: payload,
            encoder: encoder,
            decoder: decoder
        )
        .mapError { error -> any Error in
            #if DEBUG
            print("[\(type(of: self))] (\(endpoint)) |> \(#function) -> \(error)")
            if case let .responseError(_, errorData) = error {
                print(String(decoding: errorData, as: UTF8.self))
            }
            #endif
            guard let responseError = FingerprintServerAPI.ResponseError(from: error) else {
                return error
            }
            return responseError
        }
        .get()
    }
}
