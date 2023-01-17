//
//  CalculatorTests.swift
//  xxTests
//
//  Created by Joachim Neumann on 10/31/21.
//

import XCTest

@testable import Better_Calc

class CalculatorTests: XCTestCase {
    
    var screen: Screen = Screen(CGSize(width: 130, height: 130))
    let precision = 1000
    
    override func setUpWithError() throws {
        screen.thousandSeparator = .none
        screen.decimalSeparator = .comma
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func left(_ s: String) -> String {
        screen.localized(s).left
    }
    func left(_ n: Number) -> String {
        screen.localized(n).left
    }
    func right(_ s: String) -> String? {
        screen.localized(s).right
    }
    func right(_ n: Number) -> String? {
        screen.localized(n).right
    }    
    func oneLine(_ n: Number) -> String {
        screen.localized(n).oneLine
    }

    func test_Separators() {
        let debugBrain = DebugBrain(precision: precision, lengths: Lengths(50))
        screen.decimalSeparator = .comma
        screen.thousandSeparator = .none
        XCTAssertEqual(left("1234567.7"), "1234567,7")
        debugBrain.pushnew(1234567.7)
        XCTAssertEqual(left(debugBrain.last), "1234567,7")

        screen.decimalSeparator = .dot
        screen.thousandSeparator = .none
        debugBrain.pushnew(1234567.7)
        XCTAssertEqual(left(debugBrain.last), "1234567.7")

        screen.decimalSeparator = .dot
        screen.thousandSeparator = .comma
        XCTAssertEqual(left(debugBrain.last), "1,234,567.7")
        screen.decimalSeparator = .comma
        screen.thousandSeparator = .dot
        XCTAssertEqual(left(debugBrain.last), "1.234.567,7")
    }

    func compare(_ number: Number, _ left: String, _ right: String?) {
        let localized = screen.localized(number)
        XCTAssertEqual(localized.left, "123")
        XCTAssertEqual(localized.right, right)
    }

    func compare(_ numberString: String, _ left: String, _ right: String?) {
        let localized = screen.localized(Number(numberString, precision: precision))
        XCTAssertEqual(localized.left, "123")
        XCTAssertEqual(localized.right, right)
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
        XCTAssertEqual( left("1234567890.9"),     "1234567890,9")
        XCTAssertEqual(right("1234567890.9"),     nil)
        XCTAssertEqual( left("12345678901.9"),    "12345678901,")
        XCTAssertEqual(right("12345678901.9"),    nil)
        XCTAssertEqual( left("123456789012.9"),   "1,2345678")
        XCTAssertEqual(right("123456789012.9"),   "e11")
        XCTAssertEqual( left("1234567890123.9"),  "1,2345678")
        XCTAssertEqual(right("1234567890123.9"),  "e12")
        XCTAssertEqual( left("12345678901234.9"), "1,2345678")
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
        XCTAssertEqual( left("12345678.9876"),       "12345678,987")
        XCTAssertEqual(right("12345678.9876"),       nil)
        XCTAssertEqual( left("123456789.9876"),      "123456789,98")
        XCTAssertEqual(right("123456789.9876"),      nil)
        XCTAssertEqual( left("1234567890.9876"),     "1234567890,9")
        XCTAssertEqual(right("1234567890.9876"),     nil)
        XCTAssertEqual( left("12345678901.9876"),    "12345678901,")
        XCTAssertEqual(right("12345678901.9876"),    nil)
        XCTAssertEqual( left("123456789012.9876"),   "1,234567890")
        XCTAssertEqual(right("123456789012.9876"),   "e11")
        XCTAssertEqual( left("1234567890123.9876"),  "1,234567890")
        XCTAssertEqual(right("1234567890123.9876"),  "e12")
        XCTAssertEqual( left("12345678901234.9876"), "1,234567890")
        XCTAssertEqual(right("12345678901234.9876"), "e13")

        XCTAssertEqual( left("1.987654321098765432"),              "1,9876543210")
        XCTAssertEqual(right("1.987654321098765432"),              nil)
        XCTAssertEqual( left("12.987654321098765432"),             "12,987654321")
        XCTAssertEqual(right("12.987654321098765432"),             nil)
        XCTAssertEqual( left("123.987654321098765432"),            "123,98765432")
        XCTAssertEqual(right("123.987654321098765432"),            nil)
        XCTAssertEqual( left("1234.987654321098765432"),           "1234,9876543")
        XCTAssertEqual(right("1234.987654321098765432"),           nil)
        XCTAssertEqual( left("12345.987654321098765432"),          "12345,987654")
        XCTAssertEqual(right("12345.987654321098765432"),          nil)
        XCTAssertEqual( left("123456.987654321098765432"),         "123456,98765")
        XCTAssertEqual(right("123456.987654321098765432"),         nil)
        XCTAssertEqual( left("1234567.987654321098765432"),        "1234567,9876")
        XCTAssertEqual(right("1234567.987654321098765432"),        nil)
        XCTAssertEqual( left("12345678.987654321098765432"),       "12345678,987")
        XCTAssertEqual(right("12345678.987654321098765432"),       nil)
        XCTAssertEqual( left("123456789.987654321098765432"),      "123456789,98")
        XCTAssertEqual(right("123456789.987654321098765432"),      nil)
        XCTAssertEqual( left("1234567890.987654321098765432"),     "1234567890,9")
        XCTAssertEqual(right("1234567890.987654321098765432"),     nil)
        XCTAssertEqual( left("12345678901.987654321098765432"),    "12345678901,")
        XCTAssertEqual(right("12345678901.987654321098765432"),    nil)
        XCTAssertEqual( left("123456789012.987654321098765432"),   "1,234567890")
        XCTAssertEqual(right("123456789012.987654321098765432"),   "e11")
        XCTAssertEqual( left("1234567890123.987654321098765432"),  "1,234567890")
        XCTAssertEqual(right("1234567890123.987654321098765432"),  "e12")
        XCTAssertEqual( left("12345678901234.987654321098765432"), "1,234567890")
        XCTAssertEqual(right("12345678901234.987654321098765432"), "e13")

        
        
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
        XCTAssertEqual( left("-1234567890.9"),     "-1234567890,")
        XCTAssertEqual(right("-1234567890.9"),     nil)
        XCTAssertEqual( left("-12345678901.9"),    "-1,234567")
        XCTAssertEqual(right("-12345678901.9"),    "e10")
        XCTAssertEqual( left("-123456789012.9"),   "-1,234567")
        XCTAssertEqual(right("-123456789012.9"),   "e11")
        XCTAssertEqual( left("-1234567890123.9"),  "-1,234567")
        XCTAssertEqual(right("-1234567890123.9"),  "e12")
        XCTAssertEqual( left("-12345678901234.9"), "-1,234567")
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
        XCTAssertEqual( left("-1234567.9876"),        "-1234567,987")
        XCTAssertEqual(right("-1234567.9876"),        nil)
        XCTAssertEqual( left("-12345678.9876"),       "-12345678,98")
        XCTAssertEqual(right("-12345678.9876"),       nil)
        XCTAssertEqual( left("-123456789.9876"),      "-123456789,9")
        XCTAssertEqual(right("-123456789.9876"),      nil)
        XCTAssertEqual( left("-1234567890.9876"),     "-1234567890,")
        XCTAssertEqual(right("-1234567890.9876"),     nil)
        XCTAssertEqual( left("-12345678901.9876"),    "-1,234567890")
        XCTAssertEqual(right("-12345678901.9876"),    "e10")
        XCTAssertEqual( left("-123456789012.9876"),   "-1,234567890")
        XCTAssertEqual(right("-123456789012.9876"),   "e11")
        XCTAssertEqual( left("-1234567890123.9876"),  "-1,234567890")
        XCTAssertEqual(right("-1234567890123.9876"),  "e12")
        XCTAssertEqual( left("-12345678901234.9876"), "-1,234567890")
        XCTAssertEqual(right("-12345678901234.9876"), "e13")

        XCTAssertEqual( left("-1.987654321098765432"),              "-1,987654321")
        XCTAssertEqual(right("-1.987654321098765432"),              nil)
        XCTAssertEqual( left("-12.987654321098765432"),             "-12,98765432")
        XCTAssertEqual(right("-12.987654321098765432"),             nil)
        XCTAssertEqual( left("-123.987654321098765432"),            "-123,9876543")
        XCTAssertEqual(right("-123.987654321098765432"),            nil)
        XCTAssertEqual( left("-1234.987654321098765432"),           "-1234,987654")
        XCTAssertEqual(right("-1234.987654321098765432"),           nil)
        XCTAssertEqual( left("-12345.987654321098765432"),          "-12345,98765")
        XCTAssertEqual(right("-12345.987654321098765432"),          nil)
        XCTAssertEqual( left("-123456.987654321098765432"),         "-123456,9876")
        XCTAssertEqual(right("-123456.987654321098765432"),         nil)
        XCTAssertEqual( left("-1234567.987654321098765432"),        "-1234567,987")
        XCTAssertEqual(right("-1234567.987654321098765432"),        nil)
        XCTAssertEqual( left("-12345678.987654321098765432"),       "-12345678,98")
        XCTAssertEqual(right("-12345678.987654321098765432"),       nil)
        XCTAssertEqual( left("-123456789.987654321098765432"),      "-123456789,9")
        XCTAssertEqual(right("-123456789.987654321098765432"),      nil)
        XCTAssertEqual( left("-1234567890.987654321098765432"),     "-1234567890,")
        XCTAssertEqual(right("-1234567890.987654321098765432"),     nil)
        XCTAssertEqual( left("-12345678901.987654321098765432"),    "-1,234567890,")
        XCTAssertEqual(right("-12345678901.987654321098765432"),    "e10")
        XCTAssertEqual( left("-123456789012.987654321098765432"),   "-1,234567890")
        XCTAssertEqual(right("-123456789012.987654321098765432"),   "e11")
        XCTAssertEqual( left("-1234567890123.987654321098765432"),  "-1,234567890")
        XCTAssertEqual(right("-1234567890123.987654321098765432"),  "e12")
        XCTAssertEqual( left("-12345678901234.987654321098765432"), "-1,234567890")
        XCTAssertEqual(right("-12345678901234.987654321098765432"), "e13")
    }
    func test_float_less_than_1() {
        XCTAssertEqual(left("0.123"),              "0,123")         ; XCTAssertNil(right("0.123"))
        XCTAssertEqual(left("0.0123"),             "0,0123")        ; XCTAssertNil(right("0.0123"))
        XCTAssertEqual(left("0.00123"),            "0,00123")       ; XCTAssertNil(right("0.00123"))
        XCTAssertEqual(left("0.000123"),           "0,000123")      ; XCTAssertNil(right("0.000123"))
        XCTAssertEqual(left("0.0000123"),          "0,0000123")     ; XCTAssertNil(right("0.0000123"))
        XCTAssertEqual(left("0.00000123"),         "0,00000123")    ; XCTAssertNil(right("0.00000123"))
        XCTAssertEqual(left("0.000000123"),        "0,000000123")   ; XCTAssertNil(right("0.000000123"))
        XCTAssertEqual(left("0.0000000123"),       "0,0000000123")  ; XCTAssertNil(right("0.0000000123"))
        XCTAssertEqual(left("0.00000000123"),      "1,23")        ; XCTAssertEqual(right("0.00000000123"), "e-8")
        XCTAssertEqual(left("0.000000000123"),     "1,23")        ; XCTAssertEqual(right("0.000000000123"), "e-9")
        XCTAssertEqual(left("0.0000000000123"),    "1,23")        ; XCTAssertEqual(right("0.0000000000123"), "e-10")
        XCTAssertEqual(left("0.00000000000123"),   "1,23")        ; XCTAssertEqual(right("0.00000000000123"), "e-11")
        XCTAssertEqual(left("0.000000000000123"),  "1,23")        ; XCTAssertEqual(right("0.000000000000123"), "e-12")
        XCTAssertEqual(left("0.0000000000000123"), "1,23")        ; XCTAssertEqual(right("0.0000000000000123"), "e-13")

        XCTAssertEqual(left("-0.123"),              "-0,123")         ; XCTAssertNil(right("-0.123"))
        XCTAssertEqual(left("-0.0123"),             "-0,0123")        ; XCTAssertNil(right("-0.0123"))
        XCTAssertEqual(left("-0.00123"),            "-0,00123")       ; XCTAssertNil(right("-0.00123"))
        XCTAssertEqual(left("-0.000123"),           "-0,000123")      ; XCTAssertNil(right("-0.000123"))
        XCTAssertEqual(left("-0.0000123"),          "-0,0000123")     ; XCTAssertNil(right("-0.0000123"))
        XCTAssertEqual(left("-0.00000123"),         "-0,00000123")    ; XCTAssertNil(right("-0.00000123"))
        XCTAssertEqual(left("-0.000000123"),        "-0,000000123")   ; XCTAssertNil(right("-0.000000123"))
        XCTAssertEqual(left("-0.0000000123"),       "-1,23")        ; XCTAssertEqual(right("-0.0000000123"), "e-7")
        XCTAssertEqual(left("-0.00000000123"),      "-1,23")        ; XCTAssertEqual(right("-0.00000000123"), "e-8")
        XCTAssertEqual(left("-0.000000000123"),     "-1,23")        ; XCTAssertEqual(right("-0.000000000123"), "e-9")
        XCTAssertEqual(left("-0.0000000000123"),    "-1,23")        ; XCTAssertEqual(right("-0.0000000000123"), "e-10")
        XCTAssertEqual(left("-0.00000000000123"),   "-1,23")        ; XCTAssertEqual(right("-0.00000000000123"), "e-11")
        XCTAssertEqual(left("-0.000000000000123"),  "-1,23")        ; XCTAssertEqual(right("-0.000000000000123"), "e-12")
        XCTAssertEqual(left("-0.0000000000000123"), "-1,23")        ; XCTAssertEqual(right("-0.0000000000000123"), "e-13")
    }
    func test_xx() {
        screen.thousandSeparator = .none
        screen.decimalSeparator = .dot
        XCTAssertEqual(left("123"),     "123")
        XCTAssertEqual(left("1234"),    "1234")
        XCTAssertEqual(left("12345"),   "12345")
        XCTAssertEqual(left("123456"),  "123456")
        XCTAssertEqual(left("1234567"), "1234567")

        screen.thousandSeparator = .dot
        screen.decimalSeparator = .comma
        XCTAssertEqual(left("123"),     "123")
        XCTAssertEqual(left("1234"),    "1.234")
        XCTAssertEqual(left("12345"),   "12.345")
        XCTAssertEqual(left("123456"),  "123.456")
        XCTAssertEqual(left("1234567"), "1.234.567")

        screen.thousandSeparator = .comma
        screen.decimalSeparator = .dot
        XCTAssertEqual(left("123"),     "123")
        XCTAssertEqual(left("1234"),    "1,234")
        XCTAssertEqual(left("12345"),   "12,345")
        XCTAssertEqual(left("123456"),  "123,456")
        XCTAssertEqual(left("1234567"), "1,234,567")
        XCTAssertEqual(left("12345678"), "12,345,678")
        XCTAssertEqual(left("123456789"), "123,456,789")
        XCTAssertEqual(left("1234567890"), "1,234,567,890")
        XCTAssertEqual(left("12345678901"), "12,345,678,901")
        XCTAssertEqual(left("123456789012"), "123,456,789,012")

    }
    
    func testBits() {
        let debugBrain = DebugBrain(precision: 200_000, lengths: Lengths(5_000)) /// also failing: 10000

        debugBrain.push(7.7)
        debugBrain.push("One_x")
        debugBrain.push("One_x")
        XCTAssertEqual(oneLine(debugBrain.last), "7,7")

        debugBrain.push("AC")
        debugBrain.push(0.3)
        debugBrain.push("+")
        debugBrain.push("0,4")
        debugBrain.push("=")
        XCTAssertEqual(oneLine(debugBrain.last), "0,7")
    }
    
    func test_Integer() {
        screen.thousandSeparator = .none
        screen.decimalSeparator = .comma
        XCTAssertEqual(left("123"),     "123")
        XCTAssertEqual(left("1234"),    "1234")
        XCTAssertEqual(left("12345"),   "12345")
        XCTAssertEqual(left("123456"),  "123456")
        XCTAssertEqual(left("1234567"), "1234567")
        XCTAssertEqual(left("12345678"), "12345678")
        XCTAssertEqual(left("123456789"), "123456789")
        XCTAssertEqual(left("1234567890"), "1234567890")
        XCTAssertEqual(left("12345678901"), "12345678901")
        XCTAssertEqual(left("123456789012"), "123456789012")
        XCTAssertEqual(left("1234567890123"), "1234567890123")
        XCTAssertEqual(left("12345678901234"), "12345678901234")
        XCTAssertEqual(left("123456789012345"), "123456789012345")

        let debugBrain = DebugBrain(precision: 100, lengths: Lengths(withoutComma: 8, withCommaNonScientific: 9, withCommaScientific: 9, digitWidth: 0, ePadding: 0))
        
        debugBrain.pushnew(123)
        compare(debugBrain.last, "123", nil)
        
        debugBrain.pushnew(1234)
        XCTAssertEqual(left(debugBrain.last), "1234")
        XCTAssertNil(right(debugBrain.last))

        debugBrain.pushnew(12345)
        XCTAssertEqual(left(debugBrain.last), "12345")
        XCTAssertNil(right(debugBrain.last))

        debugBrain.pushnew("12345")
        XCTAssertEqual(left(debugBrain.last), "12345")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("12300")
        XCTAssertEqual(left(debugBrain.last), "12300")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("12300")
        XCTAssertEqual(left(debugBrain.last), "12300")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("123456")
        XCTAssertEqual(left(debugBrain.last), "123456")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("123456")
        XCTAssertEqual(left(debugBrain.last), "123456")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1234567")
        XCTAssertEqual(left(debugBrain.last), "1234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("12345678")
        XCTAssertEqual(left(debugBrain.last), "12345678")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("123456789")
        XCTAssertEqual(left(debugBrain.last), "1,23456")
        XCTAssertEqual(right(debugBrain.last), "e8")
//
//
//        debugBrain.pushnew("-123")
//        XCTAssertEqual(left(debugBrain.last), "-123")
//        XCTAssertNil(right(debugBrain.last))
//
//
//        debugBrain.pushnew(-12345)
//        XCTAssertEqual(left(debugBrain.last), "-12345")
//        XCTAssertNil(right(debugBrain.last))
//
//
//        debugBrain.pushnew(-123456)
//        XCTAssertEqual(left(debugBrain.last), "-123456")
//        XCTAssertNil(right(debugBrain.last))
//
//
//        debugBrain.pushnew(-1234567)
//        XCTAssertEqual(left(debugBrain.last), "-1234567")
//        XCTAssertNil(right(debugBrain.last))
//
//
//        debugBrain.pushnew(-12345678)
//        XCTAssertEqual(left(debugBrain.last), "-1,2345")
//        XCTAssertEqual(right(debugBrain.last), "e7")
//
//        debugBrain.pushnew(1234567)
//        XCTAssertEqual(left(debugBrain.last), "1234567")
//        XCTAssertNil(right(debugBrain.last))
//
//
//        debugBrain.pushnew(-1234567)
//        XCTAssertEqual(left(debugBrain.last), "-1234567")
//        XCTAssertNil(right(debugBrain.last))
        
    }
    func test_Float() {
        let debugBrain = DebugBrain(precision: 100, lengths: Lengths(withoutComma: 8, withCommaNonScientific: 9, withCommaScientific: 9, digitWidth: 0, ePadding: 0))
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
        XCTAssertEqual(left(debugBrain.last), "1,2345678")
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
        XCTAssertEqual(left(debugBrain.last), "-1,234567")
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
        XCTAssertEqual(left(debugBrain.last), "1,2345678")
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
        XCTAssertEqual(left(debugBrain.last), "-1,234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-144,23456789")
        XCTAssertEqual(left(debugBrain.last), "-144,2345")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1445,23456789")
        XCTAssertEqual(left(debugBrain.last), "1445,2345")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("14456,23456789")
        XCTAssertEqual(left(debugBrain.last), "14456,234")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("144567,23456789")
        XCTAssertEqual(left(debugBrain.last), "144567,23")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1445678,23456789")
        XCTAssertEqual(left(debugBrain.last), "1445678,2")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("14456785,23456789")
        XCTAssertEqual(left(debugBrain.last), "14456785,")
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
        XCTAssertEqual(left(debugBrain.last), "0,1234567")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,000012")
        XCTAssertEqual(left(debugBrain.last), "0,000012")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,000004")
        XCTAssertEqual(left(debugBrain.last), "0,000004")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,0000123456")
        XCTAssertEqual(left(debugBrain.last), "0,0000123")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,000012")
        XCTAssertEqual(left(debugBrain.last), "-0,000012")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,0000123")
        XCTAssertEqual(left(debugBrain.last), "-0,000012")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,0000123456")
        XCTAssertEqual(left(debugBrain.last), "-0,000012")
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
        XCTAssertEqual(left(debugBrain.last), "-0,123456")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("14456789,23456789")
        XCTAssertEqual(left(debugBrain.last), "14456789,")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-144567,23456789")
        XCTAssertEqual(left(debugBrain.last), "-144567,2")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-1445678,23456789")
        XCTAssertEqual(left(debugBrain.last), "-1445678,")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("1445678,23456789")
        XCTAssertEqual(left(debugBrain.last), "1445678,2")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,0123")
        XCTAssertEqual(left(debugBrain.last), "0,0123")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,01234567")
        XCTAssertEqual(left(debugBrain.last), "0,0123456")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,0012")
        XCTAssertEqual(left(debugBrain.last), "0,0012")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,0012")
        XCTAssertEqual(left(debugBrain.last), "-0,0012")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,001234567")
        XCTAssertEqual(left(debugBrain.last), "0,0012345")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,001234567")
        XCTAssertEqual(left(debugBrain.last), "-0,001234")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,0001234567")
        XCTAssertEqual(left(debugBrain.last), "0,0001234")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,0001234567")
        XCTAssertEqual(left(debugBrain.last), "-0,000123")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,00001234567")
        XCTAssertEqual(left(debugBrain.last), "0,0000123")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-0,00001234567")
        XCTAssertEqual(left(debugBrain.last), "-0,000012")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,12345678")
        XCTAssertEqual(left(debugBrain.last), "0,1234567")
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


        debugBrain.pushnew("0,00000004")
        XCTAssertEqual(left(debugBrain.last), "4,0")
        XCTAssertEqual(right(debugBrain.last), "e-8")


        debugBrain.pushnew("0,0000004")
        XCTAssertEqual(left(debugBrain.last), "0,0000004")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("12345678349875349873")
        XCTAssertEqual(left(debugBrain.last), "1,2345")
        XCTAssertEqual(right(debugBrain.last), "e19")


        debugBrain.pushnew("123456783498753498731")
        XCTAssertEqual(left(debugBrain.last), "1,2345")
        XCTAssertEqual(right(debugBrain.last), "e20")


        debugBrain.pushnew("0,012345678")
        XCTAssertEqual(left(debugBrain.last), "0,0123456")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("0,0012345678")
        XCTAssertEqual(left(debugBrain.last), "0,0012345")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("-1445,23456789")
        XCTAssertEqual(left(debugBrain.last), "-1445,234")
        XCTAssertNil(right(debugBrain.last))


        debugBrain.pushnew("921387491237419283092340238420398423098423049874129837649128364519234875")
        XCTAssertEqual(left(debugBrain.last), "9,2138")
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
        XCTAssertEqual(left(debugBrain.last), "2,328")
        XCTAssertEqual(right(debugBrain.last), "e-11")


        debugBrain.pushnew("0,0000000000232837642876239827342")
        XCTAssertEqual(left(debugBrain.last), "2,328")
        XCTAssertEqual(right(debugBrain.last), "e-11")

    }

    func test() {
        let debugBrain = DebugBrain(precision: 100, lengths: Lengths(10))

        /// 1
        debugBrain.push("AC")
        debugBrain.push("2")
        XCTAssertEqual(left(debugBrain.last), "2")
        XCTAssertNil(right(debugBrain.last))

        debugBrain.push("√")
        XCTAssertEqual(left(debugBrain.last), "1,41421356")

        /// 0
        debugBrain.push("AC")

        XCTAssertEqual(left(debugBrain.last), "0")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(0)

        XCTAssertEqual(left(debugBrain.last), "0")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(0)

        XCTAssertEqual(left(debugBrain.last), "0")
        XCTAssertEqual(right(debugBrain.last), nil)


        // 12
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push(2)

        XCTAssertEqual(left(debugBrain.last), "12")
        XCTAssertEqual(right(debugBrain.last), nil)

        // 01
        debugBrain.push("AC")

        XCTAssertEqual(left(debugBrain.last), "0")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(0)

        XCTAssertEqual(left(debugBrain.last), "0")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(1)

        XCTAssertEqual(left(debugBrain.last), "1")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 1234567890
        debugBrain.push("AC")
        debugBrain.push("1234567890")

        XCTAssertEqual(left(debugBrain.last), "1234567890")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 1234567891
        debugBrain.push("AC")
        debugBrain.push("12345678901")

        XCTAssertEqual(left(debugBrain.last), "1,23456")
        XCTAssertEqual(right(debugBrain.last), "e10")

        /// 123456789012345678
        debugBrain.push("AC")
        debugBrain.push("12345678901234567")

        XCTAssertEqual(left(debugBrain.last), "1,23456")
        XCTAssertEqual(right(debugBrain.last), "e16")
        debugBrain.push(8)

        XCTAssertEqual(left(debugBrain.last), "1,23456")
        XCTAssertEqual(right(debugBrain.last), "e17")


        /// -12345678901234
        debugBrain.push("AC")
        debugBrain.push("123456789")
        debugBrain.push("±")

        XCTAssertEqual(left(debugBrain.last), "-123456789")
        XCTAssertEqual(right(debugBrain.last), nil)


        /// 77777777777777777
        debugBrain.push("AC")
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)

        XCTAssertEqual(left(debugBrain.last), "777777777")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push(7)

        XCTAssertEqual(left(debugBrain.last), "7,77777")
        XCTAssertEqual(right(debugBrain.last), "e22")



        /// -123456789012345
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push(2)
        debugBrain.push(3)
        debugBrain.push(4)
        debugBrain.push(5)
        debugBrain.push(6)
        debugBrain.push(7)
        debugBrain.push(8)
        debugBrain.push(9)
        debugBrain.push("±")

        XCTAssertEqual(left(debugBrain.last), "-123456789")
        XCTAssertEqual(right(debugBrain.last), nil)


        /// ±
        debugBrain.push("AC")
        debugBrain.push(7)

        XCTAssertEqual(left(debugBrain.last), "7")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("±")

        XCTAssertEqual(left(debugBrain.last), "-7")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 0,
        debugBrain.push("AC")
        debugBrain.push(",")

        XCTAssertEqual(left(debugBrain.last), "0,")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(",")

        XCTAssertEqual(left(debugBrain.last), "0,")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// -0,7
        debugBrain.push("AC")
        debugBrain.push(",")

        XCTAssertEqual(left(debugBrain.last), "0,")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(7)

        XCTAssertEqual(left(debugBrain.last), "0,7")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("±")

        XCTAssertEqual(left(debugBrain.last), "-0,7")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 3 e6
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("EE")
        debugBrain.push(6)
        debugBrain.push("=")

        XCTAssertEqual(left(debugBrain.last), "3000000")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 3 e6 + 0.01
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("EE")
        debugBrain.push(5)
        debugBrain.push("=")
        debugBrain.push("+")
        debugBrain.push(",")
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(1)
        debugBrain.push("=")

        XCTAssertEqual(left(debugBrain.last), "300000,001")
        XCTAssertEqual(right(debugBrain.last), nil)


        /// 3 e77
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("EE")
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push("=")

        XCTAssertEqual(left(debugBrain.last), "3,0")
        XCTAssertEqual(right(debugBrain.last), "e77")

        /// 3 e-77
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("EE")
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push("±")
        debugBrain.push("=")

        XCTAssertEqual(left(debugBrain.last), "3,0")
        XCTAssertEqual(right(debugBrain.last), "e-77")

        /// -3 e-77
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("EE")
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push("±")
        debugBrain.push("=")
        debugBrain.push("±")

        XCTAssertEqual(left(debugBrain.last), "-3,0")
        XCTAssertEqual(right(debugBrain.last), "e-77")

        /// -3 e-77
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("±")
        debugBrain.push("EE")
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push("±")
        debugBrain.push("=")

        XCTAssertEqual(left(debugBrain.last), "-3,0")
        XCTAssertEqual(right(debugBrain.last), "e-77")


        /// 8888888
        debugBrain.push("AC")
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)

        XCTAssertEqual(left(debugBrain.last), "8888888")
        XCTAssertEqual(right(debugBrain.last), nil)


        /// memory
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push(2)

        XCTAssertEqual(left(debugBrain.last), "12")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("mc")

        XCTAssertEqual(left(debugBrain.last), "12")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("m+")

        XCTAssertEqual(left(debugBrain.last), "12")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("m+")

        XCTAssertEqual(left(debugBrain.last), "12")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("mr")

        XCTAssertEqual(left(debugBrain.last), "24")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("m-")

        XCTAssertEqual(left(debugBrain.last), "0")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("mr")

        XCTAssertEqual(left(debugBrain.last), "0")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 0,0000010
        debugBrain.push("AC")
        debugBrain.push(0)

        XCTAssertEqual(left(debugBrain.last), "0")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(",")

        XCTAssertEqual(left(debugBrain.last), "0,")
        XCTAssertEqual(right(debugBrain.last), nil)
        
        debugBrain.push(0)
        XCTAssertEqual(left(debugBrain.last), "0,0")
        XCTAssertEqual(right(debugBrain.last), nil)
        
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(0)
        XCTAssertEqual(left(debugBrain.last), "0,0000")
        XCTAssertEqual(right(debugBrain.last), nil)
        
        debugBrain.push(1)
        XCTAssertEqual(left(debugBrain.last), "0,00001")
        XCTAssertEqual(right(debugBrain.last), nil)
        
        debugBrain.push(0)
        XCTAssertEqual(left(debugBrain.last), "0,000010")
        XCTAssertEqual(right(debugBrain.last), nil)

        debugBrain.push(1)
        XCTAssertEqual(left(debugBrain.last), "0,0000101")
        XCTAssertEqual(right(debugBrain.last), nil)


        /// 0,000...0010
        debugBrain.push("AC")
        debugBrain.push("0,0000000000000001")

        XCTAssertEqual(left(debugBrain.last), "1,0")
        XCTAssertEqual(right(debugBrain.last), "e-16")

        /// 0,000...0010
        debugBrain.push("AC")
        debugBrain.push("0,00000001")

        XCTAssertEqual(left(debugBrain.last), "0,00000001")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 0,000...0010
        debugBrain.push("AC")
        debugBrain.push("0,00000001")
        XCTAssertEqual(left(debugBrain.last), "0,00000001")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 0,000...0010
        debugBrain.push("AC")
        debugBrain.push("0,000000001")
        XCTAssertEqual(left(debugBrain.last), "1,0")
        XCTAssertEqual(right(debugBrain.last), "e-9")

        /// 0,000...0010
        debugBrain.push("AC")
        debugBrain.push("0,0000000001")
        XCTAssertEqual(left(debugBrain.last), "1,0")
        XCTAssertEqual(right(debugBrain.last), "e-10")

        /// 0,000...0010
        debugBrain.push("AC")
        debugBrain.push("0,000000000001")
        XCTAssertEqual(left(debugBrain.last), "1,0")
        XCTAssertEqual(right(debugBrain.last), "e-12")

        /// 0,000...0010
        debugBrain.push("AC")
        debugBrain.push("0,00000000000001")
        XCTAssertEqual(left(debugBrain.last), "1,0")
        XCTAssertEqual(right(debugBrain.last), "e-14")

        

        /// 0,000...0010
        debugBrain.push("AC")
        debugBrain.push("0,0000000000000001")
        XCTAssertEqual(left(debugBrain.last), "1,0")
        XCTAssertEqual(right(debugBrain.last), "e-16")

        var res: String
        let digits = 5

        /// 1 e -15
        debugBrain.push("AC")
        debugBrain.push(",")
        res = "0,"
        for _ in 1..<digits-1 {
            res += "0"
            debugBrain.push(0)
    
            XCTAssertEqual(left(debugBrain.last), res)
            XCTAssertEqual(right(debugBrain.last), nil)
        }
        debugBrain.push(1)

        XCTAssertEqual(left(debugBrain.last), "0,0001")
        XCTAssertEqual(left(debugBrain.last), res+"1")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 32456.2244
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push(2)
        debugBrain.push(4)
        debugBrain.push(5)
        debugBrain.push(6)
        debugBrain.push(",")
        debugBrain.push(2)
        debugBrain.push(2)
        debugBrain.push(4)
        res = "32456,224"

        XCTAssertEqual(left(debugBrain.last), res)
        XCTAssertEqual(right(debugBrain.last), nil)


        /// 32456.224433
        debugBrain.push(3)
        res += "3"

        XCTAssertEqual(left(debugBrain.last), res)
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(3)

        XCTAssertEqual(left(debugBrain.last), res)
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 1/7*7 --> has more digits?
        debugBrain.push("AC")
        debugBrain.push(7)
        debugBrain.push("One_x")
        debugBrain.push("x")
        debugBrain.push(7)
        debugBrain.push("=")

        XCTAssertEqual(left(debugBrain.last), "1")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// -1/3
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("One_x")
        var correct = "0,33333333"

        XCTAssertEqual (left(debugBrain.last), correct)
        debugBrain.push("±")
        correct = "-0,3333333"

        XCTAssertEqual (left(debugBrain.last), correct)

        /// 9 %%%% ^2 ^2 ^2
        debugBrain.push("AC")
        debugBrain.push("9")
        debugBrain.push("%")

        XCTAssertEqual(left(debugBrain.last), "0,09")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("%")

        XCTAssertEqual(left(debugBrain.last), "0,0009")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("%")
        debugBrain.push("%")

        XCTAssertEqual(left(debugBrain.last), "0,00000009")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("x^2")

        XCTAssertEqual(left(debugBrain.last), "8,1")
        XCTAssertEqual(right(debugBrain.last), "e-15")


        /// 1/10 and 1/16
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push(0)

        XCTAssertEqual(left(debugBrain.last), "10")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("One_x")

        XCTAssertEqual(left(debugBrain.last), "0,1")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(1)
        debugBrain.push(6)

        XCTAssertEqual(left(debugBrain.last), "16")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("One_x")

        XCTAssertEqual(left(debugBrain.last), "0,0625")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 1+2+5+2= + 1/4 =
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("+")

        XCTAssertEqual(left(debugBrain.last), "3")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(5)
        debugBrain.push("+")

        XCTAssertEqual(left(debugBrain.last), "8")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(2)
        debugBrain.push("=")

        XCTAssertEqual(left(debugBrain.last), "10")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("+")

        XCTAssertEqual(left(debugBrain.last), "10")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(4)
        debugBrain.push("One_x")

        XCTAssertEqual(left(debugBrain.last), "0,25")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("=")

        XCTAssertEqual(left(debugBrain.last), "10,25")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 1+2*4=
        debugBrain.push("AC")
        debugBrain.push(1)

        XCTAssertEqual(left(debugBrain.last), "1")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("x")

        XCTAssertEqual(left(debugBrain.last), "2")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(4)

        XCTAssertEqual(left(debugBrain.last), "4")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("=")

        XCTAssertEqual(left(debugBrain.last), "9")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 2*3*4*5=
        debugBrain.push("AC")
        debugBrain.push(2)
        debugBrain.push("x")
        debugBrain.push(3)
        debugBrain.push("x")
        debugBrain.push(4)
        debugBrain.push("x")

        XCTAssertEqual(left(debugBrain.last), "24")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(5)
        debugBrain.push("=")

        XCTAssertEqual(left(debugBrain.last), "120")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 1+2*4
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("x")

        XCTAssertEqual(left(debugBrain.last), "2")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(4)

        XCTAssertEqual(left(debugBrain.last), "4")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("+")

        XCTAssertEqual(left(debugBrain.last), "9")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push(1)
        debugBrain.push(0)
        debugBrain.push(0)

        XCTAssertEqual(left(debugBrain.last), "100")
        XCTAssertEqual(right(debugBrain.last), nil)
        debugBrain.push("=")

        XCTAssertEqual(left(debugBrain.last), "109")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// pi
        debugBrain.push("AC")
        debugBrain.push("π")
        correct = "3,14159265"

        XCTAssertEqual(left(debugBrain.last), correct)
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 1+pi
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push("π")
        debugBrain.push("=")
        correct = "4,14159265"

        XCTAssertEqual(left(debugBrain.last), correct)
        XCTAssertEqual(right(debugBrain.last), nil)

        debugBrain.push("AC")
        debugBrain.push("π")
        debugBrain.push("x")
        debugBrain.push(2)
        debugBrain.push("=")
        correct = "6,28318530"

        XCTAssertEqual(left(debugBrain.last), correct)
        XCTAssertEqual(right(debugBrain.last), nil)

        debugBrain.push("AC")
        debugBrain.push(2)
        debugBrain.push("x^y")
        debugBrain.push(1)
        debugBrain.push(0)
        debugBrain.push("=")

        XCTAssertEqual(left(debugBrain.last), "1024")
        XCTAssertEqual(right(debugBrain.last), nil)

        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push(0)
        debugBrain.push("y^x")
        debugBrain.push(2)
        debugBrain.push("=")
        //        XCTAssertEqual(debugBrain.debugLastGmp, Gmp("1024")

        /// 2x(6+4)
        debugBrain.push("AC")
        debugBrain.push(2)
        XCTAssertEqual(debugBrain.no, 0)
        debugBrain.push("x")
        XCTAssertEqual(debugBrain.no, 1)
        debugBrain.push("( ")
        XCTAssertEqual(debugBrain.no, 2)
        debugBrain.push(6)

        XCTAssertEqual(left(debugBrain.last), "6")
        XCTAssertEqual(debugBrain.nn, 2)
        debugBrain.push("+")
        XCTAssertEqual(debugBrain.no, 3)
        debugBrain.push(4)

        XCTAssertEqual(left(debugBrain.last), "4")
        XCTAssertEqual(debugBrain.nn, 3)
        debugBrain.push(" )")
        XCTAssertEqual(debugBrain.no, 1)
        XCTAssertEqual(debugBrain.nn, 2)
        //        XCTAssertEqual(debugBrain.debugLastGmp, Gmp("10")
        debugBrain.push("=")
        //        XCTAssertEqual(debugBrain.debugLastGmp, Gmp("20")

        XCTAssertEqual(left(debugBrain.last), "20")
        XCTAssertEqual(right(debugBrain.last), nil)

        /// 2x(6+4*(5+9))
        debugBrain.push("AC")
        debugBrain.push(2)
        debugBrain.push("x")
        debugBrain.push("( ")
        debugBrain.push(6)
        debugBrain.push("+")
        debugBrain.push(4)
        debugBrain.push("x")
        debugBrain.push("( ")
        debugBrain.push(5)
        debugBrain.push("+")
        debugBrain.push(9)
        debugBrain.push(" )")
        debugBrain.push(" )")
        debugBrain.push("=")
        XCTAssertEqual(left(debugBrain.last), "124")

        /// 1+2=3
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("=")
        debugBrain.push(2)
        XCTAssertEqual(debugBrain.nn, 1)

        debugBrain.push("AC")
        debugBrain.push("π")
        XCTAssertEqual(debugBrain.double, 3.14159265358979, accuracy: 0.00000001)

        debugBrain.push("AC")
        debugBrain.push(0.01)
        debugBrain.push("/")
        debugBrain.push(1)
        debugBrain.push("EE")
        debugBrain.push(4)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 0.000001)

