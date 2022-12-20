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
        let precision = 100
        var displayData = DisplayData()
        let lengths = Lengths(withoutComma: 8, withCommaNonScientific: 9, withCommaScientific: 9, height: 0, infoHeight: 0, ePadding: 0)

        /// integers
        displayData = Number("123", precision: precision).getDisplayData(lengths)
        
        
        XCTAssertEqual(displayData.left, "123")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("1234", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1234")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("12345", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "12345")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("12345", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "12345")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("12300", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "12300")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("12300", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "12300")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("123456", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "123456")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("123456", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "123456")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("1234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1234567")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("12345678", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "12345678")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("123456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,23456")
        XCTAssertEqual(displayData.right, "e8")
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("-123", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-123")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("-12345", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-12345")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("-123456", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-123456")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("-1234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-1234567")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("-12345678", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-1,2345")
        XCTAssertEqual(displayData.right, "e7")
        XCTAssertTrue( displayData.isAbbreviated)


        displayData = Number("1234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1234567")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("-1234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-1234567")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)


        /// floating point numbers
        displayData = Number("1,234", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,234")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("1,2345", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,2345")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("1,23456", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,23456")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("1,234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,234567")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("1,2345678", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,2345678")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("1,23456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,2345678")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue(displayData.isAbbreviated)

        displayData = Number("-1,234", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-1,234")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("-1,2345", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-1,2345")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("-1,23456", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-1,23456")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("-1,234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-1,234567")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("-1,2345678", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-1,234567")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue(displayData.isAbbreviated)


        displayData = Number("1,234", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,234")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("1,234", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,234")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("1,234", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,234")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("1,234", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,234")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("1,234", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,234")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("1,234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,234567")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("1,2345678", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,2345678")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("1,23456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,2345678")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("-1,234", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-1,234")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("-1,2345", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-1,2345")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("-1,23456", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-1,23456")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("-1,23456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-1,234567")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("-144,23456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-144,2345")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("1445,23456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1445,2345")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("14456,23456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "14456,234")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("144567,23456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "144567,23")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("1445678,23456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1445678,2")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("14456785,23456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "14456785,")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("0,123", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,123")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("0,1234", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,1234")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("0,12345", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,12345")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("0,123456", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,123456")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("0,1234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,1234567")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("0,12345678", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,1234567")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("0,000012", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,000012")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("0,000004", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,000004")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("0,0000123456", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0000123")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("-0,000012", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-0,000012")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("-0,0000123", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-0,000012")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("-0,0000123456", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-0,000012")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("-0,123", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-0,123")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("-0,1234", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-0,1234")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("-0,12345", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-0,12345")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("-0,123456", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-0,123456")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("-0,1234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-0,123456")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue(displayData.isAbbreviated)

        displayData = Number("14456789,23456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "14456789,")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("-144567,23456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-144567,2")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("-1445678,23456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-1445678,")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("1445678,23456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1445678,2")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("0,0123", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0123")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("0,01234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0123456")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("0,0012", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0012")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("-0,0012", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-0,0012")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("0,001234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0012345")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("-0,001234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-0,001234")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("0,0001234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0001234")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("-0,0001234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-0,000123")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("0,00001234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0000123")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("-0,00001234567", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-0,000012")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("0,12345678", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,1234567")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        /// scientific notation

        displayData = Number("1,5e12", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,5")
        XCTAssertEqual(displayData.right, "e12")
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("1,5e12", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,5")
        XCTAssertEqual(displayData.right, "e12")
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("0,00000004", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "4,0")
        XCTAssertEqual(displayData.right, "e-8")
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("0,0000004", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0000004")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse( displayData.isAbbreviated)

        displayData = Number("12345678349875349873", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,2345")
        XCTAssertEqual(displayData.right, "e19")
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("123456783498753498731", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,2345")
        XCTAssertEqual(displayData.right, "e20")
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("0,012345678", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0123456")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("0,0012345678", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0012345")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("-1445,23456789", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-1445,234")
        XCTAssertNil(  displayData.right)
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("921387491237419283092340238420398423098423049874129837649128364519234875", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "9,2138")
        XCTAssertEqual(displayData.right, "e71")
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("1,23", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,23")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("1,23", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,23")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("0,0023", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0023")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("0,000000000023", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "2,3")
        XCTAssertEqual(displayData.right, "e-11")
        XCTAssertFalse(displayData.isAbbreviated)

        displayData = Number("0,0000000000232837642876", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "2,328")
        XCTAssertEqual(displayData.right, "e-11")
        XCTAssertTrue( displayData.isAbbreviated)

        displayData = Number("0,0000000000232837642876239827342", precision: precision).getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "2,328")
        XCTAssertEqual(displayData.right, "e-11")
        XCTAssertTrue( displayData.isAbbreviated)
    }
    
    func test() {
        let brain = Brain(precision: 100)
        let lengths = Lengths(10)
        var displayData: DisplayData

        /// 1
        brain.operation("AC")
        brain.operation("2")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "2")
        XCTAssertNil(  displayData.right)
        XCTAssertFalse( displayData.isAbbreviated)
        brain.operation("√")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,41421356")
        

        /// 0
        brain.operation("AC")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(0)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(0)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0")
        XCTAssertEqual(displayData.right, nil)
        
        
        // 12
        brain.operation("AC")
        brain.debugPress(1)
        brain.debugPress(2)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "12")
        XCTAssertEqual(displayData.right, nil)
        
        // 01
        brain.operation("AC")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(0)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(1)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1")
        XCTAssertEqual(displayData.right, nil)
        
        /// 1234567890
        brain.operation("AC")
        brain.debugPress("1234567890")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1234567890")
        XCTAssertEqual(displayData.right, nil)

        /// 1234567891
        brain.operation("AC")
        brain.debugPress("12345678901")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,23456")
        XCTAssertEqual(displayData.right, "e10")

        /// 123456789012345678
        brain.operation("AC")
        brain.debugPress("12345678901234567")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,23456")
        XCTAssertEqual(displayData.right, "e16")
        brain.debugPress(8)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1,23456")
        XCTAssertEqual(displayData.right, "e17")
        
        
        /// -12345678901234
        brain.operation("AC")
        brain.debugPress("123456789")
        brain.operation("±")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-123456789")
        XCTAssertEqual(displayData.right, nil)
        
        
        /// 77777777777777777
        brain.operation("AC")
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "777777777")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        brain.debugPress(7)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "7,77777")
        XCTAssertEqual(displayData.right, "e22")
        
        
        
        /// -123456789012345
        brain.operation("AC")
        brain.debugPress(1)
        brain.debugPress(2)
        brain.debugPress(3)
        brain.debugPress(4)
        brain.debugPress(5)
        brain.debugPress(6)
        brain.debugPress(7)
        brain.debugPress(8)
        brain.debugPress(9)
        brain.operation("±")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-123456789")
        XCTAssertEqual(displayData.right, nil)
        
        
        /// ±
        brain.operation("AC")
        brain.debugPress(7)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "7")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("±")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-7")
        XCTAssertEqual(displayData.right, nil)
        
        /// 0,
        brain.operation("AC")
        brain.operation(",")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,")
        XCTAssertEqual(displayData.right, nil)
        brain.operation(",")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,")
        XCTAssertEqual(displayData.right, nil)
        
        /// -0,7
        brain.operation("AC")
        brain.operation(",")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(7)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,7")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("±")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-0,7")
        XCTAssertEqual(displayData.right, nil)
        
        /// 3 e6
        brain.operation("AC")
        brain.debugPress(3)
        brain.operation("EE")
        brain.debugPress(6)
        brain.operation("=")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "3000000")
        XCTAssertEqual(displayData.right, nil)
        
        /// 3 e6 + 0.01
        brain.operation("AC")
        brain.debugPress(3)
        brain.operation("EE")
        brain.debugPress(5)
        brain.operation("=")
        brain.operation("+")
        brain.operation(",")
        brain.debugPress(0)
        brain.debugPress(0)
        brain.debugPress(1)
        brain.operation("=")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "300000,001")
        XCTAssertEqual(displayData.right, nil)


        /// 3 e77
        brain.operation("AC")
        brain.debugPress(3)
        brain.operation("EE")
        brain.debugPress(7)
        brain.debugPress(7)
        brain.operation("=")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "3,0")
        XCTAssertEqual(displayData.right, "e77")

        /// 3 e-77
        brain.operation("AC")
        brain.debugPress(3)
        brain.operation("EE")
        brain.debugPress(7)
        brain.debugPress(7)
        brain.operation("±")
        brain.operation("=")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "3,0")
        XCTAssertEqual(displayData.right, "e-77")

        /// -3 e-77
        brain.operation("AC")
        brain.debugPress(3)
        brain.operation("EE")
        brain.debugPress(7)
        brain.debugPress(7)
        brain.operation("±")
        brain.operation("=")
        brain.operation("±")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-3,0")
        XCTAssertEqual(displayData.right, "e-77")

        /// -3 e-77
        brain.operation("AC")
        brain.debugPress(3)
        brain.operation("±")
        brain.operation("EE")
        brain.debugPress(7)
        brain.debugPress(7)
        brain.operation("±")
        brain.operation("=")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "-3,0")
        XCTAssertEqual(displayData.right, "e-77")


        /// 8888888
        brain.operation("AC")
        brain.debugPress(8)
        brain.debugPress(8)
        brain.debugPress(8)
        brain.debugPress(8)
        brain.debugPress(8)
        brain.debugPress(8)
        brain.debugPress(8)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "8888888")
        XCTAssertEqual(displayData.right, nil)


        /// memory
        brain.operation("AC")
        brain.debugPress(1)
        brain.debugPress(2)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "12")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("mc")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "12")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("m+")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "12")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("m+")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "12")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("mr")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "24")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("m-")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("mr")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0")
        XCTAssertEqual(displayData.right, nil)

        /// 0,0000010
        brain.operation("AC")
        brain.debugPress(0)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0")
        XCTAssertEqual(displayData.right, nil)
        brain.operation(",")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(0)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(0)
        brain.debugPress(0)
        brain.debugPress(0)
        brain.debugPress(0)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,00000")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(1)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,000001")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(0)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0000010")
        XCTAssertEqual(displayData.right, nil)


        var res: String
        let digits = 5

        /// 1 e -15
        brain.operation("AC")
        brain.operation(",")
        res = "0,"
        for _ in 1..<digits-1 {
            res += "0"
            brain.debugPress(0)
            displayData = brain.last.getDisplayData(lengths)
            XCTAssertEqual(displayData.left, res)
            XCTAssertEqual(displayData.right, nil)
        }
        brain.debugPress(1)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0001")
        XCTAssertEqual(displayData.left, res+"1")
        XCTAssertEqual(displayData.right, nil)

        /// 32456.2244
        brain.operation("AC")
        brain.debugPress(3)
        brain.debugPress(2)
        brain.debugPress(4)
        brain.debugPress(5)
        brain.debugPress(6)
        brain.operation(",")
        brain.debugPress(2)
        brain.debugPress(2)
        brain.debugPress(4)
        res = "32456,224"
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, res)
        XCTAssertEqual(displayData.right, nil)


        /// 32456.224433
        brain.debugPress(3)
        res += "3"
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, res)
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(3)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, res)
        XCTAssertEqual(displayData.right, nil)

        /// 1/7*7 --> has more digits?
        brain.operation("AC")
        brain.debugPress(7)
        brain.operation("One_x")
        brain.operation("x")
        brain.debugPress(7)
        brain.operation("=")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1")
        XCTAssertEqual(displayData.right, nil)

        /// -1/3
        brain.operation("AC")
        brain.debugPress(3)
        brain.operation("One_x")
        var correct = "0,33333333"
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual (displayData.left, correct)
        brain.operation("±")
        correct = "-0,3333333"
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual (displayData.left, correct)

        /// 9 %%%% ^2 ^2 ^2
        brain.operation("AC")
        brain.operation("9")
        brain.operation("%")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,09")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("%")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0009")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("%")
        brain.operation("%")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,00000009")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("x^2")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "8,1")
        XCTAssertEqual(displayData.right, "e-15")


        /// 1/10 and 1/16
        brain.operation("AC")
        brain.debugPress(1)
        brain.debugPress(0)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "10")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("One_x")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,1")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(1)
        brain.debugPress(6)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "16")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("One_x")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,0625")
        XCTAssertEqual(displayData.right, nil)

        /// 1+2+5+2= + 1/4 =
        brain.debugPress(1)
        brain.operation("+")
        brain.debugPress(2)
        brain.operation("+")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "3")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(5)
        brain.operation("+")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "8")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(2)
        brain.operation("=")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "10")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("+")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "10")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(4)
        brain.operation("One_x")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "0,25")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("=")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "10,25")
        XCTAssertEqual(displayData.right, nil)

        /// 1+2*4=
        brain.operation("AC")
        brain.debugPress(1)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("+")
        brain.debugPress(2)
        brain.operation("x")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "2")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(4)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "4")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("=")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "9")
        XCTAssertEqual(displayData.right, nil)

        /// 2*3*4*5=
        brain.operation("AC")
        brain.debugPress(2)
        brain.operation("x")
        brain.debugPress(3)
        brain.operation("x")
        brain.debugPress(4)
        brain.operation("x")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "24")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(5)
        brain.operation("=")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "120")
        XCTAssertEqual(displayData.right, nil)

        /// 1+2*4
        brain.operation("AC")
        brain.debugPress(1)
        brain.operation("+")
        brain.debugPress(2)
        brain.operation("x")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "2")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(4)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "4")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("+")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "9")
        XCTAssertEqual(displayData.right, nil)
        brain.debugPress(1)
        brain.debugPress(0)
        brain.debugPress(0)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "100")
        XCTAssertEqual(displayData.right, nil)
        brain.operation("=")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "109")
        XCTAssertEqual(displayData.right, nil)

        /// pi
        brain.operation("AC")
        brain.operation("π")
        correct = "3,14159265"
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, correct)
        XCTAssertEqual(displayData.right, nil)

        /// 1+pi
        brain.operation("AC")
        brain.debugPress(1)
        brain.operation("+")
        brain.operation("π")
        brain.operation("=")
        correct = "4,14159265"
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, correct)
        XCTAssertEqual(displayData.right, nil)

        brain.operation("AC")
        brain.operation("π")
        brain.operation("x")
        brain.debugPress(2)
        brain.operation("=")
        correct = "6,28318530"
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, correct)
        XCTAssertEqual(displayData.right, nil)

        brain.operation("AC")
        brain.debugPress(2)
        brain.operation("x^y")
        brain.debugPress(1)
        brain.debugPress(0)
        brain.operation("=")
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "1024")
        XCTAssertEqual(displayData.right, nil)

        brain.operation("AC")
        brain.debugPress(1)
        brain.debugPress(0)
        brain.operation("y^x")
        brain.debugPress(2)
        brain.operation("=")
