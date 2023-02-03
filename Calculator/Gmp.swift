//
//  Gmp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

// This class bridges between swift and the GMP library which is implemented in C


import Foundation

var globalUnsignedLongInt: CUnsignedLong = 0

class Gmp: Equatable, CustomDebugStringConvertible {
    private var bits: Int
    private (set) var precision: Int

    /// init with zeros. The struct will be initialized correctly in init() with mpfr_init2()
    private var mpfr: mpfr_t = mpfr_t(_mpfr_prec: 0, _mpfr_sign: 0, _mpfr_exp: 0, _mpfr_d: &globalUnsignedLongInt)

    init(withString string: String, precision: Int) {
        self.precision = precision
        self.bits = Number.bits(for: precision)
        mpfr_init2 (&mpfr, bits)
        mpfr_set_str (&mpfr, string, 10, MPFR_RNDN)
    }

//    private init(withMpfr from_mpfr: inout __mpfr_struct, bits: Int) {
//        self.bits = bits
//        mpfr_init2 (&mpfr, bits)
//        mpfr_set(&mpfr, &from_mpfr, MPFR_RNDN)
//    }

    deinit {
        mpfr_clear(&mpfr)
    }
    
    static func == (lhs: Gmp, rhs: Gmp) -> Bool {
        return mpfr_cmp(&lhs.mpfr, &rhs.mpfr) == 0
    }

    var debugDescription: String {
        let (mantissa, exponent) = mantissaExponent(len: 100)
        return "\(mantissa) \(exponent)"
    }

    static func isValidGmpString(_ gmpString: String, bits: Int) -> Bool {
        var temp_mpfr: mpfr_t = mpfr_t(_mpfr_prec: 0, _mpfr_sign: 0, _mpfr_exp: 0, _mpfr_d: &globalUnsignedLongInt)
        mpfr_init2 (&temp_mpfr, bits)
        return mpfr_set_str (&temp_mpfr, gmpString, 10, MPFR_RNDN) == 0
    }
        
    func mantissaExponent(len: Int) -> (String, Int) {
        var exponent: mpfr_exp_t = 0
        
        var charArray: Array<CChar> = Array(repeating: 0, count: len+10)
        mpfr_get_str(&charArray, &exponent, 10, len, &mpfr, MPFR_RNDN)
        var mantissa: String = ""
        
        charArray.withUnsafeBufferPointer { ptr in
            mantissa = String(cString: ptr.baseAddress!)
        }

        var zeroCharacterSet = CharacterSet()
        zeroCharacterSet.insert(charactersIn: "0")
        mantissa = mantissa.trimmingCharacters(in: zeroCharacterSet)

        return (mantissa, exponent - 1)
    }

    func copy() -> Gmp {
        let ret = Gmp.init(withString: "0", precision: precision)
        mpfr_set(&ret.mpfr, &mpfr, MPFR_RNDN)
        return ret
    }
    
    static var randstate: gmp_randstate_t? = nil
    
    //func isNull()       -> Bool { mpfr_cmp_d(&mpfr, 0.0) == 0 }
    func isNegtive()    -> Bool { mpfr_cmp_d(&mpfr, 0.0)  < 0 }
    
