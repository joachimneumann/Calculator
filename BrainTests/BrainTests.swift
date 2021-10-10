//
//  BrainTests.swift
//  BrainTests
//
//  Created by Joachim Neumann on 28/09/2021.
//

import XCTest
@testable import Calculator

class BrainTests: XCTestCase {
    let digitsInSmallDisplay = TE().digitsInSmallDisplay
    let brain = Brain()
    
    func test() throws {
        /// 0
        brain.reset()
        XCTAssertEqual(brain.sString, "0")
        brain.zero()
        XCTAssertEqual(brain.sString, "0")

        // 12
        brain.reset()
        XCTAssertEqual(brain.sString, "0")
        brain.digit(1)
        XCTAssertEqual(brain.sString, "1")
        brain.digit(2)
        XCTAssertEqual(brain.sString, "12")

        // 01
        brain.reset()
        XCTAssertEqual(brain.sString, "0")
        brain.zero()
        XCTAssertEqual(brain.sString, "0")
        brain.digit(1)
        XCTAssertEqual(brain.sString, "1")

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
        XCTAssertEqual(brain.sString, "123456789012345")
        brain.digit(6)
        XCTAssertEqual(brain.sString, "1234567890123456")
        brain.digit(7)
        XCTAssertEqual(brain.sString, "1,234567890123 e16")

        
        /// memory
        brain.reset()
        brain.digit(1)
        brain.digit(2)
        XCTAssertEqual(brain.sString, "12")
        brain.clearMemory()
        XCTAssertEqual(brain.sString, "12")
        brain.addToMemory()
        XCTAssertEqual(brain.sString, "12")
        brain.addToMemory()
        XCTAssertEqual(brain.sString, "12")
        brain.getMemory()
        XCTAssertEqual(brain.sString, "24")
        brain.subtractFromMemory()
        XCTAssertEqual(brain.sString, "24")
        brain.getMemory()
        XCTAssertEqual(brain.sString, "0")
        
        /// 0,0000010
        brain.reset()
        brain.zero()
        XCTAssertEqual(brain.sString, "0")
        brain.comma()
        XCTAssertEqual(brain.sString, "0,")
        brain.zero()
        XCTAssertEqual(brain.sString, "0,0")
        brain.zero()
        brain.zero()
        brain.zero()
        brain.zero()
        XCTAssertEqual(brain.sString, "0,00000")
        brain.digit(1)
        XCTAssertEqual(brain.sString, "0,000001")
        brain.zero()
        XCTAssertEqual(brain.sString, "0,0000010")

        /// reset
        brain.reset()
        XCTAssertEqual(brain.sString, "0")

        /// 1 e -11
        brain.reset()
        brain.comma()
        XCTAssertEqual(brain.sString, "0,")
        var res = "0,"
        for _ in 1..<digitsInSmallDisplay-1 {
            res += "0"
            brain.zero()
            XCTAssertEqual(brain.sString, res)
        }
        brain.digit(1)
        XCTAssertEqual(brain.sString, "1,0 e-\(digitsInSmallDisplay-1)")

        /// 32456.2244
        brain.reset()
        XCTAssertEqual(brain.sString, "0")
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
        XCTAssertEqual(brain.sString, "32456,2244")
        
        /// 32456.2244333333333333333333333333
        for _ in res.count..<digitsInSmallDisplay+20 {
            res += "3"
            brain.digit(3)
            /// prefix + 1 for the comma
            XCTAssertEqual(brain.sString, String(res.prefix(digitsInSmallDisplay+1)))
        }

        /// 1/7*7 --> has more digits?
        brain.reset()
        brain.digit(7)
        brain.operationWorker("One_x")
        brain.operationWorker("x")
        brain.digit(7)
        brain.operationWorker("=")
        XCTAssertEqual(brain.sString, "1")
        XCTAssertEqual(brain.hasMoreDigits, false)

        /// 9 %%%% ^2 ^2 ^2
        brain.reset()
        brain.digit(9)
        brain.operationWorker("%")
        XCTAssertEqual(brain.sString, "0,09")
        brain.operationWorker("%")
        XCTAssertEqual(brain.sString, "0,0009")
        brain.operationWorker("%")
        brain.operationWorker("%")
        brain.operationWorker("x^2")
        brain.operationWorker("x^2")
        brain.operationWorker("x^2")

        /// pi
        brain.reset()
        brain.operationWorker("π")
        let correct = "3,1415926535897932384626433832795028841971"
        XCTAssertEqual(brain.debugLastDouble, Double.pi)
        XCTAssertEqual(brain.sString, String(correct.prefix(digitsInSmallDisplay+1)))
        let c = brain.lString
        XCTAssertEqual(String(c.prefix(correct.count)), correct)

        /// 1+pi
        brain.reset()
        brain.digit(1)
        XCTAssertEqual(brain.sString, "1")
        XCTAssertEqual(brain.debugLastDouble, 1.0)
        brain.operationWorker("+")
        XCTAssertEqual(brain.sString, "1")
        XCTAssertEqual(brain.debugLastDouble, 1.0)
        brain.operationWorker("π")
        XCTAssertEqual(brain.debugLastDouble, Double.pi)
        XCTAssertEqual(brain.sString, String("3,1415926535897932384626433832795028841971".prefix(digitsInSmallDisplay+1)))
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastDouble, 1.0+Double.pi)
        XCTAssertEqual(brain.sString, String("4,1415926535897932384626433832795028841971".prefix(digitsInSmallDisplay+1)))

