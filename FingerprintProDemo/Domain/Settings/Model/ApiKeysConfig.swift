import FingerprintPro

struct ApiKeysConfig: Equatable, Codable {
    let publicKey: String
    let secretKey: String
    let region: Region
}
