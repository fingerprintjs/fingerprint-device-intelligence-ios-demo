import FingerprintPro

struct ApiKeysConfig: Codable {
    let publicKey: String
    let secretKey: String
    let region: Region
}
