//
//  BrainTests.swift
//  BrainTests
//
//  Created by Joachim Neumann on 28/09/2021.
//

import XCTest
@testable import Calculator

class BrainTests: XCTestCase {
    let brain = Brain()
    
    func test() throws {
        // clear
        brain.reset()
        XCTAssertEqual(brain.gmpStack.count, 1)
        XCTAssertEqual(brain.operatorStack.count, 0)
        
        
        // 1/10 and 1/16
        brain.addDigitToNumberString("1")
        brain.addDigitToNumberString("0")
        brain.operation("oneOverX")
        XCTAssertEqual(brain.gmpStack.last!, Gmp("0.1"))
        brain.addDigitToNumberString("1")
        XCTAssertEqual(brain.gmpStack.last!, Gmp("1"))
        brain.addDigitToNumberString("6")
        XCTAssertEqual(brain.gmpStack.last!, Gmp("16"))
        brain.operation("oneOverX")
        XCTAssertEqual(brain.gmpStack.last!, Gmp("0.0625"))
        
        // clear
        brain.reset()
        
        // 1+2+5+2= + 1/4 =
        brain.addDigitToNumberString("1")
        XCTAssertEqual(brain.gmpStack.last, Gmp("1"))
        brain.operation("+")
        XCTAssertEqual(brain.gmpStack.last, Gmp("1"))
        brain.addDigitToNumberString("2")
        brain.operation("+")
        XCTAssertEqual(brain.gmpStack.last, Gmp("3"))
        brain.addDigitToNumberString("5")
        brain.operation("+")
        XCTAssertEqual(brain.gmpStack.last, Gmp("8"))
        brain.addDigitToNumberString("2")
        brain.operation("=")
        XCTAssertEqual(brain.gmpStack.last, Gmp("10"))
        brain.operation("+")
        XCTAssertEqual(brain.gmpStack.last, Gmp("10"))
        brain.addDigitToNumberString("4")
        brain.operation("oneOverX")
        XCTAssertEqual(brain.gmpStack.last, Gmp("0.25"))
        brain.operation("=")
        XCTAssertEqual(brain.gmpStack.last, Gmp("10.25"))
        
        // 1+2*4=
        brain.reset()
        brain.addDigitToNumberString("1")
        XCTAssertEqual(brain.gmpStack.last, Gmp("1"))
        brain.operation("+")
        brain.addDigitToNumberString("2")
        brain.operation("x")
        XCTAssertEqual(brain.gmpStack.last, Gmp("2"))
        brain.addDigitToNumberString("4")
        XCTAssertEqual(brain.gmpStack.last, Gmp("4"))
        brain.operation("=")
        XCTAssertEqual(brain.gmpStack.last, Gmp("9"))

        // 2*3*4*5=
        brain.reset()
        brain.addDigitToNumberString("2")
        XCTAssertEqual(brain.gmpStack.last, Gmp("2"))
        brain.operation("x")
        brain.addDigitToNumberString("3")
        XCTAssertEqual(brain.gmpStack.last, Gmp("3"))
        brain.operation("x")
        XCTAssertEqual(brain.gmpStack.last, Gmp("6"))
        brain.addDigitToNumberString("4")
        brain.operation("x")
        XCTAssertEqual(brain.gmpStack.last, Gmp("24"))
        brain.addDigitToNumberString("5")
        brain.operation("=")
        XCTAssertEqual(brain.gmpStack.last, Gmp("120"))

        // 1+2*4
        brain.reset()
        brain.addDigitToNumberString("1")
        XCTAssertEqual(brain.gmpStack.last, Gmp("1"))
        brain.operation("+")
        brain.addDigitToNumberString("2")
        brain.operation("x")
        XCTAssertEqual(brain.gmpStack.last, Gmp("2"))
        brain.addDigitToNumberString("4")
        XCTAssertEqual(brain.gmpStack.last, Gmp("4"))
        brain.operation("+")
        XCTAssertEqual(brain.gmpStack.last, Gmp("9"))
        brain.addDigitToNumberString("1")
        brain.addDigitToNumberString("0")
        brain.addDigitToNumberString("0")
        XCTAssertEqual(brain.gmpStack.last, Gmp("100"))
        // User: =
        brain.operation("=")
        XCTAssertEqual(brain.gmpStack.last, Gmp("109"))
        
        brain.reset()
        brain.operation("π")
        brain.operation("x")
        brain.addDigitToNumberString("2")
        brain.operation("=")
        
        brain.reset()
        brain.addDigitToNumberString("2")
        brain.operation("x^y")
        brain.addDigitToNumberString("1")
        brain.addDigitToNumberString("0")
        brain.operation("=")
        XCTAssertEqual(brain.gmpStack.last, Gmp("1024"))

        brain.reset()
        brain.addDigitToNumberString("1")
        brain.addDigitToNumberString("0")
        brain.operation("y^x")
        brain.addDigitToNumberString("2")
        brain.operation("=")
        XCTAssertEqual(brain.gmpStack.last, Gmp("1024"))
        
        // 2x(6+4)
        brain.reset()
        brain.addDigitToNumberString("2")
        XCTAssertEqual(brain.gmpStack.last, Gmp("2"))
        XCTAssertEqual(brain.operatorStack.count, 0)
        brain.operation("x")
        XCTAssertEqual(brain.operatorStack.count, 1)
        brain.operation("(")
        XCTAssertEqual(brain.operatorStack.count, 2)
        brain.addDigitToNumberString("6")
        XCTAssertEqual(brain.gmpStack.last, Gmp("6"))
        XCTAssertEqual(brain.gmpStack.count, 2)
        brain.operation("+")
        XCTAssertEqual(brain.operatorStack.count, 3)
        brain.addDigitToNumberString("4")
        XCTAssertEqual(brain.gmpStack.last, Gmp("4"))
        XCTAssertEqual(brain.gmpStack.count, 3)
        brain.operation(")")
        XCTAssertEqual(brain.operatorStack.count, 1)
        XCTAssertEqual(brain.gmpStack.count, 2)
        XCTAssertEqual(brain.gmpStack.last, Gmp("10"))
        brain.operation("=")
        XCTAssertEqual(brain.gmpStack.last, Gmp("20"))

        // 2x(6+4*(5+9))
        brain.reset()
        brain.addDigitToNumberString("2")
        brain.operation("x")
        brain.operation("(")
        brain.addDigitToNumberString("6")
        brain.operation("+")
        brain.addDigitToNumberString("4")
        brain.operation("x")
        brain.operation("(")
        brain.addDigitToNumberString("5")
        brain.operation("+")
        brain.addDigitToNumberString("9")
        brain.operation(")")
        brain.operation(")")
        brain.operation("=")
        XCTAssertEqual(brain.gmpStack.last, Gmp("124"))

        
    }
    
    //    func testPerformanceExample() throws {
    //        // This is an example of a performance test case.
    //        measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
