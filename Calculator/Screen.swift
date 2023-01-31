//
//  ScreenModel.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/26/22.
//

import SwiftUI

enum DecimalSeparator: String, Codable, CaseIterable{
    case comma
    case dot
    var character: Character {
        get {
            switch self {
            case .comma: return ","
            case .dot: return "."
            }
        }
    }
    var string: String {
        get {
            String(character)
        }
    }
}
enum GroupingSeparator: String, Codable, CaseIterable{
    case none
    case comma
    case dot
    var character: Character? {
        get {
            switch self {
            case .none: return nil
            case .comma: return ","
            case .dot: return "."
            }
        }
    }
    var string: String {
        get {
            guard let character = character else { return "" }
            return String(character)
        }
    }
}

protocol Separators {
    var decimalSeparator: DecimalSeparator   { get }
    var groupingSeparator: GroupingSeparator { get }
}

struct Screen: Equatable, DisplayLengthLimiter, Separators {    
            
    /// I initialize the decimalSeparator with the locale preference, but
    /// I ignore the value of Locale.current.groupingSeparator
    @AppStorage("forceScientific", store: .standard)
    var forceScientific: Bool = false
    
    @AppStorage("decimalSeparator", store: .standard)
    var decimalSeparator: DecimalSeparator = Locale.current.decimalSeparator == "," ? .comma : .dot
    
    @AppStorage("groupingSeparator", store: .standard)
    var groupingSeparator: GroupingSeparator = .none

    static func == (lhs: Screen, rhs: Screen) -> Bool { /// used to detect rotation
        lhs.keySize == rhs.keySize
    }

    let isPad: Bool
    let isPortraitPhone: Bool
    let keyboardHeight: CGFloat
    let keySpacing: CGFloat
    let keySize: CGSize
    var ePadding: CGFloat /// var and not let, because it is set to 0.0 in the tests
    let plusIconSize: CGFloat
    let iconsWidth: CGFloat
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
    
    let uiFont: UIFont
    private let calculatorWidth: CGFloat
    
    init(_ screenSize: CGSize) {
        //print("Screen INIT", screenSize)
    
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
        iconsWidth   = keyboardHeight * 0.16
        plusIconLeftPadding = plusIconSize * 0.4
        ePadding = isPortraitPhone ? plusIconSize * 0.1 : plusIconSize * 0.3
        uiFontSize = ((isPortraitPhone ? 0.125 : 0.16) * keyboardHeight).rounded()
        uiFontWeight = UIFont.Weight.thin
        uiFont = UIFont.monospacedDigitSystemFont(ofSize: uiFontSize, weight: uiFontWeight)
        infoUiFontSize = uiFontSize * 0.3
        infoUiFont = UIFont.monospacedDigitSystemFont(ofSize: infoUiFontSize, weight: .regular)
        kerning = -0.02 * uiFontSize
        
        textHeight     = textHeight("0")
        infoTextHeight = textHeight("0", uiFont: infoUiFont)
        digitWidth     = textWidth("0")

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
        (isPortraitPhone ? 2.0 * portraitIPhoneDisplayHorizontalPadding : iconsWidth + plusIconLeftPadding)
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

