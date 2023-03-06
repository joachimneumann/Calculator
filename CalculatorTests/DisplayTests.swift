//
//  DisplayTests.swift
//
//  Created by Joachim Neumann on 10/31/21.
//

import XCTest

@testable import Better_Calc

class DisplayTests: XCTestCase {
    var screen: Screen = Screen(CGSize(width: 428.0, height: 845.0))
    let viewModel = ViewModel()
    let precision = 1000

    override func setUpWithError() throws {
        screen = Screen(CGSize(width: 428.0, height: 845.0))
        screen.groupingSeparator = .none
        screen.decimalSeparator = .comma
        screen.ePadding = 0.0
        viewModel.showAsFloat = false
        viewModel.showAsInt = false
    }
    
    override func tearDownWithError() throws {
    }

    private func left(_ s: String) -> String {
        Display(s, screen: screen, showAs: viewModel, forceScientific: false).left
    }
    private func right(_ s: String) -> String? {
        Display(s, screen: screen, showAs: viewModel, forceScientific: false).right
    }
    private func allInOneLine(_ s: String) -> String {
        Display(s, screen: screen, showAs: viewModel, forceScientific: false).allInOneLine
    }
    private func left(_ n: Number) -> String {
        Display(n, screen: screen, showAs: viewModel, forceScientific: false).left
    }
    private func right(_ n: Number) -> String? {
        Display(n, screen: screen, showAs: viewModel, forceScientific: false).right
    }
    private func allInOneLine(_ n: Number) -> String {
        Display(n, screen: screen, showAs: viewModel, forceScientific: false).allInOneLine
    }

    func test_portraitIPhone() {
        screen = Screen(CGSize(width: 428.0, height: 845.0)) // portrait iPhone 13 Pro Max
        screen.groupingSeparator = .none
        screen.decimalSeparator = .dot
        screen.ePadding = 0.0
        XCTAssertEqual( left("1234567890"),     "1234567890")
        XCTAssertEqual(right("1234567890"),     nil)

        XCTAssertEqual( left("12345678901"),     "1.2345678901")
        XCTAssertEqual(right("12345678901"),     "e10")
        
        XCTAssertEqual( left("123456789012"),    "1.23456789012")
        XCTAssertEqual(right("123456789012"),    "e11")
        
        XCTAssertEqual( left("123456.4444444444"), "123456.4444444444")
        XCTAssertEqual(right("123456.4444444444"),     nil)
        
        XCTAssertEqual( left("123456789.1"),    "123456789.1")
        XCTAssertEqual(right("123456789.1"),     nil)
        
        XCTAssertEqual( left("1234567890.1"),    "1.2345678901")
        XCTAssertEqual(right("1234567890.1"),     "e9")
        
        XCTAssertEqual( left("12345678901.1"),   "1.23456789011")
        XCTAssertEqual(right("12345678901.1"),   "e10")
        
        XCTAssertEqual( left("123456789012.1"),  "1.234567890121")
        XCTAssertEqual(right("123456789012.1"),  "e11")
    }
    
    
    func test_Separators() {
        let debugBrain = DebugBrain(precision: precision)
        screen.decimalSeparator = .comma
        screen.groupingSeparator = .none
        XCTAssertEqual(left("1234567.7"), "1234567,7")
        debugBrain.pushnew(1234567.7)
        XCTAssertEqual(left(debugBrain.last), "1234567,7")

        screen.decimalSeparator = .dot
        screen.groupingSeparator = .none
        debugBrain.pushnew(1234567.7)
        XCTAssertEqual(left(debugBrain.last), "1234567.7")

        screen.decimalSeparator = .dot
        screen.groupingSeparator = .comma
        XCTAssertEqual(left(debugBrain.last), "1,234,567.7")
        screen.decimalSeparator = .comma
        screen.groupingSeparator = .dot
        XCTAssertEqual(left(debugBrain.last), "1.234.567,7")
    }

