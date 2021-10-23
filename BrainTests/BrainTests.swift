//
//  BrainTests.swift
//  BrainTests
//
//  Created by Joachim Neumann on 28/09/2021.
//

import XCTest
@testable import Calculator

/*
 
0 0
123456789012345678901234 -> mantissa = 1.234... exponent = 24 oneliner = 123456789012345678901234
*/
class BrainTests: XCTestCase {
    let brain = Brain()
        
    func test() throws {
        let digits = 16

        var res = ""
        var resTruncated = ""
        var correct = ""
        var sci = ""
        var sci_e = 0

        
        /// 1
        brain.reset()
        brain.digit(1)
        XCTAssertEqual(brain.nonScientific, "1")
        XCTAssertEqual(brain.scientific, Scientific("1,0", "e0"))

        /// 0
        brain.reset()
        XCTAssertEqual(brain.nonScientific, "0")
        XCTAssertEqual(brain.scientific, Scientific("0,0", "e0"))
        brain.zero()
        XCTAssertEqual(brain.nonScientific, "0")
        XCTAssertEqual(brain.scientific, Scientific("0,0", "e0"))
        brain.zero()
        XCTAssertEqual(brain.nonScientific, "0")
        XCTAssertEqual(brain.scientific, Scientific("0,0", "e0"))

        

        // 12
        brain.reset()
        brain.digit(1)
        brain.digit(2)
        XCTAssertEqual(brain.nonScientific, "12")
        XCTAssertEqual(brain.scientific, Scientific("1,2", "e1"))

        // 01
        brain.reset()
        XCTAssertEqual(brain.nonScientific, "0")
        XCTAssertEqual(brain.scientific, Scientific("0,0", "e0"))
        brain.zero()
        XCTAssertEqual(brain.nonScientific, "0")
        XCTAssertEqual(brain.scientific, Scientific("0,0", "e0"))
        brain.digit(1)
        XCTAssertEqual(brain.nonScientific, "1")
        XCTAssertEqual(brain.scientific, Scientific("1,0", "e0"))

        /// 123456789012345678
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
        XCTAssertEqual(brain.nonScientific, "123456789012345")
        XCTAssertEqual(brain.scientific, Scientific("1,23456789012345", "e14"))
        brain.digit(6)
        XCTAssertEqual(brain.nonScientific, "1234567890123456")
        XCTAssertEqual(brain.scientific, Scientific("1,234567890123456", "e15"))
        brain.digit(7)
        XCTAssertEqual(brain.nonScientific, "12345678901234567")
        XCTAssertEqual(brain.scientific, Scientific("1,2345678901234567", "e16"))
        brain.digit(8)
        XCTAssertEqual(brain.nonScientific, "123456789012345678")
        XCTAssertEqual(brain.scientific, Scientific("1,23456789012345678", "e17"))


        /// -12345678901234
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
        brain.operationWorker("+/-")
        XCTAssertEqual(brain.nonScientific, "-12345678901234")
        XCTAssertEqual(brain.scientific, Scientific("-1,2345678901234", "e13"))


        /// 77777777777777777
        brain.reset()
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        XCTAssertEqual(brain.nonScientific, "777777777")
        XCTAssertEqual(brain.scientific, Scientific("7,77777777", "e8"))
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        brain.digit(7)
        XCTAssertEqual(brain.nonScientific, "7777777777777777777")
        XCTAssertEqual(brain.scientific, Scientific("7,777777777777777777", "e18"))



        /// -123456789012345
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
        brain.operationWorker("+/-")
        XCTAssertEqual(brain.nonScientific, "-123456789012345")
        XCTAssertEqual(brain.scientific, Scientific("-1,23456789012345", "e14"))


        /// +/-
        brain.reset()
        brain.digit(7)
        XCTAssertEqual(brain.nonScientific, "7")
        XCTAssertEqual(brain.scientific, Scientific("7,0", "e0"))
        brain.operationWorker("+/-")
        XCTAssertEqual(brain.nonScientific, "-7")
        XCTAssertEqual(brain.scientific, Scientific("-7,0", "e0"))

        /// 0,
        brain.reset()
        brain.comma()
        XCTAssertEqual(brain.nonScientific, "0,")
        XCTAssertEqual(brain.scientific, Scientific("0,0", "e0"))
        brain.comma()
        XCTAssertEqual(brain.nonScientific, "0,")
        XCTAssertEqual(brain.scientific, Scientific("0,0", "e0"))

        /// -0,7
        brain.reset()
        brain.comma()
        XCTAssertEqual(brain.nonScientific, "0,")
        XCTAssertEqual(brain.scientific, Scientific("0,0", "e0"))
        brain.digit(7)
        XCTAssertEqual(brain.nonScientific, "0,7")
        XCTAssertEqual(brain.scientific, Scientific("7,0", "e-1"))
        brain.operationWorker("+/-")
        XCTAssertEqual(brain.nonScientific, "-0,7")
        XCTAssertEqual(brain.scientific, Scientific("-7,0", "e-1"))
        
        /// 3 e6
        brain.reset()
        brain.digit(3)
        brain.operationWorker("EE")
        brain.digit(6)
        brain.operationWorker("=")
        XCTAssertEqual(brain.nonScientific, "3000000")
        XCTAssertEqual(brain.scientific, Scientific("3,0", "e6"))

        /// 3 e6 + 0.01
        brain.reset()
        brain.digit(3)
        brain.operationWorker("EE")
        brain.digit(6)
        brain.operationWorker("=")
        brain.operationWorker("+")
        brain.comma()
        brain.zero()
        brain.zero()
        brain.digit(1)
        brain.operationWorker("=")
        XCTAssertEqual(brain.nonScientific, "3000000,001")
        XCTAssertEqual(brain.scientific, Scientific("3,000000001", "e6"))


        /// 3 e77
        brain.reset()
        brain.digit(3)
        brain.operationWorker("EE")
        brain.digit(7)
        brain.digit(7)
        brain.operationWorker("=")
        XCTAssertEqual(brain.nonScientific, "300000000000000000000000000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(brain.scientific, Scientific("3,0", "e77"))

        /// 3 e-77
        brain.reset()
        brain.digit(3)
        brain.operationWorker("EE")
        brain.digit(7)
        brain.digit(7)
        brain.operationWorker("+/-")
        brain.operationWorker("=")
        XCTAssertEqual(brain.nonScientific, "0,00000000000000000000000000000000000000000000000000000000000000000000000000003")
        XCTAssertEqual(brain.scientific, Scientific("3,0", "e-77"))

        /// -3 e-77
        brain.reset()
        brain.digit(3)
        brain.operationWorker("EE")
        brain.digit(7)
        brain.digit(7)
        brain.operationWorker("+/-")
        brain.operationWorker("=")
        brain.operationWorker("+/-")
        XCTAssertEqual(brain.nonScientific, "-0,00000000000000000000000000000000000000000000000000000000000000000000000000003")
        XCTAssertEqual(brain.scientific, Scientific("-3,0", "e-77"))

        /// -3 e-77
        brain.reset()
        brain.digit(3)
        brain.operationWorker("+/-")
        brain.operationWorker("EE")
        brain.digit(7)
        brain.digit(7)
        brain.operationWorker("+/-")
        brain.operationWorker("=")
        XCTAssertEqual(brain.nonScientific, "-0,00000000000000000000000000000000000000000000000000000000000000000000000000003")
        XCTAssertEqual(brain.scientific, Scientific("-3,0", "e-77"))

        
        /// 8888888
        brain.reset()
        brain.digit(8)
        brain.digit(8)
        brain.digit(8)
        brain.digit(8)
        brain.digit(8)
        brain.digit(8)
        brain.digit(8)
        XCTAssertEqual(brain.nonScientific, "8888888")
        XCTAssertEqual(brain.scientific, Scientific("8,888888", "e6"))


        /// memory
        brain.reset()
        brain.digit(1)
        brain.digit(2)
        XCTAssertEqual(brain.nonScientific, "12")
        XCTAssertEqual(brain.scientific, Scientific("1,2", "e1"))
        brain.clearMemory()
        XCTAssertEqual(brain.nonScientific, "12")
        XCTAssertEqual(brain.scientific, Scientific("1,2", "e1"))
        brain.addToMemory()
        XCTAssertEqual(brain.nonScientific, "12")
        XCTAssertEqual(brain.scientific, Scientific("1,2", "e1"))
        brain.addToMemory()
        XCTAssertEqual(brain.nonScientific, "12")
        XCTAssertEqual(brain.scientific, Scientific("1,2", "e1"))
        brain.getMemory()
        XCTAssertEqual(brain.nonScientific, "24")
        XCTAssertEqual(brain.scientific, Scientific("2,4", "e1"))
        brain.subtractFromMemory()
        XCTAssertEqual(brain.nonScientific, "24")
        XCTAssertEqual(brain.scientific, Scientific("2,4", "e1"))
        brain.getMemory()
        XCTAssertEqual(brain.nonScientific, "0")
        XCTAssertEqual(brain.scientific, Scientific("0,0", "e0"))

        /// 0,0000010
        brain.reset()
        brain.zero()
        XCTAssertEqual(brain.nonScientific, "0")
        XCTAssertEqual(brain.scientific, Scientific("0,0", "e0"))
        brain.comma()
        XCTAssertEqual(brain.nonScientific, "0,")
        XCTAssertEqual(brain.scientific, Scientific("0,0", "e0"))
        brain.zero()
        XCTAssertEqual(brain.nonScientific, "0,0")
        XCTAssertEqual(brain.scientific, Scientific("0,0", "e0"))
        brain.zero()
        brain.zero()
        brain.zero()
        brain.zero()
        XCTAssertEqual(brain.nonScientific, "0,00000")
        XCTAssertEqual(brain.scientific, Scientific("0,0", "e0"))
        brain.digit(1)
        XCTAssertEqual(brain.nonScientific, "0,000001")
        XCTAssertEqual(brain.scientific, Scientific("1,0", "e-6"))
        brain.zero()
        XCTAssertEqual(brain.nonScientific, "0,0000010")
        XCTAssertEqual(brain.scientific, Scientific("1,0", "e-6"))

        /// 1 e -15
        brain.reset()
        brain.comma()
        res = "0,"
        for _ in 1..<digits-1 {
            res += "0"
            brain.zero()
            XCTAssertEqual(brain.nonScientific, res)
            XCTAssertEqual(brain.scientific, Scientific("0,0", "e0"))
        }
        brain.digit(1)
        XCTAssertEqual(brain.nonScientific, "0,000000000000001")
        XCTAssertEqual(brain.nonScientific, res+"1")
        XCTAssertEqual(brain.scientific, Scientific("1,0", "e-15"))

        /// 32456.2244
        brain.reset()
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
        sci = "3,24562244"
        sci_e = 4
        XCTAssertEqual(brain.nonScientific, res)
        XCTAssertEqual(brain.scientific, Scientific(sci, "e\(sci_e)"))


        /// 32456.224433333333333333333333333
        for _ in res.count..<digits+20 {
            brain.digit(3)
            res += "3"
            sci += "3"
            XCTAssertEqual(brain.nonScientific, res)
            XCTAssertEqual(brain.scientific, Scientific(sci, "e\(sci_e)"))
        }

        /// 1/7*7 --> has more digits?
        brain.reset()
        brain.digit(7)
        brain.operationWorker("One_x")
        brain.operationWorker("x")
        brain.digit(7)
        brain.operationWorker("=")
        XCTAssertEqual(brain.nonScientific, "1")
        XCTAssertEqual(brain.scientific, Scientific("1,0", "e0"))

        /// 9 %%%% ^2 ^2 ^2
        brain.reset()
        brain.digit(9)
        brain.operationWorker("%")
        XCTAssertEqual(brain.nonScientific, "0,09")
        XCTAssertEqual(brain.scientific, Scientific("9,0", "e-2"))
        brain.operationWorker("%")
        XCTAssertEqual(brain.nonScientific, "0,0009")
        XCTAssertEqual(brain.scientific, Scientific("9,0", "e-4"))
        brain.operationWorker("%")
        brain.operationWorker("%")
        XCTAssertEqual(brain.nonScientific, "0,00000009")
        XCTAssertEqual(brain.scientific, Scientific("9,0", "e-8"))
        brain.operationWorker("x^2")
        XCTAssertEqual(brain.nonScientific, "0,0000000000000081")
        XCTAssertEqual(brain.scientific, Scientific("8,1", "e-15"))


        /// 1/10 and 1/16
        brain.reset()
        brain.digit(1)
        brain.zero()
        XCTAssertEqual(brain.nonScientific, "10")
        XCTAssertEqual(brain.scientific, Scientific("1,0", "e1"))
        brain.operationWorker("One_x")
        XCTAssertEqual(brain.nonScientific, "0,1")
        XCTAssertEqual(brain.scientific, Scientific("1,0", "e-1"))
        brain.digit(1)
        brain.digit(6)
        XCTAssertEqual(brain.debugLastDouble, 16.0)
        XCTAssertEqual(brain.nonScientific, "16")
        XCTAssertEqual(brain.scientific, Scientific("1,6", "e1"))
        brain.operationWorker("One_x")
        XCTAssertEqual(brain.debugLastDouble, 0.0625)
        XCTAssertEqual(brain.nonScientific, "0,0625")
        XCTAssertEqual(brain.scientific, Scientific("6,25", "e-2"))

        /// 1+2+5+2= + 1/4 =
        brain.digit(1)
        brain.operationWorker("+")
        brain.digit(2)
        brain.operationWorker("+")
        XCTAssertEqual(brain.nonScientific, "3")
        XCTAssertEqual(brain.scientific, Scientific("3,0", "e0"))
        brain.digit(5)
        brain.operationWorker("+")
        XCTAssertEqual(brain.nonScientific, "8")
        XCTAssertEqual(brain.scientific, Scientific("8,0", "e0"))
        brain.digit(2)
        brain.operationWorker("=")
        XCTAssertEqual(brain.nonScientific, "10")
        XCTAssertEqual(brain.scientific, Scientific("1,0", "e1"))
        brain.operationWorker("+")
        XCTAssertEqual(brain.nonScientific, "10")
        XCTAssertEqual(brain.scientific, Scientific("1,0", "e1"))
        brain.digit(4)
        brain.operationWorker("One_x")
        XCTAssertEqual(brain.nonScientific, "0,25")
        XCTAssertEqual(brain.scientific, Scientific("2,5", "e-1"))
        brain.operationWorker("=")
        XCTAssertEqual(brain.nonScientific, "10,25")
        XCTAssertEqual(brain.scientific, Scientific("1,025", "e1"))

        /// 1+2*4=
        brain.reset()
        brain.digit(1)
        XCTAssertEqual(brain.nonScientific, "1")
        XCTAssertEqual(brain.scientific, Scientific("1,0", "e0"))
        brain.operationWorker("+")
        brain.digit(2)
        brain.operationWorker("x")
        XCTAssertEqual(brain.nonScientific, "2")
        XCTAssertEqual(brain.scientific, Scientific("2,0", "e0"))
        brain.digit(4)
        XCTAssertEqual(brain.nonScientific, "4")
        XCTAssertEqual(brain.scientific, Scientific("4,0", "e0"))
        brain.operationWorker("=")
        XCTAssertEqual(brain.nonScientific, "9")
        XCTAssertEqual(brain.scientific, Scientific("9,0", "e0"))

        /// 2*3*4*5=
        brain.reset()
        brain.digit(2)
        brain.operationWorker("x")
        brain.digit(3)
        brain.operationWorker("x")
        brain.digit(4)
        brain.operationWorker("x")
        XCTAssertEqual(brain.nonScientific, "24")
        XCTAssertEqual(brain.scientific, Scientific("2,4", "e1"))
        brain.digit(5)
        brain.operationWorker("=")
        XCTAssertEqual(brain.nonScientific, "120")
        XCTAssertEqual(brain.scientific, Scientific("1,2", "e2"))

        /// 1+2*4
        brain.reset()
        brain.digit(1)
        brain.operationWorker("+")
        brain.digit(2)
        brain.operationWorker("x")
        XCTAssertEqual(brain.nonScientific, "2")
        XCTAssertEqual(brain.scientific, Scientific("2,0", "e0"))
        brain.digit(4)
        XCTAssertEqual(brain.nonScientific, "4")
        XCTAssertEqual(brain.scientific, Scientific("4,0", "e0"))
        brain.operationWorker("+")
        XCTAssertEqual(brain.nonScientific, "9")
        XCTAssertEqual(brain.scientific, Scientific("9,0", "e0"))
        brain.digit(1)
        brain.zero()
        brain.zero()
        XCTAssertEqual(brain.nonScientific, "100")
        XCTAssertEqual(brain.scientific, Scientific("1,0", "e2"))
        brain.operationWorker("=")
        XCTAssertEqual(brain.nonScientific, "109")
        XCTAssertEqual(brain.scientific, Scientific("1,09", "e2"))

        /// pi
        brain.reset()
        brain.operationWorker("π")
        correct = "3,1415926535897932384626433832795028841971"
        XCTAssertEqual(brain.debugLastDouble, Double.pi)
        res = brain.nonScientific!
        resTruncated = String(res.prefix(correct.count))
        XCTAssertEqual (resTruncated, correct)

        /// 1+pi
        brain.reset()
        brain.digit(1)
        brain.operationWorker("+")
        brain.operationWorker("π")
        brain.operationWorker("=")
        correct = "4,1415926535897932384626433832795028841971"
        XCTAssertEqual(brain.debugLastDouble, 1.0+Double.pi)
        res = brain.nonScientific!
        resTruncated = String(res.prefix(correct.count))
        XCTAssertEqual (resTruncated, correct)

        brain.reset()
        brain.operationWorker("π")
        brain.operationWorker("x")
        brain.digit(2)
        brain.operationWorker("=")


        correct = String("6,28318530717958647692528676655900576839433879875021164194988918461563281257241799725606965068423413596429617302656461329418768921910116446345".prefix(100))
        XCTAssertEqual(brain.debugLastDouble, 2.0*Double.pi)
        res = brain.nonScientific!
        resTruncated = String(res.prefix(100))
        XCTAssertEqual (resTruncated, correct)

        brain.reset()
        brain.digit(2)
        brain.operationWorker("x^y")
        brain.digit(1)
        brain.zero()
        brain.operationWorker("=")
        XCTAssertEqual(brain.debugLastGmp, Gmp("1024"))
        XCTAssertEqual(brain.nonScientific, "1024")
        XCTAssertEqual(brain.scientific, Scientific("1,024", "e3"))

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
        XCTAssertEqual(brain.nonScientific, "20")
        XCTAssertEqual(brain.scientific, Scientific("2,0", "e1"))

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
