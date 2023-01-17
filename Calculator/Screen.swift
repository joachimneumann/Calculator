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
    let offsetToVerticallyAlignTextWithkeyboard: CGFloat
    let offsetToVerticallyIconWithText: CGFloat
    let kerning: CGFloat
    let textHeight: CGFloat
    let infoTextHeight: CGFloat
    let displayWidth: CGFloat
    let digitWidth: CGFloat
    let eWidth: CGFloat
    let decimalSeparatorWidth: CGFloat
    let thousandSeparatorWidth: CGFloat
    var lengths: Lengths /// will be updated when the digital or thousands separator changes
    
    private let uiFont: UIFont
    private let calculatorWidth: CGFloat
    
    init(_ screenSize: CGSize) {
        // print("Screen INIT", screenSize)
        
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
        
        textHeight = heightMeasurement(uiFont: uiFont, kerning: kerning)
        infoTextHeight = heightMeasurement(uiFont: infoUiFont, kerning: 0)
        
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
        
        lengths = Lengths(0)
        
        displayWidth = calculatorWidth -
        (isPortraitPhone ? 2.0 * portraitIPhoneDisplayHorizontalPadding : plusIconSize + plusIconLeftPadding)
        
        digitWidth             = "0".textSize(for: uiFont, kerning: kerning).width
        eWidth                 = "e".textSize(for: uiFont, kerning: kerning).width
        decimalSeparatorWidth  = _decimalSeparator.wrappedValue.string.textSize(for: uiFont, kerning: kerning).width
        thousandSeparatorWidth = _thousandSeparator.wrappedValue.string.textSize(for: uiFont, kerning: kerning).width
        
        measureTextLengths(screenSize: screenSize)
        
    }
    
    func measureTextLengths(screenSize: CGSize) {
        lengths = lengthMeasurement(width: displayWidth, uiFont: uiFont, infoUiFont: infoUiFont, ePadding: ePadding, kerning: kerning)
        objectWillChange.send()
    }
    
    func localized(_ candidate: String, forceScientific: Bool = false) -> DisplayData {
        if forceScientific {
            // what precision do I need to convert the string into a Gmp?
            // The length of the string is not sufficient because Gmp does not use base 10
            // Let's try three times the length with a minumum of 1000
            // Note that displayGmp is not used in further calculations!
            let displayPrecision: Int = max(candidate.count * 3, 1000)
            let asGmp = Gmp(withString: candidate, precision: displayPrecision)
            return localizedScientific(asGmp)
        }
        guard !candidate.contains(",") else { assert(false, "string contains comma, but only dot is allowed") }
        
        if candidate.contains("e") {
            /// scientific
            return DisplayData(left: "scientific?")
        } else {
            /// integer or float
            let localised = withSeparators(numberString: candidate)
            return DisplayData(left: localised)
        }
    }
    
    func localizedScientific(_ candidate: Gmp) -> DisplayData {
        return DisplayData(left: "SCIENTIFIC")
    }
    func localized(_ candidate: Number, forceScientific: Bool = false) -> DisplayData {
        if candidate.str != nil {
            return localized(candidate.str!, forceScientific: forceScientific)
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
        
        if !forceScientific && displayGmp.isZero {
            return DisplayData(left: "0")
        }
        
        if forceScientific {
            return localizedScientific(displayGmp)
        }

        let mantissaExponent = displayGmp.mantissaExponent(len: min(displayGmp.precision, Number.MAX_DISPLAY_LENGTH))
        var mantissa: String = mantissaExponent.mantissa
        var exponent: Int = mantissaExponent.exponent

        if mantissa.isEmpty {
            mantissa = "0"
        } else {
            exponent = exponent - 1
        }

        /// negative? Special treatment
        let isNegative = mantissa.first == "-"
        if isNegative {
            mantissa.removeFirst()
        }
        
        /// Can be displayed as Integer?
        let mantissaWithSeparators = withSeparators(numberString: mantissa)
        let displayLengthOfInteger = Int(displayWidth / digitWidth)
        if mantissa.count <= exponent+1 && exponent+1 <= withoutComma { /// smaller than because of possible trailing zeroes in the integer
            /// restore trailing zeros that have been removed
            mantissa = mantissa.padding(toLength: exponent+1, withPad: "0", startingAt: 0)
            // print(mantissa)
            
            if mantissa.count > firstLineWithoutComma { displayData.canBeInteger = true }
            if mantissa.count <= firstLineWithoutComma ||
                (multipleLines && showAsInteger) {
                displayData.left = (isNegative ? "-" : "") + mantissa
                displayData.maxlength = lengths.withoutComma
                return displayData
            }
        }


        return DisplayData(left: mantissa, right: "e\(exponent)", maxlength: 0, canBeInteger: false, canBeFloat: false)
    }
    
    func withSeparators(numberString: String) -> String {
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
        
        if numberString.contains(".") {
            return integerPart + decimalSeparator.string + fractionalPart
        } else {
            return integerPart
        }
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
}
