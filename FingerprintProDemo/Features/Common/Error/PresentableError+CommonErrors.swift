extension PresentableError {

    static var networkError: Self {
        .init(
            image: .cloudSlash,
            localizedTitle: .init(localized: "Server cannot be reached"),
            localizedDescription: .init(
                localized: """
                           Please check your network settings and try again.
                           """
            )
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
            )
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
            )
        )
    }
}
