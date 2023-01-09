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
        continueAfterFailure = false
        app.launch()
        print(app.debugDescription)
        app.staticTexts["KeyID_AC"].tap()
        let infoText = app.staticTexts["infoText"]
        XCTAssertEqual(infoText.label, "Precision: ten million digits")
    }

    override func tearDownWithError() throws {
    }

    func test_ln_0_infinity() throws {
        app.staticTexts["KeyID_ln"].tap()
        XCTAssertEqual(app.staticTexts["landscapeDisplayText"].label, "infinity")
    }

    func test_e_infinity_notChanged() throws {
        app.staticTexts["KeyID_ln"].tap()
        XCTAssertEqual(app.staticTexts["landscapeDisplayText"].label, "infinity")
        app.staticTexts["KeyID_e^x"].tap()
        XCTAssertEqual(app.staticTexts["landscapeDisplayText"].label, "infinity")
    }
    
    func test_changeSign_7() throws {
        app.staticTexts["KeyID_7"].tap()
        app.images["KeyID_±"].tap()
        XCTAssertEqual(app.staticTexts["landscapeDisplayText"].label, "-7")
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
