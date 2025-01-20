extension PresentableError {

    static var networkError: Self {
        .init(
            image: .cloudSlash,
            localizedTitle: .init(localized: "Server cannot be reached"),
            localizedDescription: .init(
                localized: """
                    Please check your network settings and try again.
                    """
            ),
            actionKind: .retry
        )
    }

    static var publicApiKeyExpiredError: Self {
        .init(
            image: .exclamationMark,
            localizedTitle: .init(localized: "Failed to Fingerprint"),
            localizedDescription: .init(
                localized: """
                    The public key has expired.
                    """
            ),
            actionKind: .editApiKeys
        )
    }

    static var publicApiKeyInvalidError: Self {
        .init(
            image: .exclamationMark,
            localizedTitle: .init(localized: "Failed to Fingerprint"),
            localizedDescription: .init(
                localized: """
                    The public API key is missing or invalid. Ensure the key was \
                    entered correctly.
                    """
            ),
            actionKind: .editApiKeys
        )
    }

    static var secretApiKeyMismatchError: Self {
        .init(
            image: .exclamationMark,
            localizedTitle: .init(localized: "Failed to fetch Smart Signals"),
            localizedDescription: .init(
                localized: """
                    The provided secret API key is invalid. Make sure that provided \
                    public and secret API keys belong to the same application.
                    """
            ),
            actionKind: .editApiKeys
        )
    }

    static var secretApiKeyInvalidError: Self {
        .init(
            image: .exclamationMark,
            localizedTitle: .init(localized: "Failed to fetch Smart Signals"),
            localizedDescription: .init(
                localized: """
                    The provided secret API key is either missing or invalid. \
                    Please double-check that the key was entered correctly.
                    """
            ),
            actionKind: .editApiKeys
        )
    }

    static var subscriptionNotActiveError: Self {
        .init(
            image: .exclamationMark,
            localizedTitle: .init(localized: "Failed to Fingerprint"),
            localizedDescription: .init(
                localized: """
                    The application is not active for the provided public API key.
                    """
            ),
            actionKind: .editApiKeys
        )
    }

    static var tooManyRequestsError: Self {
        .init(
            image: .handRaised,
            localizedTitle: .init(localized: "Too many requests"),
            localizedDescription: .init(
                localized: """
                    The request rate limit set for the public API key was exceeded.
                    """
            ),
            actionKind: .retry
        )
    }

    static var wrongRegionError: Self {
        .init(
            image: .exclamationMark,
            localizedTitle: .init(localized: "Failed to Fingerprint"),
            localizedDescription: .init(
                localized: """
                    The public API key is not intended for the selected region. \
                    Visit Settings to change the region.
                    """
            ),
            actionKind: .editApiKeys
        )
    }

    static var unknownError: Self {
        .init(
            image: .exclamationMark,
            localizedTitle: .init(localized: "An unexpected error occurred..."),
            localizedDescription: .init(
                localized: """
                    Please [contact support](\(C.URLs.support, format: .url)) \
                    if this issue persists.
                    """
            ),
            actionKind: .retry
        )
    }
}
