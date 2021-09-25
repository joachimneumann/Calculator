//
//  Gmp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

// This class bridges between swift and the GMP library which is implemented in C


import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
}

var globalUnsignedLongInt: CUnsignedLong = 0


class Gmp {
    // Swift requires me to initialize the mpfr_t struc
    // I do this with zeros. The struct will be initialized correctly in mpfr_init2
    var mpfr: mpfr_t = mpfr_t(_mpfr_prec: 0, _mpfr_sign: 0, _mpfr_exp: 0, _mpfr_d: &globalUnsignedLongInt)

    // there is only ine initialzer that takes a string.
    // Implementing an initializer that accepts a double which is created from a string leads to a loss of precision.
    init(_ s: String) {
        let s1 = s.replacingOccurrences(of: ",", with: ".")
        mpfr_init2 (&mpfr, 1000)//331146) // TODO precision
        mpfr_set_str (&mpfr, s1, 10, MPFR_RNDN)
    }
    
    static func π() -> Gmp {
        let ret = Gmp("0.0")
        mpfr_const_pi(&ret.mpfr, MPFR_RNDN)
        return ret
    }
    static func e() -> Gmp {
        let one = Gmp("1.0")
        pow_e_x(one)
        return one
    }
    static func γ() -> Gmp {
        let ret = Gmp("0.0")
        mpfr_const_pi(&ret.mpfr, MPFR_RNDN)
        return ret
    }
    
