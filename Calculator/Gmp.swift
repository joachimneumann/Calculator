//
//  Gmp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

// This class bridges between swift and the GMP library which is implemented in C


import Foundation

struct ShortDisplayString {
    let isValidNumber: Bool
    let isNegative: Bool
    let higherPrecisionAvailable: Bool
    let isScientificNotation: Bool
    let content: String
    func show() -> String {
        var ret = content.replacingOccurrences(of: ".", with: ",")
        if isNegative { ret = "-" + ret }
        return ret
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
}

var dummyUnsignedLongInt: CUnsignedLong = 0


func toDouble(me: Gmp) -> Double {
    return mpfr_get_d(&me.mpfr, MPFR_RNDN)
}

func + (left: Gmp, right: Gmp) -> Gmp {
    mpfr_add(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
    return left
}
func add (left: Gmp, right: Gmp) -> Gmp {
    mpfr_add(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
    return left
}

func / (left: Gmp, right: Gmp) -> Gmp {
    mpfr_div(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
    return left
}
func div (left: Gmp, right: Gmp) -> Gmp {
    mpfr_div(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
    return left
}

func - (left: Gmp, right: Gmp) -> Gmp {
    mpfr_sub(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
    return left
}

func min (left: Gmp, right: Gmp) -> Gmp {
    mpfr_sub(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
    return left
}

func * (left: Gmp, right: Gmp) -> Gmp {
    mpfr_mul(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
    return left
}

func mul (left: Gmp, right: Gmp) -> Gmp {
    mpfr_mul(&left.mpfr, &left.copy().mpfr, &right.mpfr, MPFR_RNDN)
    return left
}

func pow_x_y(_ base: Gmp, exponent: Gmp) -> Gmp {
    mpfr_pow(&base.mpfr, &base.copy().mpfr, &exponent.mpfr, MPFR_RNDN)
    return base
}

func x_double_up_arrow_y(_ left: Gmp, right: Gmp) -> Gmp {
    var temp: mpfr_t = mpfr_t(_mpfr_prec: 0, _mpfr_sign: 0, _mpfr_exp: 0, _mpfr_d: &dummyUnsignedLongInt)
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

func changeSign(_ me: Gmp) {
    mpfr_neg(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}

func abs(_ me: Gmp) {
    mpfr_abs(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}

func π(_ me: Gmp) {
    mpfr_const_pi(&me.mpfr, MPFR_RNDN)
}
func sqrt(_ me: Gmp) {
    mpfr_sqrt(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}
func sqrt3(_ me: Gmp) {
    mpfr_cbrt(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}
func rez(_ me: Gmp) {
    mpfr_ui_div(&me.mpfr, 1, &me.copy().mpfr, MPFR_RNDN)
}

func Z(_ me: Gmp) {
    mpfr_zeta(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}

func fac(_ me: Gmp) {
    let n = mpfr_get_si(&me.mpfr, MPFR_RNDN)
    if n >= 0 {
        let un = UInt(n)
        mpfr_fac_ui(&me.mpfr, un, MPFR_RNDN)
    } else {
        mpfr_set_d(&me.mpfr, 0.0, MPFR_RNDN)
    }
}
func ln(_ me: Gmp) {
    mpfr_log(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}
func log10(_ me: Gmp) {
    mpfr_log10(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}
func sin(_ me: Gmp) {
    mpfr_sin(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}
func cos(_ me: Gmp) {
    mpfr_cos(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}
func tan(_ me: Gmp) {
    mpfr_tan(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}
func asin(_ me: Gmp) {
    mpfr_asin(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}
func acos(_ me: Gmp) {
    mpfr_acos(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}
func atan(_ me: Gmp) {
    mpfr_atan(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}
func e(_ me: Gmp) {
    var one: mpfr_t = mpfr_t(_mpfr_prec: 0, _mpfr_sign: 0, _mpfr_exp: 0, _mpfr_d: &dummyUnsignedLongInt)
    mpfr_init2 (&one, mpfr_get_prec(&me.mpfr))
    mpfr_set_d(&one, 1.0, MPFR_RNDN)
    mpfr_exp(&me.mpfr, &one, MPFR_RNDN); // Strangely, this returns a status of -1
    mpfr_clear(&one);
}
func γ(_ me: Gmp) {
    mpfr_const_euler(&me.mpfr, MPFR_RNDN)
}
func pow_x_2(_ me: Gmp) {
    mpfr_sqr(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}
func pow_x_3(_ me: Gmp) {
    mpfr_pow_ui(&me.mpfr, &me.copy().mpfr, 3, MPFR_RNDN)
}
func pow_e_x(_ me: Gmp) {
    mpfr_exp(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}
func pow_10_x(_ me: Gmp) {
    mpfr_exp10(&me.mpfr, &me.copy().mpfr, MPFR_RNDN)
}

func isValidGmpString(s: String, precision: CLong) -> Bool {
    var temp_mpfr: mpfr_t = mpfr_t(_mpfr_prec: 0, _mpfr_sign: 0, _mpfr_exp: 0, _mpfr_d: &dummyUnsignedLongInt)
    let s1 = s.replacingOccurrences(of: " E", with: "e")
    mpfr_init2 (&temp_mpfr, precision)
    return mpfr_set_str (&temp_mpfr, s1, 10, MPFR_RNDN) == 0
}

class Gmp: CustomDebugStringConvertible {
    // Swift requires me to initialize the mpfr_t struc
    // I do this with zeros. The struct will be initialized correctly in mpfr_init2
    fileprivate var mpfr: mpfr_t = mpfr_t(_mpfr_prec: 0, _mpfr_sign: 0, _mpfr_exp: 0, _mpfr_d: &dummyUnsignedLongInt)
    
    // there is only ine initialzer that takes a string.
    // Implementing an initializer that accepts a double which is created from a string leads to a loss of precision.
    init(_ s: String, precision: CLong) {
        let s1 = s.replacingOccurrences(of: " E", with: "e")
        mpfr_init2 (&mpfr, precision)
        mpfr_set_str (&mpfr, s1, 10, MPFR_RNDN)
    }
    
    func copy() -> Gmp {
        let ret = Gmp("0.0", precision: mpfr_get_prec(&mpfr))
        mpfr_set(&ret.mpfr, &mpfr, MPFR_RNDN)
        return ret
    }
    
    var debugDescription: String {
        return toLongString()
    }
    
    func toLongString() -> String {
        if mpfr_nan_p(&mpfr) != 0 {
            return "Not a Number"
        }
        if mpfr_inf_p(&mpfr) != 0 {
            return "Infinity"
        }
        
        // set negative 0 to 0
        if mpfr_zero_p(&mpfr) != 0 {
            return "0"
        }
        
        let significantBytesEstimate = Int(round(0.302 * Double(mpfr_get_prec(&mpfr))))+1
        var expptr: mpfr_exp_t = 0
        var charArray: Array<CChar> = Array(repeating: 0, count: significantBytesEstimate+2) // +2 because: one for a possible - and one for zero termination
        mpfr_get_str(&charArray, &expptr, 10, significantBytesEstimate, &mpfr, MPFR_RNDN)
        
        // for speed, we work a bit with the charArray before using swift string
        
        // negative?
        var negative = false
        if charArray[0] == 45 {
            charArray.removeFirst()
            negative = true
        }
        
        // find last non-zero digit
        var lastSignificantIndex = charArray.count-1
        while (charArray[lastSignificantIndex] == 0 || charArray[lastSignificantIndex] == 48) && lastSignificantIndex > 0 {
            lastSignificantIndex -= 1
        }
        let lastSignificantDigit = lastSignificantIndex + 1
        
        // is it an Integer?
        if expptr > 0 && lastSignificantDigit <= expptr && expptr < significantBytesEstimate {
            charArray[expptr] = 0
            guard let integerString = String(validatingUTF8: charArray)
            else { return "not a number" }
            if negative {
                return "-"+integerString
            } else {
                return integerString
            }
        }
        
        // do we have a simple double that can written in decimal notation?
        let doubleDigits = 6
        if lastSignificantDigit < doubleDigits && abs(expptr) < 10 {
            let d = mpfr_get_d(&mpfr, MPFR_RNDN)
            return String(d)
        }
        
        charArray[lastSignificantDigit] = 0
        
        guard var floatString = String(validatingUTF8: charArray)
        else { return "not a number" }
        
        // make sure the length of the float string is at least two characters
        while floatString.count < 2 { floatString += "0" }
        
        floatString.insert(".", at: floatString.index(floatString.startIndex, offsetBy: 1))
        
        // if exponent is 0, drop it
        if expptr-1 != 0 {
            floatString += " E"+String(expptr-1)
        }
        
        if negative {
            return "-"+floatString
        } else {
            return floatString
        }
    }
    
    func printCharArray(_ a: Array<CChar>) {
        var s1 = "["
        var s2 = "["
        for c in a {
            s1 += String(format: "%3i,", UInt8(c))
            if c != 0 {
                let x1 = UInt8(c)
                let x2 = UnicodeScalar(x1)
                let x3 = String(x2)
                s2 += x3.withCString { String(format: "%3s,", $0) }
            } else {
                s2 += "  -,"
            }
        }
        s1 = String(s1.dropLast())
        s2 = String(s2.dropLast())
        s1 += "]"
        s2 += "]"
        print(s1)
        print(s2)
    }
    
    func getIntegerString(_ a: Array<CChar>, exponent: Int) -> String {
        var s = ""
        var l = 0
        for c in a {
            if c != 0 && l < exponent+1 {
                let x1 = UInt8(c)
                let x2 = UnicodeScalar(x1)
                let x3 = String(x2)
                s += x3.withCString { String(format: "%s", $0) }
            }
            l += 1
        }
        print("getIntegerString: \(s)")
        return s
    }
    
    
    func getZeroDotString(_ a: Array<CChar>, exponent: Int, significantDigits: Int) -> String {
        var s = "0."
        var l = 0
        for _ in 1..<(-1*exponent) {
            s += "0"
        }
        for c in a {
            if c != 0 && l < significantDigits {
                let x1 = UInt8(c)
                let x2 = UnicodeScalar(x1)
                let x3 = String(x2)
                s += x3.withCString { String(format: "%s", $0) }
            }
            l += 1
        }
        print("getZeroDotString: \(s)")
        return s
    }
    
    func getXDotString(_ a: Array<CChar>, exponent: Int, significantDigits: Int) -> String {
        var s = ""
        /// first digit
        let x1 = UInt8(a[0])
        let x2 = UnicodeScalar(x1)
        let x3 = String(x2)
        s += x3.withCString { String(format: "%s", $0) }
        s += "."
        
        var l = 0
        for c in a {
            if c != 0 && l > 0 && l < significantDigits {
                let x1 = UInt8(c)
                let x2 = UnicodeScalar(x1)
                let x3 = String(x2)
                s += x3.withCString { String(format: "%s", $0) }
            }
            l += 1
        }
        print("getXDotString: \(s)")
        return s
    }
    
    func getScientificString(
        _ a: Array<CChar>,
        exponent: Int,
        significantDigits: Int,
        availableDigits: Int) -> String {
        var s = ""
        
        /// first digit
        let x1 = UInt8(a[0])
        let x2 = UnicodeScalar(x1)
        let x3 = String(x2)
        s += x3.withCString { String(format: "%s", $0) }
        s += "."
        
        var l = 0
        for c in a {
            if l > 0 && c != 0 && l < min(significantDigits, availableDigits) {
                let x1 = UInt8(c)
                let x2 = UnicodeScalar(x1)
                let x3 = String(x2)
                s += x3.withCString { String(format: "%s", $0) }
            }
            l += 1
        }
        
        if s.count == 2 {
            /// the mantissa is of type "x."
            s += "0"
        }
        
        if exponent != 0 {
            s += "e"
            s += String(exponent)
        }
        
        print("getScientificString: \(s)")
        return s
    }
    
    func shortDisplayString() -> ShortDisplayString {
        if mpfr_nan_p(&mpfr) != 0 {
            return ShortDisplayString(
                isValidNumber: false,
                isNegative: false,
                higherPrecisionAvailable: false,
                isScientificNotation: false,
                content: "Not a Number")
        }
        if mpfr_inf_p(&mpfr) != 0 {
            return ShortDisplayString(
                isValidNumber: false,
                isNegative: false,
                higherPrecisionAvailable: false,
                isScientificNotation: false,
                content: "Infinity")
        }
        
        // set negative 0 to 0
        if mpfr_zero_p(&mpfr) != 0 {
            return ShortDisplayString(
                isValidNumber: true,
                isNegative: false,
                higherPrecisionAvailable: false,
                isScientificNotation: false,
                content: "0")
        }
        
        let charArrayLength = Configuration.shared.digits + 5 // some extra bytes for debugging
        var exponent: mpfr_exp_t = 0
        var charArray: Array<CChar> = Array(repeating: 0, count: charArrayLength)
        mpfr_get_str(&charArray, &exponent, 10, charArrayLength, &mpfr, MPFR_RNDN)
        
        exponent -= 1 /// This gives the actual power 10 exponent
        
        if exponent > 160 {
            return ShortDisplayString(
                isValidNumber: false,
                isNegative: false,
                higherPrecisionAvailable: false,
                isScientificNotation: false,
                content: "too large")
        }
        
        if exponent < -160 {
            return ShortDisplayString(
                isValidNumber: false,
                isNegative: false,
                higherPrecisionAvailable: false,
                isScientificNotation: false,
                content: "too small")
        }
        
        // negative?
        var negative = false
        if charArray[0] == 45 {
            charArray.removeFirst()
            negative = true
        }
        
        print("exponent=\(exponent) \(negative ? "negative" : "")")
        printCharArray(charArray)
        
        // find last significant digit
        var lastSignificantIndex = charArray.count-1
        while (charArray[lastSignificantIndex] == 0 || charArray[lastSignificantIndex] == 48) && lastSignificantIndex > 0 {
            lastSignificantIndex -= 1
        }
        let significantDigits = lastSignificantIndex + 1
        print("significantDigits=\(significantDigits)")
        
        // is it an Integer?
        var availableDigits = negative ? Configuration.shared.digits-1 : Configuration.shared.digits
        if exponent >= 0 && exponent <= availableDigits && significantDigits <= exponent+1 {
            return ShortDisplayString(
                isValidNumber: true,
                isNegative: negative,
                higherPrecisionAvailable: false,
                isScientificNotation: false,
                content: getIntegerString(charArray, exponent: exponent))
        }
        
        // is it a floating point number, starting with 0. ?
        availableDigits = negative ? Configuration.shared.digits-2 : Configuration.shared.digits-1 /// 9 minus one for "0." minus? negative
        if exponent < 0 && significantDigits - exponent <= availableDigits {
            return ShortDisplayString(
                isValidNumber: true,
                isNegative: negative,
                higherPrecisionAvailable: false,
                isScientificNotation: false,
                content: getZeroDotString(charArray, exponent: exponent, significantDigits: significantDigits))
        }
        // is it a floating point number, starting with X. ?
        availableDigits = negative ? Configuration.shared.digits-1 : Configuration.shared.digits
        if exponent == 0 && significantDigits <= availableDigits {
            return ShortDisplayString(
                isValidNumber: true,
                isNegative: negative,
                higherPrecisionAvailable: false,
                isScientificNotation: false,
                content: getXDotString(charArray, exponent: exponent, significantDigits: significantDigits))
        }
        
        
        /// number that can be displayed in scientific notation without loss of precision?
        availableDigits = Configuration.shared.digits
        availableDigits -= 1 // for "e"
        if negative { availableDigits -= 1 }
        if exponent < 0 { availableDigits -= 1 }
        if exponent != 0 {
            let doubleExponent = Double(abs(exponent))
            let log10e = Int(floor(log10(doubleExponent))) + 1
            availableDigits -= log10e
        }
        return ShortDisplayString(
            isValidNumber: true,
            isNegative: negative,
            higherPrecisionAvailable: significantDigits > availableDigits,
            isScientificNotation: true,
            content: getScientificString(charArray, exponent: exponent, significantDigits: significantDigits, availableDigits: availableDigits))
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
        return lhs.toLongString() == rhs.toLongString()
    }
}