        /// 1/10 and 1/16
        brain.reset()
        brain.digit(1)
        brain.zero()
        XCTAssertEqual(brain.debugLastDouble, 10.0)
        XCTAssertEqual(brain.sString, "10")
        brain.operationWorker("One_x")
        XCTAssertEqual(brain.debugLastDouble, 0.1)
        brain.digit(1)
        brain.digit(6)
        XCTAssertEqual(brain.debugLastDouble, 16.0)
        brain.operationWorker("One_x")
        XCTAssertEqual(brain.debugLastDouble, 0.0625)
        
        /// 1+2+5+2= + 1/4 =
        brain.digit(1)
        XCTAssertEqual(brain.debugLastGmp, Gmp("1"))
        brain.operationWorker("+")
        XCTAssertEqual(brain.debugLastGmp, Gmp("1"))
        brain.digit(2)
        brain.operationWorker("+")
        XCTAssertEqual(brain.debugLastGmp, Gmp("3"))
        brain.digit(5)
        brain.operationWorker("+")
        XCTAssertEqual(brain.debugLastGmp, Gmp("8"))
        brain.digit(2)
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("10"))
        brain.operationWorker("+")
        XCTAssertEqual(brain.debugLastGmp, Gmp("10"))
        brain.digit(4)
        brain.operationWorker("One_x")
        XCTAssertEqual(brain.debugLastGmp, Gmp("0.25"))
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("10.25"))
        
        /// 1+2*4=
        brain.reset()
        brain.digit(1)
        XCTAssertEqual(brain.debugLastGmp, Gmp("1"))
        brain.operationWorker("+")
        brain.digit(2)
        brain.operationWorker("x")
        XCTAssertEqual(brain.debugLastGmp, Gmp("2"))
        brain.digit(4)
        XCTAssertEqual(brain.debugLastGmp, Gmp("4"))
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("9"))

        /// 2*3*4*5=
        brain.reset()
        brain.digit(2)
        XCTAssertEqual(brain.debugLastGmp, Gmp("2"))
        brain.operationWorker("x")
        brain.digit(3)
        XCTAssertEqual(brain.debugLastGmp, Gmp("3"))
        brain.operationWorker("x")
        XCTAssertEqual(brain.debugLastGmp, Gmp("6"))
        brain.digit(4)
        brain.operationWorker("x")
        XCTAssertEqual(brain.debugLastGmp, Gmp("24"))
        brain.digit(5)
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("120"))

        /// 1+2*4
        brain.reset()
        brain.digit(1)
        XCTAssertEqual(brain.debugLastGmp, Gmp("1"))
        brain.operationWorker("+")
        brain.digit(2)
        brain.operationWorker("x")
        XCTAssertEqual(brain.debugLastGmp, Gmp("2"))
        brain.digit(4)
        XCTAssertEqual(brain.debugLastGmp, Gmp("4"))
        brain.operationWorker("+")
        XCTAssertEqual(brain.debugLastGmp, Gmp("9"))
        brain.digit(1)
        brain.zero()
        brain.zero()
        XCTAssertEqual(brain.debugLastGmp, Gmp("100"))
        /// User: =
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("109"))
        
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
        XCTAssertEqual(brain.debugLastGmp, Gmp("1024"))

        brain.reset()
        brain.digit(1)
        brain.zero()
        brain.operationWorker("y^x")
        brain.digit(2)
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("1024"))
        
        /// 2x(6+4)
        brain.reset()
        brain.digit(2)
        XCTAssertEqual(brain.debugLastGmp, Gmp("2"))
        XCTAssertEqual(brain.no, 0)
        brain.operationWorker("x")
        XCTAssertEqual(brain.no, 1)
        brain.operationWorker("(")
        XCTAssertEqual(brain.no, 2)
        brain.digit(6)
        XCTAssertEqual(brain.debugLastGmp, Gmp("6"))
        XCTAssertEqual(brain.nn, 2)
        brain.operationWorker("+")
        XCTAssertEqual(brain.no, 3)
        brain.digit(4)
        XCTAssertEqual(brain.debugLastGmp, Gmp("4"))
        XCTAssertEqual(brain.nn, 3)
        brain.operationWorker(")")
        XCTAssertEqual(brain.no, 1)
        XCTAssertEqual(brain.nn, 2)
        XCTAssertEqual(brain.debugLastGmp, Gmp("10"))
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("20"))

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
        XCTAssertEqual(brain.debugLastGmp, Gmp("124"))

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
        XCTAssertEqual(brain.debugLastDouble, 3.14159265358979, accuracy: 0.00000001)

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
        XCTAssertEqual(brain.debugLastDouble, 0.000001)

        brain.reset()
        brain.digit(8)
        brain.digit(8)
        brain.operationWorker("%")
        XCTAssertEqual(brain.debugLastDouble, 0.88)

        brain.reset()
        brain.digit(4)
        brain.zero()
        brain.operationWorker("+")
        brain.digit(1)
        brain.zero()
        brain.operationWorker("%")
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastDouble, 44.0)
    }
}
