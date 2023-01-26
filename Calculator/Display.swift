//
//  Display.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/25/22.
//

import SwiftUI

protocol DisplayLengthLimiter {
    var kerning: CGFloat      { get }
    var uiFont: UIFont        { get }
    var displayWidth: CGFloat { set get }
    var ePadding: CGFloat     { set get }
    var isPortraitPhone: Bool { get }
}

struct Display {
    var left: String
    var portraitPhoneString: String?
    var right: String?
    var maxlength: Int
    var canBeInteger: Bool
    var canBeFloat: Bool
    var preliminary: Bool = false

    var color: Color = .white
    
    var isZero: Bool {
        left == "0" && right == nil
    }
    
    var allInOneLine: String {
        left + (right ?? "")
    }
    var length: Int {
        var ret = left.count
        if right != nil { ret += right!.count }
        return ret
    }
}

extension Display {
    init(
    left: String,
    right: String?,
    maxlength: Int,
    canBeInteger: Bool,
    canBeFloat: Bool) {
        self.left = left
        self.right = right
        self.maxlength = maxlength
        self.canBeInteger = canBeInteger
        self.canBeFloat = canBeFloat
    }
    init(left: String) {
        self.left = left
        right = nil
        maxlength = 0
        canBeInteger = false
        canBeFloat = false
    }
    init(_ number: Number, forceScientific: Bool = false, screen: Screen, noLimits: Bool = false, showAs: ShowAs) {
        self.left = "0"
        right = nil
        maxlength = 0
        canBeInteger = false
        canBeFloat = false
        self = fromNumber(number, displayLengthLimiter: noLimits ? nil : screen, separators: screen, showAs: showAs)
    }
    init(_ stringNumber: String, screen: Screen, showAs: ShowAs) {
        self.left = "0"
        right = nil
        maxlength = 0
        canBeInteger = false
        canBeFloat = false
        self = fromStringNumber(stringNumber, displayLengthLimiter: screen, separators: screen, showAs: showAs)
    }
}

extension Display {
    func fromLeft(_ left: String) -> Display {
        return Display(left: left)
    }

    func fromNumber(_ number: Number, displayLengthLimiter: DisplayLengthLimiter?, separators: Separators, showAs: ShowAs) -> Display {
        if number.str != nil {
            return fromStringNumber(number.str!, displayLengthLimiter: displayLengthLimiter, separators: separators, showAs: showAs)
        }

        guard number.gmp != nil else {
            assert(false, "DisplayData candidate no str and no gmp")
            return fromLeft("error")
        }

        let displayGmp: Gmp = number.gmp!

        if displayGmp.NaN {
            return fromLeft("not a number")
        }
        if displayGmp.inf {
            return fromLeft("infinity")
        }

        if displayGmp.isZero {
            return fromLeft("0")
        }

        let mantissaLength: Int
        if displayLengthLimiter != nil {
            mantissaLength = min(displayGmp.precision, Number.MAX_DISPLAY_LENGTH)
        } else {
            mantissaLength = displayGmp.precision
        }
        let (mantissa, exponent) = displayGmp.mantissaExponent(len: mantissaLength)
        
        return fromMantissaAndExponent(mantissa, exponent, displayLengthLimiter: displayLengthLimiter, separators: separators)
    }

    func fromStringNumber(_ stringNumber: String, displayLengthLimiter: DisplayLengthLimiter?, separators: Separators, showAs: ShowAs) -> Display {
        guard !stringNumber.contains(",") else { assert(false, "string contains comma, but only dot is allowed") }
        guard !stringNumber.contains("e") else { assert(false, "scientific?") }
        var mantissa: String
        var exponent: Int
        
        /// stringNumber fits in the display? show it!
        let signAndSeparator: String
        mantissa = stringNumber
        if stringNumber.starts(with: "-") {
            let temp = String(mantissa.dropFirst())
            signAndSeparator = withSeparators(numberString: temp, isNegative: true, separators: separators)
        } else {
            signAndSeparator = withSeparators(numberString: mantissa, isNegative: false, separators: separators)
        }

        if let displayLengthLimiter = displayLengthLimiter {
            if textWidth(signAndSeparator, displayLengthLimiter: displayLengthLimiter) <= displayLengthLimiter.displayWidth - displayLengthLimiter.ePadding {
                return fromLeft(signAndSeparator)
            } /// else: too long to fil into a single line display
        } else {
            /// no limiter: return. E.g. to copy to paste bin
            return fromLeft(signAndSeparator)
        }
        
        /// integer or float
        if stringNumber.contains(".") {
            /// float
            let tempArray = stringNumber.split(separator: ".")
            
            var integerPart: String = ""
            var fractionPart: String = ""
            if tempArray.count == 1 {
                integerPart = String(tempArray[0])
                fractionPart = ""
            } else if tempArray.count == 2 {
                integerPart = String(tempArray[0])
                fractionPart = String(tempArray[1])
            } else {
                assert(false, "DisplayData: tempArray.count = \(tempArray.count)")
            }
            
            mantissa = integerPart + fractionPart
            exponent = integerPart.count - 1
            while mantissa.starts(with: "0") {
                mantissa = mantissa.replacingFirstOccurrence(of: "0", with: "")
                exponent -= 1
            }
        } else {
            /// no dot --> integer
            mantissa = stringNumber
            exponent = stringNumber.count - 1
        }
        if mantissa.starts(with: "-") { exponent -= 1 }
        return fromMantissaAndExponent(mantissa, exponent, displayLengthLimiter: displayLengthLimiter, separators: separators)
    }
    