    func inPlace(op: inplaceType) { op(self)() }
    /// in the second argument, I a simultaneously using the same memory
    /// Option 1: &mpfr -> &copy().mpfr
    /// Option 2: in the build settings set exclusiv access to memory to compiletime enfocement only
    func abs()        { mpfr_abs(  &mpfr, &mpfr, MPFR_RNDN) }
    func sqrt()       { mpfr_sqrt( &mpfr, &mpfr, MPFR_RNDN) }
    func sqrt3()      { mpfr_cbrt( &mpfr, &mpfr, MPFR_RNDN) }
    func Z()          { mpfr_zeta( &mpfr, &mpfr, MPFR_RNDN) }
    func ln()         { mpfr_log(  &mpfr, &mpfr, MPFR_RNDN) }
    func log10()      { mpfr_log10(&mpfr, &mpfr, MPFR_RNDN) }
    func log2()       { mpfr_log2 (&mpfr, &mpfr, MPFR_RNDN) }
    func sin()        { mpfr_sin(  &mpfr, &mpfr, MPFR_RNDN) }
    func cos()        { mpfr_cos(  &mpfr, &mpfr, MPFR_RNDN) }
    func tan()        { mpfr_tan(  &mpfr, &mpfr, MPFR_RNDN) }
    func asin()       { mpfr_asin( &mpfr, &mpfr, MPFR_RNDN) }
    func acos()       { mpfr_acos( &mpfr, &mpfr, MPFR_RNDN) }
    func atan()       { mpfr_atan( &mpfr, &mpfr, MPFR_RNDN) }
    func sinh()       { mpfr_sinh( &mpfr, &mpfr, MPFR_RNDN) }
    func cosh()       { mpfr_cosh( &mpfr, &mpfr, MPFR_RNDN) }
    func tanh()       { mpfr_tanh( &mpfr, &mpfr, MPFR_RNDN) }
    func asinh()      { mpfr_asinh(&mpfr, &mpfr, MPFR_RNDN) }
    func acosh()      { mpfr_acosh(&mpfr, &mpfr, MPFR_RNDN) }
    func atanh()      { mpfr_atanh(&mpfr, &mpfr, MPFR_RNDN) }
    func pow_x_2()    { mpfr_sqr(  &mpfr, &mpfr, MPFR_RNDN) }
    func pow_e_x()    { mpfr_exp(  &mpfr, &mpfr, MPFR_RNDN) }
    func pow_10_x()   { mpfr_exp10(&mpfr, &mpfr, MPFR_RNDN) }
    func changeSign() { mpfr_neg(  &mpfr, &mpfr, MPFR_RNDN) }
    
    static var deg2rad: Gmp? = nil
    static var rad2deg: Gmp? = nil
    static var rad_deg_precision: Int = 0
    
    static func check(_ precision: Int) {
        if precision != rad_deg_precision {
            deg2rad = Gmp(withString: "0", precision: precision);
            deg2rad!.π()
            deg2rad!.div(other: Gmp(withString: "180", precision: precision))
            Gmp.rad2deg = Gmp(withString: "0", precision: precision);
            Gmp.rad2deg!.π()
            Gmp.rad2deg!.rez()
            Gmp.rad2deg!.mul(other: Gmp(withString: "180", precision: precision))
        }
        rad_deg_precision = precision
    }
    
    func sinD()  { Gmp.check(precision); mpfr_mul(&mpfr, &mpfr, &Gmp.deg2rad!.mpfr, MPFR_RNDN); mpfr_sin(  &mpfr, &mpfr, MPFR_RNDN) }
    func cosD()  { Gmp.check(precision); mpfr_mul(&mpfr, &mpfr, &Gmp.deg2rad!.mpfr, MPFR_RNDN); mpfr_cos(  &mpfr, &mpfr, MPFR_RNDN) }
    func tanD()  { Gmp.check(precision); mpfr_mul(&mpfr, &mpfr, &Gmp.deg2rad!.mpfr, MPFR_RNDN); mpfr_tan(  &mpfr, &mpfr, MPFR_RNDN) }
    func asinD() { Gmp.check(precision); mpfr_asin( &mpfr, &mpfr, MPFR_RNDN); mpfr_mul(&mpfr, &mpfr, &Gmp.rad2deg!.mpfr, MPFR_RNDN) }
    func acosD() { Gmp.check(precision); mpfr_acos( &mpfr, &mpfr, MPFR_RNDN); mpfr_mul(&mpfr, &mpfr, &Gmp.rad2deg!.mpfr, MPFR_RNDN) }
    func atanD() { Gmp.check(precision); mpfr_atan( &mpfr, &mpfr, MPFR_RNDN); mpfr_mul(&mpfr, &mpfr, &Gmp.rad2deg!.mpfr, MPFR_RNDN) }
    
