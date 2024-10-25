import Foundation

final class HTTPClient: Sendable {

    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }
}

extension HTTPClient {

    func request<
        Convertible: URLConvertible,
        Encoder: DataEncoder,
        Response: Decodable & Sendable,
        Decoder: DataDecoder
    >(
        _ convertible: Convertible,
        method: HTTPMethod = .get,
        headerFields: Set<HTTPHeaderField> = [],
        payload: (any Encodable)? = .none,
        encoder: Encoder = JSONEncoder(),
        decoder: Decoder = JSONDecoder()
    ) async -> Result<Response, NetworkingError> {
        guard let url = try? convertible.asURL() else {
            return .failure(.invalidURL(url: convertible))
        }

        var urlRequest: URLRequest
        do {
            urlRequest = .init(url: url)
            urlRequest.httpMethod = method.rawValue
            headerFields.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.name) }
            if let payload {
                urlRequest.httpBody = try encoder.encode(payload)
            }
        } catch {
            return .failure(.payloadEncodingFailed(error: error))
        }

        return await request(urlRequest, decoder: decoder)
    }

    func request<
        Convertible: URLRequestConvertible,
        Response: Decodable & Sendable,
        Decoder: DataDecoder
    >(
        _ convertible: Convertible,
        decoder: Decoder = JSONDecoder()
    ) async -> Result<Response, NetworkingError> {
        let urlRequest: URLRequest
        do {
            urlRequest = try convertible.asURLRequest()
        } catch {
            return .failure(.createURLRequestFailed(error: error))
        }

        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let response = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            guard Validation.isSuccessStatusCode(response.statusCode) else {
                let error: NetworkingError = .responseError(
                    errorCode: response.statusCode,
                    errorData: data
                )
                return .failure(error)
            }

            return Result { try decoder.decode(Response.self, from: data) }
                .mapError(NetworkingError.responseDecodingFailed(error:))
        } catch {
            return .failure(.requestFailed(error: error))
        }
    }
}

private extension HTTPClient {

    enum Validation {

        static func isSuccessStatusCode(_ statusCode: Int) -> Bool {
            200 ... 299 ~= statusCode
        }
    }
}
