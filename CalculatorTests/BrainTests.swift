//
//  BrainTests.swift
//  CalculatorTests
//
//  Created by Joachim Neumann on 3/5/23.
//

import XCTest

@testable import Better_Calc

class BrainTests: XCTestCase {
    let debugBrain = DebugBrain(precision: 100)
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    func testDigits() {
        debugBrain.push("AC")
        debugBrain.push("2")
        XCTAssertEqual(debugBrain.double, 2.0)
        
        debugBrain.push("√")
        XCTAssertEqual(debugBrain.double, 1.4142135623730950488)
        
        debugBrain.push("AC")
        XCTAssertEqual(debugBrain.double, 0.0)
        
        debugBrain.push(1)
        debugBrain.push(2)
        XCTAssertEqual(debugBrain.double, 12.0)
        
        debugBrain.push("AC")
        XCTAssertEqual(debugBrain.double, 0.0)
        
        debugBrain.push(0)
        XCTAssertEqual(debugBrain.double, 0.0)
        debugBrain.push(1)
        XCTAssertEqual(debugBrain.double, 1.0)
        debugBrain.push(2)
        XCTAssertEqual(debugBrain.double, 2.0)
        debugBrain.push(3)
        XCTAssertEqual(debugBrain.double, 3.0)
        debugBrain.push(4)
        XCTAssertEqual(debugBrain.double, 4.0)
        debugBrain.push(5)
        XCTAssertEqual(debugBrain.double, 5.0)
        debugBrain.push(6)
        XCTAssertEqual(debugBrain.double, 6.0)
        debugBrain.push(7)
        XCTAssertEqual(debugBrain.double, 7.0)
        debugBrain.push(8)
        XCTAssertEqual(debugBrain.double, 8.0)
        debugBrain.push(9)
        XCTAssertEqual(debugBrain.double, 9.0)

        debugBrain.push("0")
        XCTAssertEqual(debugBrain.double, 0.0)
        debugBrain.push("1")
        XCTAssertEqual(debugBrain.double, 1.0)
        debugBrain.push("2")
        XCTAssertEqual(debugBrain.double, 2.0)
        debugBrain.push("3")
        XCTAssertEqual(debugBrain.double, 3.0)
        debugBrain.push("4")
        XCTAssertEqual(debugBrain.double, 4.0)
        debugBrain.push("5")
        XCTAssertEqual(debugBrain.double, 5.0)
        debugBrain.push("6")
        XCTAssertEqual(debugBrain.double, 6.0)
        debugBrain.push("7")
        XCTAssertEqual(debugBrain.double, 7.0)
        debugBrain.push("8")
        XCTAssertEqual(debugBrain.double, 8.0)
        debugBrain.push("9")
        XCTAssertEqual(debugBrain.double, 9.0)
    }
    
    func testNumbers() {
        debugBrain.push("AC")
        debugBrain.push("1234567890")

        XCTAssertEqual(debugBrain.double, 1234567890.0)

        /// 1234567891
        debugBrain.push("AC")
        debugBrain.push("12345678901")

        XCTAssertEqual(debugBrain.double, 12345678901.0)

        /// 123456789012345678
        debugBrain.push("AC")
        debugBrain.push("12345678901234567")

        XCTAssertEqual(debugBrain.double, 1.2345678901234567e16)
        debugBrain.push("123456789012345678")
        XCTAssertEqual(debugBrain.double, 1.23456789012345678e17)


        /// -12345678901234
        debugBrain.push("AC")
        debugBrain.push("123456789")
        debugBrain.push("±")

        XCTAssertEqual(debugBrain.double, -123456789.0)


        /// 77777777777777777
        debugBrain.pushnew("777777777")
        XCTAssertEqual(debugBrain.double, 777777777)

        debugBrain.pushnew("777777777")
        debugBrain.push("777777777")
        XCTAssertEqual(debugBrain.double, 7.77777777777777777e17)



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

        XCTAssertEqual(debugBrain.double, -123456789.0)


        /// ±
        debugBrain.push("AC")
        debugBrain.push(7)

        XCTAssertEqual(debugBrain.double, 7.0)

        debugBrain.push("±")
        XCTAssertEqual(debugBrain.double, -7.0)
        
        debugBrain.pushnew(123)
        XCTAssertEqual(debugBrain.double, 123.0)
        debugBrain.pushnew(1234)
        XCTAssertEqual(debugBrain.double, 1234.0)
        debugBrain.pushnew(12345)
        XCTAssertEqual(debugBrain.double, 12345.0)
        debugBrain.pushnew(123456)
        XCTAssertEqual(debugBrain.double, 123456.0)
        debugBrain.pushnew(1234567)
        XCTAssertEqual(debugBrain.double, 1234567.0)
        debugBrain.pushnew(12345678)
        XCTAssertEqual(debugBrain.double, 12345678.0)

        debugBrain.pushnew("123")
        XCTAssertEqual(debugBrain.double, 123.0)
        debugBrain.pushnew("1234")
        XCTAssertEqual(debugBrain.double, 1234.0)
        debugBrain.pushnew("12345")
        XCTAssertEqual(debugBrain.double, 12345.0)
        debugBrain.pushnew("123456")
        XCTAssertEqual(debugBrain.double, 123456.0)
        debugBrain.pushnew("1234567")
        XCTAssertEqual(debugBrain.double, 1234567.0)
        debugBrain.pushnew("12345678")
        XCTAssertEqual(debugBrain.double, 12345678.0)

        debugBrain.pushnew("12300")
        XCTAssertEqual(debugBrain.double, 12300.0)
        debugBrain.pushnew("12345678901")
        XCTAssertEqual(debugBrain.double, 1.2345678901e10)
        debugBrain.pushnew("12345678901234")
        XCTAssertEqual(debugBrain.double, 1.2345678901234e13)
    }
    
