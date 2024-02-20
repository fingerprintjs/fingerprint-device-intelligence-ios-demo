extension DeviceFingerprintViewModel {

    static var preview: Self {
        .init(
            identificationService: .preview,
            userDefaults: .preview
        )
    }
}
