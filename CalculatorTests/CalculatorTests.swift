//
//  CalculatorTests.swift
//  xxTests
//
//  Created by Joachim Neumann on 10/31/21.
//

import XCTest

@testable import Better_Calc

class CalculatorTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testmultipleLiner() {
//        let precision = 100
//        var displayData = DisplayData()
//        let lengths = Lengths(withoutComma: 8, withCommaNonScientific: 9, withCommaScientific: 9, height: 0, infoHeight: 0, ePadding: 0)
//
//        /// integers
//        displayData = Number("123", precision: precision).getDisplayData( lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "123")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("1234", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("12345", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "12345")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("12345", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "12345")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("12300", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "12300")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("12300", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "12300")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("123456", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "123456")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("123456", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "123456")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("1234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1234567")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("12345678", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "12345678")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("123456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,23456")
//        XCTAssertEqual(displayData.shortRight, "e8")
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("-123", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-123")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("-12345", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-12345")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("-123456", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-123456")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("-1234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-1234567")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("-12345678", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-1,2345")
//        XCTAssertEqual(displayData.shortRight, "e7")
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//
//        displayData = Number("1234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1234567")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("-1234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-1234567")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//
//        /// floating point numbers
//        displayData = Number("1,234", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("1,2345", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,2345")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("1,23456", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,23456")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("1,234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,234567")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("1,2345678", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,2345678")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("1,23456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,2345678")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue(displayData.shortAbbreviated)
//
//        displayData = Number("-1,234", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-1,234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("-1,2345", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-1,2345")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("-1,23456", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-1,23456")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("-1,234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-1,234567")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("-1,2345678", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-1,234567")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue(displayData.shortAbbreviated)
//
//
//        displayData = Number("1,234", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("1,234", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("1,234", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("1,234", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("1,234", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("1,234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,234567")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("1,2345678", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,2345678")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("1,23456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,2345678")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("-1,234", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-1,234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("-1,2345", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-1,2345")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("-1,23456", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-1,23456")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("-1,23456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-1,234567")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("-144,23456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-144,2345")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("1445,23456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1445,2345")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("14456,23456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "14456,234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("144567,23456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "144567,23")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("1445678,23456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1445678,2")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("14456785,23456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "14456785,")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("0,123", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,123")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("0,1234", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,1234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("0,12345", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,12345")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("0,123456", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,123456")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("0,1234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,1234567")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("0,12345678", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,1234567")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("0,000012", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,000012")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("0,000004", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,000004")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("0,0000123456", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,0000123")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("-0,000012", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-0,000012")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("-0,0000123", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-0,000012")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("-0,0000123456", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-0,000012")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("-0,123", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-0,123")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("-0,1234", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-0,1234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("-0,12345", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-0,12345")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("-0,123456", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-0,123456")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("-0,1234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-0,123456")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue(displayData.shortAbbreviated)
//
//        displayData = Number("14456789,23456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "14456789,")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("-144567,23456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-144567,2")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("-1445678,23456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-1445678,")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("1445678,23456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1445678,2")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("0,0123", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,0123")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("0,01234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,0123456")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("0,0012", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,0012")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("-0,0012", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-0,0012")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("0,001234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,0012345")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("-0,001234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-0,001234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("0,0001234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,0001234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("-0,0001234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-0,000123")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("0,00001234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,0000123")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("-0,00001234567", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-0,000012")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("0,12345678", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,1234567")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        /// scientific notation
//
//        displayData = Number("1,5e12", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,5")
//        XCTAssertEqual(displayData.shortRight, "e12")
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("1,5e12", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,5")
//        XCTAssertEqual(displayData.shortRight, "e12")
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("0,00000004", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "4,0")
//        XCTAssertEqual(displayData.shortRight, "e-8")
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("0,0000004", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,0000004")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse( displayData.shortAbbreviated)
//
//        displayData = Number("12345678349875349873", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,2345")
//        XCTAssertEqual(displayData.shortRight, "e19")
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("123456783498753498731", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,2345")
//        XCTAssertEqual(displayData.shortRight, "e20")
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("0,012345678", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,0123456")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("0,0012345678", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,0012345")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("-1445,23456789", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "-1445,234")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("921387491237419283092340238420398423098423049874129837649128364519234875", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "9,2138")
//        XCTAssertEqual(displayData.shortRight, "e71")
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("1,23", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,23")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("1,23", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,23")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("0,0023", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "0,0023")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("0,000000000023", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "2,3")
//        XCTAssertEqual(displayData.shortRight, "e-11")
//        XCTAssertFalse(displayData.shortAbbreviated)
//
//        displayData = Number("0,0000000000232837642876", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "2,328")
//        XCTAssertEqual(displayData.shortRight, "e-11")
//        XCTAssertTrue( displayData.shortAbbreviated)
//
//        displayData = Number("0,0000000000232837642876239827342", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "2,328")
//        XCTAssertEqual(displayData.shortRight, "e-11")
//        XCTAssertTrue( displayData.shortAbbreviated)
    }
    
    func test() {
//        let brain = Brain(precision: 100)
//        var displayData = DisplayData(shortLeft: "0", shortAbbreviated: false, longLeft: "0", longAbbreviated: false)
//        let lengths = Lengths(10)
////
////        /// 1
////
//        brain.operation("AC")
//        brain.operation("2")
//        displayData = brain.last.getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "2")
//        XCTAssertNil(  displayData.shortRight)
//        XCTAssertFalse( displayData.shortAbbreviated)
//        brain.operation("√")
//        displayData = brain.last.getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(displayData.shortLeft, "1,41421356")

        
        
        
        
        
        
//
//        /// 0
//        brain.nonWaitingOperation("AC")
//        XCTAssertEqual(brain.nonScientific, "0")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(0)
//        XCTAssertEqual(brain.nonScientific, "0")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(0)
//        XCTAssertEqual(brain.nonScientific, "0")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        
//        
//        // 12
//        brain.nonWaitingOperation("AC")
//        brain.press(1)
//        brain.press(2)
//        XCTAssertEqual(brain.nonScientific, "12")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        // 01
//        brain.nonWaitingOperation("AC")
//        XCTAssertEqual(brain.nonScientific, "0")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(0)
//        XCTAssertEqual(brain.nonScientific, "0")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(1)
//        XCTAssertEqual(brain.nonScientific, "1")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        /// 123456789012345678
//        brain.nonWaitingOperation("AC")
//        brain.press("12345678901234567")
//        XCTAssertEqual(brain.nonScientific, "12345678901234567")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(8)
//        XCTAssertEqual(brain.nonScientific, "123456789012345678")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(9)
//        XCTAssertEqual(brain.nonScientific, "1234567890123456789")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(0)
//        XCTAssertEqual(brain.nonScientific, nil)
//        XCTAssertEqual(brain.scientific, DisplayData.Scientific("1,234567890123456789", "e19", precision: precision).getDisplayData(lengths, forceScientific: false)
//        
//        
//        /// -12345678901234
//        brain.nonWaitingOperation("AC")
//        brain.press("12345678901234")
//        brain.nonWaitingOperation("±")
//        XCTAssertEqual(brain.nonScientific, "-12345678901234")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        
//        /// 77777777777777777
//        brain.nonWaitingOperation("AC")
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        XCTAssertEqual(brain.nonScientific, "777777777")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        brain.press(7)
//        XCTAssertEqual(brain.nonScientific, nil)
//        XCTAssertEqual(brain.scientific, DisplayData.Scientific("7,7777777777777777777777", "e22", precision: precision).getDisplayData(lengths, forceScientific: false)
//        
//        
//        
//        /// -123456789012345
//        brain.nonWaitingOperation("AC")
//        brain.press(1)
//        brain.press(2)
//        brain.press(3)
//        brain.press(4)
//        brain.press(5)
//        brain.press(6)
//        brain.press(7)
//        brain.press(8)
//        brain.press(9)
//        brain.press(0)
//        brain.press(1)
//        brain.press(2)
//        brain.press(3)
//        brain.press(4)
//        brain.press(5)
//        brain.nonWaitingOperation("±")
//        XCTAssertEqual(brain.nonScientific, "-123456789012345")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        
//        /// ±
//        brain.nonWaitingOperation("AC")
//        brain.press(7)
//        XCTAssertEqual(brain.nonScientific, "7")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("±")
//        XCTAssertEqual(brain.nonScientific, "-7")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        /// 0,
//        brain.nonWaitingOperation("AC")
//        brain.nonWaitingOperation(",")
//        XCTAssertEqual(brain.nonScientific, "0,")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation(",")
//        XCTAssertEqual(brain.nonScientific, "0,")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        /// -0,7
//        brain.nonWaitingOperation("AC")
//        brain.nonWaitingOperation(",")
//        XCTAssertEqual(brain.nonScientific, "0,")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(7)
//        XCTAssertEqual(brain.nonScientific, "0,7")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("±")
//        XCTAssertEqual(brain.nonScientific, "-0,7")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        /// 3 e6
//        brain.nonWaitingOperation("AC")
//        brain.press(3)
//        brain.nonWaitingOperation("EE")
//        brain.press(6)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.nonScientific, "3000000")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        /// 3 e6 + 0.01
//        brain.nonWaitingOperation("AC")
//        brain.press(3)
//        brain.nonWaitingOperation("EE")
//        brain.press(6)
//        brain.nonWaitingOperation("=")
//        brain.nonWaitingOperation("+")
//        brain.nonWaitingOperation(",")
//        brain.press(0)
//        brain.press(0)
//        brain.press(1)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.nonScientific, "3000000,001")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        
//        /// 3 e77
//        brain.nonWaitingOperation("AC")
//        brain.press(3)
//        brain.nonWaitingOperation("EE")
//        brain.press(7)
//        brain.press(7)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.nonScientific, nil)
//        XCTAssertEqual(brain.scientific, DisplayData.Scientific("3,0", "e77", precision: precision).getDisplayData(lengths, forceScientific: false)
//        
//        /// 3 e-77
//        brain.nonWaitingOperation("AC")
//        brain.press(3)
//        brain.nonWaitingOperation("EE")
//        brain.press(7)
//        brain.press(7)
//        brain.nonWaitingOperation("±")
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.nonScientific, nil)
//        XCTAssertEqual(brain.scientific, DisplayData.Scientific("3,0", "e-77", precision: precision).getDisplayData(lengths, forceScientific: false)
//        
//        /// -3 e-77
//        brain.nonWaitingOperation("AC")
//        brain.press(3)
//        brain.nonWaitingOperation("EE")
//        brain.press(7)
//        brain.press(7)
//        brain.nonWaitingOperation("±")
//        brain.nonWaitingOperation("=")
//        brain.nonWaitingOperation("±")
//        XCTAssertEqual(brain.nonScientific, nil)
//        XCTAssertEqual(brain.scientific, DisplayData.Scientific("-3,0", "e-77", precision: precision).getDisplayData(lengths, forceScientific: false)
//        
//        /// -3 e-77
//        brain.nonWaitingOperation("AC")
//        brain.press(3)
//        brain.nonWaitingOperation("±")
//        brain.nonWaitingOperation("EE")
//        brain.press(7)
//        brain.press(7)
//        brain.nonWaitingOperation("±")
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.nonScientific, nil)
//        XCTAssertEqual(brain.scientific, DisplayData.Scientific("-3,0", "e-77", precision: precision).getDisplayData(lengths, forceScientific: false)
//        
//        
//        /// 8888888
//        brain.nonWaitingOperation("AC")
//        brain.press(8)
//        brain.press(8)
//        brain.press(8)
//        brain.press(8)
//        brain.press(8)
//        brain.press(8)
//        brain.press(8)
//        XCTAssertEqual(brain.nonScientific, "8888888")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        
//        /// memory
//        brain.nonWaitingOperation("AC")
//        brain.press(1)
//        brain.press(2)
//        XCTAssertEqual(brain.nonScientific, "12")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("mc")
//        XCTAssertEqual(brain.nonScientific, "12")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("m+")
//        XCTAssertEqual(brain.nonScientific, "12")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("m+")
//        XCTAssertEqual(brain.nonScientific, "12")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("mr")
//        XCTAssertEqual(brain.nonScientific, "24")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("m-")
//        XCTAssertEqual(brain.nonScientific, "24")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("mr")
//        XCTAssertEqual(brain.nonScientific, "0")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        /// 0,0000010
//        brain.nonWaitingOperation("AC")
//        brain.press(0)
//        XCTAssertEqual(brain.nonScientific, "0")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation(",")
//        XCTAssertEqual(brain.nonScientific, "0,")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(0)
//        XCTAssertEqual(brain.nonScientific, "0,0")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(0)
//        brain.press(0)
//        brain.press(0)
//        brain.press(0)
//        XCTAssertEqual(brain.nonScientific, "0,00000")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(1)
//        XCTAssertEqual(brain.nonScientific, "0,000001")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(0)
//        XCTAssertEqual(brain.nonScientific, "0,0000010")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        /// 1 e -15
//        brain.nonWaitingOperation("AC")
//        brain.nonWaitingOperation(",")
//        res = "0,"
//        for _ in 1..<digits-1 {
//            res += "0"
//            brain.press(0)
//            XCTAssertEqual(brain.nonScientific, res)
//            XCTAssertEqual(brain.scientific, nil)
//        }
//        brain.press(1)
//        XCTAssertEqual(brain.nonScientific, "0,000000000000001")
//        XCTAssertEqual(brain.nonScientific, res+"1")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        /// 32456.2244
//        brain.nonWaitingOperation("AC")
//        brain.press(3)
//        brain.press(2)
//        brain.press(4)
//        brain.press(5)
//        brain.press(6)
//        brain.nonWaitingOperation(",")
//        brain.press(2)
//        brain.press(2)
//        brain.press(4)
//        brain.press(4)
//        res = "32456,2244"
//        sci = "3,24562244"
//        XCTAssertEqual(brain.nonScientific, res)
//        XCTAssertEqual(brain.scientific, nil)
//        
//        
//        /// 32456.224433333333333333333333333
//        for _ in res.count..<digits+20 {
//            brain.press(3)
//            res += "3"
//            sci += "3"
//            XCTAssertEqual(brain.nonScientific, res)
//            XCTAssertEqual(brain.scientific, nil)
//        }
//        
//        /// 1/7*7 --> has more digits?
//        brain.nonWaitingOperation("AC")
//        brain.press(7)
//        brain.nonWaitingOperation("One_x")
//        brain.nonWaitingOperation("x")
//        brain.press(7)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.nonScientific, "1")
//        XCTAssertEqual(brain.scientific, nil)
//
//        /// -1/3
//        brain.nonWaitingOperation("AC")
//        brain.press(3)
//        brain.nonWaitingOperation("One_x")
//        correct = "0,3333333333333333"
//        res = brain.nonScientific!
//        resTruncated = String(res.prefix(correct.count))
//        XCTAssertEqual (resTruncated, correct)
//        brain.nonWaitingOperation("±")
//        correct = "-0,3333333333333333"
//        res = brain.nonScientific!
//        resTruncated = String(res.prefix(correct.count))
//        XCTAssertEqual (resTruncated, correct)
//
//        /// 9 %%%% ^2 ^2 ^2
//        brain.nonWaitingOperation("AC")
//        brain.press(9)
//        brain.nonWaitingOperation("%")
//        XCTAssertEqual(brain.nonScientific, "0,09")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("%")
//        XCTAssertEqual(brain.nonScientific, "0,0009")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("%")
//        brain.nonWaitingOperation("%")
//        XCTAssertEqual(brain.nonScientific, "0,00000009")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("x^2")
//        XCTAssertEqual(brain.nonScientific, "0,0000000000000081")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        
//        /// 1/10 and 1/16
//        brain.nonWaitingOperation("AC")
//        brain.press(1)
//        brain.press(0)
//        XCTAssertEqual(brain.nonScientific, "10")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("One_x")
//        XCTAssertEqual(brain.nonScientific, "0,1")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(1)
//        brain.press(6)
//        XCTAssertEqual(brain.nonScientific, "16")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("One_x")
//        XCTAssertEqual(brain.debugLastDouble, 0.0625)
//        XCTAssertEqual(brain.nonScientific, "0,0625")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        /// 1+2+5+2= + 1/4 =
//        brain.press(1)
//        brain.nonWaitingOperation("+")
//        brain.press(2)
//        brain.nonWaitingOperation("+")
//        XCTAssertEqual(brain.nonScientific, "3")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(5)
//        brain.nonWaitingOperation("+")
//        XCTAssertEqual(brain.nonScientific, "8")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(2)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.nonScientific, "10")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("+")
//        XCTAssertEqual(brain.nonScientific, "10")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(4)
//        brain.nonWaitingOperation("One_x")
//        XCTAssertEqual(brain.nonScientific, "0,25")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.nonScientific, "10,25")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        /// 1+2*4=
//        brain.nonWaitingOperation("AC")
//        brain.press(1)
//        XCTAssertEqual(brain.nonScientific, "1")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("+")
//        brain.press(2)
//        brain.nonWaitingOperation("x")
//        XCTAssertEqual(brain.nonScientific, "2")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(4)
//        XCTAssertEqual(brain.nonScientific, "4")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.nonScientific, "9")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        /// 2*3*4*5=
//        brain.nonWaitingOperation("AC")
//        brain.press(2)
//        brain.nonWaitingOperation("x")
//        brain.press(3)
//        brain.nonWaitingOperation("x")
//        brain.press(4)
//        brain.nonWaitingOperation("x")
//        XCTAssertEqual(brain.nonScientific, "24")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(5)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.nonScientific, "120")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        /// 1+2*4
//        brain.nonWaitingOperation("AC")
//        brain.press(1)
//        brain.nonWaitingOperation("+")
//        brain.press(2)
//        brain.nonWaitingOperation("x")
//        XCTAssertEqual(brain.nonScientific, "2")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(4)
//        XCTAssertEqual(brain.nonScientific, "4")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("+")
//        XCTAssertEqual(brain.nonScientific, "9")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.press(1)
//        brain.press(0)
//        brain.press(0)
//        XCTAssertEqual(brain.nonScientific, "100")
//        XCTAssertEqual(brain.scientific, nil)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.nonScientific, "109")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        /// pi
//        brain.nonWaitingOperation("AC")
//        brain.nonWaitingOperation("π")
//        correct = "3,1415926535897932384626433832795028841971"
//        XCTAssertEqual(brain.debugLastDouble, Double.pi)
//        res = brain.nonScientific!
//        resTruncated = String(res.prefix(correct.count))
//        XCTAssertEqual (resTruncated, correct)
//        
//        /// 1+pi
//        brain.nonWaitingOperation("AC")
//        brain.press(1)
//        brain.nonWaitingOperation("+")
//        brain.nonWaitingOperation("π")
//        brain.nonWaitingOperation("=")
//        correct = "4,1415926535897932384626433832795028841971"
//        XCTAssertEqual(brain.debugLastDouble, 1.0+Double.pi)
//        res = brain.nonScientific!
//        resTruncated = String(res.prefix(correct.count))
//        XCTAssertEqual (resTruncated, correct)
//        
//        brain.nonWaitingOperation("AC")
//        brain.nonWaitingOperation("π")
//        brain.nonWaitingOperation("x")
//        brain.press(2)
//        brain.nonWaitingOperation("=")
//        
//        
//        correct = String("6,28318530717958647692528676655900576839433879875021164194988918461563281257241799725606965068423413596429617302656461329418768921910116446345".prefix(100))
//        XCTAssertEqual(brain.debugLastDouble, 2.0*Double.pi)
//        res = brain.nonScientific!
//        resTruncated = String(res.prefix(100))
//        XCTAssertEqual (resTruncated, correct)
//        
//        brain.nonWaitingOperation("AC")
//        brain.press(2)
//        brain.nonWaitingOperation("x^y")
//        brain.press(1)
//        brain.press(0)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.debugLastGmp, Gmp("1024", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(brain.nonScientific, "1024")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        brain.nonWaitingOperation("AC")
//        brain.press(1)
//        brain.press(0)
//        brain.nonWaitingOperation("y^x")
//        brain.press(2)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.debugLastGmp, Gmp("1024", precision: precision).getDisplayData(lengths, forceScientific: false)
//        
//        /// 2x(6+4)
//        brain.nonWaitingOperation("AC")
//        brain.press(2)
//        XCTAssertEqual(brain.no, 0)
//        brain.nonWaitingOperation("x")
//        XCTAssertEqual(brain.no, 1)
//        brain.nonWaitingOperation("(")
//        XCTAssertEqual(brain.no, 2)
//        brain.press(6)
//        XCTAssertEqual(brain.nonScientific, "6")
//        XCTAssertEqual(brain.nn, 2)
//        brain.nonWaitingOperation("+")
//        XCTAssertEqual(brain.no, 3)
//        brain.press(4)
//        XCTAssertEqual(brain.nonScientific, "4")
//        XCTAssertEqual(brain.nn, 3)
//        brain.nonWaitingOperation(")")
//        XCTAssertEqual(brain.no, 1)
//        XCTAssertEqual(brain.nn, 2)
//        XCTAssertEqual(brain.debugLastGmp, Gmp("10", precision: precision).getDisplayData(lengths, forceScientific: false)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.debugLastGmp, Gmp("20", precision: precision).getDisplayData(lengths, forceScientific: false)
//        XCTAssertEqual(brain.nonScientific, "20")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        /// 2x(6+4*(5+9))
//        brain.nonWaitingOperation("AC")
//        brain.press(2)
//        brain.nonWaitingOperation("x")
//        brain.nonWaitingOperation("(")
//        brain.press(6)
//        brain.nonWaitingOperation("+")
//        brain.press(4)
//        brain.nonWaitingOperation("x")
//        brain.nonWaitingOperation("(")
//        brain.press(5)
//        brain.nonWaitingOperation("+")
//        brain.press(9)
//        brain.nonWaitingOperation(")")
//        brain.nonWaitingOperation(")")
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.debugLastGmp, Gmp("124", precision: precision).getDisplayData(lengths, forceScientific: false)
//        
//        /// 1+2=3
//        brain.nonWaitingOperation("AC")
//        brain.press(1)
//        brain.nonWaitingOperation("+")
//        brain.press(2)
//        brain.nonWaitingOperation("=")
//        brain.press(2)
//        XCTAssertEqual(brain.nn, 1)
//        
//        brain.nonWaitingOperation("AC")
//        brain.nonWaitingOperation("π")
//        XCTAssertEqual(brain.debugLastDouble, 3.14159265358979, accuracy: 0.00000001)
//        
//        brain.nonWaitingOperation("AC")
//        brain.press(0)
//        brain.nonWaitingOperation(",")
//        brain.press(0)
//        brain.press(1)
//        brain.nonWaitingOperation("/")
//        brain.press(1)
//        brain.nonWaitingOperation("EE")
//        brain.press(4)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.debugLastDouble, 0.000001)
//        
//        brain.nonWaitingOperation("AC")
//        brain.press(8)
//        brain.press(8)
//        brain.nonWaitingOperation("%")
//        XCTAssertEqual(brain.debugLastDouble, 0.88)
//        
//        brain.nonWaitingOperation("AC")
//        brain.press(4)
//        brain.press(0)
//        brain.nonWaitingOperation("+")
//        brain.press(1)
//        brain.press(0)
//        brain.nonWaitingOperation("%")
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.debugLastDouble, 44.0)
    }
    
    func XXtestPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