    func test_float_more_than_1() {
        XCTAssertEqual( left("1.9"),              "1,9")
        XCTAssertEqual(right("1.9"),              nil)
        XCTAssertEqual( left("12.9"),             "12,9")
        XCTAssertEqual(right("12.9"),             nil)
        XCTAssertEqual( left("1234.9"),           "1234,9")
        XCTAssertEqual(right("1234.9"),           nil)
        XCTAssertEqual( left("12345.9"),          "12345,9")
        XCTAssertEqual(right("12345.9"),          nil)
        XCTAssertEqual( left("123456.9"),         "123456,9")
        XCTAssertEqual(right("123456.9"),         nil)
        XCTAssertEqual( left("1234567.9"),        "1234567,9")
        XCTAssertEqual(right("1234567.9"),        nil)
        XCTAssertEqual( left("12345678.9"),       "12345678,9")
        XCTAssertEqual(right("12345678.9"),       nil)
        XCTAssertEqual( left("123456789.9"),      "123456789,9")
        XCTAssertEqual(right("123456789.9"),      nil)
        XCTAssertEqual( left("1234567890.9"),     "1,2345678909")
        XCTAssertEqual(right("1234567890.9"),     "e9")
        XCTAssertEqual( left("12345678901.9"),    "1,23456789019") /// this is too long for one line, but that is ok
        XCTAssertEqual(right("12345678901.9"),    "e10")
        XCTAssertEqual( left("123456789012.9"),   "1,234567890129")
        XCTAssertEqual(right("123456789012.9"),   "e11")
        XCTAssertEqual( left("1234567890123.9"),  "1,2345678901239")
        XCTAssertEqual(right("1234567890123.9"),  "e12")
        XCTAssertEqual( left("12345678901234.9"), "1,23456789012349")
        XCTAssertEqual(right("12345678901234.9"), "e13")
        
        XCTAssertEqual( left("1.9876"),              "1,9876")
        XCTAssertEqual(right("1.9876"),              nil)
        XCTAssertEqual( left("12.9876"),             "12,9876")
        XCTAssertEqual(right("12.9876"),             nil)
        XCTAssertEqual( left("1234.9876"),           "1234,9876")
        XCTAssertEqual(right("1234.9876"),           nil)
        XCTAssertEqual( left("12345.9876"),          "12345,9876")
        XCTAssertEqual(right("12345.9876"),          nil)
        XCTAssertEqual( left("123456.9876"),         "123456,9876")
        XCTAssertEqual(right("123456.9876"),         nil)
        XCTAssertEqual( left("1234567.9876"),        "1234567,9876")
        XCTAssertEqual(right("1234567.9876"),        nil)
        XCTAssertEqual( left("12345678.9876"),       "12345678,9876") /// this is too long for one line, but that is ok
        XCTAssertEqual(right("12345678.9876"),       nil)
        XCTAssertEqual( left("123456789.9876"),      "123456789,9876")
        XCTAssertEqual(right("123456789.9876"),      nil)
        XCTAssertEqual( left("1234567890.9876"),     "1,2345678909876")
        XCTAssertEqual(right("1234567890.9876"),     "e9")
        XCTAssertEqual( left("12345678901.9876"),    "1,23456789019876")
        XCTAssertEqual(right("12345678901.9876"),    "e10")
        XCTAssertEqual( left("123456789012.9876"),   "1,234567890129876")
        XCTAssertEqual(right("123456789012.9876"),   "e11")
        XCTAssertEqual( left("1234567890123.9876"),  "1,2345678901239876")
        XCTAssertEqual(right("1234567890123.9876"),  "e12")
        XCTAssertEqual( left("12345678901234.9876"), "1,23456789012349876")
        XCTAssertEqual(right("12345678901234.9876"), "e13")
        
        XCTAssertEqual( left("1.987654321098765432"),              "1,987654321098765432")
        XCTAssertEqual(right("1.987654321098765432"),              nil)
        XCTAssertEqual( left("12.987654321098765432"),             "12,987654321098765432")
        XCTAssertEqual(right("12.987654321098765432"),             nil)
        XCTAssertEqual( left("123.987654321098765432"),            "123,987654321098765432")
        XCTAssertEqual(right("123.987654321098765432"),            nil)
        XCTAssertEqual( left("1234.987654321098765432"),           "1234,987654321098765432")
        XCTAssertEqual(right("1234.987654321098765432"),           nil)
        XCTAssertEqual( left("12345.987654321098765432"),          "12345,987654321098765432")
        XCTAssertEqual(right("12345.987654321098765432"),          nil)
        XCTAssertEqual( left("123456.987654321098765432"),         "123456,987654321098765432")
        XCTAssertEqual(right("123456.987654321098765432"),         nil)
        XCTAssertEqual( left("1234567.987654321098765432"),        "1234567,987654321098765432")
        XCTAssertEqual(right("1234567.987654321098765432"),        nil)
        XCTAssertEqual( left("12345678.987654321098765432"),       "12345678,987654321098765432")
        XCTAssertEqual(right("12345678.987654321098765432"),       nil)
        XCTAssertEqual( left("123456789.987654321098765432"),      "123456789,987654321098765432")
        XCTAssertEqual(right("123456789.987654321098765432"),      nil)
        XCTAssertEqual( left("1234567890.987654321098765432"),     "1,234567890987654321098765432")
        XCTAssertEqual(right("1234567890.987654321098765432"),     "e9")
        XCTAssertEqual( left("12345678901.987654321098765432"),    "1,2345678901987654321098765432")
        XCTAssertEqual(right("12345678901.987654321098765432"),    "e10")
        XCTAssertEqual( left("123456789012.987654321098765432"),   "1,23456789012987654321098765432")
        XCTAssertEqual(right("123456789012.987654321098765432"),   "e11")
        XCTAssertEqual( left("1234567890123.987654321098765432"),  "1,234567890123987654321098765432")
        XCTAssertEqual(right("1234567890123.987654321098765432"),  "e12")
        XCTAssertEqual( left("12345678901234.987654321098765432"), "1,2345678901234987654321098765432")
        XCTAssertEqual(right("12345678901234.987654321098765432"), "e13")
    }
    
    func test_float_more_than_1_grouping() {
        screen.decimalSeparator = .dot
        screen.groupingSeparator = .comma
        XCTAssertEqual( left("1.9"),              "1.9")
        XCTAssertEqual(right("1.9"),              nil)
        XCTAssertEqual( left("12.9"),             "12.9")
        XCTAssertEqual(right("12.9"),             nil)
        XCTAssertEqual( left("1234.9"),           "1,234.9")
        XCTAssertEqual(right("1234.9"),           nil)
        XCTAssertEqual( left("12345.9"),          "12,345.9")
        XCTAssertEqual(right("12345.9"),          nil)
        XCTAssertEqual( left("123456.9"),         "123,456.9")
        XCTAssertEqual(right("123456.9"),         nil)
        XCTAssertEqual( left("1234567.9"),        "1,234,567.9")
        XCTAssertEqual(right("1234567.9"),        nil)
        XCTAssertEqual( left("12345678.9"),       "12,345,678.9")
        XCTAssertEqual(right("12345678.9"),       nil)
        XCTAssertEqual( left("123456789.9"),      "123,456,789.9")
        XCTAssertEqual(right("123456789.9"),      nil)
        XCTAssertEqual( left("1234567890.9"),     "1.2345678909")
        XCTAssertEqual(right("1234567890.9"),     "e9")
        XCTAssertEqual( left("12345678901.9"),    "1.23456789019")
        XCTAssertEqual(right("12345678901.9"),    "e10")
        XCTAssertEqual( left("123456789012.9"),   "1.234567890129")
        XCTAssertEqual(right("123456789012.9"),   "e11")
        XCTAssertEqual( left("1234567890123.9"),  "1.2345678901239")
        XCTAssertEqual(right("1234567890123.9"),  "e12")
        XCTAssertEqual( left("12345678901234.9"), "1.23456789012349")
        XCTAssertEqual(right("12345678901234.9"), "e13")
        
        XCTAssertEqual( left("1.9876"),              "1.9876")
        XCTAssertEqual(right("1.9876"),              nil)
        XCTAssertEqual( left("12.9876"),             "12.9876")
        XCTAssertEqual(right("12.9876"),             nil)
        XCTAssertEqual( left("1234.9876"),           "1,234.9876")
        XCTAssertEqual(right("1234.9876"),           nil)
        XCTAssertEqual( left("12345.9876"),          "12,345.9876")
        XCTAssertEqual(right("12345.9876"),          nil)
        XCTAssertEqual( left("123456.9876"),         "123,456.9876")
        XCTAssertEqual(right("123456.9876"),         nil)
        XCTAssertEqual( left("1234567.9876"),        "1,234,567.9876")
        XCTAssertEqual(right("1234567.9876"),        nil)
        XCTAssertEqual( left("12345678.9876"),       "12,345,678.9876") /// this is too long for one line, but that is ok
        XCTAssertEqual(right("12345678.9876"),       nil)
        XCTAssertEqual( left("123456789.9876"),      "123,456,789.9876")
        XCTAssertEqual(right("123456789.9876"),      nil)
        XCTAssertEqual( left("1234567890.9876"),     "1.2345678909876")
        XCTAssertEqual(right("1234567890.9876"),     "e9")
        XCTAssertEqual( left("12345678901.9876"),    "1.23456789019876")
        XCTAssertEqual(right("12345678901.9876"),    "e10")
        XCTAssertEqual( left("123456789012.9876"),   "1.234567890129876")
        XCTAssertEqual(right("123456789012.9876"),   "e11")
        XCTAssertEqual( left("1234567890123.9876"),  "1.2345678901239876")
        XCTAssertEqual(right("1234567890123.9876"),  "e12")
        XCTAssertEqual( left("12345678901234.9876"), "1.23456789012349876")
        XCTAssertEqual(right("12345678901234.9876"), "e13")
        
        XCTAssertEqual( left("1.987654321098765432"),              "1.987654321098765432")
        XCTAssertEqual(right("1.987654321098765432"),              nil)
        XCTAssertEqual( left("12.987654321098765432"),             "12.987654321098765432")
        XCTAssertEqual(right("12.987654321098765432"),             nil)
        XCTAssertEqual( left("123.987654321098765432"),            "123.987654321098765432")
        XCTAssertEqual(right("123.987654321098765432"),            nil)
        XCTAssertEqual( left("1234.987654321098765432"),           "1,234.987654321098765432")
        XCTAssertEqual(right("1234.987654321098765432"),           nil)
        XCTAssertEqual( left("12345.987654321098765432"),          "12,345.987654321098765432")
        XCTAssertEqual(right("12345.987654321098765432"),          nil)
        XCTAssertEqual( left("123456.987654321098765432"),         "123,456.987654321098765432")
        XCTAssertEqual(right("123456.987654321098765432"),         nil)
        XCTAssertEqual( left("1234567.987654321098765432"),        "1,234,567.987654321098765432")
        XCTAssertEqual(right("1234567.987654321098765432"),        nil)
        XCTAssertEqual( left("12345678.987654321098765432"),       "12,345,678.987654321098765432")
        XCTAssertEqual(right("12345678.987654321098765432"),       nil)
        XCTAssertEqual( left("123456789.987654321098765432"),      "123,456,789.987654321098765432")
        XCTAssertEqual(right("123456789.987654321098765432"),      nil)
        XCTAssertEqual( left("1234567890.987654321098765432"),     "1.234567890987654321098765432")
        XCTAssertEqual(right("1234567890.987654321098765432"),     "e9")
        XCTAssertEqual( left("12345678901.987654321098765432"),    "1.2345678901987654321098765432")
        XCTAssertEqual(right("12345678901.987654321098765432"),    "e10")
        XCTAssertEqual( left("123456789012.987654321098765432"),   "1.23456789012987654321098765432")
        XCTAssertEqual(right("123456789012.987654321098765432"),   "e11")
        XCTAssertEqual( left("1234567890123.987654321098765432"),  "1.234567890123987654321098765432")
        XCTAssertEqual(right("1234567890123.987654321098765432"),  "e12")
        XCTAssertEqual( left("12345678901234.987654321098765432"), "1.2345678901234987654321098765432")
        XCTAssertEqual(right("12345678901234.987654321098765432"), "e13")
    }
    
