//
//  CalculatorTests.swift
//  xxTests
//
//  Created by Joachim Neumann on 10/31/21.
//

import XCTest

@testable import Better_Calc

class CalculatorTests: XCTestCase {
    
    func testBits() throws {
        let debugBrain = DebugBrain(precision: 200_000)
        let _ = Lengths(5_000) /// also failing: 10000

        debugBrain.run(7.7)
        debugBrain.run("One_x")
        debugBrain.run("One_x")
        XCTAssertEqual(debugBrain.oneLine, "7,7")

        debugBrain.run("AC")
        debugBrain.run(0.3)
        debugBrain.run("+")
        debugBrain.run("0,4")
        debugBrain.run("=")
        XCTAssertEqual(debugBrain.left, "0,7")
    }
    
//    func testmultipleLiner() {
//        let debugBrain = DebugBrain(precision: 100)
//        let lengths = Lengths(withoutComma: 8, withCommaNonScientific: 9, withCommaScientific: 9, height: 0, digitWidth: 0, infoHeight: 0, ePadding: 0)
//
//        /// integers
//        displayData = Number("123", precision: precision).getDisplayData(lengths)
//
//
//        XCTAssertEqual(debugBrain.left, "123")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1234", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("12345", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "12345")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("12345", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "12345")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("12300", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "12300")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("12300", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "12300")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("123456", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "123456")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("123456", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "123456")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1234567")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("12345678", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "12345678")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("123456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,23456")
//        XCTAssertEqual(debugBrain.right, "e8")
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("-123", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-123")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-12345", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-12345")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-123456", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-123456")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-1234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-1234567")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-12345678", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-1,2345")
//        XCTAssertEqual(debugBrain.right, "e7")
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//
//        displayData = Number("1234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1234567")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-1234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-1234567")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//
//        /// floating point numbers
//        displayData = Number("1,234", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1,2345", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,2345")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1,23456", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,23456")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1,234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,234567")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1,2345678", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,2345678")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1,23456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,2345678")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("-1,234", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-1,234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-1,2345", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-1,2345")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-1,23456", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-1,23456")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-1,234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-1,234567")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-1,2345678", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-1,234567")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//
//        displayData = Number("1,234", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1,234", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1,234", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1,234", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1,234", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1,234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,234567")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1,2345678", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,2345678")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1,23456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,2345678")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("-1,234", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-1,234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-1,2345", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-1,2345")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-1,23456", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-1,23456")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-1,23456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-1,234567")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("-144,23456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-144,2345")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("1445,23456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1445,2345")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("14456,23456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "14456,234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("144567,23456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "144567,23")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("1445678,23456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1445678,2")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("14456785,23456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "14456785,")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("0,123", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,123")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("0,1234", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,1234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("0,12345", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,12345")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("0,123456", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,123456")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("0,1234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,1234567")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("0,12345678", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,1234567")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("0,000012", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,000012")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("0,000004", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,000004")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("0,0000123456", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,0000123")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("-0,000012", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-0,000012")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-0,0000123", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-0,000012")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("-0,0000123456", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-0,000012")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("-0,123", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-0,123")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-0,1234", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-0,1234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-0,12345", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-0,12345")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-0,123456", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-0,123456")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-0,1234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-0,123456")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("14456789,23456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "14456789,")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("-144567,23456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-144567,2")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("-1445678,23456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-1445678,")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("1445678,23456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1445678,2")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("0,0123", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,0123")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("0,01234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,0123456")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("0,0012", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,0012")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("-0,0012", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-0,0012")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("0,001234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,0012345")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("-0,001234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-0,001234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("0,0001234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,0001234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("-0,0001234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-0,000123")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("0,00001234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,0000123")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("-0,00001234567", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-0,000012")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("0,12345678", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,1234567")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        /// scientific notation
//
//        displayData = Number("1,5e12", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,5")
//        XCTAssertEqual(debugBrain.right, "e12")
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1,5e12", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,5")
//        XCTAssertEqual(debugBrain.right, "e12")
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("0,00000004", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "4,0")
//        XCTAssertEqual(debugBrain.right, "e-8")
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("0,0000004", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,0000004")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("12345678349875349873", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,2345")
//        XCTAssertEqual(debugBrain.right, "e19")
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("123456783498753498731", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,2345")
//        XCTAssertEqual(debugBrain.right, "e20")
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("0,012345678", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,0123456")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("0,0012345678", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,0012345")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("-1445,23456789", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "-1445,234")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("921387491237419283092340238420398423098423049874129837649128364519234875", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "9,2138")
//        XCTAssertEqual(debugBrain.right, "e71")
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("1,23", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,23")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("1,23", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "1,23")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("0,0023", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "0,0023")
//        XCTAssertNil(  debugBrain.right)
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("0,000000000023", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "2,3")
//        XCTAssertEqual(debugBrain.right, "e-11")
////        XCTAssertFalse(debugBrain.isAbbreviated)
//
//        displayData = Number("0,0000000000232837642876", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "2,328")
//        XCTAssertEqual(debugBrain.right, "e-11")
////        XCTAssertTrue(debugBrain.isAbbreviated)
//
//        displayData = Number("0,0000000000232837642876239827342", precision: precision).getDisplayData(lengths)
//        XCTAssertEqual(debugBrain.left, "2,328")
//        XCTAssertEqual(debugBrain.right, "e-11")
////        XCTAssertTrue(debugBrain.isAbbreviated)
//    }
//
    func test() {
        let debugBrain = DebugBrain(precision: 100)
        let lengths = Lengths(10)

        /// 1
        debugBrain.run("AC")
        debugBrain.run("2")
        XCTAssertEqual(debugBrain.left, "2")
        XCTAssertNil(  debugBrain.right)
//        XCTAssertFalse(debugBrain.isAbbreviated)
        debugBrain.run("√")
        XCTAssertEqual(debugBrain.left, "1,41421356")

        /// 0
        debugBrain.run("AC")

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(0)

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(0)

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)


        // 12
        debugBrain.run("AC")
        debugBrain.debugPress(1)
        debugBrain.debugPress(2)

        XCTAssertEqual(debugBrain.left, "12")
        XCTAssertEqual(debugBrain.right, nil)

        // 01
        debugBrain.run("AC")

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(0)

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(1)

        XCTAssertEqual(debugBrain.left, "1")
        XCTAssertEqual(debugBrain.right, nil)

        /// 1234567890
        debugBrain.run("AC")
        debugBrain.debugPress("1234567890")

        XCTAssertEqual(debugBrain.left, "1234567890")
        XCTAssertEqual(debugBrain.right, nil)

        /// 1234567891
        debugBrain.run("AC")
        debugBrain.debugPress("12345678901")

        XCTAssertEqual(debugBrain.left, "1,23456")
        XCTAssertEqual(debugBrain.right, "e10")

        /// 123456789012345678
        debugBrain.run("AC")
        debugBrain.debugPress("12345678901234567")

        XCTAssertEqual(debugBrain.left, "1,23456")
        XCTAssertEqual(debugBrain.right, "e16")
        debugBrain.debugPress(8)

        XCTAssertEqual(debugBrain.left, "1,23456")
        XCTAssertEqual(debugBrain.right, "e17")


        /// -12345678901234
        debugBrain.run("AC")
        debugBrain.debugPress("123456789")
        debugBrain.run("±")

        XCTAssertEqual(debugBrain.left, "-123456789")
        XCTAssertEqual(debugBrain.right, nil)


        /// 77777777777777777
        debugBrain.run("AC")
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)

        XCTAssertEqual(debugBrain.left, "777777777")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)

        XCTAssertEqual(debugBrain.left, "7,77777")
        XCTAssertEqual(debugBrain.right, "e22")



        /// -123456789012345
        debugBrain.run("AC")
        debugBrain.debugPress(1)
        debugBrain.debugPress(2)
        debugBrain.debugPress(3)
        debugBrain.debugPress(4)
        debugBrain.debugPress(5)
        debugBrain.debugPress(6)
        debugBrain.debugPress(7)
        debugBrain.debugPress(8)
        debugBrain.debugPress(9)
        debugBrain.run("±")

        XCTAssertEqual(debugBrain.left, "-123456789")
        XCTAssertEqual(debugBrain.right, nil)


        /// ±
        debugBrain.run("AC")
        debugBrain.debugPress(7)

        XCTAssertEqual(debugBrain.left, "7")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("±")

        XCTAssertEqual(debugBrain.left, "-7")
        XCTAssertEqual(debugBrain.right, nil)

        /// 0,
        debugBrain.run("AC")
        debugBrain.run(",")

        XCTAssertEqual(debugBrain.left, "0,")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run(",")

        XCTAssertEqual(debugBrain.left, "0,")
        XCTAssertEqual(debugBrain.right, nil)

        /// -0,7
        debugBrain.run("AC")
        debugBrain.run(",")

        XCTAssertEqual(debugBrain.left, "0,")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(7)

        XCTAssertEqual(debugBrain.left, "0,7")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("±")

        XCTAssertEqual(debugBrain.left, "-0,7")
        XCTAssertEqual(debugBrain.right, nil)

        /// 3 e6
        debugBrain.run("AC")
        debugBrain.debugPress(3)
        debugBrain.run("EE")
        debugBrain.debugPress(6)
        debugBrain.run("=")

        XCTAssertEqual(debugBrain.left, "3000000")
        XCTAssertEqual(debugBrain.right, nil)

        /// 3 e6 + 0.01
        debugBrain.run("AC")
        debugBrain.debugPress(3)
        debugBrain.run("EE")
        debugBrain.debugPress(5)
        debugBrain.run("=")
        debugBrain.run("+")
        debugBrain.run(",")
        debugBrain.debugPress(0)
        debugBrain.debugPress(0)
        debugBrain.debugPress(1)
        debugBrain.run("=")

        XCTAssertEqual(debugBrain.left, "300000,001")
        XCTAssertEqual(debugBrain.right, nil)


        /// 3 e77
        debugBrain.run("AC")
        debugBrain.debugPress(3)
        debugBrain.run("EE")
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.run("=")

        XCTAssertEqual(debugBrain.left, "3,0")
        XCTAssertEqual(debugBrain.right, "e77")

        /// 3 e-77
        debugBrain.run("AC")
        debugBrain.debugPress(3)
        debugBrain.run("EE")
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.run("±")
        debugBrain.run("=")

        XCTAssertEqual(debugBrain.left, "3,0")
        XCTAssertEqual(debugBrain.right, "e-77")

        /// -3 e-77
        debugBrain.run("AC")
        debugBrain.debugPress(3)
        debugBrain.run("EE")
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.run("±")
        debugBrain.run("=")
        debugBrain.run("±")

        XCTAssertEqual(debugBrain.left, "-3,0")
        XCTAssertEqual(debugBrain.right, "e-77")

        /// -3 e-77
        debugBrain.run("AC")
        debugBrain.debugPress(3)
        debugBrain.run("±")
        debugBrain.run("EE")
        debugBrain.debugPress(7)
        debugBrain.debugPress(7)
        debugBrain.run("±")
        debugBrain.run("=")

        XCTAssertEqual(debugBrain.left, "-3,0")
        XCTAssertEqual(debugBrain.right, "e-77")


        /// 8888888
        debugBrain.run("AC")
        debugBrain.debugPress(8)
        debugBrain.debugPress(8)
        debugBrain.debugPress(8)
        debugBrain.debugPress(8)
        debugBrain.debugPress(8)
        debugBrain.debugPress(8)
        debugBrain.debugPress(8)

        XCTAssertEqual(debugBrain.left, "8888888")
        XCTAssertEqual(debugBrain.right, nil)


        /// memory
        debugBrain.run("AC")
        debugBrain.debugPress(1)
        debugBrain.debugPress(2)

        XCTAssertEqual(debugBrain.left, "12")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("mc")

        XCTAssertEqual(debugBrain.left, "12")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("m+")

        XCTAssertEqual(debugBrain.left, "12")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("m+")

        XCTAssertEqual(debugBrain.left, "12")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("mr")

        XCTAssertEqual(debugBrain.left, "24")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("m-")

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("mr")

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)

        /// 0,0000010
        debugBrain.run("AC")
        debugBrain.debugPress(0)

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run(",")

        XCTAssertEqual(debugBrain.left, "0,")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(0)

        XCTAssertEqual(debugBrain.left, "0,0")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(0)
        debugBrain.debugPress(0)
        debugBrain.debugPress(0)
        debugBrain.debugPress(0)

        XCTAssertEqual(debugBrain.left, "0,00000")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(1)

        XCTAssertEqual(debugBrain.left, "0,000001")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(0)

        XCTAssertEqual(debugBrain.left, "0,0000010")
        XCTAssertEqual(debugBrain.right, nil)


        var res: String
        let digits = 5

        /// 1 e -15
        debugBrain.run("AC")
        debugBrain.run(",")
        res = "0,"
        for _ in 1..<digits-1 {
            res += "0"
            debugBrain.debugPress(0)
    
            XCTAssertEqual(debugBrain.left, res)
            XCTAssertEqual(debugBrain.right, nil)
        }
        debugBrain.debugPress(1)

        XCTAssertEqual(debugBrain.left, "0,0001")
        XCTAssertEqual(debugBrain.left, res+"1")
        XCTAssertEqual(debugBrain.right, nil)

        /// 32456.2244
        debugBrain.run("AC")
        debugBrain.debugPress(3)
        debugBrain.debugPress(2)
        debugBrain.debugPress(4)
        debugBrain.debugPress(5)
        debugBrain.debugPress(6)
        debugBrain.run(",")
        debugBrain.debugPress(2)
        debugBrain.debugPress(2)
        debugBrain.debugPress(4)
        res = "32456,224"

        XCTAssertEqual(debugBrain.left, res)
        XCTAssertEqual(debugBrain.right, nil)


        /// 32456.224433
        debugBrain.debugPress(3)
        res += "3"

        XCTAssertEqual(debugBrain.left, res)
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(3)

        XCTAssertEqual(debugBrain.left, res)
        XCTAssertEqual(debugBrain.right, nil)

        /// 1/7*7 --> has more digits?
        debugBrain.run("AC")
        debugBrain.debugPress(7)
        debugBrain.run("One_x")
        debugBrain.run("x")
        debugBrain.debugPress(7)
        debugBrain.run("=")

        XCTAssertEqual(debugBrain.left, "1")
        XCTAssertEqual(debugBrain.right, nil)

        /// -1/3
        debugBrain.run("AC")
        debugBrain.debugPress(3)
        debugBrain.run("One_x")
        var correct = "0,33333333"

        XCTAssertEqual (debugBrain.left, correct)
        debugBrain.run("±")
        correct = "-0,3333333"

        XCTAssertEqual (debugBrain.left, correct)

        /// 9 %%%% ^2 ^2 ^2
        debugBrain.run("AC")
        debugBrain.run("9")
        debugBrain.run("%")

        XCTAssertEqual(debugBrain.left, "0,09")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("%")

        XCTAssertEqual(debugBrain.left, "0,0009")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("%")
        debugBrain.run("%")

        XCTAssertEqual(debugBrain.left, "0,00000009")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("x^2")

        XCTAssertEqual(debugBrain.left, "8,1")
        XCTAssertEqual(debugBrain.right, "e-15")


        /// 1/10 and 1/16
        debugBrain.run("AC")
        debugBrain.debugPress(1)
        debugBrain.debugPress(0)

        XCTAssertEqual(debugBrain.left, "10")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("One_x")

        XCTAssertEqual(debugBrain.left, "0,1")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(1)
        debugBrain.debugPress(6)

        XCTAssertEqual(debugBrain.left, "16")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("One_x")

        XCTAssertEqual(debugBrain.left, "0,0625")
        XCTAssertEqual(debugBrain.right, nil)

        /// 1+2+5+2= + 1/4 =
        debugBrain.debugPress(1)
        debugBrain.run("+")
        debugBrain.debugPress(2)
        debugBrain.run("+")

        XCTAssertEqual(debugBrain.left, "3")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(5)
        debugBrain.run("+")

        XCTAssertEqual(debugBrain.left, "8")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(2)
        debugBrain.run("=")

        XCTAssertEqual(debugBrain.left, "10")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("+")

        XCTAssertEqual(debugBrain.left, "10")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(4)
        debugBrain.run("One_x")

        XCTAssertEqual(debugBrain.left, "0,25")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("=")

        XCTAssertEqual(debugBrain.left, "10,25")
        XCTAssertEqual(debugBrain.right, nil)

        /// 1+2*4=
        debugBrain.run("AC")
        debugBrain.debugPress(1)

        XCTAssertEqual(debugBrain.left, "1")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("+")
        debugBrain.debugPress(2)
        debugBrain.run("x")

        XCTAssertEqual(debugBrain.left, "2")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(4)

        XCTAssertEqual(debugBrain.left, "4")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("=")

        XCTAssertEqual(debugBrain.left, "9")
        XCTAssertEqual(debugBrain.right, nil)

        /// 2*3*4*5=
        debugBrain.run("AC")
        debugBrain.debugPress(2)
        debugBrain.run("x")
        debugBrain.debugPress(3)
        debugBrain.run("x")
        debugBrain.debugPress(4)
        debugBrain.run("x")

        XCTAssertEqual(debugBrain.left, "24")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(5)
        debugBrain.run("=")

        XCTAssertEqual(debugBrain.left, "120")
        XCTAssertEqual(debugBrain.right, nil)

        /// 1+2*4
        debugBrain.run("AC")
        debugBrain.debugPress(1)
        debugBrain.run("+")
        debugBrain.debugPress(2)
        debugBrain.run("x")

        XCTAssertEqual(debugBrain.left, "2")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(4)

        XCTAssertEqual(debugBrain.left, "4")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("+")

        XCTAssertEqual(debugBrain.left, "9")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.debugPress(1)
        debugBrain.debugPress(0)
        debugBrain.debugPress(0)

        XCTAssertEqual(debugBrain.left, "100")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.run("=")

        XCTAssertEqual(debugBrain.left, "109")
        XCTAssertEqual(debugBrain.right, nil)

        /// pi
        debugBrain.run("AC")
        debugBrain.run("π")
        correct = "3,14159265"

        XCTAssertEqual(debugBrain.left, correct)
        XCTAssertEqual(debugBrain.right, nil)

        /// 1+pi
        debugBrain.run("AC")
        debugBrain.debugPress(1)
        debugBrain.run("+")
        debugBrain.run("π")
        debugBrain.run("=")
        correct = "4,14159265"

        XCTAssertEqual(debugBrain.left, correct)
        XCTAssertEqual(debugBrain.right, nil)

        debugBrain.run("AC")
        debugBrain.run("π")
        debugBrain.run("x")
        debugBrain.debugPress(2)
        debugBrain.run("=")
        correct = "6,28318530"

        XCTAssertEqual(debugBrain.left, correct)
        XCTAssertEqual(debugBrain.right, nil)

        debugBrain.run("AC")
        debugBrain.debugPress(2)
        debugBrain.run("x^y")
        debugBrain.debugPress(1)
        debugBrain.debugPress(0)
        debugBrain.run("=")

        XCTAssertEqual(debugBrain.left, "1024")
        XCTAssertEqual(debugBrain.right, nil)

        debugBrain.run("AC")
        debugBrain.debugPress(1)
        debugBrain.debugPress(0)
        debugBrain.run("y^x")
        debugBrain.debugPress(2)
        debugBrain.run("=")
        //        XCTAssertEqual(debugBrain.debugLastGmp, Gmp("1024", precision: precision).getDisplayData(lengths)

        /// 2x(6+4)
        debugBrain.run("AC")
        debugBrain.debugPress(2)
        XCTAssertEqual(debugBrain.no, 0)
        debugBrain.run("x")
        XCTAssertEqual(debugBrain.no, 1)
        debugBrain.run("( ")
        XCTAssertEqual(debugBrain.no, 2)
        debugBrain.debugPress(6)

        XCTAssertEqual(debugBrain.left, "6")
        XCTAssertEqual(debugBrain.nn, 2)
        debugBrain.run("+")
        XCTAssertEqual(debugBrain.no, 3)
        debugBrain.debugPress(4)

        XCTAssertEqual(debugBrain.left, "4")
        XCTAssertEqual(debugBrain.nn, 3)
        debugBrain.run(" )")
        XCTAssertEqual(debugBrain.no, 1)
        XCTAssertEqual(debugBrain.nn, 2)
        //        XCTAssertEqual(debugBrain.debugLastGmp, Gmp("10", precision: precision).getDisplayData(lengths)
        debugBrain.run("=")
        //        XCTAssertEqual(debugBrain.debugLastGmp, Gmp("20", precision: precision).getDisplayData(lengths)

        XCTAssertEqual(debugBrain.left, "20")
        XCTAssertEqual(debugBrain.right, nil)

        /// 2x(6+4*(5+9))
        debugBrain.run("AC")
        debugBrain.debugPress(2)
        debugBrain.run("x")
        debugBrain.run("( ")
        debugBrain.debugPress(6)
        debugBrain.run("+")
        debugBrain.debugPress(4)
        debugBrain.run("x")
        debugBrain.run("( ")
        debugBrain.debugPress(5)
        debugBrain.run("+")
        debugBrain.debugPress(9)
        debugBrain.run(" )")
        debugBrain.run(" )")
        debugBrain.run("=")
        //        XCTAssertEqual(debugBrain.debugLastGmp, Gmp("124", precision: precision).getDisplayData(lengths)

        /// 1+2=3
        debugBrain.run("AC")
        debugBrain.debugPress(1)
        debugBrain.run("+")
        debugBrain.debugPress(2)
        debugBrain.run("=")
        debugBrain.debugPress(2)
        XCTAssertEqual(debugBrain.nn, 1)

        debugBrain.run("AC")
        debugBrain.run("π")
        //        XCTAssertEqual(debugBrain.debugLastDouble, 3.14159265358979, accuracy: 0.00000001)

        debugBrain.run("AC")
        debugBrain.debugPress(0)
        debugBrain.run(",")
        debugBrain.debugPress(0)
        debugBrain.debugPress(1)
        debugBrain.run("/")
        debugBrain.debugPress(1)
        debugBrain.run("EE")
        debugBrain.debugPress(4)
        debugBrain.run("=")
        //        XCTAssertEqual(debugBrain.debugLastDouble, 0.000001)

        debugBrain.run("AC")
        debugBrain.debugPress(8)
        debugBrain.debugPress(8)
        debugBrain.run("%")
        //        XCTAssertEqual(debugBrain.debugLastDouble, 0.88)

        debugBrain.run("AC")
        debugBrain.debugPress(4)
        debugBrain.debugPress(0)
        debugBrain.run("+")
        debugBrain.debugPress(1)
        debugBrain.debugPress(0)
        debugBrain.run("%")
        debugBrain.run("=")
        //        XCTAssertEqual(debugBrain.debugLastDouble, 44.0)
    }
    
    func _testSpeed1() throws {
        let debugBrain = DebugBrain(precision: 10_000_000)
        self.measure {
            let x = Number("88888888", precision: 10_000_000)
            x.toGmp()
        }
    }
    
    func _testSpeed2() throws {
        let debugBrain = DebugBrain(precision: 10_000_000)
        self.measure {
            let x = Number("888888888,8888888", precision: 10_000_000)
            x.toGmp()
        }
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
}
