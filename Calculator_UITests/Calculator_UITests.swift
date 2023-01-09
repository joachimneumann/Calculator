//
//  Calculator_UITests.swift
//  Calculator_UITests
//
//  Created by Joachim Neumann on 1/9/23.
//

import XCTest

final class Calculator_UITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        let device = XCUIDevice.shared
        device.orientation = .landscapeRight
        continueAfterFailure = false
        app.launch()
        print(app.debugDescription)
    }

    override func tearDownWithError() throws {
    }

    func test_infoText() {
        app.staticTexts["KeyID_AC"].tap()
        let infoText = app.staticTexts["infoText"]
        XCTAssertEqual(infoText.label, "Precision: 200 thousand digits")
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
        let app = XCUIApplication()
        app.staticTexts["KeyID_2^nd"].tap()
        app.staticTexts["KeyID_2^nd"].tap()
        app.staticTexts["KeyID_sin"].tap()
        XCTAssertEqual(app.staticTexts["landscapeDisplayText"].label, "0")
    }

    func test_9_sin_cos_tan() {
        let app = XCUIApplication()
        /// make sure we are in Degrees, not Radians
        if app.staticTexts["infoText"].label == "Rad" {
            app.staticTexts["KeyID_Deg"].tap()
        }
        app.staticTexts["KeyID_9"].tap()
        app.staticTexts["KeyID_sin"].tap()
        sleep(4)
        app.staticTexts["KeyID_cos"].tap()
        sleep(4)
        app.staticTexts["KeyID_tan"].tap()
        sleep(4)
        app.staticTexts["KeyID_2^nd"].tap()
        app.staticTexts["KeyID_tan^-1"].tap()
        sleep(4)
        app.staticTexts["KeyID_cos^-1"].tap()
        sleep(4)
        app.staticTexts["KeyID_sin^-1"].tap()
        sleep(4)
        XCTAssertEqual(app.staticTexts["landscapeDisplayText"].label, "9")
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
