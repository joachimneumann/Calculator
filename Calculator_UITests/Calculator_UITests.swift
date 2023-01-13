//
//  Calculator_UITests.swift
//  Calculator_UITests
//
//  Created by Joachim Neumann on 1/9/23.
//

import XCTest

final class Calculator_UITests: XCTestCase {

    let app = XCUIApplication()

    func forcePrecision(incrementCounter: Int) {
        app.images["plusButton"].tap()
        app.buttons["settingsButton"].tap()
        let decrementButton = app.scrollViews.otherElements.buttons["decrementButton"]
        let incrementButton = app.scrollViews.otherElements.buttons["incrementButton"]
        for _ in 0..<30 { decrementButton.tap() }
        for _ in 0..<incrementCounter { incrementButton.tap() }
        app.buttons["Back"].tap()
        app.images["plusButton"].tap()
        app.staticTexts["KeyID_AC"].tap()
        app.staticTexts["KeyID_AC"].tap()
    }
    
    override func setUpWithError() throws {
        let device = XCUIDevice.shared
        device.orientation = .landscapeRight
        continueAfterFailure = false
        app.launch()

        app.staticTexts["KeyID_AC"].tap()
        if app.staticTexts["infoText"].label != "Precision: 200 thousand digits" {
            forcePrecision(incrementCounter: 13) // 200,000
        }
        app.staticTexts["KeyID_AC"].tap()
    }

    override func tearDownWithError() throws {
    }

    func test_infoText() {
        app.staticTexts["KeyID_AC"].tap()
        var infoText = app.staticTexts["infoText"]
        XCTAssertEqual(infoText.label, "Precision: 200 thousand digits")
        app.staticTexts["KeyID_AC"].tap()
        infoText = app.staticTexts["infoText"]
        XCTAssertEqual(infoText.label, "")
    }
    
    func test_ln_0_infinity() throws {
        app.staticTexts["KeyID_ln"].tap()
        XCTAssertEqual(app.staticTexts["landscapeDisplayText"].label, "infinity")
    }

    func test_e_infinity_notChanged() {
        app.staticTexts["KeyID_ln"].tap()
        XCTAssertEqual(app.staticTexts["landscapeDisplayText"].label, "infinity")
        app.staticTexts["KeyID_e^x"].tap()
        XCTAssertEqual(app.staticTexts["landscapeDisplayText"].label, "infinity")
    }
    
    func test_changeSign_7() {
        app.staticTexts["KeyID_7"].tap()
        app.images["KeyID_±"].tap()
        XCTAssertEqual(app.staticTexts["landscapeDisplayText"].label, "-7")
    }

    func test_2nd() {
        app.staticTexts["KeyID_2^nd"].tap()
        app.staticTexts["KeyID_2^nd"].tap()
        app.staticTexts["KeyID_sin"].tap()
        XCTAssertEqual(app.staticTexts["landscapeDisplayText"].label, "0")
    }

    func test_9_sin_cos_tan() {
        /// make sure we are in Degrees, not Radians
        if app.staticTexts["infoText"].label == "Rad" {
            app.staticTexts["KeyID_Deg"].tap()
        }
        let sleepDuration:UInt32 = 4 // seconds
        app.staticTexts["KeyID_9"].tap()
        app.staticTexts["KeyID_sin"].tap()
        sleep(sleepDuration)
        app.staticTexts["KeyID_cos"].tap()
        sleep(sleepDuration)
        app.staticTexts["KeyID_tan"].tap()
        sleep(sleepDuration)
        app.staticTexts["KeyID_2^nd"].tap()
        app.staticTexts["KeyID_tan^-1"].tap()
        sleep(sleepDuration)
        app.staticTexts["KeyID_cos^-1"].tap()
        sleep(sleepDuration)
        app.staticTexts["KeyID_sin^-1"].tap()
        sleep(sleepDuration)
        /// if this test fails, maybe the sleepDuration was too short
        XCTAssertEqual(app.staticTexts["landscapeDisplayText"].label, "9")
    }
    
    func test_REQUIRES_PERMISSION_IN_POPUP_copy_paste_precision() {
        app.staticTexts["Rand"].tap()
        let plusbuttonImage = app.images["plusButton"]
        plusbuttonImage.tap()
        app.staticTexts["copyButton"].tap()
        plusbuttonImage.tap()
        XCTAssertEqual(UIPasteboard.general.string?.count, 200_000)
    }
    
    func test_copy_pending() {
        
    }

    func test_copy_non_pending() {
        
    }

    func test_mr_pending() {
        
    }

    func test_mr_non_pending() {
        
    }

//    func XestLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