    func withSeparators(numberString: String, isNegative: Bool, separators: Separators) -> String {
        var integerPart: String
        let fractionalPart: String
        
        if numberString.contains(".") {
            integerPart = numberString.before(first: ".")
            fractionalPart = numberString.after(first: ".")
        } else {
            /// integer
            integerPart = numberString
            fractionalPart = ""
        }
        
        if let c = separators.groupingSeparator.character {
            var count = integerPart.count
            while count >= 4 {
                count = count - 3
                integerPart.insert(c, at: integerPart.index(integerPart.startIndex, offsetBy: count))
            }
        }
        let minusSign = isNegative ? "-" : ""
        if numberString.contains(".") {
            return minusSign + integerPart + separators.decimalSeparator.string + fractionalPart
        } else {
            return minusSign + integerPart
        }
    }
    
    private func textSize(string: String, displayLengthLimiter: DisplayLengthLimiter) -> CGSize {
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[.kern] = displayLengthLimiter.kerning
        attributes[.font] = displayLengthLimiter.uiFont
        return string.size(withAttributes: attributes)
    }
    func textWidth(_ string: String, displayLengthLimiter: DisplayLengthLimiter) -> CGFloat {
        textSize(string: string, displayLengthLimiter: displayLengthLimiter).width
    }
    
    func textHeight(_ string: String, displayLengthLimiter: DisplayLengthLimiter) -> CGFloat {
        textSize(string: string, displayLengthLimiter: displayLengthLimiter).height
    }
    