    func test_negative_float_more_than_1() {
        XCTAssertEqual( left("-1.9"),              "-1,9")
        XCTAssertEqual(right("-1.9"),              nil)
        XCTAssertEqual( left("-12.9"),             "-12,9")
        XCTAssertEqual(right("-12.9"),             nil)
        XCTAssertEqual( left("-1234.9"),           "-1234,9")
        XCTAssertEqual(right("-1234.9"),           nil)
        XCTAssertEqual( left("-12345.9"),          "-12345,9")
        XCTAssertEqual(right("-12345.9"),          nil)
        XCTAssertEqual( left("-123456.9"),         "-123456,9")
        XCTAssertEqual(right("-123456.9"),         nil)
        XCTAssertEqual( left("-1234567.9"),        "-1234567,9")
        XCTAssertEqual(right("-1234567.9"),        nil)
        XCTAssertEqual( left("-12345678.9"),       "-12345678,9")
        XCTAssertEqual(right("-12345678.9"),       nil)
        XCTAssertEqual( left("-123456789.9"),      "-123456789,9")
        XCTAssertEqual(right("-123456789.9"),      nil)
        XCTAssertEqual( left("-1234567890.9"),     "-1,2345678909")
        XCTAssertEqual(right("-1234567890.9"),     "e9")
        XCTAssertEqual( left("-12345678901.9"),    "-1,23456789019")
        XCTAssertEqual(right("-12345678901.9"),    "e10")
        XCTAssertEqual( left("-123456789012.9"),   "-1,234567890129")
        XCTAssertEqual(right("-123456789012.9"),   "e11")
        XCTAssertEqual( left("-1234567890123.9"),  "-1,2345678901239")
        XCTAssertEqual(right("-1234567890123.9"),  "e12")
        XCTAssertEqual( left("-12345678901234.9"), "-1,23456789012349")
        XCTAssertEqual(right("-12345678901234.9"), "e13")

        XCTAssertEqual( left("-1.9876"),              "-1,9876")
        XCTAssertEqual(right("-1.9876"),              nil)
        XCTAssertEqual( left("-12.9876"),             "-12,9876")
        XCTAssertEqual(right("-12.9876"),             nil)
        XCTAssertEqual( left("-1234.9876"),           "-1234,9876")
        XCTAssertEqual(right("-1234.9876"),           nil)
        XCTAssertEqual( left("-12345.9876"),          "-12345,9876")
        XCTAssertEqual(right("-12345.9876"),          nil)
        XCTAssertEqual( left("-123456.9876"),         "-123456,9876")
        XCTAssertEqual(right("-123456.9876"),         nil)
        XCTAssertEqual( left("-1234567.9876"),        "-1234567,9876")
        XCTAssertEqual(right("-1234567.9876"),        nil)
        XCTAssertEqual( left("-12345678.9876"),       "-12345678,9876")
        XCTAssertEqual(right("-12345678.9876"),       nil)
        XCTAssertEqual( left("-123456789.9876"),      "-123456789,9876")
        XCTAssertEqual(right("-123456789.9876"),      nil)
        XCTAssertEqual( left("-1234567890.9876"),     "-1,2345678909876")
        XCTAssertEqual(right("-1234567890.9876"),     "e9")
        XCTAssertEqual( left("-12345678901.9876"),    "-1,23456789019876")
        XCTAssertEqual(right("-12345678901.9876"),    "e10")
        XCTAssertEqual( left("-123456789012.9876"),   "-1,234567890129876")
        XCTAssertEqual(right("-123456789012.9876"),   "e11")
        XCTAssertEqual( left("-1234567890123.9876"),  "-1,2345678901239876")
        XCTAssertEqual(right("-1234567890123.9876"),  "e12")
        XCTAssertEqual( left("-12345678901234.9876"), "-1,23456789012349876")
        XCTAssertEqual(right("-12345678901234.9876"), "e13")

        XCTAssertEqual( left("-1.987654321098765432"),              "-1,987654321098765432")
        XCTAssertEqual(right("-1.987654321098765432"),              nil)
        XCTAssertEqual( left("-12.987654321098765432"),             "-12,987654321098765432")
        XCTAssertEqual(right("-12.987654321098765432"),             nil)
        XCTAssertEqual( left("-123.987654321098765432"),            "-123,987654321098765432")
        XCTAssertEqual(right("-123.987654321098765432"),            nil)
        XCTAssertEqual( left("-1234.987654321098765432"),           "-1234,987654321098765432")
        XCTAssertEqual(right("-1234.987654321098765432"),           nil)
        XCTAssertEqual( left("-12345.987654321098765432"),          "-12345,987654321098765432")
        XCTAssertEqual(right("-12345.987654321098765432"),          nil)
        XCTAssertEqual( left("-123456.987654321098765432"),         "-123456,987654321098765432")
        XCTAssertEqual(right("-123456.987654321098765432"),         nil)
        XCTAssertEqual( left("-1234567.987654321098765432"),        "-1234567,987654321098765432")
        XCTAssertEqual(right("-1234567.987654321098765432"),        nil)
        XCTAssertEqual( left("-12345678.987654321098765432"),       "-12345678,987654321098765432")
        XCTAssertEqual(right("-12345678.987654321098765432"),       nil)
        XCTAssertEqual( left("-123456789.987654321098765432"),      "-123456789,987654321098765432")
        XCTAssertEqual(right("-123456789.987654321098765432"),      nil)
        XCTAssertEqual( left("-1234567890.987654321098765432"),     "-1,234567890987654321098765432")
        XCTAssertEqual(right("-1234567890.987654321098765432"),     "e9")
        XCTAssertEqual( left("-12345678901.987654321098765432"),    "-1,2345678901987654321098765432")
        XCTAssertEqual(right("-12345678901.987654321098765432"),    "e10")
        XCTAssertEqual( left("-123456789012.987654321098765432"),   "-1,23456789012987654321098765432")
        XCTAssertEqual(right("-123456789012.987654321098765432"),   "e11")
        XCTAssertEqual( left("-1234567890123.987654321098765432"),  "-1,234567890123987654321098765432")
        XCTAssertEqual(right("-1234567890123.987654321098765432"),  "e12")
        XCTAssertEqual( left("-12345678901234.987654321098765432"), "-1,2345678901234987654321098765432")
        XCTAssertEqual(right("-12345678901234.987654321098765432"), "e13")
    }
    
