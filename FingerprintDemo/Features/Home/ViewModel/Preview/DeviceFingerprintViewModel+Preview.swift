extension DeviceFingerprintViewModel {

    static var preview: Self {
        .init(
            identificationService: .preview,
            smartSignalsService: .preview,
            geolocationService: .preview,
            settingsContainer: .preview
        )
    }
}