    static func changeSign(_ me: Gmp) {
        mpfr_neg(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    
    static func + (left: Gmp, right: Gmp) -> Gmp {
        mpfr_add(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
        return left
    }
    static func add (left: Gmp, right: Gmp) -> Gmp {
        mpfr_add(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
        return left
    }
    
    static func / (left: Gmp, right: Gmp) -> Gmp {
        mpfr_div(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
        return left
    }
    
    static func div (left: Gmp, right: Gmp) -> Gmp {
        mpfr_div(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
        return left
    }
    
    static func - (left: Gmp, right: Gmp) -> Gmp {
        mpfr_sub(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
        return left
    }
    
    static func min (left: Gmp, right: Gmp) -> Gmp {
        mpfr_sub(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
        return left
    }
    
    static func * (left: Gmp, right: Gmp) -> Gmp {
        mpfr_mul(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
        return left
    }
    
    static func mul (left: Gmp, right: Gmp) -> Gmp {
        mpfr_mul(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
        return left
    }
    
    static func pow_x_y(_ base: Gmp, exponent: Gmp) -> Gmp {
        mpfr_pow(&base.mpfr, &base.copy().mpfr, &exponent.mpfr, MPFR_RNDN)
        return base
    }
    
    static func sqrty(_ base: Gmp, exponent: Gmp) -> Gmp {
        rez(exponent)
        mpfr_pow(&exponent.mpfr, &exponent.copy().mpfr, &base.mpfr, MPFR_RNDN)
        return base
    }
    
    static func x_double_up_arrow_y(_ left: Gmp, right: Gmp) -> Gmp {
        var temp: mpfr_t = mpfr_t(_mpfr_prec: 0, _mpfr_sign: 0, _mpfr_exp: 0, _mpfr_d: &globalUnsignedLongInt)
        mpfr_init2 (&temp, mpfr_get_prec(&left.mpfr))
        mpfr_set(&temp, &left.mpfr, MPFR_RNDN)
        
        let counter: CLong = mpfr_get_si(&right.mpfr, MPFR_RNDN) - 1
        guard counter > 0 else { return left }
        for _ in 0..<counter {
            mpfr_pow(&left.mpfr, &temp, &left.copy().mpfr, MPFR_RNDN)
        }
        mpfr_clear(&temp)
        return left
    }
    
    static func abs(_ me: Gmp) {
        mpfr_abs(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    
    static func sqrt(_ me: Gmp) {
        mpfr_sqrt(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    static func sqrt3(_ me: Gmp) {
        mpfr_cbrt(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    static func rez(_ me: Gmp) {
        mpfr_ui_div(&me.mpfr, 1, &me.copy().mpfr, MPFR_RNDN)
    }
    
    static func Z(_ me: Gmp) {
        mpfr_zeta(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    
    static func fac(_ me: Gmp) {
        let n = mpfr_get_si(&me.mpfr, MPFR_RNDN)
        if n >= 0 {
            let un = UInt(n)
            mpfr_fac_ui(&me.mpfr, un, MPFR_RNDN)
        } else {
            mpfr_set_d(&me.mpfr, 0.0, MPFR_RNDN)
        }
    }
    static func ln(_ me: Gmp) {
        mpfr_log(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    static func log10(_ me: Gmp) {
        mpfr_log10(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    static func sin(_ me: Gmp) {
        mpfr_sin(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    static func cos(_ me: Gmp) {
        mpfr_cos(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    static func tan(_ me: Gmp) {
        mpfr_tan(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    static func asin(_ me: Gmp) {
        mpfr_asin(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    static func acos(_ me: Gmp) {
        mpfr_acos(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    static func atan(_ me: Gmp) {
        mpfr_atan(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    static func pow_x_2(_ me: Gmp) {
        mpfr_sqr(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    static func pow_x_3(_ me: Gmp) {
        mpfr_pow_ui(&me.mpfr, &me.copy().mpfr, 3, MPFR_RNDN)
    }
    static func pow_e_x(_ me: Gmp) {
        mpfr_exp(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    static func pow_10_x(_ me: Gmp) {
        mpfr_exp10(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
    }
    
    func isValidGmpString(s: String) -> Bool {
        var temp_mpfr: mpfr_t = mpfr_t(_mpfr_prec: 0, _mpfr_sign: 0, _mpfr_exp: 0, _mpfr_d: &globalUnsignedLongInt)
        mpfr_init2 (&temp_mpfr, 331146) // TODO precision
        return mpfr_set_str (&temp_mpfr, s, 10, MPFR_RNDN) == 0
    }
    func toDouble() -> Double {
        return mpfr_get_d(&mpfr, MPFR_RNDN)
    }
    
    var NaN: Bool {
        mpfr_nan_p(&mpfr) != 0
    }
    var inf: Bool {
        mpfr_inf_p(&mpfr) != 0
    }
    var isZero: Bool {
        mpfr_zero_p(&mpfr) != 0
    }
    
    
    func copy() -> Gmp {
        let ret = Gmp("0.0")
        mpfr_set(&ret.mpfr, &mpfr, MPFR_RNDN)
        return ret
    }
    
    var debugDescription: String {
        return "not implemented"//displayString(digits: 10).string
    }
    
    struct Data {
        let mantissa: String
        let exponent: Int
        let negative: Bool
        let hasMoreDigits: Bool
    }
    
    func data(length: Int) -> Data {
        var exponent: mpfr_exp_t = 0
        var charArray: Array<CChar> = Array(repeating: 0, count: length+5)
        mpfr_get_str(&charArray, &exponent, 10, length+5, &mpfr, MPFR_RNDN)
        
        var negative: Bool
        if charArray[0] == 45 {
            charArray.removeFirst()
            negative = true
        } else {
            negative = false
        }
        
        var mantissa = ""
        for c in charArray {
            if c != 0 {
                let x1 = UInt8(c)
                let x2 = UnicodeScalar(x1)
                let x3 = String(x2)
                mantissa += x3.withCString { String(format: "%s", $0) }
            }
        }
        while mantissa.last == "0" {
            mantissa.removeLast()
        }
        
        exponent = exponent - 1
        var hasMoreDigits = false
        if mantissa.count > length {
            // this is possible, because we added 5 at the top of this function
            hasMoreDigits = true
            mantissa = String(mantissa.prefix(length))
        }
        return Data(mantissa: mantissa, exponent: exponent, negative: negative, hasMoreDigits: hasMoreDigits)
        //return Data(mantissa: "123", exponent: 2, negative: false)
    }
    
    
    func isNull() -> Bool {
        return mpfr_cmp_d(&mpfr, 0.0) == 0
    }
    
    func isNegtive() -> Bool {
        return mpfr_cmp_d(&mpfr, 0.0) < 0
    }
    
    func isNotANumber() -> Bool {
        return mpfr_nan_p(&mpfr) != 0
    }
    
}

extension Gmp: Equatable {
    static func ==(lhs: Gmp, rhs: Gmp) -> Bool {
        DisplayData(gmp: lhs, digits: 10000-1) == DisplayData(gmp: rhs, digits: 10000-1)
    }
}