    private func fromMantissaAndExponent(_ mantissa_: String, _ exponent: Int, displayLengthLimiter: DisplayLengthLimiter?, separators: Separators) -> Display {
        var mantissa = mantissa_
        
        if mantissa.isEmpty {
            mantissa = "0"
        }
        
        /// negative? Special treatment
        let isNegative = mantissa.first == "-"
        if isNegative {
            mantissa.removeFirst()
        }
        
        /// Can be displayed as Integer?
        /*
         123,456,789,012,345,678,901,123,456 --> 400 pixel
         What can be displayed in 200 pixel?
         - I dont want the separator as leading character!
         */
        if mantissa.count <= exponent + 1 { /// smaller than because of possible trailing zeroes in the integer
            mantissa = mantissa.padding(toLength: exponent+1, withPad: "0", startingAt: 0)
            let withSeparators = withSeparators(numberString: mantissa, isNegative: isNegative, separators: separators)
            if let displayLengthLimiter = displayLengthLimiter {
                if textWidth(withSeparators, displayLengthLimiter: displayLengthLimiter) <= displayLengthLimiter.displayWidth - displayLengthLimiter.ePadding {
                    return Display(left: withSeparators, right: nil, maxlength: 0, canBeInteger: true, canBeFloat: false)
                }
            } else {
                return Display(left: withSeparators, right: nil, maxlength: 0, canBeInteger: true, canBeFloat: false)
            }
        }
        
        /// Is floating point XXX,xxx?
        if exponent >= 0 {
            var floatString = mantissa
            let index = floatString.index(floatString.startIndex, offsetBy: exponent+1)
            var indexInt: Int = floatString.distance(from: floatString.startIndex, to: index)
            floatString.insert(".", at: index)
            floatString = withSeparators(numberString: floatString, isNegative: isNegative, separators: separators)
            if let displayLengthLimiter = displayLengthLimiter {
                if let index = floatString.firstIndex(of: separators.decimalSeparator.character) {
                    indexInt = floatString.distance(from: floatString.startIndex, to: index)
                    var floatCandidate = String(floatString.prefix(indexInt+1))
                    if textWidth(floatCandidate, displayLengthLimiter: displayLengthLimiter) <= displayLengthLimiter.displayWidth - displayLengthLimiter.ePadding {
                        if displayLengthLimiter.isPortraitPhone {
                            while textWidth(floatCandidate, displayLengthLimiter: displayLengthLimiter) <= displayLengthLimiter.displayWidth - displayLengthLimiter.ePadding {
                                indexInt += 1
                                floatCandidate = String(floatString.prefix(indexInt+1))
                            }
                            floatCandidate = String(floatCandidate.prefix(indexInt))
                            return Display(left: floatCandidate, right: nil, maxlength: 0, canBeInteger: false, canBeFloat: false)
                        } else {
                            return Display(left: floatString, right: nil, maxlength: 0, canBeInteger: false, canBeFloat: false)
                        }
                    }
                }
            } else {
                return Display(left: floatString, right: nil, maxlength: 0, canBeInteger: false, canBeFloat: false)
            }
            /// is the comma visible in the first line and is there at least one digit after the comma?
        }
        
        /// is floating point 0,xxxx
        /// additional requirement: first non-zero digit in first line. If not -> Scientific
        if exponent < 0 {
            let minusSign = isNegative ? "-" : ""
            
            var testFloat = minusSign + "0" + separators.decimalSeparator.string
            var floatString = mantissa
            for _ in 0..<(-1*exponent - 1) {
                floatString = "0" + floatString
                testFloat += "0"
            }
            testFloat += "x"
            floatString = minusSign + "0" + separators.decimalSeparator.string + floatString
            if let displayLengthLimiter = displayLengthLimiter {
                if textWidth(testFloat, displayLengthLimiter: displayLengthLimiter) <= displayLengthLimiter.displayWidth - displayLengthLimiter.ePadding {
                    if displayLengthLimiter.isPortraitPhone {
                        var indexInt = 3 /// minimum: X,x
                        var limitedFloatString = String(floatString.prefix(indexInt))
                        while textWidth(limitedFloatString, displayLengthLimiter: displayLengthLimiter) <= displayLengthLimiter.displayWidth {
                            indexInt += 1
                            limitedFloatString = String(floatString.prefix(indexInt))
                        }
                        limitedFloatString = String(limitedFloatString.prefix(indexInt-1))
                        return Display(left: limitedFloatString, right: nil, maxlength: 0, canBeInteger: false, canBeFloat: false)
                    } else {
                        return Display(left: floatString, right: nil, maxlength: 0, canBeInteger: false, canBeFloat: false)
                    }
                }
            } else {
                return Display(left: floatString, right: nil, maxlength: 0, canBeInteger: false, canBeFloat: false)
            }
        }
        
        mantissa = mantissa_
        if isNegative {
            mantissa.removeFirst()
        }
        
        let secondIndex = mantissa.index(mantissa.startIndex, offsetBy: 1)
        mantissa.insert(".", at: secondIndex)
        if mantissa.count == 2 {
            // 4.
            mantissa.append("0")
        }
        mantissa = withSeparators(numberString: mantissa, isNegative: isNegative, separators: separators)
        let exponentString = "e\(exponent)"
        if let displayLengthLimiter = displayLengthLimiter {
            if displayLengthLimiter.isPortraitPhone {
                var indexInt = 3 /// minimum: X,x
                var floatString = String(mantissa.prefix(indexInt))
                if textWidth(floatString + exponentString, displayLengthLimiter: displayLengthLimiter) > displayLengthLimiter.displayWidth - displayLengthLimiter.ePadding {
                    return Display(left: "can not show")
                }
                while textWidth(floatString + exponentString, displayLengthLimiter: displayLengthLimiter) <= displayLengthLimiter.displayWidth - displayLengthLimiter.ePadding {
                    indexInt += 1
                    floatString = String(mantissa.prefix(indexInt))
                }
                floatString = String(floatString.prefix(indexInt-1))
                return Display(left: floatString, right: exponentString, maxlength: 0, canBeInteger: false, canBeFloat: false)
            } else {
                return Display(left: mantissa, right: exponentString, maxlength: 0, canBeInteger: false, canBeFloat: true)
            }
        } else {
            return Display(left: mantissa, right: exponentString, maxlength: 0, canBeInteger: false, canBeFloat: true)
        }
    }
}
//
//struct DisplayFormat {
//    let font: Font
//    let color: Color
//    let showThreeDots: Bool
//    let digitWidth: CGFloat
//    let ePadding: CGFloat
//    let kerning: CGFloat
//    
//    init(for length: Int, withMaxLength maxLength: Int, showThreeDots: Bool, screen: Screen) {
//        var factor = 1.0
//        
//        if screen.isPortraitPhone {
//            let factorMin = 1.0
//            let factorMax = 2.0
//            // if factorMax is too large (above 2.3) the space needed
//            // for the new caracter is more then the shrinking,
//            // which results in the string to be too long
//            
//            let notOccupiedLength = CGFloat(length) / CGFloat(maxLength)
//            factor = factorMax - notOccupiedLength * (factorMax - factorMin)
//            if factor > 1.5 { factor = 1.5 }
//            if factor < 1.0 { factor = 1.0 }
//        }
//        let uiFont = UIFont.monospacedDigitSystemFont(ofSize: screen.uiFontSize * factor, weight: screen.uiFontWeight)
//        
//        font = Font(uiFont)
//        color = showThreeDots ? .gray : .white
//        self.showThreeDots = showThreeDots
//        self.digitWidth = screen.digitWidth
//        self.ePadding = screen.ePadding
//        self.kerning = screen.kerning
//    }
//}
