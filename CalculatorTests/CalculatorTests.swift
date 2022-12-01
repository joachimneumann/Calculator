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
        let brain = Brain(precision: 100)
        var multipleLiner = MultipleLiner(left: "0", abreviated: false)

        /// integers
        multipleLiner = brain.number("123").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "123")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("1234").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("12345").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "12345")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("12345").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "12345")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("12300").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "12300")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("12300").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "12300")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("123456").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "123456")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("123456").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "123456")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("1234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1234567")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("12345678").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "12345678")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("123456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,23456")
        XCTAssertEqual(multipleLiner.right, "e8")
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-123").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-123")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("-12345").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-12345")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("-123456").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-123456")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("-1234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-1234567")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("-12345678").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-1,2345")
        XCTAssertEqual(multipleLiner.right, "e7")
        XCTAssertTrue( multipleLiner.Abbreviated)
        
        
        multipleLiner = brain.number("1234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1234567")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("-1234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-1234567")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)


        /// floating point numbers
        multipleLiner = brain.number("1,234").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("1,2345").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,2345")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("1,23456").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,23456")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("1,234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,234567")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("1,2345678").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,2345678")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("1,23456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,2345678")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue(multipleLiner.Abbreviated)

        multipleLiner = brain.number("-1,234").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-1,234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("-1,2345").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-1,2345")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("-1,23456").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-1,23456")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("-1,234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-1,234567")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("-1,2345678").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-1,234567")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue(multipleLiner.Abbreviated)


        multipleLiner = brain.number("1,234").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("1,234").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("1,234").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("1,234").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("1,234").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("1,234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,234567")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("1,2345678").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,2345678")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("1,23456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,2345678")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-1,234").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-1,234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-1,2345").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-1,2345")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-1,23456").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-1,23456")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-1,23456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-1,234567")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-144,23456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-144,2345")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("1445,23456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1445,2345")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("14456,23456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "14456,234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("144567,23456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "144567,23")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("1445678,23456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1445678,2")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("14456785,23456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "14456785,")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,123").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,123")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,1234").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,1234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,12345").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,12345")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,123456").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,123456")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,1234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,1234567")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,12345678").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,1234567")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,000012").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,000012")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,000004").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,000004")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,0000123456").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,0000123")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-0,000012").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-0,000012")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-0,0000123").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-0,000012")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-0,0000123456").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-0,000012")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-0,123").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-0,123")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("-0,1234").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-0,1234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("-0,12345").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-0,12345")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("-0,123456").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-0,123456")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("-0,1234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-0,123456")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue(multipleLiner.Abbreviated)

        multipleLiner = brain.number("14456789,23456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "14456789,")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-144567,23456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-144567,2")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-1445678,23456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-1445678,")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("1445678,23456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1445678,2")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,0123").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,0123")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,01234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,0123456")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,0012").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,0012")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-0,0012").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-0,0012")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,001234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,0012345")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-0,001234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-0,001234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,0001234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,0001234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-0,0001234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-0,000123")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,00001234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,0000123")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-0,00001234567").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-0,000012")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,12345678").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,1234567")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)
        
        /// scientific notation

        multipleLiner = brain.number("1,5e12").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,5e12")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.gmpNumber("1,5e12").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,5")
        XCTAssertEqual(multipleLiner.right, "e12")
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,00000004").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "4,0")
        XCTAssertEqual(multipleLiner.right, "e-8")
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,0000004").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,0000004")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)

        multipleLiner = brain.number("12345678349875349873").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,2345")
        XCTAssertEqual(multipleLiner.right, "e19")
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("123456783498753498731").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,2345")
        XCTAssertEqual(multipleLiner.right, "e20")
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,012345678").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,0123456")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,0012345678").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,0012345")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("-1445,23456789").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "-1445,234")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("921387491237419283092340238420398423098423049874129837649128364519234875").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "9,2138")
        XCTAssertEqual(multipleLiner.right, "e71")
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("1,23").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,23")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("1,23").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,23")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,0023").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0,0023")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,000000000023").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "2,3")
        XCTAssertEqual(multipleLiner.right, "e-11")
        XCTAssertFalse(multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,0000000000232837642876").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "2,328")
        XCTAssertEqual(multipleLiner.right, "e-11")
        XCTAssertTrue( multipleLiner.Abbreviated)

        multipleLiner = brain.number("0,0000000000232837642876239827342").multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "2,328")
        XCTAssertEqual(multipleLiner.right, "e-11")
        XCTAssertTrue( multipleLiner.Abbreviated)
    }
    
    func test() {
//        let digits = 16
//        
//        var res = ""
//        var resTruncated = ""
//        var correct = ""
//        var sci = ""
//        
        let brain = Brain(precision: 100)
        var multipleLiner = MultipleLiner(left: "0", abreviated: false)
//
//        /// 1
//        
        brain.nonWaitingOperation("AC")
        brain.press("2")
        multipleLiner = brain.last.multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "2")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)
        brain.nonWaitingOperation("√")
        multipleLiner = brain.last.multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "1,4142135")

        /// sin(pi) =? 0
        brain.nonWaitingOperation("AC")
        brain.press("π")
        brain.nonWaitingOperation("sin")
        multipleLiner = brain.last.multipleLines(withoutComma: 8, withComma: 9)
        XCTAssertEqual(multipleLiner.left, "0")
        XCTAssertNil(  multipleLiner.right)
        XCTAssertFalse( multipleLiner.Abbreviated)
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
//        XCTAssertEqual(brain.scientific, DisplayData.Scientific("1,234567890123456789", "e19").multipleLines(withoutComma: 8, withComma: 9)
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
//        XCTAssertEqual(brain.scientific, DisplayData.Scientific("7,7777777777777777777777", "e22").multipleLines(withoutComma: 8, withComma: 9)
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
//        XCTAssertEqual(brain.scientific, DisplayData.Scientific("3,0", "e77").multipleLines(withoutComma: 8, withComma: 9)
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
//        XCTAssertEqual(brain.scientific, DisplayData.Scientific("3,0", "e-77").multipleLines(withoutComma: 8, withComma: 9)
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
//        XCTAssertEqual(brain.scientific, DisplayData.Scientific("-3,0", "e-77").multipleLines(withoutComma: 8, withComma: 9)
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
//        XCTAssertEqual(brain.scientific, DisplayData.Scientific("-3,0", "e-77").multipleLines(withoutComma: 8, withComma: 9)
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
//        XCTAssertEqual(brain.debugLastGmp, Gmp("1024").multipleLines(withoutComma: 8, withComma: 9)
//        XCTAssertEqual(brain.nonScientific, "1024")
//        XCTAssertEqual(brain.scientific, nil)
//        
//        brain.nonWaitingOperation("AC")
//        brain.press(1)
//        brain.press(0)
//        brain.nonWaitingOperation("y^x")
//        brain.press(2)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.debugLastGmp, Gmp("1024").multipleLines(withoutComma: 8, withComma: 9)
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
//        XCTAssertEqual(brain.debugLastGmp, Gmp("10").multipleLines(withoutComma: 8, withComma: 9)
//        brain.nonWaitingOperation("=")
//        XCTAssertEqual(brain.debugLastGmp, Gmp("20").multipleLines(withoutComma: 8, withComma: 9)
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
//        XCTAssertEqual(brain.debugLastGmp, Gmp("124").multipleLines(withoutComma: 8, withComma: 9)
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