    func test_negative_float_more_than_1_grouping() {
        screen.decimalSeparator = .comma
        screen.groupingSeparator = .dot
        XCTAssertEqual( left("-1.9"),              "-1,9")
        XCTAssertEqual(right("-1.9"),              nil)
        XCTAssertEqual( left("-12.9"),             "-12,9")
        XCTAssertEqual(right("-12.9"),             nil)
        XCTAssertEqual( left("-1234.9"),           "-1.234,9")
        XCTAssertEqual(right("-1234.9"),           nil)
        XCTAssertEqual( left("-12345.9"),          "-12.345,9")
        XCTAssertEqual(right("-12345.9"),          nil)
        XCTAssertEqual( left("-123456.9"),         "-123.456,9")
        XCTAssertEqual(right("-123456.9"),         nil)
        XCTAssertEqual( left("-1234567.9"),        "-1.234.567,9")
        XCTAssertEqual(right("-1234567.9"),        nil)
        XCTAssertEqual( left("-12345678.9"),       "-12.345.678,9")
        XCTAssertEqual(right("-12345678.9"),       nil)
        XCTAssertEqual( left("-123456789.9"),      "-1,234567899")
        XCTAssertEqual(right("-123456789.9"),      "e8")
        XCTAssertEqual( left("-1234567890.9"),     "-1,2345678909")
        XCTAssertEqual(right("-1234567890.9"),     "e9")
        XCTAssertEqual( left("-12345678901.9"),    "-1,23456789019")
        XCTAssertEqual(right("-12345678901.9"),    "e10")
        XCTAssertEqual( left("-123456789012.9"),   "-1,234567890129")
        XCTAssertEqual(right("-123456789012.9"),   "e11")
        XCTAssertEqual( left("-1234567890123.9"),  "-1,2345678901239")
        XCTAssertEqual(right("-1234567890123.9"),  "e12")
        XCTAssertEqual( left("-12345678901234.9"), "-1,23456789012349")
        XCTAssertEqual(right("-12345678901234.9"), "e13")

        XCTAssertEqual( left("-1.9876"),              "-1,9876")
        XCTAssertEqual(right("-1.9876"),              nil)
        XCTAssertEqual( left("-12.9876"),             "-12,9876")
        XCTAssertEqual(right("-12.9876"),             nil)
        XCTAssertEqual( left("-1234.9876"),           "-1.234,9876")
        XCTAssertEqual(right("-1234.9876"),           nil)
        XCTAssertEqual( left("-12345.9876"),          "-12.345,9876")
        XCTAssertEqual(right("-12345.9876"),          nil)
        XCTAssertEqual( left("-123456.9876"),         "-123.456,9876")
        XCTAssertEqual(right("-123456.9876"),         nil)
        XCTAssertEqual( left("-1234567.9876"),        "-1.234.567,9876")
        XCTAssertEqual(right("-1234567.9876"),        nil)
        XCTAssertEqual( left("-12345678.9876"),       "-12.345.678,9876")
        XCTAssertEqual(right("-12345678.9876"),       nil)
        XCTAssertEqual( left("-123456789.9876"),      "-1,234567899876")
        XCTAssertEqual(right("-123456789.9876"),      "e8")
        XCTAssertEqual( left("-1234567890.9876"),     "-1,2345678909876")
        XCTAssertEqual(right("-1234567890.9876"),     "e9")
        XCTAssertEqual( left("-12345678901.9876"),    "-1,23456789019876")
        XCTAssertEqual(right("-12345678901.9876"),    "e10")
        XCTAssertEqual( left("-123456789012.9876"),   "-1,234567890129876")
        XCTAssertEqual(right("-123456789012.9876"),   "e11")
        XCTAssertEqual( left("-1234567890123.9876"),  "-1,2345678901239876")
        XCTAssertEqual(right("-1234567890123.9876"),  "e12")
        XCTAssertEqual( left("-12345678901234.9876"), "-1,23456789012349876")
        XCTAssertEqual(right("-12345678901234.9876"), "e13")

        XCTAssertEqual( left("-1.987654321098765432"),              "-1,987654321098765432")
        XCTAssertEqual(right("-1.987654321098765432"),              nil)
        XCTAssertEqual( left("-12.987654321098765432"),             "-12,987654321098765432")
        XCTAssertEqual(right("-12.987654321098765432"),             nil)
        XCTAssertEqual( left("-123.987654321098765432"),            "-123,987654321098765432")
        XCTAssertEqual(right("-123.987654321098765432"),            nil)
        XCTAssertEqual( left("-1234.987654321098765432"),           "-1.234,987654321098765432")
        XCTAssertEqual(right("-1234.987654321098765432"),           nil)
        XCTAssertEqual( left("-12345.987654321098765432"),          "-12.345,987654321098765432")
        XCTAssertEqual(right("-12345.987654321098765432"),          nil)
        XCTAssertEqual( left("-123456.987654321098765432"),         "-123.456,987654321098765432")
        XCTAssertEqual(right("-123456.987654321098765432"),         nil)
        XCTAssertEqual( left("-1234567.987654321098765432"),        "-1.234.567,987654321098765432")
        XCTAssertEqual(right("-1234567.987654321098765432"),        nil)
        XCTAssertEqual( left("-12345678.987654321098765432"),       "-12.345.678,987654321098765432")
        XCTAssertEqual(right("-12345678.987654321098765432"),       nil)
        XCTAssertEqual( left("-123456789.987654321098765432"),      "-1,23456789987654321098765432")
        XCTAssertEqual(right("-123456789.987654321098765432"),      "e8")
        XCTAssertEqual( left("-1234567890.987654321098765432"),     "-1,234567890987654321098765432")
        XCTAssertEqual(right("-1234567890.987654321098765432"),     "e9")
        XCTAssertEqual( left("-12345678901.987654321098765432"),    "-1,2345678901987654321098765432")
        XCTAssertEqual(right("-12345678901.987654321098765432"),    "e10")
        XCTAssertEqual( left("-123456789012.987654321098765432"),   "-1,23456789012987654321098765432")
        XCTAssertEqual(right("-123456789012.987654321098765432"),   "e11")
        XCTAssertEqual( left("-1234567890123.987654321098765432"),  "-1,234567890123987654321098765432")
        XCTAssertEqual(right("-1234567890123.987654321098765432"),  "e12")
        XCTAssertEqual( left("-12345678901234.987654321098765432"), "-1,2345678901234987654321098765432")
        XCTAssertEqual(right("-12345678901234.987654321098765432"), "e13")
    }
    
