//
//  ScreenModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/26/22.
//

import SwiftUI

class Screen: Equatable, ObservableObject {
    
    enum DecimalSeparator: String, Codable, CaseIterable{
        case comma
        case dot
        var character: Character {
            switch self {
            case .comma: return ","
            case .dot: return "."
            }
        }
        var string: String { String(character) }
    }
    enum ThousandSeparator: String, Codable, CaseIterable{
        case none
        case comma
        case dot
        var character: Character? {
            switch self {
            case .none: return nil
            case .comma: return ","
            case .dot: return "."
            }
        }
        var string: String {
            guard let character = character else { return "" }
            return String(character)
        }
    }
    
    @AppStorage("DecimalSeparator") var decimalSeparator: DecimalSeparator = .comma
    @AppStorage("DecimalSeparator") var thousandSeparator: ThousandSeparator = .none
    @AppStorage("forceScientific", store: .standard) var forceScientific: Bool = false

    static func == (lhs: Screen, rhs: Screen) -> Bool { /// used to detect rotation
        lhs.keySize == rhs.keySize
    }
    
    /// no @Published propertied, but objectWillChange.send() at the end of update()
    let isPad: Bool
    let isPortraitPhone: Bool
    let keyboardHeight: CGFloat
    let keySpacing: CGFloat
    let keySize: CGSize
    let ePadding: CGFloat
    let plusIconSize: CGFloat
    let plusIconLeftPadding: CGFloat
    let uiFontSize: CGFloat
    let uiFontWeight: UIFont.Weight
    let infoUiFont: UIFont
    let infoUiFontSize: CGFloat
    let portraitIPhoneDisplayHorizontalPadding: CGFloat
    let portraitIPhoneDisplayBottomPadding: CGFloat
    let horizontalPadding: CGFloat
    let bottomPadding: CGFloat
    var offsetToVerticallyAlignTextWithkeyboard: CGFloat = 0.0
    var offsetToVerticallyIconWithText: CGFloat = 0.0
    let kerning: CGFloat
    var textHeight: CGFloat = 0.0
    var infoTextHeight: CGFloat = 0.0
    var displayWidth: CGFloat = 0.0
    var digitWidth: CGFloat = 0.0
    var eWidth: CGFloat = 0.0
    var decimalSeparatorWidth: CGFloat = 0.0
    var thousandSeparatorWidth: CGFloat = 0.0
    
    private let uiFont: UIFont
    private let calculatorWidth: CGFloat
    
    init(_ screenSize: CGSize) {
         print("Screen INIT", screenSize)
        
        isPad = UIDevice.current.userInterfaceIdiom == .pad
        let isPortrait = screenSize.height > screenSize.width
        isPortraitPhone = isPad ? false : isPortrait
        
        if isPortraitPhone {
            keySpacing = 0.034 * screenSize.width
            horizontalPadding = keySpacing
        } else {
            // with scientific keyboard: narrower spacing
            keySpacing = 0.012 * screenSize.width
            horizontalPadding = 0.0
        }
        
        portraitIPhoneDisplayHorizontalPadding = screenSize.width * 0.035
        portraitIPhoneDisplayBottomPadding = screenSize.height * 0.012
        
        calculatorWidth = screenSize.width - 2 * horizontalPadding
        let tempKeyWidth: CGFloat
        let tempKeyheight: CGFloat
        if isPortrait {
            /// Round keys
            tempKeyWidth = isPad ? (calculatorWidth - 9.0 * keySpacing) * 0.1 : (calculatorWidth - 3.0 * keySpacing) * 0.25
            tempKeyheight = tempKeyWidth
            keyboardHeight = 5 * tempKeyheight + 4 * keySpacing
            bottomPadding = isPad ? 0.0 : keyboardHeight * 0.09
        } else {
            /// wider keys
            tempKeyWidth = (calculatorWidth - 9.0 * keySpacing) * 0.1
            if isPad {
                /// landscape iPad: half of the screen is the keyboard
                keyboardHeight = isPortrait ? screenSize.height * 0.4 : screenSize.height * 0.5
            } else {
                /// iPhone landscape
                keyboardHeight = 0.8 * screenSize.height
            }
            tempKeyheight = (keyboardHeight - 4.0 * keySpacing) * 0.2
            bottomPadding = 0.0
        }
        
        keySize = CGSize(width: tempKeyWidth, height: tempKeyheight)
        
        plusIconSize = keyboardHeight * 0.13
        plusIconLeftPadding = plusIconSize * 0.4
        ePadding = isPortraitPhone ? plusIconSize * 0.1 : plusIconSize * 0.3
        uiFontSize = ((isPortraitPhone ? 0.125 : 0.16) * keyboardHeight).rounded()
        uiFontWeight = UIFont.Weight.thin
        uiFont = UIFont.monospacedDigitSystemFont(ofSize: uiFontSize, weight: uiFontWeight)
        infoUiFontSize = uiFontSize * 0.3
        infoUiFont = UIFont.monospacedDigitSystemFont(ofSize: infoUiFontSize, weight: .regular)
        kerning = -0.02 * uiFontSize
        
        textHeight = textHeight("0")
        infoTextHeight = textHeight("0", uiFont: infoUiFont)
        
        offsetToVerticallyAlignTextWithkeyboard =
        CGFloat(screenSize.height) -
        CGFloat(keyboardHeight) -
        CGFloat(infoUiFontSize) -
        CGFloat(textHeight)
        
        offsetToVerticallyIconWithText =
        CGFloat(screenSize.height) -
        CGFloat(keyboardHeight) -
        CGFloat(infoUiFontSize) -
        CGFloat(plusIconSize) +
        CGFloat(uiFont.descender) -
        CGFloat(0.5 * uiFont.capHeight) +
        CGFloat(0.5 * plusIconSize)
                
        displayWidth = calculatorWidth -
        (isPortraitPhone ? 2.0 * portraitIPhoneDisplayHorizontalPadding : plusIconSize + plusIconLeftPadding)
        
        digitWidth             = textWidth("0")
        eWidth                 = textWidth("0")
        decimalSeparatorWidth  = textWidth(_decimalSeparator.wrappedValue.string)
        thousandSeparatorWidth = textWidth(_thousandSeparator.wrappedValue.string)
    }
        