//        XCTAssertEqual(brain.debugLastGmp, Gmp("1024", precision: precision).getDisplayData(lengths)

        /// 2x(6+4)
        brain.operation("AC")
        brain.debugPress(2)
        XCTAssertEqual(brain.no, 0)
        brain.operation("x")
        XCTAssertEqual(brain.no, 1)
        brain.operation("( ")
        XCTAssertEqual(brain.no, 2)
        brain.debugPress(6)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "6")
        XCTAssertEqual(brain.nn, 2)
        brain.operation("+")
        XCTAssertEqual(brain.no, 3)
        brain.debugPress(4)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "4")
        XCTAssertEqual(brain.nn, 3)
        brain.operation(" )")
        XCTAssertEqual(brain.no, 1)
        XCTAssertEqual(brain.nn, 2)
//        XCTAssertEqual(brain.debugLastGmp, Gmp("10", precision: precision).getDisplayData(lengths)
        brain.operation("=")
//        XCTAssertEqual(brain.debugLastGmp, Gmp("20", precision: precision).getDisplayData(lengths)
        displayData = brain.last.getDisplayData(lengths)
        XCTAssertEqual(displayData.left, "20")
        XCTAssertEqual(displayData.right, nil)

        /// 2x(6+4*(5+9))
        brain.operation("AC")
        brain.debugPress(2)
        brain.operation("x")
        brain.operation("( ")
        brain.debugPress(6)
        brain.operation("+")
        brain.debugPress(4)
        brain.operation("x")
        brain.operation("( ")
        brain.debugPress(5)
        brain.operation("+")
        brain.debugPress(9)
        brain.operation(" )")
        brain.operation(" )")
        brain.operation("=")
