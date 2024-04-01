extension DeviceFingerprintViewModel {

    static var preview: Self {
        .init(
            identificationService: .preview,
            settingsContainer: .preview
        )
    }
}
