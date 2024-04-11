import FingerprintPro

typealias FingerprintClient = FingerprintClientProviding

protocol FingerprintClientFactory {
    static func getInstance(_ configuration: Configuration) -> FingerprintClient
}

protocol DeviceIdentificationServiceProtocol {
    func fingerprintDevice() async -> Result<FingerprintResponse, any Error>
}

struct DeviceIdentificationService<ClientFactory: FingerprintClientFactory>: DeviceIdentificationServiceProtocol {

    func fingerprintDevice() async -> Result<FingerprintResponse, any Error> {
        let client = makeFingerprintClient()

        do {
            let response = try await client.getVisitorIdResponse()
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}

private extension DeviceIdentificationService {

    func makeFingerprintClient() -> FingerprintClient {
        let configuration = Configuration(
            apiKey: ConfigVariable.apiKey,
            region: ConfigVariable.region,
            extendedResponseFormat: true
        )

        return ClientFactory.getInstance(configuration)
    }
}