    func test_float_less_than_1() {
        XCTAssertEqual( left("0.123"),              "0,123")
        XCTAssertEqual(right("0.123"),              nil)
        XCTAssertEqual( left("0.0123"),             "0,0123")
        XCTAssertEqual(right("0.0123"),             nil)
        XCTAssertEqual( left("0.00123"),            "0,00123")
        XCTAssertEqual(right("0.00123"),            nil)
        XCTAssertEqual( left("0.000123"),           "0,000123")
        XCTAssertEqual(right("0.000123"),           nil)
        XCTAssertEqual( left("0.0000123"),          "0,0000123")
        XCTAssertEqual(right("0.0000123"),          nil)
        XCTAssertEqual( left("0.00000123"),         "0,00000123")
        XCTAssertEqual(right("0.00000123"),         nil)
        XCTAssertEqual( left("0.000000123"),        "0,000000123")
        XCTAssertEqual(right("0.000000123"),        nil)
        XCTAssertEqual( left("0.0000000123"),       "0,0000000123")
        XCTAssertEqual(right("0.0000000123"),       nil)
        XCTAssertEqual( left("0.00000000123"),      "0,00000000123")
        XCTAssertEqual(right("0.00000000123"),      nil)
        XCTAssertEqual( left("0.000000000123"),     "1,23")
        XCTAssertEqual(right("0.000000000123"),     "e-10")
        XCTAssertEqual( left("0.0000000000123"),    "1,23")
        XCTAssertEqual(right("0.0000000000123"),    "e-11")
        XCTAssertEqual( left("0.00000000000123"),   "1,23")
        XCTAssertEqual(right("0.00000000000123"),   "e-12")
        XCTAssertEqual( left("0.000000000000123"),  "1,23")
        XCTAssertEqual(right("0.000000000000123"),  "e-13")
        XCTAssertEqual( left("0.0000000000000123"), "1,23")
        XCTAssertEqual(right("0.0000000000000123"), "e-14")
    }
    func test_xx() {
        screen.groupingSeparator = .none
        screen.decimalSeparator = .dot
        XCTAssertEqual(left("123"),     "123")
        XCTAssertEqual(left("1234"),    "1234")
        XCTAssertEqual(left("12345"),   "12345")
        XCTAssertEqual(left("123456"),  "123456")
        XCTAssertEqual(left("1234567"), "1234567")

        screen.groupingSeparator = .dot
        screen.decimalSeparator = .comma
        XCTAssertEqual(left("123"),     "123")
        XCTAssertEqual(left("1234"),    "1.234")
        XCTAssertEqual(left("12345"),   "12.345")
        XCTAssertEqual(left("123456"),  "123.456")
        XCTAssertEqual(left("1234567"), "1.234.567")

        screen.groupingSeparator = .comma
        screen.decimalSeparator = .dot
        XCTAssertEqual( left("123"),     "123")
        XCTAssertEqual(right("123"),     nil)
        XCTAssertEqual( left("1234"),    "1,234")
        XCTAssertEqual(right("1234"),    nil)
        XCTAssertEqual( left("12345"),   "12,345")
        XCTAssertEqual(right("12345"),   nil)
        XCTAssertEqual( left("123456"),  "123,456")
        XCTAssertEqual(right("123456"),  nil)
        XCTAssertEqual( left("1234567"), "1,234,567")
        XCTAssertEqual(right("1234567"), nil)
        XCTAssertEqual( left("12345678"), "12,345,678")
        XCTAssertEqual(right("12345678"), nil)
        XCTAssertEqual( left("123456789"), "123,456,789")
        XCTAssertEqual(right("123456789"), nil)
        XCTAssertEqual( left("1234567890"), "1.234567890")
        XCTAssertEqual(right("1234567890"), "e9")
        XCTAssertEqual( left("12345678901"), "1.2345678901")
        XCTAssertEqual(right("12345678901"), "e10")
        XCTAssertEqual( left("123456789012"), "1.23456789012")
        XCTAssertEqual(right("123456789012"), "e11")

    }
    
    func testBits() {
        let debugBrain = DebugBrain(precision: 200_000) /// also failing: 10000

        debugBrain.push(7.7)
        debugBrain.push("One_x")
        debugBrain.push("One_x")
        XCTAssertEqual(left(debugBrain.last), "7,7")
        XCTAssertEqual(right(debugBrain.last), nil)
        XCTAssertEqual(allInOneLine(debugBrain.last), "7,7")

        debugBrain.push("AC")
        debugBrain.push(0.3)
        debugBrain.push("+")
        debugBrain.push("0,4")
        debugBrain.push("=")
        XCTAssertEqual(allInOneLine(debugBrain.last), "0,7")
    }
    
