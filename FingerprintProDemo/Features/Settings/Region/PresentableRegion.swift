import FingerprintPro

enum PresentableRegion: String, Sendable, CaseIterable {
    /// A default Global (US) region.
    case global
    /// A European (EU) region.
    case eu
    /// An Asia-Pacific (APAC) region.
    case ap
}

extension PresentableRegion: CustomStringConvertible {

    var description: String {
        switch self {
        case .global: .init(localized: "Global (US)")
        case .eu: .init(localized: "EU")
        case .ap: .init(localized: "Asia (Mumbai)")
        }
    }
}

extension PresentableRegion {

    var underlyingRegion: Region {
        switch self {
        case .global: .global
        case .eu: .eu
        case .ap: .ap
        }
    }

    init?(_ region: Region) {
        switch region {
        case .global: self = .global
        case .eu: self = .eu
        case .ap: self = .ap
        default: return nil
        }
    }
}

extension PresentableRegion: Identifiable {

    var id: RawValue { rawValue }
}