    func localized(_ stringNumber: String) -> DisplayData {
        guard !stringNumber.contains(",") else { assert(false, "string contains comma, but only dot is allowed") }
        guard !stringNumber.contains("e") else { assert(false, "scientific?") }

        var mantissa: String
        var exponent: Int

        /// stringNumber fits in the display? show it!
        let correctSeparator: String
        mantissa = stringNumber
        if stringNumber.starts(with: "-") {
            let temp = String(mantissa.dropFirst())
            correctSeparator = withSeparators(numberString: temp, isNegative: true)
        } else {
            correctSeparator = withSeparators(numberString: mantissa, isNegative: false)
        }
        if textWidth(correctSeparator) <= displayWidth {
            return DisplayData(left: correctSeparator, maxlength: 0, canBeInteger: false, canBeFloat: false)
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
                assert(false, "localized: tempArray.count = \(tempArray.count)")
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
        return process(mantissa, exponent)
    }
    
    func process(_ mantissa_: String, _ exponent: Int) -> DisplayData {
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
            let withSeparators = withSeparators(numberString: mantissa, isNegative: isNegative)
            if textWidth(withSeparators) <= displayWidth {
                return DisplayData(left: withSeparators, right: nil, maxlength: 0, canBeInteger: true, canBeFloat: false)
            }
        }
        
        /// Is floating point XXX,xxx?
        if exponent >= 0 {
            var floatString = mantissa
            let index = floatString.index(floatString.startIndex, offsetBy: exponent+1)
            var indexInt: Int = floatString.distance(from: floatString.startIndex, to: index)
            floatString.insert(".", at: index)
            floatString = withSeparators(numberString: floatString, isNegative: isNegative)
            if let index = floatString.firstIndex(of: decimalSeparator.character) {
                indexInt = floatString.distance(from: floatString.startIndex, to: index)
                let floatCandidate = String(floatString.prefix(indexInt+1))
                if textWidth(floatCandidate) <= displayWidth {
                    return DisplayData(left: floatString, right: nil, maxlength: 0, canBeInteger: false, canBeFloat: false)
                }
            }
            /// is the comma visible in the first line and is there at least one digit after the comma?
        }
        
        /// is floating point 0,xxxx
        /// additional requirement: first non-zero digit in first line. If not -> Scientific
        if exponent < 0 {
            let minusSign = isNegative ? "-" : ""

            var testFloat = minusSign + "0" + decimalSeparator.string
            var floatString = mantissa
            for _ in 0..<(-1*exponent - 1) {
                floatString = "0" + floatString
                testFloat += "0"
            }
            testFloat += "x"
            if textWidth(testFloat) <= displayWidth {
                floatString = minusSign + "0" + decimalSeparator.string + floatString
                return DisplayData(left: floatString, right: nil, maxlength: 0, canBeInteger: false, canBeFloat: false)
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
        mantissa = withSeparators(numberString: mantissa, isNegative: isNegative)
        let exponentString = "e\(exponent)"
        return DisplayData(left: mantissa, right: exponentString, maxlength: 0, canBeInteger: false, canBeFloat: true)
    }
    
    func localized(_ candidate: Number, forceScientific: Bool = false) -> DisplayData {
        if candidate.str != nil {
            return localized(candidate.str!)
        }

        guard candidate.gmp != nil else {
            assert(false, "localized candidate no str and no gmp")
            return DisplayData(left: "error")
        }
        
        let displayGmp: Gmp = candidate.gmp!
        
        if displayGmp.NaN {
            return DisplayData(left: "not a number")
        }
        if displayGmp.inf {
            return DisplayData(left: "infinity")
        }
        
        if displayGmp.isZero {
            return DisplayData(left: "0")
        }

        let (mantissa, exponent) = displayGmp.mantissaExponent(len: min(displayGmp.precision, Number.MAX_DISPLAY_LENGTH))

        return process(mantissa, exponent)

    }
    
    func withSeparators(numberString: String, isNegative: Bool) -> String {
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
        
        if let c = thousandSeparator.character {
            var count = integerPart.count
            while count >= 4 {
                count = count - 3
                integerPart.insert(c, at: integerPart.index(integerPart.startIndex, offsetBy: count))
            }
        }
        let minusSign = isNegative ? "-" : ""
        if numberString.contains(".") {
            return minusSign + integerPart + decimalSeparator.string + fractionalPart
        } else {
            return minusSign + integerPart
        }
    }
    
    private func textSize(string: String, uiFont: UIFont?, kerning: CGFloat) -> CGSize {
        let font: UIFont
        if uiFont != nil {
            font = uiFont!
        } else {
            font = self.uiFont
        }
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[.kern] = kerning
        attributes[.font] = font
        return string.size(withAttributes: attributes)
    }
    func textWidth(_ string: String, uiFont: UIFont? = nil, kerning: CGFloat = 0.0) -> CGFloat {
        textSize(string: string, uiFont: uiFont, kerning: kerning).width
    }

    func textHeight(_ string: String, uiFont: UIFont? = nil, kerning: CGFloat = 0.0) -> CGFloat {
        textSize(string: string, uiFont: uiFont, kerning: kerning).height
    }

}

extension String {
    func before(first delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            let before = prefix(upTo: index)
            return String(before)
        }
        return ""
    }
    
    func after(first delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            let after = suffix(from: index).dropFirst()
            return String(after)
        }
        return ""
    }

