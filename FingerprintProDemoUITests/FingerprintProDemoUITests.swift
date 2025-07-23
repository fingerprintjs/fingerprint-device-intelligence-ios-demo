import XCTest

final class FingerprintProDemoUITests: XCTestCase {

    private enum EnvVariable: String {
        case apiKey = "API_KEY"
        case region = "REGION"
    }

    private enum Accessibility {
        static let tapToBeginButton = "tapToBeginButton"
        static let fingerprintErrorView = "fingerprintErrorView"
        static let fingerprintResultView = "fingerprintResultView"
    }

    private let tapToBeginTimeout: TimeInterval = 10
    private let fingerprintViewTimeout: TimeInterval = 20

    private var sut: XCUIApplication!

    override func setUp() {
        super.setUp()
        sut = XCUIApplication()
    }

    func test_givenNoKey_whenFingeprintViewDisplayed_thenShowsKeyMissingOrInvalidError() {
        // given
        sut.launchEnvironment = [:]

        // when
        sut.launch()

        // then
        XCTAssertTrue(sut.buttons[Accessibility.tapToBeginButton].waitForExistence(timeout: tapToBeginTimeout))
        sut.buttons[Accessibility.tapToBeginButton].firstMatch.tap()
        XCTAssertTrue(sut.staticTexts[Accessibility.fingerprintErrorView].waitForExistence(timeout: fingerprintViewTimeout))

        captureTestScreenshot()
    }

    func test_givenInvalidKey_whenFingeprintViewDisplayed_thenShowsKeyMissingOrInvalidError() {
        // given
        sut.launchEnvironment = [
            EnvVariable.apiKey.rawValue: "invalidKey",
            EnvVariable.region.rawValue: "global",
        ]

        // when
        sut.launch()

        // then
        XCTAssertTrue(sut.buttons[Accessibility.tapToBeginButton].waitForExistence(timeout: tapToBeginTimeout))
        sut.buttons[Accessibility.tapToBeginButton].firstMatch.tap()
        XCTAssertTrue(sut.staticTexts[Accessibility.fingerprintErrorView].waitForExistence(timeout: fingerprintViewTimeout))

        captureTestScreenshot()
    }

    func test_givenValidKey_whenFingeprintViewDisplayed_thenShowsFingerprint() {
        // given
        guard let apiKey = ProcessInfo.processInfo.environment[EnvVariable.apiKey.rawValue] else {
            XCTFail("Failed to read API key from the environment")
            return
        }
        guard let region = ProcessInfo.processInfo.environment[EnvVariable.region.rawValue] else {
            XCTFail("Failed to read region from the environment")
            return
        }

        sut.launchEnvironment = [
            EnvVariable.apiKey.rawValue: apiKey,
            EnvVariable.region.rawValue: region,
        ]

        // when
        sut.launch()

        // then
        XCTAssertTrue(sut.buttons[Accessibility.tapToBeginButton].waitForExistence(timeout: tapToBeginTimeout))
        sut.buttons[Accessibility.tapToBeginButton].firstMatch.tap()
        XCTAssertTrue(sut.staticTexts[Accessibility.fingerprintResultView].waitForExistence(timeout: fingerprintViewTimeout))
        XCTAssertFalse(sut.staticTexts[Accessibility.fingerprintErrorView].waitForExistence(timeout: fingerprintViewTimeout))

        captureTestScreenshot()
    }
}

private extension FingerprintProDemoUITests {

    func captureTestScreenshot() {
        add(sut.screenshotAttachment())
    }
}

private extension XCUIApplication {

    func screenshotAttachment() -> XCTAttachment {
        let screenshot = screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        return attachment
    }
}
