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
    
    func test_digits() {
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
    
    func test_numbers() {
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
    
    func test_constants() {
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
    
    func test_comma() {
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
    
    func test_negative() {
        /// -0,7
        debugBrain.push("AC")
        debugBrain.push(",")
        XCTAssertEqual(debugBrain.double, 0.0)
        
        debugBrain.push("AC")
        debugBrain.push(",")
        debugBrain.push(7)
        XCTAssertEqual(debugBrain.double, 0.7)
        
        debugBrain.push("AC")
        debugBrain.push(",")
        debugBrain.push(7)
        debugBrain.push("±")
        XCTAssertEqual(debugBrain.double, -0.7)
    }
    
    func test_sci() {
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
    
    func test_sciNegative() {
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
    }
    
    func test_memory() {
        /// memory
        debugBrain.push("AC")
        debugBrain.push("mc")
        XCTAssertEqual(debugBrain.memoryDouble, 0.0)
        debugBrain.push(12)
        XCTAssertEqual(debugBrain.double, 12.0)
        XCTAssertEqual(debugBrain.memoryDouble, 0.0)
        
        debugBrain.push("m+")
        XCTAssertEqual(debugBrain.double, 12.0)
        XCTAssertEqual(debugBrain.memoryDouble, 12.0)
        
        debugBrain.push("m+")
        XCTAssertEqual(debugBrain.double, 12.0)
        XCTAssertEqual(debugBrain.memoryDouble, 24.0)
        
        debugBrain.push("m+")
        XCTAssertEqual(debugBrain.double, 12.0)
        XCTAssertEqual(debugBrain.memoryDouble, 36.0)
        
        debugBrain.push("mr")
        XCTAssertEqual(debugBrain.double, 36.0)
        XCTAssertEqual(debugBrain.memoryDouble, 36.0)
        
        debugBrain.push(100)
        XCTAssertEqual(debugBrain.double, 100.0)
        XCTAssertEqual(debugBrain.memoryDouble, 36.0)
        
        debugBrain.push("m+")
        XCTAssertEqual(debugBrain.double, 100.0)
        XCTAssertEqual(debugBrain.memoryDouble, 136.0)
        
        debugBrain.push("mr")
        XCTAssertEqual(debugBrain.double, 136.0)
        XCTAssertEqual(debugBrain.memoryDouble, 136.0)
        
        debugBrain.push(10)
        XCTAssertEqual(debugBrain.double, 10.0)
        XCTAssertEqual(debugBrain.memoryDouble, 136.0)
        
        debugBrain.push("m-")
        XCTAssertEqual(debugBrain.double, 10.0)
        XCTAssertEqual(debugBrain.memoryDouble, 126.0)
        
        debugBrain.push("mr")
        XCTAssertEqual(debugBrain.double, 126.0)
        XCTAssertEqual(debugBrain.memoryDouble, 126.0)
        
        debugBrain.push("mc")
        XCTAssertEqual(debugBrain.double, 126.0)
        XCTAssertEqual(debugBrain.memoryDouble, 0.0)
    }
    
    func test_smallNumbers() {
        debugBrain.push("AC")
        debugBrain.push(0)
        XCTAssertEqual(debugBrain.double, 0.0)
        
        debugBrain.push("AC")
        debugBrain.push(0)
        debugBrain.push(",")
        XCTAssertEqual(debugBrain.double, 0.0)
        
        debugBrain.push("AC")
        debugBrain.push(0)
        debugBrain.push(",")
        debugBrain.push(0)
        XCTAssertEqual(debugBrain.double, 0.0)
        
        debugBrain.push("AC")
        debugBrain.push(0)
        debugBrain.push(",")
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(0)
        XCTAssertEqual(debugBrain.double, 0.0)
        
        debugBrain.push("AC")
        debugBrain.push(0)
        debugBrain.push(",")
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(1)
        XCTAssertEqual(debugBrain.double, 0.00001)
        
        debugBrain.push("AC")
        debugBrain.push(0)
        debugBrain.push(",")
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(1)
        debugBrain.push(0)
        XCTAssertEqual(debugBrain.double, 0.00001)
        
        debugBrain.push("AC")
        debugBrain.push(0)
        debugBrain.push(",")
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(0)
        debugBrain.push(1)
        debugBrain.push(0)
        debugBrain.push(1)
        XCTAssertEqual(debugBrain.double, 0.0000101)
    }
    
    func test_moreSmallNumbers() {
        /// 0,000...0010
        debugBrain.push("AC")
        debugBrain.push("0,00000001")
        XCTAssertEqual(debugBrain.double, 0.00000001)
        
        debugBrain.push("AC")
        debugBrain.push("0,0000000000000000000000001")
        XCTAssertEqual(debugBrain.double, 1.0e-25)
    }
    
    func test_smallNumberLoop() {
        for digits in 2..<100 {
            /// 1 e -15
            debugBrain.push("AC")
            debugBrain.push(",")
            var res = 0.1
            for _ in 0..<digits {
                res *= 0.1
                debugBrain.push(0)
            }
            debugBrain.push(1)
            XCTAssertEqual(debugBrain.double, res, accuracy: 0.0000001)
        }
        
        for digits in 2..<100 {
            /// 1 e -15
            debugBrain.push("AC")
            debugBrain.push("5")
            debugBrain.push(",")
            var res = 0.1
            for _ in 0..<digits {
                res *= 0.1
                debugBrain.push(0)
            }
            debugBrain.push(1)
            res += 5.0
            XCTAssertEqual(debugBrain.double, res, accuracy: 0.0000001)
        }
    }
    
    func test_numberPlus1() {
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
        var res = 32456.224
        XCTAssertEqual(debugBrain.double, res)
        
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
        debugBrain.push("+")
        debugBrain.push(3)
        debugBrain.push("=")
        res += 3.0
        XCTAssertEqual(debugBrain.double, res)
    }
    
    func test_add() {
        /// 1+2+5+2= + 1/4 =
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 3.0)

        debugBrain.push(1.43)
        debugBrain.push("+")
        debugBrain.push(2.11)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 3.54)

        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push(-5)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, -4.0)

        debugBrain.push(-1)
        debugBrain.push("+")
        debugBrain.push(-2)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, -3.0)

        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("+")
        debugBrain.push(5)
        debugBrain.push("+")
        XCTAssertEqual(debugBrain.double, 8.0)

        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("+")
        debugBrain.push(5)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 10.0)

        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("+")
        debugBrain.push(5)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("=")
        debugBrain.push("+")
        debugBrain.push(4)
        debugBrain.push("One_x")
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 10.25)
    }
    
    func test_addFractions() {
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push(0)
        debugBrain.push("One_x")
        debugBrain.push("+")
        debugBrain.push(1)
        debugBrain.push(6)
        debugBrain.push("One_x")
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, (1.0 / 10.0) + (1.0 / 16.0))
    }

    func test_minus() {
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("-")
        debugBrain.push(5)
        debugBrain.push("-")
        debugBrain.push(8)
        debugBrain.push("=")
        debugBrain.push("-")
        debugBrain.push(4)
        debugBrain.push("One_x")
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, -10.25)
        
        debugBrain.push(-1)
        debugBrain.push("-")
        debugBrain.push(-3)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 2.0)

        debugBrain.push(1)
        debugBrain.push("-")
        debugBrain.push(-3)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 4.0)

        debugBrain.push(3.332)
        debugBrain.push("-")
        debugBrain.push(1.111)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 2.221)

        debugBrain.push(1.332)
        debugBrain.push("-")
        debugBrain.push(-3.111)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 4.443)

        debugBrain.push(-1.332)
        debugBrain.push("-")
        debugBrain.push(3.111)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, -4.443)
    }

    func test_mul() {
        debugBrain.push("AC")
        debugBrain.push(7)
        debugBrain.push("x")
        debugBrain.push(8)
        debugBrain.push("x")
        XCTAssertEqual(debugBrain.double, 56.0)
        debugBrain.push("2")
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 112.0)
    }
    
    func test_div() {
        var res: Double
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("One_x")
        res = 1.0 / 3.0
        XCTAssertEqual(debugBrain.double, res)
        
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("/")
        debugBrain.push(7)
        debugBrain.push("=")
        res = 1.0 / 7.0
        XCTAssertEqual(debugBrain.double, res)

        debugBrain.push("AC")
        debugBrain.push(7)
        debugBrain.push("One_x")
        res = 1.0 / 7.0
        XCTAssertEqual(debugBrain.double, res)
        
        debugBrain.push("AC")
        debugBrain.push(7)
        debugBrain.push("One_x")
        debugBrain.push("x")
        debugBrain.push(7)
        debugBrain.push("=")
        res = 1.0
        XCTAssertEqual(debugBrain.double, res)
        
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("/")
        debugBrain.push(-7)
        debugBrain.push("=")
        res = 1.0 / -7.0
        XCTAssertEqual(debugBrain.double, res)

        debugBrain.push("AC")
        debugBrain.push(-1)
        debugBrain.push("/")
        debugBrain.push(-7)
        debugBrain.push("=")
        res = -1.0 / -7.0
        XCTAssertEqual(debugBrain.double, res)

        debugBrain.push("AC")
        debugBrain.push(0)
        debugBrain.push("/")
        debugBrain.push(7)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 0.0)

        debugBrain.push("AC")
        debugBrain.push(0)
        debugBrain.push("/")
        debugBrain.push(-7)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 0.0)
    }
    
    func test_negativeDiv() {
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("±")
        debugBrain.push("One_x")
        var res = -1.0 / 3.0
        XCTAssertEqual(debugBrain.double, res)
        
        debugBrain.push("AC")
        debugBrain.push(3)
        debugBrain.push("One_x")
        debugBrain.push("±")
        res = -1.0 / 3.0
        XCTAssertEqual(debugBrain.double, res)
        
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("±")
        debugBrain.push("/")
        debugBrain.push(7)
        debugBrain.push("=")
        res = -1.0 / 7.0
        XCTAssertEqual(debugBrain.double, res)
        
        debugBrain.push("AC")
        debugBrain.push(7)
        debugBrain.push("±")
        debugBrain.push("One_x")
        res = -1.0 / 7.0
        XCTAssertEqual(debugBrain.double, res)
        
        debugBrain.push("AC")
        debugBrain.push(7)
        debugBrain.push("±")
        debugBrain.push("One_x")
        debugBrain.push("x")
        debugBrain.push(7)
        debugBrain.push("=")
        res = -1.0
        XCTAssertEqual(debugBrain.double, res)
    }
    
    func test_divByZero() {
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("/")
        debugBrain.push(0)
        debugBrain.push("=")
        XCTAssertNil(debugBrain.last.str)
        XCTAssertNotNil(debugBrain.last.gmp)
        XCTAssertTrue(debugBrain.last.gmp!.inf)
        XCTAssertFalse(debugBrain.last.gmp!.NaN)
        XCTAssertFalse(debugBrain.last.gmp!.isValid)
        
        debugBrain.push("AC")
        debugBrain.push("π")
        debugBrain.push("/")
        debugBrain.push(0)
        debugBrain.push("=")
        XCTAssertNil(debugBrain.last.str)
        XCTAssertNotNil(debugBrain.last.gmp)
        XCTAssertTrue(debugBrain.last.gmp!.inf)
        XCTAssertFalse(debugBrain.last.gmp!.NaN)
        XCTAssertFalse(debugBrain.last.gmp!.isValid)
        
        debugBrain.push("AC")
        debugBrain.push("π")
        debugBrain.last.changeSign()
        debugBrain.push("/")
        debugBrain.push(0)
        debugBrain.push("=")
        XCTAssertNil(debugBrain.last.str)
        XCTAssertNotNil(debugBrain.last.gmp)
        XCTAssertTrue(debugBrain.last.gmp!.inf)
        XCTAssertFalse(debugBrain.last.gmp!.NaN)
        XCTAssertFalse(debugBrain.last.gmp!.isValid)
        
        debugBrain.push("AC")
        debugBrain.push(0)
        debugBrain.push("/")
        debugBrain.push(0)
        debugBrain.push("=")
        XCTAssertNil(debugBrain.last.str)
        XCTAssertNotNil(debugBrain.last.gmp)
        XCTAssertTrue(debugBrain.last.gmp!.NaN)
        XCTAssertFalse(debugBrain.last.gmp!.inf)
        XCTAssertFalse(debugBrain.last.gmp!.isValid)
    }
    
    func test_negativeZero() {
        debugBrain.push("AC")
        debugBrain.push(0)
        debugBrain.push("±")
        XCTAssertEqual(debugBrain.double, 0.0)
        
        debugBrain.push("AC")
        debugBrain.push(0)
        debugBrain.push("±")
        debugBrain.push("x^2")
        XCTAssertEqual(debugBrain.double, 0.0)
    }
    
    func test_negativeDivByZero() {
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("±")
        debugBrain.push("/")
        debugBrain.push(0)
        debugBrain.push("=")
        XCTAssertNil(debugBrain.last.str)
        XCTAssertNotNil(debugBrain.last.gmp)
        XCTAssertTrue(debugBrain.last.gmp!.inf)
        XCTAssertFalse(debugBrain.last.gmp!.NaN)
        XCTAssertFalse(debugBrain.last.gmp!.isValid)
        
        debugBrain.push("AC")
        debugBrain.push("π")
        debugBrain.push("±")
        debugBrain.push("/")
        debugBrain.push(0)
        debugBrain.push("=")
        XCTAssertNil(debugBrain.last.str)
        XCTAssertNotNil(debugBrain.last.gmp)
        XCTAssertTrue(debugBrain.last.gmp!.inf)
        XCTAssertFalse(debugBrain.last.gmp!.NaN)
        XCTAssertFalse(debugBrain.last.gmp!.isValid)
        
        debugBrain.push("AC")
        debugBrain.push("π")
        debugBrain.last.changeSign()
        debugBrain.push("/")
        debugBrain.push(0)
        debugBrain.push("=")
        XCTAssertNil(debugBrain.last.str)
        XCTAssertNotNil(debugBrain.last.gmp)
        XCTAssertTrue(debugBrain.last.gmp!.inf)
        XCTAssertFalse(debugBrain.last.gmp!.NaN)
        XCTAssertFalse(debugBrain.last.gmp!.isValid)
        
        debugBrain.push("AC")
        debugBrain.push(0)
        debugBrain.push("±")
        debugBrain.push("/")
        debugBrain.push(0)
        debugBrain.push("=")
        XCTAssertNil(debugBrain.last.str)
        XCTAssertNotNil(debugBrain.last.gmp)
        XCTAssertFalse(debugBrain.last.gmp!.inf)
        XCTAssertTrue(debugBrain.last.gmp!.NaN)
        XCTAssertFalse(debugBrain.last.gmp!.isValid)
    }
    
    func test_precentage() {
        debugBrain.push("AC")
        debugBrain.push("9")
        debugBrain.push("%")
        XCTAssertEqual(debugBrain.double, 0.09)
        
        debugBrain.push("AC")
        debugBrain.push("9")
        debugBrain.push("%")
        debugBrain.push("%")
        XCTAssertEqual(debugBrain.double, 0.0009)
        
        debugBrain.push("AC")
        debugBrain.push("9")
        debugBrain.push("%")
        debugBrain.push("%")
        debugBrain.push("%")
        debugBrain.push("%")
        XCTAssertEqual(debugBrain.double, 0.00000009)
        
        debugBrain.push("AC")
        debugBrain.push("9")
        debugBrain.push("%")
        debugBrain.push("%")
        debugBrain.push("%")
        debugBrain.push("%")
        debugBrain.push("x^2")
        XCTAssertEqual(debugBrain.double, 8.1e-15)
        
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

    }
    
    func test_fractions() {
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push(0)
        XCTAssertEqual(debugBrain.double, 10.0)
        
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push(0)
        debugBrain.push("One_x")
        XCTAssertEqual(debugBrain.double, 0.1)
        
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push(6)
        debugBrain.push("One_x")
        XCTAssertEqual(debugBrain.double, 1.0 / 16.0)
    }
        
    func test_operationPriority() {
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push(2)
        debugBrain.push("x")
        debugBrain.push(4)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 9.0)
        
        debugBrain.push("AC")
        debugBrain.push(2)
        debugBrain.push("x")
        debugBrain.push(3)
        debugBrain.push("x")
        debugBrain.push(4)
        debugBrain.push("x")
        debugBrain.push(5)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 120.0)
        XCTAssertEqual(debugBrain.double, 2.0*3.0*4.0*5.0)
        
        debugBrain.push("AC")
        debugBrain.push(2)
        debugBrain.push("x")
        debugBrain.push(3)
        debugBrain.push("+")
        debugBrain.push(4)
        debugBrain.push("x")
        debugBrain.push(5)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 26.0)
        XCTAssertEqual(debugBrain.double, 2.0*3.0 + 4.0*5.0)

        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push("+")
        debugBrain.push(7)
        debugBrain.push("x")
        debugBrain.push(7)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 50.0)
    }
    
    func test_x_pow_y() {
        debugBrain.push("AC")
        debugBrain.push(2)
        debugBrain.push("x^y")
        debugBrain.push(1)
        debugBrain.push(0)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 1024.0)
        
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
        XCTAssertEqual(debugBrain.double, 41.0)

    }
    
    func test_y_pow_x() {
        debugBrain.push("AC")
        debugBrain.push(1)
        debugBrain.push(0)
        debugBrain.push("y^x")
        debugBrain.push(2)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 1024.0)
    }

    func test_parenthesis() {
        debugBrain.push("AC")
        debugBrain.push(2)
        debugBrain.push("x")
        debugBrain.push("( ")
        debugBrain.push(6)
        debugBrain.push("+")
        debugBrain.push(4)
        debugBrain.push(" )")
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 20.0)
        
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
        XCTAssertEqual(debugBrain.double, 2.0 * ( 6.0 + 4.0 * ( 5.0 + 9.0)))
        XCTAssertEqual(debugBrain.double, 124.0)
    }
    
    func test_EE() {
        debugBrain.push("AC")
        debugBrain.push(0.01)
        debugBrain.push("/")
        debugBrain.push(1)
        debugBrain.push("EE")
        debugBrain.push(4)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 0.000001)
    }
    
    func test_root() {
        debugBrain.push("AC")
        debugBrain.push("2")
        XCTAssertEqual(debugBrain.double, 2.0)
        debugBrain.push("√")
        XCTAssertEqual(debugBrain.double, 1.4142135623730950488)
    }

    func test_square() {
        debugBrain.push("AC")
        debugBrain.push("2")
        XCTAssertEqual(debugBrain.double, 2.0)
        debugBrain.push("√")
        XCTAssertEqual(debugBrain.double, 1.4142135623730950488)
        debugBrain.push("x^2")
        XCTAssertEqual(debugBrain.double, 2.0)

        debugBrain.push("AC")
        debugBrain.push("100")
        debugBrain.push("x^2")
        XCTAssertEqual(debugBrain.double, 10_000.0)
    }

    func test_rootOfNegativeNumber() {
        debugBrain.push("AC")
        debugBrain.push(-2)
        debugBrain.push("√")
        XCTAssertNil(debugBrain.last.str)
        XCTAssertNotNil(debugBrain.last.gmp)
        XCTAssertTrue(debugBrain.last.gmp!.NaN)
        XCTAssertFalse(debugBrain.last.gmp!.inf)
        XCTAssertFalse(debugBrain.last.gmp!.isValid)
    }
    
    func test_oddRootOfNegativeNumber() {
        /// roots of negative numbers generally result in NAN
        /// There is an exception: if the root is an integer and odd, the root of negative number are implemented as special case in BrainEngine.execute
        debugBrain.push("AC")
        debugBrain.push(-8)
        debugBrain.push("y√")
        debugBrain.push(3)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, -2.0)

        debugBrain.push("AC")
        debugBrain.push(-8)
        debugBrain.push("3√")
        XCTAssertEqual(debugBrain.double, -2.0)

        debugBrain.push("AC")
        debugBrain.push(-8)
        debugBrain.push("y√")
        debugBrain.push(4)
        debugBrain.push("=")
        XCTAssertTrue(debugBrain.last.gmp!.NaN)

        debugBrain.push("AC")
        debugBrain.push(-8)
        debugBrain.push("y√")
        debugBrain.push(5)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, -1.515716566510398)
    }
    
    func test_changeOperand() {
        /// change operand
        debugBrain.push("AC")
        debugBrain.push(5)
        debugBrain.push("+")
        debugBrain.push("x")
        debugBrain.push(4)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 20.0)
        
        /// change twoOperand
        debugBrain.push("AC")
        debugBrain.push(5)
        debugBrain.push("y√")
        debugBrain.push("x^y")
        debugBrain.push(3)
        debugBrain.push("=")
        XCTAssertEqual(debugBrain.double, 125.0)
    }
    
    func test_trigonometic() {
        debugBrain.push("AC")
        debugBrain.push(30)
        debugBrain.push("sinD")
        XCTAssertEqual(debugBrain.double, 0.5)
        
        let precision = 0.0000001
        
        let angles = [0.0, 30.0, 45.0, 60.0, 90.0] // degrees
        let radians = [0.0, Double.pi / 6.0, Double.pi / 4.0, Double.pi / 3.0, Double.pi / 2.0]
        let expectedSin = [0.0, 0.5, 1.0/sqrt(2.0), sqrt(3.0)/2.0, 1.0]
        let expectedCos = [1.0, sqrt(3.0)/2.0, 1.0/sqrt(2.0), 0.5, 0.0]
        let expectedTan = [0.0, 1.0/sqrt(3.0), 1.0, sqrt(3)] // one less value
        for i in 0..<angles.count {
            debugBrain.push(angles[i])
            debugBrain.push("sinD")
            XCTAssertEqual(debugBrain.double, expectedSin[i], accuracy: precision)

            debugBrain.push(radians[i])
            debugBrain.push("sin")
            XCTAssertEqual(debugBrain.double, expectedSin[i], accuracy: precision)

            debugBrain.push(angles[i])
            debugBrain.push("cosD")
            XCTAssertEqual(debugBrain.double, expectedCos[i], accuracy: precision)

            debugBrain.push(radians[i])
            debugBrain.push("cos")
            XCTAssertEqual(debugBrain.double, expectedCos[i], accuracy: precision)
        }
        
        for i in 0..<angles.count-1 {
            debugBrain.push(angles[i])
            debugBrain.push("tanD")
            XCTAssertEqual(debugBrain.double, expectedTan[i], accuracy: precision)

            debugBrain.push(radians[i])
            debugBrain.push("tan")
            XCTAssertEqual(debugBrain.double, expectedTan[i], accuracy: precision)
        }
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