    func replacingFirstOccurrence(of target: String, with replacement: String) -> String {
        guard let range = self.range(of: target) else { return self }
        return self.replacingCharacters(in: range, with: replacement)
    }
}


//    func trimToDisplaylength(withSeparators: String) -> String {
//        var position = withSeparators.count - 1
//        print("withSeparators", withSeparators, "position", position)
//        print("displayWidth", displayWidth)
//
//        var trimmed = ""
//        while position >= 0 && trimmed.textWidth(for: uiFont, kerning: kerning) <= displayWidth {
//            print("position", position, "width", trimmed.textWidth(for: uiFont, kerning: kerning))
//            let startIndex = withSeparators.index(withSeparators.startIndex, offsetBy: position)
//            let endIndex = withSeparators.index(before: withSeparators.endIndex)
//            trimmed = String(withSeparators[startIndex...endIndex])
//            position -= 1
//        }
////        let endIndex = withSeparators.endIndex
////        print(withSeparators[endIndex])
////        var n = 1
////        var x = ""
////        while x.textWidth(for: uiFont, kerning: kerning) < displayWidth && n < withSeparators.count {
////            let index = withSeparators.index(endIndex, offsetBy: -n)
////            x = String(withSeparators[index...endIndex])
////            n += 1
////        }
////
//        print("--> trimmed", trimmed)
//        return trimmed
//    }

//if forceScientific {
//    // what precision do I need to convert the string into a Gmp?
//    // The length of the string is not sufficient because Gmp does not use base 10
//    // Let's try three times the length with a minumum of 1000
//    // Note that displayGmp is not used in further calculations!
//    let displayPrecision: Int = max(stringNumber.count * 3, 1000)
//    let asGmp = Gmp(withString: stringNumber, precision: displayPrecision)
//    return localizedScientific(asGmp)
//}