    func test_showAs_Int() {
        screen.groupingSeparator = .none
        screen.decimalSeparator = .comma
        viewModel.showAsInt = false
        viewModel.showAsFloat = false
        XCTAssertEqual( left("1234567890"),      "1234567890")
        XCTAssertEqual(right("1234567890"),      nil)
        XCTAssertEqual( left("123456789012345"), "1,23456789012345")
        XCTAssertEqual(right("123456789012345"), "e14")
        viewModel.showAsInt = true
        viewModel.showAsFloat = true
        XCTAssertEqual( left("1234567890"),      "1234567890")
        XCTAssertEqual(right("1234567890"),      nil)
        XCTAssertEqual( left("123456789012345"), "123456789012345")
        XCTAssertEqual(right("123456789012345"), nil)
        screen.decimalSeparator = .dot
        screen.groupingSeparator = .comma
        XCTAssertEqual( left("1234567890"),      "1,234,567,890")
        XCTAssertEqual(right("1234567890"),      nil)
        XCTAssertEqual( left("123456789012345"), "123,456,789,012,345")
        XCTAssertEqual(right("123456789012345"), nil)
    }

    func test_showAs_Float() {
        let debugBrain = DebugBrain(precision: 100)
        screen.groupingSeparator = .none
        screen.decimalSeparator = .comma
        viewModel.showAsInt = false
        viewModel.showAsFloat = false
        debugBrain.pushnew("0,0023")
        XCTAssertEqual(left(debugBrain.last), "0,0023")
        XCTAssertNil(right(debugBrain.last))
        debugBrain.pushnew("0,0000000000232837642876")
        XCTAssertEqual(left(debugBrain.last), "2,32837642876")
        XCTAssertEqual(right(debugBrain.last), "e-11")

        viewModel.showAsInt = true
        viewModel.showAsFloat = true
        debugBrain.pushnew("0,0023")
        XCTAssertEqual(left(debugBrain.last), "0,0023")
        XCTAssertNil(right(debugBrain.last))
        debugBrain.pushnew("0,0000000000232837642876")
        XCTAssertEqual(left(debugBrain.last), "0,0000000000232837642876")
        XCTAssertEqual(right(debugBrain.last), nil)
        
        screen.decimalSeparator = .dot
        screen.groupingSeparator = .comma
        debugBrain.pushnew("0,0023")
        XCTAssertEqual(left(debugBrain.last), "0.0023")
        XCTAssertNil(right(debugBrain.last))
        debugBrain.pushnew("0,0000000000232837642876")
        XCTAssertEqual(left(debugBrain.last), "0.0000000000232837642876")
        XCTAssertEqual(right(debugBrain.last), nil)

        debugBrain.pushnew("1000,0023")
        XCTAssertEqual(left(debugBrain.last), "1,000.0023")
        XCTAssertNil(right(debugBrain.last))
        debugBrain.pushnew("1000,0000000000232837642876")
        XCTAssertEqual(left(debugBrain.last), "1,000.0000000000232837642876")
        XCTAssertEqual(right(debugBrain.last), nil)

    }

    func test_integer() {
        screen.groupingSeparator = .none
        screen.decimalSeparator = .comma
        XCTAssertEqual( left("123"),             "123")
        XCTAssertEqual(right("123"),             nil)
        XCTAssertEqual( left("1234"),            "1234")
        XCTAssertEqual(right("1234"),            nil)
        XCTAssertEqual( left("12345"),           "12345")
        XCTAssertEqual(right("12345"),           nil)
        XCTAssertEqual( left("123456"),          "123456")
        XCTAssertEqual(right("123456"),          nil)
        XCTAssertEqual( left("1234567"),         "1234567")
        XCTAssertEqual(right("1234567"),         nil)
        XCTAssertEqual( left("12345678"),        "12345678")
        XCTAssertEqual(right("12345678"),        nil)
        XCTAssertEqual( left("123456789"),       "123456789")
        XCTAssertEqual(right("123456789"),       nil)
        XCTAssertEqual( left("1234567890"),      "1234567890")
        XCTAssertEqual(right("1234567890"),      nil)
        XCTAssertEqual( left("12345678901"),     "1,2345678901")
        XCTAssertEqual(right("12345678901"),     "e10")
        XCTAssertEqual( left("123456789012"),    "1,23456789012")
        XCTAssertEqual(right("123456789012"),    "e11")
        XCTAssertEqual( left("1234567890123"),   "1,234567890123")
        XCTAssertEqual(right("1234567890123"),   "e12")
        XCTAssertEqual( left("12345678901234"),  "1,2345678901234")
        XCTAssertEqual(right("12345678901234"),  "e13")
        XCTAssertEqual( left("123456789012345"), "1,23456789012345")
        XCTAssertEqual(right("123456789012345"), "e14")
        XCTAssertEqual(allInOneLine("123456789012345"), "1,23456789012345e14")

        
        screen.decimalSeparator = .dot
        screen.groupingSeparator = .comma
        XCTAssertEqual( left("123"),             "123")
        XCTAssertEqual(right("123"),             nil)
        XCTAssertEqual( left("1234"),            "1,234")
        XCTAssertEqual(right("1234"),            nil)
        XCTAssertEqual( left("12345"),           "12,345")
        XCTAssertEqual(right("12345"),           nil)
        XCTAssertEqual( left("123456"),          "123,456")
        XCTAssertEqual(right("123456"),          nil)
        XCTAssertEqual( left("1234567"),         "1,234,567")
        XCTAssertEqual(right("1234567"),         nil)
        XCTAssertEqual( left("12345678"),        "12,345,678")
        XCTAssertEqual(right("12345678"),        nil)
        XCTAssertEqual( left("123456789"),       "123,456,789")
        XCTAssertEqual(right("123456789"),       nil)
        XCTAssertEqual( left("1234567890"),      "1.234567890")
        XCTAssertEqual(right("1234567890"),      "e9")
        XCTAssertEqual( left("12345678901"),     "1.2345678901")
        XCTAssertEqual(right("12345678901"),     "e10")
        XCTAssertEqual( left("123456789012"),    "1.23456789012")
        XCTAssertEqual(right("123456789012"),    "e11")
        XCTAssertEqual( left("1234567890123"),   "1.234567890123")
        XCTAssertEqual(right("1234567890123"),   "e12")
        XCTAssertEqual( left("12345678901234"),  "1.2345678901234")
        XCTAssertEqual(right("12345678901234"),  "e13")
        XCTAssertEqual( left("123456789012345"), "1.23456789012345")
        XCTAssertEqual(right("123456789012345"), "e14")
    }
    