        debugBrain.push("AC")
        debugBrain.push(88)
        debugBrain.push("%")
        XCTAssertEqual(debugBrain.double, 0.88)

        debugBrain.push("AC")
        debugBrain.push(40)
        debugBrain.push("+")
        debugBrain.push(10)
        debugBrain.push("%")
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 44.0)
        
        /// 5+4*3^2 = 5+4*9 = 5+36 = 41
        debugBrain.push("AC")
        debugBrain.push(5)
        debugBrain.push("+")
        debugBrain.push(4)
        debugBrain.push("x")
        debugBrain.push(3)
        debugBrain.push("x^y")
        debugBrain.push(2)
        debugBrain.push("=")
        XCTAssertEqual(left(debugBrain.last), "41")
        
        /// odd root of negative number, implemented as special case in BrainEngine.execute
        debugBrain.push("AC")
        debugBrain.push(-8)
        debugBrain.push("y√")
        debugBrain.push(3)
        debugBrain.push("=")
        XCTAssertEqual(left(debugBrain.last), "-2")
        
        /// change operand
        debugBrain.push("AC")
        debugBrain.push(5)
        debugBrain.push("+")
        debugBrain.push("x")
        debugBrain.push(4)
        debugBrain.push("=")
        XCTAssertEqual(left(debugBrain.last), "20")

        /// change twoOperand
        debugBrain.push("AC")
        debugBrain.push(5)
        debugBrain.push("y√")
        debugBrain.push("x^y")
        debugBrain.push(3)
        debugBrain.push("=")
        XCTAssertEqual(left(debugBrain.last), "125")
    }
    
    func _testSpeed1() throws {
        self.measure {
            let x = Number("88888888", precision: 10_000_000)
            x.toGmp()
        }
    }
    
    func _testSpeed2() throws {
        self.measure {
            let x = Number("888888888,8888888", precision: 10_000_000)
            x.toGmp()
        }
    }
        
}
