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
        let debugBrain = DebugBrain(precision: 200_000, lengths: Lengths(5_000)) /// also failing: 10000

        debugBrain.push(7.7)
        debugBrain.push("One_x")
        debugBrain.push("One_x")
        XCTAssertEqual(debugBrain.oneLine, "7,7")

        debugBrain.push("AC")
        debugBrain.push(0.3)
        debugBrain.push("+")
        debugBrain.push("0,4")
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.left, "0,7")
    }
    
    func testmultipleLiner() {
        let debugBrain = DebugBrain(precision: 100, lengths: Lengths(withoutComma: 8, withCommaNonScientific: 9, withCommaScientific: 9, digitWidth: 0, ePadding: 0))

        /// integers
        debugBrain.pushnew(123)
        XCTAssertEqual(debugBrain.left, "123")
        XCTAssertNil(  debugBrain.right)

        debugBrain.pushnew(1234)
        XCTAssertEqual(debugBrain.left, "1234")
        XCTAssertNil(  debugBrain.right)

        debugBrain.pushnew(12345)
        XCTAssertEqual(debugBrain.left, "12345")
        XCTAssertNil(  debugBrain.right)

        debugBrain.pushnew("12345")
        XCTAssertEqual(debugBrain.left, "12345")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("12300")
        XCTAssertEqual(debugBrain.left, "12300")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("12300")
        XCTAssertEqual(debugBrain.left, "12300")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("123456")
        XCTAssertEqual(debugBrain.left, "123456")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("123456")
        XCTAssertEqual(debugBrain.left, "123456")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1234567")
        XCTAssertEqual(debugBrain.left, "1234567")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("12345678")
        XCTAssertEqual(debugBrain.left, "12345678")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("123456789")
        XCTAssertEqual(debugBrain.left, "1,23456")
        XCTAssertEqual(debugBrain.right, "e8")


        debugBrain.pushnew("-123")
        XCTAssertEqual(debugBrain.left, "-123")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew(-12345)
        XCTAssertEqual(debugBrain.left, "-12345")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew(-123456)
        XCTAssertEqual(debugBrain.left, "-123456")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew(-1234567)
        XCTAssertEqual(debugBrain.left, "-1234567")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew(-12345678)
        XCTAssertEqual(debugBrain.left, "-1,2345")
        XCTAssertEqual(debugBrain.right, "e7")



        debugBrain.pushnew(1234567)
        XCTAssertEqual(debugBrain.left, "1234567")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew(-1234567)
        XCTAssertEqual(debugBrain.left, "-1234567")
        XCTAssertNil(  debugBrain.right)



        /// floating point numbers
        debugBrain.pushnew("1,234")
        XCTAssertEqual(debugBrain.left, "1,234")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1,2345")
        XCTAssertEqual(debugBrain.left, "1,2345")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1,23456")
        XCTAssertEqual(debugBrain.left, "1,23456")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1,234567")
        XCTAssertEqual(debugBrain.left, "1,234567")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1,2345678")
        XCTAssertEqual(debugBrain.left, "1,2345678")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1,23456789")
        XCTAssertEqual(debugBrain.left, "1,2345678")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-1,234")
        XCTAssertEqual(debugBrain.left, "-1,234")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-1,2345")
        XCTAssertEqual(debugBrain.left, "-1,2345")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-1,23456")
        XCTAssertEqual(debugBrain.left, "-1,23456")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-1,234567")
        XCTAssertEqual(debugBrain.left, "-1,234567")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-1,2345678")
        XCTAssertEqual(debugBrain.left, "-1,234567")
        XCTAssertNil(  debugBrain.right)



        debugBrain.pushnew("1,234")
        XCTAssertEqual(debugBrain.left, "1,234")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1,234")
        XCTAssertEqual(debugBrain.left, "1,234")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1,234")
        XCTAssertEqual(debugBrain.left, "1,234")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1,234")
        XCTAssertEqual(debugBrain.left, "1,234")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1,234")
        XCTAssertEqual(debugBrain.left, "1,234")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1,234567")
        XCTAssertEqual(debugBrain.left, "1,234567")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1,2345678")
        XCTAssertEqual(debugBrain.left, "1,2345678")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1,23456789")
        XCTAssertEqual(debugBrain.left, "1,2345678")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-1,234")
        XCTAssertEqual(debugBrain.left, "-1,234")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-1,2345")
        XCTAssertEqual(debugBrain.left, "-1,2345")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-1,23456")
        XCTAssertEqual(debugBrain.left, "-1,23456")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-1,23456789")
        XCTAssertEqual(debugBrain.left, "-1,234567")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-144,23456789")
        XCTAssertEqual(debugBrain.left, "-144,2345")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1445,23456789")
        XCTAssertEqual(debugBrain.left, "1445,2345")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("14456,23456789")
        XCTAssertEqual(debugBrain.left, "14456,234")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("144567,23456789")
        XCTAssertEqual(debugBrain.left, "144567,23")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1445678,23456789")
        XCTAssertEqual(debugBrain.left, "1445678,2")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("14456785,23456789")
        XCTAssertEqual(debugBrain.left, "14456785,")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,123")
        XCTAssertEqual(debugBrain.left, "0,123")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,1234")
        XCTAssertEqual(debugBrain.left, "0,1234")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,12345")
        XCTAssertEqual(debugBrain.left, "0,12345")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,123456")
        XCTAssertEqual(debugBrain.left, "0,123456")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,1234567")
        XCTAssertEqual(debugBrain.left, "0,1234567")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,12345678")
        XCTAssertEqual(debugBrain.left, "0,1234567")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,000012")
        XCTAssertEqual(debugBrain.left, "0,000012")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,000004")
        XCTAssertEqual(debugBrain.left, "0,000004")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,0000123456")
        XCTAssertEqual(debugBrain.left, "0,0000123")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-0,000012")
        XCTAssertEqual(debugBrain.left, "-0,000012")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-0,0000123")
        XCTAssertEqual(debugBrain.left, "-0,000012")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-0,0000123456")
        XCTAssertEqual(debugBrain.left, "-0,000012")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-0,123")
        XCTAssertEqual(debugBrain.left, "-0,123")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-0,1234")
        XCTAssertEqual(debugBrain.left, "-0,1234")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-0,12345")
        XCTAssertEqual(debugBrain.left, "-0,12345")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-0,123456")
        XCTAssertEqual(debugBrain.left, "-0,123456")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-0,1234567")
        XCTAssertEqual(debugBrain.left, "-0,123456")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("14456789,23456789")
        XCTAssertEqual(debugBrain.left, "14456789,")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-144567,23456789")
        XCTAssertEqual(debugBrain.left, "-144567,2")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-1445678,23456789")
        XCTAssertEqual(debugBrain.left, "-1445678,")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1445678,23456789")
        XCTAssertEqual(debugBrain.left, "1445678,2")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,0123")
        XCTAssertEqual(debugBrain.left, "0,0123")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,01234567")
        XCTAssertEqual(debugBrain.left, "0,0123456")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,0012")
        XCTAssertEqual(debugBrain.left, "0,0012")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-0,0012")
        XCTAssertEqual(debugBrain.left, "-0,0012")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,001234567")
        XCTAssertEqual(debugBrain.left, "0,0012345")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-0,001234567")
        XCTAssertEqual(debugBrain.left, "-0,001234")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,0001234567")
        XCTAssertEqual(debugBrain.left, "0,0001234")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-0,0001234567")
        XCTAssertEqual(debugBrain.left, "-0,000123")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,00001234567")
        XCTAssertEqual(debugBrain.left, "0,0000123")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-0,00001234567")
        XCTAssertEqual(debugBrain.left, "-0,000012")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,12345678")
        XCTAssertEqual(debugBrain.left, "0,1234567")
        XCTAssertNil(  debugBrain.right)


        /// scientific notation

        debugBrain.pushnew(1.5)
        debugBrain.push("EE")
        debugBrain.push(12)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.left, "1,5")
        XCTAssertEqual(debugBrain.right, "e12")


        debugBrain.pushnew("1,5")
        debugBrain.push("EE")
        debugBrain.push("12")
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.left, "1,5")
        XCTAssertEqual(debugBrain.right, "e12")


        debugBrain.pushnew("0,00000004")
        XCTAssertEqual(debugBrain.left, "4,0")
        XCTAssertEqual(debugBrain.right, "e-8")


        debugBrain.pushnew("0,0000004")
        XCTAssertEqual(debugBrain.left, "0,0000004")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("12345678349875349873")
        XCTAssertEqual(debugBrain.left, "1,2345")
        XCTAssertEqual(debugBrain.right, "e19")


        debugBrain.pushnew("123456783498753498731")
        XCTAssertEqual(debugBrain.left, "1,2345")
        XCTAssertEqual(debugBrain.right, "e20")


        debugBrain.pushnew("0,012345678")
        XCTAssertEqual(debugBrain.left, "0,0123456")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,0012345678")
        XCTAssertEqual(debugBrain.left, "0,0012345")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("-1445,23456789")
        XCTAssertEqual(debugBrain.left, "-1445,234")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("921387491237419283092340238420398423098423049874129837649128364519234875")
        XCTAssertEqual(debugBrain.left, "9,2138")
        XCTAssertEqual(debugBrain.right, "e71")


        debugBrain.pushnew("1,23")
        XCTAssertEqual(debugBrain.left, "1,23")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("1,23")
        XCTAssertEqual(debugBrain.left, "1,23")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,0023")
        XCTAssertEqual(debugBrain.left, "0,0023")
        XCTAssertNil(  debugBrain.right)


        debugBrain.pushnew("0,000000000023")
        XCTAssertEqual(debugBrain.left, "2,3")
        XCTAssertEqual(debugBrain.right, "e-11")


        debugBrain.pushnew("0,0000000000232837642876")
        XCTAssertEqual(debugBrain.left, "2,328")
        XCTAssertEqual(debugBrain.right, "e-11")


        debugBrain.pushnew("0,0000000000232837642876239827342")
        XCTAssertEqual(debugBrain.left, "2,328")
        XCTAssertEqual(debugBrain.right, "e-11")

    }

    func test() {
        let debugBrain = DebugBrain(precision: 100, lengths: Lengths(10))

        /// 1
        debugBrain.push("AC")
        debugBrain.push("2")
        XCTAssertEqual(debugBrain.left, "2")
        XCTAssertNil(  debugBrain.right)

        debugBrain.push("√")
        XCTAssertEqual(debugBrain.left, "1,41421356")

        /// 0
        debugBrain.push("AC")

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(0)

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(0)

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)


        // 12
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push(2)

        XCTAssertEqual(debugBrain.left, "12")
        XCTAssertEqual(debugBrain.right, nil)

        // 01
        debugBrain.push("AC")

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(0)

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(1)

        XCTAssertEqual(debugBrain.left, "1")
        XCTAssertEqual(debugBrain.right, nil)

        /// 1234567890
        debugBrain.push("AC")
        debugBrain.push("1234567890")

        XCTAssertEqual(debugBrain.left, "1234567890")
        XCTAssertEqual(debugBrain.right, nil)

        /// 1234567891
        debugBrain.push("AC")
        debugBrain.push("12345678901")

        XCTAssertEqual(debugBrain.left, "1,23456")
        XCTAssertEqual(debugBrain.right, "e10")

        /// 123456789012345678
        debugBrain.push("AC")
        debugBrain.push("12345678901234567")

        XCTAssertEqual(debugBrain.left, "1,23456")
        XCTAssertEqual(debugBrain.right, "e16")
        debugBrain.push(8)

        XCTAssertEqual(debugBrain.left, "1,23456")
        XCTAssertEqual(debugBrain.right, "e17")


        /// -12345678901234
        debugBrain.push("AC")
        debugBrain.push("123456789")
        debugBrain.push("±")

        XCTAssertEqual(debugBrain.left, "-123456789")
        XCTAssertEqual(debugBrain.right, nil)


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

        XCTAssertEqual(debugBrain.left, "777777777")
        XCTAssertEqual(debugBrain.right, nil)
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

        XCTAssertEqual(debugBrain.left, "7,77777")
        XCTAssertEqual(debugBrain.right, "e22")



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

        XCTAssertEqual(debugBrain.left, "-123456789")
        XCTAssertEqual(debugBrain.right, nil)


        /// ±
        debugBrain.push("AC")
        debugBrain.push(7)

        XCTAssertEqual(debugBrain.left, "7")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("±")

        XCTAssertEqual(debugBrain.left, "-7")
        XCTAssertEqual(debugBrain.right, nil)

        /// 0,
        debugBrain.push("AC")
        debugBrain.push(",")

        XCTAssertEqual(debugBrain.left, "0,")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(",")

        XCTAssertEqual(debugBrain.left, "0,")
        XCTAssertEqual(debugBrain.right, nil)

        /// -0,7
        debugBrain.push("AC")
        debugBrain.push(",")

        XCTAssertEqual(debugBrain.left, "0,")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(7)

        XCTAssertEqual(debugBrain.left, "0,7")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("±")

        XCTAssertEqual(debugBrain.left, "-0,7")
        XCTAssertEqual(debugBrain.right, nil)

        /// 3 e6
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("EE")
        debugBrain.push(6)
        debugBrain.push("=")

        XCTAssertEqual(debugBrain.left, "3000000")
        XCTAssertEqual(debugBrain.right, nil)

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

        XCTAssertEqual(debugBrain.left, "300000,001")
        XCTAssertEqual(debugBrain.right, nil)


        /// 3 e77
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("EE")
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push("=")

        XCTAssertEqual(debugBrain.left, "3,0")
        XCTAssertEqual(debugBrain.right, "e77")

        /// 3 e-77
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("EE")
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push("±")
        debugBrain.push("=")

        XCTAssertEqual(debugBrain.left, "3,0")
        XCTAssertEqual(debugBrain.right, "e-77")

        /// -3 e-77
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("EE")
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push("±")
        debugBrain.push("=")
        debugBrain.push("±")

        XCTAssertEqual(debugBrain.left, "-3,0")
        XCTAssertEqual(debugBrain.right, "e-77")

        /// -3 e-77
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("±")
        debugBrain.push("EE")
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push("±")
        debugBrain.push("=")

        XCTAssertEqual(debugBrain.left, "-3,0")
        XCTAssertEqual(debugBrain.right, "e-77")


        /// 8888888
        debugBrain.push("AC")
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)

        XCTAssertEqual(debugBrain.left, "8888888")
        XCTAssertEqual(debugBrain.right, nil)


        /// memory
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push(2)

        XCTAssertEqual(debugBrain.left, "12")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("mc")

        XCTAssertEqual(debugBrain.left, "12")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("m+")

        XCTAssertEqual(debugBrain.left, "12")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("m+")

        XCTAssertEqual(debugBrain.left, "12")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("mr")

        XCTAssertEqual(debugBrain.left, "24")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("m-")

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("mr")

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)

        /// 0,0000010
        debugBrain.push("AC")
        debugBrain.push(0)

        XCTAssertEqual(debugBrain.left, "0")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(",")

        XCTAssertEqual(debugBrain.left, "0,")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(0)

        XCTAssertEqual(debugBrain.left, "0,0")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(0)

        XCTAssertEqual(debugBrain.left, "0,00000")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(1)

        XCTAssertEqual(debugBrain.left, "0,000001")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(0)

        XCTAssertEqual(debugBrain.left, "0,0000010")
        XCTAssertEqual(debugBrain.right, nil)


        var res: String
        let digits = 5

        /// 1 e -15
        debugBrain.push("AC")
        debugBrain.push(",")
        res = "0,"
        for _ in 1..<digits-1 {
            res += "0"
            debugBrain.push(0)
    
            XCTAssertEqual(debugBrain.left, res)
            XCTAssertEqual(debugBrain.right, nil)
        }
        debugBrain.push(1)

        XCTAssertEqual(debugBrain.left, "0,0001")
        XCTAssertEqual(debugBrain.left, res+"1")
        XCTAssertEqual(debugBrain.right, nil)

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

        XCTAssertEqual(debugBrain.left, res)
        XCTAssertEqual(debugBrain.right, nil)


        /// 32456.224433
        debugBrain.push(3)
        res += "3"

        XCTAssertEqual(debugBrain.left, res)
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(3)

        XCTAssertEqual(debugBrain.left, res)
        XCTAssertEqual(debugBrain.right, nil)

        /// 1/7*7 --> has more digits?
        debugBrain.push("AC")
        debugBrain.push(7)
        debugBrain.push("One_x")
        debugBrain.push("x")
        debugBrain.push(7)
        debugBrain.push("=")

        XCTAssertEqual(debugBrain.left, "1")
        XCTAssertEqual(debugBrain.right, nil)

        /// -1/3
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("One_x")
        var correct = "0,33333333"

        XCTAssertEqual (debugBrain.left, correct)
        debugBrain.push("±")
        correct = "-0,3333333"

        XCTAssertEqual (debugBrain.left, correct)

        /// 9 %%%% ^2 ^2 ^2
        debugBrain.push("AC")
        debugBrain.push("9")
        debugBrain.push("%")

        XCTAssertEqual(debugBrain.left, "0,09")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("%")

        XCTAssertEqual(debugBrain.left, "0,0009")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("%")
        debugBrain.push("%")

        XCTAssertEqual(debugBrain.left, "0,00000009")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("x^2")

        XCTAssertEqual(debugBrain.left, "8,1")
        XCTAssertEqual(debugBrain.right, "e-15")


        /// 1/10 and 1/16
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push(0)

        XCTAssertEqual(debugBrain.left, "10")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("One_x")

        XCTAssertEqual(debugBrain.left, "0,1")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(1)
        debugBrain.push(6)

        XCTAssertEqual(debugBrain.left, "16")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("One_x")

        XCTAssertEqual(debugBrain.left, "0,0625")
        XCTAssertEqual(debugBrain.right, nil)

        /// 1+2+5+2= + 1/4 =
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("+")

        XCTAssertEqual(debugBrain.left, "3")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(5)
        debugBrain.push("+")

        XCTAssertEqual(debugBrain.left, "8")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(2)
        debugBrain.push("=")

        XCTAssertEqual(debugBrain.left, "10")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("+")

        XCTAssertEqual(debugBrain.left, "10")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(4)
        debugBrain.push("One_x")

        XCTAssertEqual(debugBrain.left, "0,25")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("=")

        XCTAssertEqual(debugBrain.left, "10,25")
        XCTAssertEqual(debugBrain.right, nil)

        /// 1+2*4=
        debugBrain.push("AC")
        debugBrain.push(1)

        XCTAssertEqual(debugBrain.left, "1")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("x")

        XCTAssertEqual(debugBrain.left, "2")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(4)

        XCTAssertEqual(debugBrain.left, "4")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("=")

        XCTAssertEqual(debugBrain.left, "9")
        XCTAssertEqual(debugBrain.right, nil)

        /// 2*3*4*5=
        debugBrain.push("AC")
        debugBrain.push(2)
        debugBrain.push("x")
        debugBrain.push(3)
        debugBrain.push("x")
        debugBrain.push(4)
        debugBrain.push("x")

        XCTAssertEqual(debugBrain.left, "24")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(5)
        debugBrain.push("=")

        XCTAssertEqual(debugBrain.left, "120")
        XCTAssertEqual(debugBrain.right, nil)

        /// 1+2*4
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("x")

        XCTAssertEqual(debugBrain.left, "2")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(4)

        XCTAssertEqual(debugBrain.left, "4")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("+")

        XCTAssertEqual(debugBrain.left, "9")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push(1)
        debugBrain.push(0)
        debugBrain.push(0)

        XCTAssertEqual(debugBrain.left, "100")
        XCTAssertEqual(debugBrain.right, nil)
        debugBrain.push("=")

        XCTAssertEqual(debugBrain.left, "109")
        XCTAssertEqual(debugBrain.right, nil)

        /// pi
        debugBrain.push("AC")
        debugBrain.push("π")
        correct = "3,14159265"

        XCTAssertEqual(debugBrain.left, correct)
        XCTAssertEqual(debugBrain.right, nil)

        /// 1+pi
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push("π")
        debugBrain.push("=")
        correct = "4,14159265"

        XCTAssertEqual(debugBrain.left, correct)
        XCTAssertEqual(debugBrain.right, nil)

        debugBrain.push("AC")
        debugBrain.push("π")
        debugBrain.push("x")
        debugBrain.push(2)
        debugBrain.push("=")
        correct = "6,28318530"

        XCTAssertEqual(debugBrain.left, correct)
        XCTAssertEqual(debugBrain.right, nil)

        debugBrain.push("AC")
        debugBrain.push(2)
        debugBrain.push("x^y")
        debugBrain.push(1)
        debugBrain.push(0)
        debugBrain.push("=")

        XCTAssertEqual(debugBrain.left, "1024")
        XCTAssertEqual(debugBrain.right, nil)

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

        XCTAssertEqual(debugBrain.left, "6")
        XCTAssertEqual(debugBrain.nn, 2)
        debugBrain.push("+")
        XCTAssertEqual(debugBrain.no, 3)
        debugBrain.push(4)

        XCTAssertEqual(debugBrain.left, "4")
        XCTAssertEqual(debugBrain.nn, 3)
        debugBrain.push(" )")
        XCTAssertEqual(debugBrain.no, 1)
        XCTAssertEqual(debugBrain.nn, 2)
        //        XCTAssertEqual(debugBrain.debugLastGmp, Gmp("10")
        debugBrain.push("=")
        //        XCTAssertEqual(debugBrain.debugLastGmp, Gmp("20")

        XCTAssertEqual(debugBrain.left, "20")
        XCTAssertEqual(debugBrain.right, nil)

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
        XCTAssertEqual(debugBrain.left, "124")

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
        XCTAssertEqual(debugBrain.left, "41")
        
        /// odd root of negative number, implemented as special case in BrainEngine.execute
        debugBrain.push("AC")
        debugBrain.push(-8)
        debugBrain.push("y√")
        debugBrain.push(3)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.left, "-2")
        
        /// change operand
        debugBrain.push("AC")
        debugBrain.push(5)
        debugBrain.push("+")
        debugBrain.push("x")
        debugBrain.push(4)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.left, "20")

        /// change twoOperand
        debugBrain.push("AC")
        debugBrain.push(5)
        debugBrain.push("y√")
        debugBrain.push("x^y")
        debugBrain.push(3)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.left, "125")
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
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
}