    func test_negative_integer() {
        screen.groupingSeparator = .none
        screen.decimalSeparator = .comma
        XCTAssertEqual( left("-123"),             "-123")
        XCTAssertEqual(right("-123"),             nil)
        XCTAssertEqual( left("-1234"),            "-1234")
        XCTAssertEqual(right("-1234"),            nil)
        XCTAssertEqual( left("-12345"),           "-12345")
        XCTAssertEqual(right("-12345"),           nil)
        XCTAssertEqual( left("-123456"),          "-123456")
        XCTAssertEqual(right("-123456"),          nil)
        XCTAssertEqual( left("-1234567"),         "-1234567")
        XCTAssertEqual(right("-1234567"),         nil)
        XCTAssertEqual( left("-12345678"),        "-12345678")
        XCTAssertEqual(right("-12345678"),        nil)
        XCTAssertEqual( left("-123456789"),       "-123456789")
        XCTAssertEqual(right("-123456789"),       nil)
        XCTAssertEqual( left("-1234567890"),      "-1,234567890")
        XCTAssertEqual(right("-1234567890"),      "e9")
        XCTAssertEqual( left("-12345678901"),     "-1,2345678901")
        XCTAssertEqual(right("-12345678901"),     "e10")
        XCTAssertEqual( left("-123456789012"),    "-1,23456789012")
        XCTAssertEqual(right("-123456789012"),    "e11")
        XCTAssertEqual( left("-1234567890123"),   "-1,234567890123")
        XCTAssertEqual(right("-1234567890123"),   "e12")
        XCTAssertEqual( left("-12345678901234"),  "-1,2345678901234")
        XCTAssertEqual(right("-12345678901234"),  "e13")
        XCTAssertEqual( left("-123456789012345"), "-1,23456789012345")
        XCTAssertEqual(right("-123456789012345"), "e14")
        
        screen.decimalSeparator = .dot
        screen.groupingSeparator = .comma
        XCTAssertEqual( left("-123"),             "-123")
        XCTAssertEqual(right("-123"),             nil)
        XCTAssertEqual( left("-1234"),            "-1,234")
        XCTAssertEqual(right("-1234"),            nil)
        XCTAssertEqual( left("-12345"),           "-12,345")
        XCTAssertEqual(right("-12345"),           nil)
        XCTAssertEqual( left("-123456"),          "-123,456")
        XCTAssertEqual(right("-123456"),          nil)
        XCTAssertEqual( left("-1234567"),         "-1,234,567")
        XCTAssertEqual(right("-1234567"),         nil)
        XCTAssertEqual( left("-12345678"),        "-12,345,678")
        XCTAssertEqual(right("-12345678"),        nil)
        XCTAssertEqual( left("-123456789"),       "-1.23456789")
        XCTAssertEqual(right("-123456789"),       "e8")
        XCTAssertEqual( left("-1234567890"),      "-1.234567890")
        XCTAssertEqual(right("-1234567890"),      "e9")
        XCTAssertEqual( left("-12345678901"),     "-1.2345678901")
        XCTAssertEqual(right("-12345678901"),     "e10")
        XCTAssertEqual( left("-123456789012"),    "-1.23456789012")
        XCTAssertEqual(right("-123456789012"),    "e11")
        XCTAssertEqual( left("-1234567890123"),   "-1.234567890123")
        XCTAssertEqual(right("-1234567890123"),   "e12")
        XCTAssertEqual( left("-12345678901234"),  "-1.2345678901234")
        XCTAssertEqual(right("-12345678901234"),  "e13")
        XCTAssertEqual( left("-123456789012345"), "-1.23456789012345")
        XCTAssertEqual(right("-123456789012345"), "e14")
    }
    