    func testConstants() {
        /// pi
        debugBrain.push("AC")
        debugBrain.push("π")
        XCTAssertEqual(debugBrain.double, 3.14159265358979323846)

        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push("π")
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 4.14159265358979323846)

        debugBrain.push("AC")
        debugBrain.push("π")
        debugBrain.push("x")
        debugBrain.push(2)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 6.283185307179586)

        /// e
        debugBrain.push("AC")
        debugBrain.push("e")
        XCTAssertEqual(debugBrain.double, 2.718281828459045)

        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push("e")
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 3.718281828459045)

        debugBrain.push("AC")
        debugBrain.push("e")
        debugBrain.push("x")
        debugBrain.push(2)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 5.43656365691809)
    }
    
    func testComma() {
        debugBrain.push("AC")
        debugBrain.push(",")
        XCTAssertEqual(debugBrain.double, 0.0)

        debugBrain.push("AC")
        debugBrain.push(",")
        debugBrain.push(",")
        XCTAssertEqual(debugBrain.double, 0.0)

        debugBrain.push("AC")
        debugBrain.push(",")
        debugBrain.push("0")
        XCTAssertEqual(debugBrain.double, 0.0)
        
        debugBrain.push("AC")
        debugBrain.push(",")
        debugBrain.push("0")
        debugBrain.push("0")
        XCTAssertEqual(debugBrain.double, 0.0)
        
        debugBrain.push("AC")
        debugBrain.push(",")
        debugBrain.push("0")
        debugBrain.push("0")
        debugBrain.push("0")
        XCTAssertEqual(debugBrain.double, 0.0)
        
        debugBrain.push("AC")
        debugBrain.push(",")
        debugBrain.push("0")
        debugBrain.push("0")
        debugBrain.push("0")
        debugBrain.push("1")
        XCTAssertEqual(debugBrain.double, 0.0001)
    }
    
    func testSci() {
        /// 3 e6
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("EE")
        debugBrain.push(6)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 3000000.0)

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
        XCTAssertEqual(debugBrain.double, 300000.001)

        /// 3 e77
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("EE")
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 3.0e77)

        /// 3 e-77
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("EE")
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push("±")
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 3.0e-77)

        /// -3 e-77
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("EE")
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push("±")
        debugBrain.push("=")
        debugBrain.push("±")
        XCTAssertEqual(debugBrain.double, -3.0e-77)

        /// -3 e-77
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("±")
        debugBrain.push("EE")
        debugBrain.push(7)
        debugBrain.push(7)
        debugBrain.push("±")
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, -3.0e-77)


        /// 8888888
        debugBrain.push("AC")
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        XCTAssertEqual(debugBrain.double, 8888888.0)

        debugBrain.push("AC")
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        debugBrain.push(8)
        XCTAssertEqual(debugBrain.double, 8.88888888888888888888e18)
    }
}
