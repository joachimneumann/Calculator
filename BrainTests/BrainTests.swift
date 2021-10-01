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

        // 12
        brain.reset()
        XCTAssertEqual(brain.display, "0")
        brain.digit(1)
        XCTAssertEqual(brain.display, "1")
        brain.digit(2)
        XCTAssertEqual(brain.display, "12")

        // 01
        brain.reset()
        XCTAssertEqual(brain.display, "0")
        brain.zero()
        XCTAssertEqual(brain.display, "0")
        brain.digit(1)
        XCTAssertEqual(brain.display, "1")

        /// 1234567890123456
        brain.reset()
        brain.digit(1)
        brain.digit(2)
        brain.digit(3)
        brain.digit(4)
        brain.digit(5)
        brain.digit(6)
        brain.digit(7)
        brain.digit(8)
        brain.digit(9)
        brain.zero()
        brain.digit(1)
        brain.digit(2)
        brain.digit(3)
        brain.digit(4)
        brain.digit(5)
        XCTAssertEqual(brain.display, "123456789012345")
        brain.digit(6)
        XCTAssertEqual(brain.display, "1234567890123456")
        brain.digit(7)
        XCTAssertEqual(brain.display, "1,234567890123 e16")

        
        /// memory
        brain.reset()
        brain.digit(1)
        brain.digit(2)
        XCTAssertEqual(brain.display, "12")
        brain.clearMemory()
        XCTAssertEqual(brain.display, "12")
        brain.addToMemory()
        XCTAssertEqual(brain.display, "12")
        brain.addToMemory()
        XCTAssertEqual(brain.display, "12")
        brain.getMemory()
        XCTAssertEqual(brain.display, "24")
        brain.subtractFromMemory()
        XCTAssertEqual(brain.display, "24")
        brain.getMemory()
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
        for _ in 1..<Configuration.digitsInSmallDisplay-1 {
            res += "0"
            brain.zero()
            XCTAssertEqual(brain.display, res)
        }
        brain.digit(1)
        XCTAssertEqual(brain.display, "1,0 e-\(Configuration.digitsInSmallDisplay-1)")

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
        for _ in res.count..<Configuration.digitsInSmallDisplay+20 {
            res += "3"
            brain.digit(3)
            /// prefix + 1 for the comma
            XCTAssertEqual(brain.display, String(res.prefix(Configuration.digitsInSmallDisplay+1)))
        }

        /// 1/7*7 --> has more digits?
        brain.reset()
        brain.digit(7)
        brain.operationWorker("One_x")
        brain.operationWorker("x")
        brain.digit(7)
        brain.operationWorker("=")
        XCTAssertEqual(brain.display, "1")
        XCTAssertEqual(brain.hasMoreDigits, false)

        /// 9 %%%% ^2 ^2 ^2
        brain.reset()
        brain.digit(9)
        brain.operationWorker("%")
        XCTAssertEqual(brain.display, "0,09")
        brain.operationWorker("%")
        XCTAssertEqual(brain.display, "0,0009")
        brain.operationWorker("%")
        brain.operationWorker("%")
        brain.operationWorker("x^2")
        brain.operationWorker("x^2")
        brain.operationWorker("x^2")

        /// pi
        brain.reset()
        brain.operationWorker("π")
        let correct = "3,1415926535897932384626433832795028841971"
        XCTAssertEqual(brain.last.gmp.toDouble(), Double.pi)
        XCTAssertEqual(brain.display, String(correct.prefix(Configuration.digitsInSmallDisplay+1)))
        let c = brain.combinedLongDisplayString(longDisplayString: brain.longDisplayString)
        XCTAssertEqual(String(c.prefix(correct.count)), correct)

        /// 1+pi
        brain.reset()
        brain.digit(1)
        XCTAssertEqual(brain.display, "1")
        XCTAssertEqual(brain.last.gmp.toDouble(), 1.0)
        brain.operationWorker("+")
        XCTAssertEqual(brain.display, "1")
        XCTAssertEqual(brain.last.gmp.toDouble(), 1.0)
        brain.operationWorker("π")
        XCTAssertEqual(brain.last.gmp.toDouble(), Double.pi)
        XCTAssertEqual(brain.display, String("3,1415926535897932384626433832795028841971".prefix(Configuration.digitsInSmallDisplay+1)))
        brain.operationWorker("=")
        XCTAssertEqual(brain.last.gmp.toDouble(), 1.0+Double.pi)
        XCTAssertEqual(brain.display, String("4,1415926535897932384626433832795028841971".prefix(Configuration.digitsInSmallDisplay+1)))

        /// 1/10 and 1/16
        brain.reset()
        brain.digit(1)
        brain.zero()
        XCTAssertEqual(brain.last.gmp.toDouble(), 10.0)
        XCTAssertEqual(brain.display, "10")
        brain.operationWorker("One_x")
        XCTAssertEqual(brain.last.gmp.toDouble(), 0.1)
        brain.digit(1)
        brain.digit(6)
        XCTAssertEqual(brain.last.gmp.toDouble(), 16.0)
        brain.operationWorker("One_x")
        XCTAssertEqual(brain.last.gmp.toDouble(), 0.0625)
        
        /// 1+2+5+2= + 1/4 =
        brain.digit(1)
        XCTAssertEqual(brain.last.gmp, Gmp("1"))
        brain.operationWorker("+")
        XCTAssertEqual(brain.last.gmp, Gmp("1"))
        brain.digit(2)
        brain.operationWorker("+")
        XCTAssertEqual(brain.last.gmp, Gmp("3"))
        brain.digit(5)
        brain.operationWorker("+")
        XCTAssertEqual(brain.last.gmp, Gmp("8"))
        brain.digit(2)
        brain.operationWorker("=")
        XCTAssertEqual(brain.last.gmp, Gmp("10"))
        brain.operationWorker("+")
        XCTAssertEqual(brain.last.gmp, Gmp("10"))
        brain.digit(4)
        brain.operationWorker("One_x")
        XCTAssertEqual(brain.last.gmp, Gmp("0.25"))
        brain.operationWorker("=")
        XCTAssertEqual(brain.last.gmp, Gmp("10.25"))
        
        /// 1+2*4=
        brain.reset()
        brain.digit(1)
        XCTAssertEqual(brain.last.gmp, Gmp("1"))
        brain.operationWorker("+")
        brain.digit(2)
        brain.operationWorker("x")
        XCTAssertEqual(brain.last.gmp, Gmp("2"))
        brain.digit(4)
        XCTAssertEqual(brain.last.gmp, Gmp("4"))
        brain.operationWorker("=")
        XCTAssertEqual(brain.last.gmp, Gmp("9"))

        /// 2*3*4*5=
        brain.reset()
        brain.digit(2)
        XCTAssertEqual(brain.last.gmp, Gmp("2"))
        brain.operationWorker("x")
        brain.digit(3)
        XCTAssertEqual(brain.last.gmp, Gmp("3"))
        brain.operationWorker("x")
        XCTAssertEqual(brain.last.gmp, Gmp("6"))
        brain.digit(4)
        brain.operationWorker("x")
        XCTAssertEqual(brain.last.gmp, Gmp("24"))
        brain.digit(5)
        brain.operationWorker("=")
        XCTAssertEqual(brain.last.gmp, Gmp("120"))

        /// 1+2*4
        brain.reset()
        brain.digit(1)
        XCTAssertEqual(brain.last.gmp, Gmp("1"))
        brain.operationWorker("+")
        brain.digit(2)
        brain.operationWorker("x")
        XCTAssertEqual(brain.last.gmp, Gmp("2"))
        brain.digit(4)
        XCTAssertEqual(brain.last.gmp, Gmp("4"))
        brain.operationWorker("+")
        XCTAssertEqual(brain.last.gmp, Gmp("9"))
        brain.digit(1)
        brain.zero()
        brain.zero()
        XCTAssertEqual(brain.last.gmp, Gmp("100"))
        /// User: =
        brain.operationWorker("=")
        XCTAssertEqual(brain.last.gmp, Gmp("109"))
        
        brain.reset()
        brain.operationWorker("π")
        brain.operationWorker("x")
        brain.digit(2)
        brain.operationWorker("=")
        
        brain.reset()
        brain.digit(2)
        brain.operationWorker("x^y")
        brain.digit(1)
        brain.zero()
        brain.operationWorker("=")
        XCTAssertEqual(brain.last.gmp, Gmp("1024"))

        brain.reset()
        brain.digit(1)
        brain.zero()
        brain.operationWorker("y^x")
        brain.digit(2)
        brain.operationWorker("=")
        XCTAssertEqual(brain.last.gmp, Gmp("1024"))
        
        /// 2x(6+4)
        brain.reset()
        brain.digit(2)
        XCTAssertEqual(brain.last.gmp, Gmp("2"))
        XCTAssertEqual(brain.operatorStack.count, 0)
        brain.operationWorker("x")
        XCTAssertEqual(brain.operatorStack.count, 1)
        brain.operationWorker("(")
        XCTAssertEqual(brain.operatorStack.count, 2)
        brain.digit(6)
        XCTAssertEqual(brain.last.gmp, Gmp("6"))
        XCTAssertEqual(brain.nn, 2)
        brain.operationWorker("+")
        XCTAssertEqual(brain.operatorStack.count, 3)
        brain.digit(4)
        XCTAssertEqual(brain.last.gmp, Gmp("4"))
        XCTAssertEqual(brain.nn, 3)
        brain.operationWorker(")")
        XCTAssertEqual(brain.operatorStack.count, 1)
        XCTAssertEqual(brain.nn, 2)
        XCTAssertEqual(brain.last.gmp, Gmp("10"))
        brain.operationWorker("=")
        XCTAssertEqual(brain.last.gmp, Gmp("20"))

        /// 2x(6+4*(5+9))
        brain.reset()
        brain.digit(2)
        brain.operationWorker("x")
        brain.operationWorker("(")
        brain.digit(6)
        brain.operationWorker("+")
        brain.digit(4)
        brain.operationWorker("x")
        brain.operationWorker("(")
        brain.digit(5)
        brain.operationWorker("+")
        brain.digit(9)
        brain.operationWorker(")")
        brain.operationWorker(")")
        brain.operationWorker("=")
        XCTAssertEqual(brain.last.gmp, Gmp("124"))

        /// 1+2=3
        brain.reset()
        brain.digit(1)
        brain.operationWorker("+")
        brain.digit(2)
        brain.operationWorker("=")
        brain.digit(2)
        XCTAssertEqual(brain.nn, 1)
        
        brain.reset()
        brain.operationWorker("π")
        XCTAssertEqual(brain.last.gmp.toDouble(), 3.14159265358979, accuracy: 0.00000001)

        brain.reset()
        brain.zero()
        brain.comma()
        brain.zero()
        brain.digit(1)
        brain.operationWorker("/")
        brain.digit(1)
        brain.operationWorker("EE")
        brain.digit(4)
        brain.operationWorker("=")
        XCTAssertEqual(brain.last.gmp.toDouble(), 0.000001)

        brain.reset()
        brain.digit(8)
        brain.digit(8)
        brain.operationWorker("%")
        XCTAssertEqual(brain.last.gmp.toDouble(), 0.88)

        brain.reset()
        brain.digit(4)
        brain.zero()
        brain.operationWorker("+")
        brain.digit(1)
        brain.zero()
        brain.operationWorker("%")
        brain.operationWorker("=")
        XCTAssertEqual(brain.last.gmp.toDouble(), 44.0)

    }
    
    //    func testPerformanceExample() throws {
    //        // This is an example of a performance test case.
    //        measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
}