    func test_Float() {
        let debugBrain = DebugBrain(precision: 100)
        screen.decimalSeparator = .comma
        debugBrain.pushnew("1,234")
        XCTAssertEqual(left(debugBrain.last), "1,234")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1,2345")
        XCTAssertEqual(left(debugBrain.last), "1,2345")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1,23456")
        XCTAssertEqual(left(debugBrain.last), "1,23456")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1,234567")
        XCTAssertEqual(left(debugBrain.last), "1,234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1,2345678")
        XCTAssertEqual(left(debugBrain.last), "1,2345678")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1,23456789")
        XCTAssertEqual(left(debugBrain.last), "1,23456789")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-1,234")
        XCTAssertEqual(left(debugBrain.last), "-1,234")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-1,2345")
        XCTAssertEqual(left(debugBrain.last), "-1,2345")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-1,23456")
        XCTAssertEqual(left(debugBrain.last), "-1,23456")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-1,234567")
        XCTAssertEqual(left(debugBrain.last), "-1,234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-1,2345678")
        XCTAssertEqual(left(debugBrain.last), "-1,2345678")
        XCTAssertNil(right(debugBrain.last))



        debugBrain.pushnew("1,234")
        XCTAssertEqual(left(debugBrain.last), "1,234")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1,234")
        XCTAssertEqual(left(debugBrain.last), "1,234")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1,234")
        XCTAssertEqual(left(debugBrain.last), "1,234")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1,234")
        XCTAssertEqual(left(debugBrain.last), "1,234")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1,234")
        XCTAssertEqual(left(debugBrain.last), "1,234")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1,234567")
        XCTAssertEqual(left(debugBrain.last), "1,234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1,2345678")
        XCTAssertEqual(left(debugBrain.last), "1,2345678")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1,23456789")
        XCTAssertEqual(left(debugBrain.last), "1,23456789")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-1,234")
        XCTAssertEqual(left(debugBrain.last), "-1,234")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-1,2345")
        XCTAssertEqual(left(debugBrain.last), "-1,2345")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-1,23456")
        XCTAssertEqual(left(debugBrain.last), "-1,23456")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-1,23456789")
        XCTAssertEqual(left(debugBrain.last), "-1,23456789")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-144,23456789")
        XCTAssertEqual(left(debugBrain.last), "-144,23456789")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1445,23456789")
        XCTAssertEqual(left(debugBrain.last), "1445,23456789")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("14456,23456789")
        XCTAssertEqual(left(debugBrain.last), "14456,23456789")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("144567,23456789")
        XCTAssertEqual(left(debugBrain.last), "144567,23456789")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1445678,23456789")
        XCTAssertEqual(left(debugBrain.last), "1445678,23456789")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("14456785,23456789")
        XCTAssertEqual(left(debugBrain.last), "14456785,23456789")
        XCTAssertNil(right(debugBrain.last))
        
        debugBrain.pushnew("0,123")
        XCTAssertEqual(left(debugBrain.last), "0,123")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,1234")
        XCTAssertEqual(left(debugBrain.last), "0,1234")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,12345")
        XCTAssertEqual(left(debugBrain.last), "0,12345")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,123456")
        XCTAssertEqual(left(debugBrain.last), "0,123456")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,1234567")
        XCTAssertEqual(left(debugBrain.last), "0,1234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,12345678")
        XCTAssertEqual(left(debugBrain.last), "0,12345678")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,000012")
        XCTAssertEqual(left(debugBrain.last), "0,000012")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,000004")
        XCTAssertEqual(left(debugBrain.last), "0,000004")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,0000123456")
        XCTAssertEqual(left(debugBrain.last), "0,0000123456")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,000012")
        XCTAssertEqual(left(debugBrain.last), "-0,000012")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,0000123")
        XCTAssertEqual(left(debugBrain.last), "-0,0000123")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,0000123456")
        XCTAssertEqual(left(debugBrain.last), "-0,0000123456")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,123")
        XCTAssertEqual(left(debugBrain.last), "-0,123")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,1234")
        XCTAssertEqual(left(debugBrain.last), "-0,1234")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,12345")
        XCTAssertEqual(left(debugBrain.last), "-0,12345")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,123456")
        XCTAssertEqual(left(debugBrain.last), "-0,123456")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,1234567")
        XCTAssertEqual(left(debugBrain.last), "-0,1234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("14456789,23456789")
        XCTAssertEqual(left(debugBrain.last), "14456789,23456789")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-144567,23456789")
        XCTAssertEqual(left(debugBrain.last), "-144567,23456789")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-1445678,23456789")
        XCTAssertEqual(left(debugBrain.last), "-1445678,23456789")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1445678,23456789")
        XCTAssertEqual(left(debugBrain.last), "1445678,23456789")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,0123")
        XCTAssertEqual(left(debugBrain.last), "0,0123")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,01234567")
        XCTAssertEqual(left(debugBrain.last), "0,01234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,0012")
        XCTAssertEqual(left(debugBrain.last), "0,0012")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,0012")
        XCTAssertEqual(left(debugBrain.last), "-0,0012")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,001234567")
        XCTAssertEqual(left(debugBrain.last), "0,001234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,001234567")
        XCTAssertEqual(left(debugBrain.last), "-0,001234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,0001234567")
        XCTAssertEqual(left(debugBrain.last), "0,0001234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,0001234567")
        XCTAssertEqual(left(debugBrain.last), "-0,0001234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,00001234567")
        XCTAssertEqual(left(debugBrain.last), "0,00001234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,00001234567")
        XCTAssertEqual(left(debugBrain.last), "-0,00001234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,12345678")
        XCTAssertEqual(left(debugBrain.last), "0,12345678")
        XCTAssertNil(right(debugBrain.last))


        /// scientific notation

        debugBrain.pushnew(1.5)
        debugBrain.push("EE")
        debugBrain.push(12)
        debugBrain.push("=")
        XCTAssertEqual(left(debugBrain.last), "1,5")
        XCTAssertEqual(right(debugBrain.last), "e12")


        debugBrain.pushnew("1,5")
        debugBrain.push("EE")
        debugBrain.push("12")
        debugBrain.push("=")
        XCTAssertEqual(left(debugBrain.last), "1,5")
        XCTAssertEqual(right(debugBrain.last), "e12")

        debugBrain.pushnew("0,0000004")
        XCTAssertEqual(left(debugBrain.last), "0,0000004")
        XCTAssertNil(right(debugBrain.last))

        debugBrain.pushnew("0,00000004")
        XCTAssertEqual(left(debugBrain.last), "0,00000004")
        XCTAssertEqual(right(debugBrain.last), nil)

        debugBrain.pushnew("0,000000004")
        XCTAssertEqual(left(debugBrain.last), "0,000000004")
        XCTAssertEqual(right(debugBrain.last), nil)

        debugBrain.pushnew("0,0000000004")
        XCTAssertEqual(left(debugBrain.last), "4,0")
        XCTAssertEqual(right(debugBrain.last), "e-10")

        debugBrain.pushnew("0,00000000004")
        XCTAssertEqual(left(debugBrain.last), "4,0")
        XCTAssertEqual(right(debugBrain.last), "e-11")

        debugBrain.pushnew("0,000000000004")
        XCTAssertEqual(left(debugBrain.last), "4,0")
        XCTAssertEqual(right(debugBrain.last), "e-12")

        debugBrain.pushnew("12345678349875349873")
        XCTAssertEqual(left(debugBrain.last), "1,2345678349875349873")
        XCTAssertEqual(right(debugBrain.last), "e19")


        debugBrain.pushnew("123456783498753498731")
        XCTAssertEqual(left(debugBrain.last), "1,23456783498753498731")
        XCTAssertEqual(right(debugBrain.last), "e20")


        debugBrain.pushnew("0,012345678")
        XCTAssertEqual(left(debugBrain.last), "0,012345678")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,0012345678")
        XCTAssertEqual(left(debugBrain.last), "0,0012345678")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-1445,23456789")
        XCTAssertEqual(left(debugBrain.last), "-1445,23456789")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("921387491237419283092340238420398423098423049874129837649128364519234875")
        XCTAssertEqual(left(debugBrain.last), "9,21387491237419283092340238420398423098423049874129837649128364519234875")
        XCTAssertEqual(right(debugBrain.last), "e71")


        debugBrain.pushnew("1,23")
        XCTAssertEqual(left(debugBrain.last), "1,23")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1,23")
        XCTAssertEqual(left(debugBrain.last), "1,23")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,0023")
        XCTAssertEqual(left(debugBrain.last), "0,0023")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,000000000023")
        XCTAssertEqual(left(debugBrain.last), "2,3")
        XCTAssertEqual(right(debugBrain.last), "e-11")


        debugBrain.pushnew("0,0000000000232837642876")
        XCTAssertEqual(left(debugBrain.last), "2,32837642876")
        XCTAssertEqual(right(debugBrain.last), "e-11")


        debugBrain.pushnew("0,0000000000232837642876239827342")
        XCTAssertEqual(left(debugBrain.last), "2,32837642876239827342")
        XCTAssertEqual(right(debugBrain.last), "e-11")

    }
    
    func testComma() {
        let debugBrain = DebugBrain(precision: 100)
        /// 0,
        screen.decimalSeparator = .comma
        debugBrain.push("AC")
        debugBrain.push(",")
        XCTAssertEqual(left(debugBrain.last), "0,")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(",")
        XCTAssertEqual(left(debugBrain.last), "0,")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("0")
        XCTAssertEqual(left(debugBrain.last), "0,0")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("0")
        XCTAssertEqual(left(debugBrain.last), "0,00")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("0")
        XCTAssertEqual(left(debugBrain.last), "0,000")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("1")
        XCTAssertEqual(left(debugBrain.last), "0,0001")
        XCTAssertEqual(right(debugBrain.last), nil)

        screen.decimalSeparator = .dot
        debugBrain.push("AC")
        debugBrain.push(",")
        XCTAssertEqual(left(debugBrain.last), "0.")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(",")
        XCTAssertEqual(left(debugBrain.last), "0.")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("0")
        XCTAssertEqual(left(debugBrain.last), "0.0")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("0")
        XCTAssertEqual(left(debugBrain.last), "0.00")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("0")
        XCTAssertEqual(left(debugBrain.last), "0.000")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("1")
        XCTAssertEqual(left(debugBrain.last), "0.0001")
        XCTAssertEqual(right(debugBrain.last), nil)
    }
}
