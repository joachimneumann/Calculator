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
        /// 0
        brain.reset()
        XCTAssertEqual(brain.display, "0")
        brain.zero()
        XCTAssertEqual(brain.display, "0")

        /// 0,0000010
        brain.reset()
        brain.zero()
        XCTAssertEqual(brain.display, "0")
        brain.comma()
        XCTAssertEqual(brain.display, "0,")
        brain.zero()
        XCTAssertEqual(brain.display, "0,0")
        brain.zero()
        brain.zero()
        brain.zero()
        brain.zero()
        XCTAssertEqual(brain.display, "0,00000")
        brain.digit(1)
        XCTAssertEqual(brain.display, "0,000001")
        brain.zero()
        XCTAssertEqual(brain.display, "0,0000010")

        /// reset
        brain.reset()
        XCTAssertEqual(brain.display, "0")

        /// 1 e -11
        brain.reset()
        brain.comma()
        XCTAssertEqual(brain.display, "0,")
        var res = "0,"
        for _ in 1..<Configuration.shared.digitsInSmallDisplay-1 {
            res += "0"
            brain.zero()
            XCTAssertEqual(brain.display, res)
        }
        brain.digit(1)
        XCTAssertEqual(brain.display, "1,0 e-\(Configuration.shared.digitsInSmallDisplay-1)")

        /// 32456.2244
        brain.reset()
        XCTAssertEqual(brain.display, "0")
        brain.digit(3)
        brain.digit(2)
        brain.digit(4)
        brain.digit(5)
        brain.digit(6)
        brain.comma()
        brain.digit(2)
        brain.digit(2)
        brain.digit(4)
        brain.digit(4)
        res = "32456,2244"
        XCTAssertEqual(brain.display, "32456,2244")
        
        /// 32456.2244333333333333333333333333
        for _ in res.count..<Configuration.shared.digitsInSmallDisplay+20 {
            res += "3"
            brain.digit(3)
            /// prefix + 1 for the comma
            XCTAssertEqual(brain.display, String(res.prefix(Configuration.shared.digitsInSmallDisplay+1)))
        }

        /// pi
        brain.reset()
        brain.operation("π")
        XCTAssertEqual(brain.last.gmp.toDouble(), Double.pi)
        XCTAssertEqual(brain.display, String("3,1415926535897932384626433832795028841971".prefix(Configuration.shared.digitsInSmallDisplay+1)))

        /// 1+pi
        brain.reset()
        brain.digit(1)
        XCTAssertEqual(brain.display, "1")
        XCTAssertEqual(brain.last.gmp.toDouble(), 1.0)
        brain.operation("+")
        XCTAssertEqual(brain.display, "1")
        XCTAssertEqual(brain.last.gmp.toDouble(), 1.0)
        brain.operation("π")
        XCTAssertEqual(brain.last.gmp.toDouble(), Double.pi)
        XCTAssertEqual(brain.display, String("3,1415926535897932384626433832795028841971".prefix(Configuration.shared.digitsInSmallDisplay+1)))
        brain.operation("=")
        XCTAssertEqual(brain.last.gmp.toDouble(), 1.0+Double.pi)
        XCTAssertEqual(brain.display, String("4,1415926535897932384626433832795028841971".prefix(Configuration.shared.digitsInSmallDisplay+1)))

        /// 1/10 and 1/16
        brain.reset()
        brain.digit(1)
        brain.zero()
        XCTAssertEqual(brain.last.gmp.toDouble(), 10.0)
        XCTAssertEqual(brain.display, "10")
        brain.operation("One_x")
        XCTAssertEqual(brain.last.gmp.toDouble(), 0.1)
        brain.digit(1)
        brain.digit(6)
        XCTAssertEqual(brain.last.gmp.toDouble(), 16.0)
        brain.operation("One_x")
        XCTAssertEqual(brain.last.gmp.toDouble(), 0.0625)
        
        /// 1+2+5+2= + 1/4 =
        brain.digit(1)
        XCTAssertEqual(brain.last.gmp, Gmp("1"))
        brain.operation("+")
        XCTAssertEqual(brain.last.gmp, Gmp("1"))
        brain.digit(2)
        brain.operation("+")
        XCTAssertEqual(brain.last.gmp, Gmp("3"))
        brain.digit(5)
        brain.operation("+")
        XCTAssertEqual(brain.last.gmp, Gmp("8"))
        brain.digit(2)
        brain.operation("=")
        XCTAssertEqual(brain.last.gmp, Gmp("10"))
        brain.operation("+")
        XCTAssertEqual(brain.last.gmp, Gmp("10"))
        brain.digit(4)
        brain.operation("One_x")
        XCTAssertEqual(brain.last.gmp, Gmp("0.25"))
        brain.operation("=")
        XCTAssertEqual(brain.last.gmp, Gmp("10.25"))
        
        /// 1+2*4=
        brain.reset()
        brain.digit(1)
        XCTAssertEqual(brain.last.gmp, Gmp("1"))
        brain.operation("+")
        brain.digit(2)
        brain.operation("x")
        XCTAssertEqual(brain.last.gmp, Gmp("2"))
        brain.digit(4)
        XCTAssertEqual(brain.last.gmp, Gmp("4"))
        brain.operation("=")
        XCTAssertEqual(brain.last.gmp, Gmp("9"))

        /// 2*3*4*5=
        brain.reset()
        brain.digit(2)
        XCTAssertEqual(brain.last.gmp, Gmp("2"))
        brain.operation("x")
        brain.digit(3)
        XCTAssertEqual(brain.last.gmp, Gmp("3"))
        brain.operation("x")
        XCTAssertEqual(brain.last.gmp, Gmp("6"))
        brain.digit(4)
        brain.operation("x")
        XCTAssertEqual(brain.last.gmp, Gmp("24"))
        brain.digit(5)
        brain.operation("=")
        XCTAssertEqual(brain.last.gmp, Gmp("120"))

        /// 1+2*4
        brain.reset()
        brain.digit(1)
        XCTAssertEqual(brain.last.gmp, Gmp("1"))
        brain.operation("+")
        brain.digit(2)
        brain.operation("x")
        XCTAssertEqual(brain.last.gmp, Gmp("2"))
        brain.digit(4)
        XCTAssertEqual(brain.last.gmp, Gmp("4"))
        brain.operation("+")
        XCTAssertEqual(brain.last.gmp, Gmp("9"))
        brain.digit(1)
        brain.zero()
        brain.zero()
        XCTAssertEqual(brain.last.gmp, Gmp("100"))
        /// User: =
        brain.operation("=")
        XCTAssertEqual(brain.last.gmp, Gmp("109"))
        
        brain.reset()
        brain.operation("π")
        brain.operation("x")
        brain.digit(2)
        brain.operation("=")
        
        brain.reset()
        brain.digit(2)
        brain.operation("x^y")
        brain.digit(1)
        brain.zero()
        brain.operation("=")
        XCTAssertEqual(brain.last.gmp, Gmp("1024"))

        brain.reset()
        brain.digit(1)
        brain.zero()
        brain.operation("y^x")
        brain.digit(2)
        brain.operation("=")
        XCTAssertEqual(brain.last.gmp, Gmp("1024"))
        
        /// 2x(6+4)
        brain.reset()
        brain.digit(2)
        XCTAssertEqual(brain.last.gmp, Gmp("2"))
        XCTAssertEqual(brain.operatorStack.count, 0)
        brain.operation("x")
        XCTAssertEqual(brain.operatorStack.count, 1)
        brain.operation("(")
        XCTAssertEqual(brain.operatorStack.count, 2)
        brain.digit(6)
        XCTAssertEqual(brain.last.gmp, Gmp("6"))
        XCTAssertEqual(brain.nn, 2)
        brain.operation("+")
        XCTAssertEqual(brain.operatorStack.count, 3)
        brain.digit(4)
        XCTAssertEqual(brain.last.gmp, Gmp("4"))
        XCTAssertEqual(brain.nn, 3)
        brain.operation(")")
        XCTAssertEqual(brain.operatorStack.count, 1)
        XCTAssertEqual(brain.nn, 2)
        XCTAssertEqual(brain.last.gmp, Gmp("10"))
        brain.operation("=")
        XCTAssertEqual(brain.last.gmp, Gmp("20"))

        /// 2x(6+4*(5+9))
        brain.reset()
        brain.digit(2)
        brain.operation("x")
        brain.operation("(")
        brain.digit(6)
        brain.operation("+")
        brain.digit(4)
        brain.operation("x")
        brain.operation("(")
        brain.digit(5)
        brain.operation("+")
        brain.digit(9)
        brain.operation(")")
        brain.operation(")")
        brain.operation("=")
        XCTAssertEqual(brain.last.gmp, Gmp("124"))

        /// 1+2=3
        brain.reset()
        brain.digit(1)
        brain.operation("+")
        brain.digit(2)
        brain.operation("=")
        brain.digit(2)
        XCTAssertEqual(brain.nn, 1)
        
        brain.reset()
        brain.operation("π")
        XCTAssertEqual(brain.last.gmp.toDouble(), 3.14159265358979, accuracy: 0.00000001)

        brain.reset()
        brain.zero()
        brain.comma()
        brain.zero()
        brain.digit(1)
        brain.operation("/")
        brain.digit(1)
        brain.operation("EE")
        brain.digit(4)
        XCTAssertEqual(brain.last.gmp.toDouble(), 0.000001)

    }
    
    //    func testPerformanceExample() throws {
    //        // This is an example of a performance test case.
    //        measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