    func π() {
        mpfr_const_pi(&mpfr, MPFR_RNDN)
    }
    func e() {
        mpfr_exp( &mpfr, &Gmp(withString: "1.0", precision: precision).mpfr, MPFR_RNDN)
        /// Note: mpfr_const_euler() returns 0.577..., not 2.718
    }
    
    func rand() {
        if Gmp.randstate == nil {
            Gmp.randstate = gmp_randstate_t()
            __gmp_randinit_mt(&Gmp.randstate!)
            __gmp_randseed_ui(&Gmp.randstate!, UInt.random(in: 0..<UInt.max));
        }
        mpfr_urandom(&mpfr, &Gmp.randstate!, MPFR_RNDN)
    }
    
    
    func pow_x_3()    { mpfr_pow_ui(&mpfr, &mpfr, 3, MPFR_RNDN) }
    func pow_2_x()    { mpfr_ui_pow(&mpfr, 2, &mpfr, MPFR_RNDN) }
    func rez()        { mpfr_ui_div(&mpfr, 1, &mpfr, MPFR_RNDN) }
    func fac() {
        let n = mpfr_get_si(&mpfr, MPFR_RNDN)
        if n >= 0 {
            let un = UInt(n)
            mpfr_fac_ui(&mpfr, un, MPFR_RNDN)
        } else {
            mpfr_set_d(&mpfr, 0.0, MPFR_RNDN)
        }
    }
    
    func execute(_ op: twoOperantsType, with other: Gmp) { op(self)(other) }
    func add (other: Gmp) { mpfr_add(&mpfr, &mpfr, &other.mpfr, MPFR_RNDN) }
    func sub (other: Gmp) {
        mpfr_sub(&mpfr, &mpfr, &other.mpfr, MPFR_RNDN)
    }
    func mul (other: Gmp) { mpfr_mul(&mpfr, &mpfr, &other.mpfr, MPFR_RNDN) }
    func div (other: Gmp) { mpfr_div(&mpfr, &mpfr, &other.mpfr, MPFR_RNDN) }
    
    func pow_x_y(exponent: Gmp) { mpfr_pow(&mpfr, &mpfr, &exponent.mpfr, MPFR_RNDN) }
    func pow_y_x(base: Gmp)     { mpfr_pow(&mpfr, &base.mpfr, &mpfr, MPFR_RNDN) }
    func sqrty(exponent: Gmp)   { exponent.rez(); pow_x_y(exponent: exponent) }
    func logy(base: Gmp) {
        self.ln()
        base.ln()
        self.div(other: base)
    }
    func EE(other: Gmp) {
        other.pow_10_x()
        self.mul(other: other)
    }
    
    func setValue(other: Gmp) {
        mpfr_set(&mpfr, &other.mpfr, MPFR_RNDN)
    }
    
    func x_double_up_arrow_y(other: Gmp) {
        var temp: mpfr_t = mpfr_t(_mpfr_prec: 0, _mpfr_sign: 0, _mpfr_exp: 0, _mpfr_d: &globalUnsignedLongInt)
        mpfr_init2 (&temp, mpfr_get_prec(&mpfr))
        mpfr_set(&temp, &mpfr, MPFR_RNDN)
        
        let counter: CLong = mpfr_get_si(&other.mpfr, MPFR_RNDN) - 1
        guard counter > 0 else { return }
        for _ in 0..<counter {
            mpfr_pow(&mpfr, &temp, &mpfr, MPFR_RNDN)
        }
        mpfr_clear(&temp)
    }
    
    func toDouble() -> Double {
        return mpfr_get_d(&mpfr, MPFR_RNDN)
    }
    var isValid: Bool {
        if mpfr_number_p(&mpfr) == 0 { return false }
        if NaN { return false }
        if inf { return false }
        return true
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
        
    static func memorySize(bits: Int) -> Int {
        mpfr_custom_get_size(bits)
    }
}