//        XCTAssertEqual(brain.debugLastGmp, Gmp("124", precision: precision).getDisplayData(lengths)

        /// 1+2=3
        brain.operation("AC")
        brain.debugPress(1)
        brain.operation("+")
        brain.debugPress(2)
        brain.operation("=")
        brain.debugPress(2)
        XCTAssertEqual(brain.nn, 1)

        brain.operation("AC")
        brain.operation("π")
//        XCTAssertEqual(brain.debugLastDouble, 3.14159265358979, accuracy: 0.00000001)

        brain.operation("AC")
        brain.debugPress(0)
        brain.operation(",")
        brain.debugPress(0)
        brain.debugPress(1)
        brain.operation("/")
        brain.debugPress(1)
        brain.operation("EE")
        brain.debugPress(4)
        brain.operation("=")
//        XCTAssertEqual(brain.debugLastDouble, 0.000001)

        brain.operation("AC")
        brain.debugPress(8)
        brain.debugPress(8)
        brain.operation("%")
//        XCTAssertEqual(brain.debugLastDouble, 0.88)

        brain.operation("AC")
        brain.debugPress(4)
        brain.debugPress(0)
        brain.operation("+")
        brain.debugPress(1)
        brain.debugPress(0)
        brain.operation("%")
        brain.operation("=")
//        XCTAssertEqual(brain.debugLastDouble, 44.0)
    }
    
    func XXtestPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
