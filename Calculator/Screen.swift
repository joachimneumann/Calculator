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
    case comma
    case dot
    case none
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

    static func == (lhs: Screen, rhs: Screen) -> Bool { /// used to detect rotation
        lhs.keySize == rhs.keySize
    }
    static func appleFont(ofSize size: CGFloat, weight: AppleFont.Weight = .thin) -> AppleFont {
        return AppleFont.monospacedDigitSystemFont(ofSize: size, weight: weight)
    }
    
    /// I initialize the decimalSeparator with the locale preference, but
    /// I ignore the value of Locale.current.groupingSeparator
    @AppStorage("forceScientific", store: .standard)
    var forceScientific: Bool = false
    
    @AppStorage("decimalSeparator", store: .standard)
    var decimalSeparator: DecimalSeparator = Locale.current.decimalSeparator == "," ? .comma : .dot
    
    @AppStorage("groupingSeparator", store: .standard)
    var groupingSeparator: GroupingSeparator = .none

    private let isPad: Bool

    let isPortraitPhone: Bool
    let keyboardHeight: CGFloat
    let keySpacing: CGFloat
    let keySize: CGSize
    var ePadding: CGFloat /// var and not let, because it is set to 0.0 in the tests
    let plusIconSize: CGFloat
    let iconsWidth: CGFloat
    let plusIconTrailingPadding: CGFloat
    var uiFontSize: CGFloat
    let infoUiFont: AppleFont
    let infoUiFontSize: CGFloat
    let displayHorizontalPadding: CGFloat
    let portraitIPhoneDisplayBottomPadding: CGFloat
    let horizontalPadding: CGFloat
    let bottomPadding: CGFloat
    var offsetToVerticallyAlignTextWithkeyboard: CGFloat = 0.0
    var offsetToVerticallyAlignIconWithText: CGFloat = 0.0
    let kerning: CGFloat
    var textHeight: CGFloat = 0.0
    var infoTextHeight: CGFloat = 0.0
    var displayWidth: CGFloat = 0.0
    var digitWidth: CGFloat = 0.0
    var radWidth: CGFloat = 0.0
    var eWidth: CGFloat = 0.0
    let backgroundColor: Color
    let defaultTextColor: Color

    let appleFont: AppleFont
    private let calculatorWidth: CGFloat
        
    init(_ screenSize: CGSize) {
        //print("Screen INIT", screenSize)

        
#if os(macOS)
        backgroundColor = Color(white: 80.0/255.0)
        defaultTextColor = Color(white: 236.0/255.0)
        isPad = false
        let isPortrait = false
        isPortraitPhone = false
        keySpacing = 1.0
        horizontalPadding = 0.0
        displayHorizontalPadding = 10
#else
        backgroundColor = .black
        defaultTextColor = .white
        isPad = UIDevice.current.userInterfaceIdiom == .pad
        let isPortrait = screenSize.height > screenSize.width
        isPortraitPhone = isPad ? false : isPortrait
        if isPortraitPhone {
            keySpacing = 0.034 * screenSize.width
            horizontalPadding = keySpacing
            displayHorizontalPadding = screenSize.width * 0.035
        } else {
            // with scientific keyboard: narrower spacing
            keySpacing = 0.012 * screenSize.width
            horizontalPadding = 0.0
            displayHorizontalPadding = screenSize.width * 0.015
        }
#endif
        
        portraitIPhoneDisplayBottomPadding = screenSize.height * 0.012
        
        calculatorWidth = screenSize.width - 2 * horizontalPadding
        let keyWidth: CGFloat
        let keyHeight: CGFloat
        
#if os(macOS)
        keyWidth = (calculatorWidth - 9.0 * keySpacing) * 0.1
        keyboardHeight = 0.815 * screenSize.height
        keyHeight = (keyboardHeight - 4.0 * keySpacing) * 0.2
        bottomPadding = 0.0
#else
        if isPortrait {
            /// Round keys
            keyWidth = isPad ? (calculatorWidth - 9.0 * keySpacing) * 0.1 : (calculatorWidth - 3.0 * keySpacing) * 0.25
            keyHeight = keyWidth
            keyboardHeight = 5 * keyHeight + 4 * keySpacing
            bottomPadding = isPad ? 0.0 : keyboardHeight * 0.09
        } else {
            /// wider keys
            keyWidth = (calculatorWidth - 9.0 * keySpacing) * 0.1
            if isPad {
                /// landscape iPad: half of the screen is the keyboard
                keyboardHeight = screenSize.height * 0.5
            } else {
                /// iPhone landscape
                keyboardHeight = 0.8 * screenSize.height
            }
            keyHeight = (keyboardHeight - 4.0 * keySpacing) * 0.2
            bottomPadding = 0.0
        }
#endif
        
        keySize = CGSize(width: keyWidth, height: keyHeight)
        
        plusIconSize = keyboardHeight * 0.13
        iconsWidth   = keyboardHeight * 0.16
        plusIconTrailingPadding = plusIconSize * 0.4
        ePadding = isPortraitPhone ? plusIconSize * 0.1 : plusIconSize * 0.3
#if os(macOS)
        uiFontSize = (0.22 * keyboardHeight).rounded()
        infoUiFontSize = 12.0
#else
        uiFontSize = (0.16 * keyboardHeight).rounded()
        if isPortraitPhone { uiFontSize = 0.125 * keyboardHeight }
        infoUiFontSize = 16.0
#endif
        appleFont = Self.appleFont(ofSize: uiFontSize)
        infoUiFont = Screen.appleFont(ofSize: infoUiFontSize, weight: .regular)

        kerning = -0.02 * uiFontSize
        
        textHeight     = "0".textHeight(kerning: kerning, appleFont: appleFont)
        infoTextHeight = "0".textHeight(kerning: 0.0, appleFont: infoUiFont)
        radWidth       = "Rad".textWidth(kerning: 0.0, appleFont: infoUiFont)
        digitWidth     = "0".textWidth(kerning: kerning, appleFont: appleFont)

#if os(macOS)
        offsetToVerticallyAlignTextWithkeyboard =
        CGFloat(screenSize.height) -
        CGFloat(keyboardHeight) -
        CGFloat(textHeight)

        offsetToVerticallyAlignIconWithText =
        CGFloat(screenSize.height) -
        CGFloat(keyboardHeight) -
        0.5 * CGFloat(infoUiFontSize) -
        CGFloat(plusIconSize) +
        CGFloat(appleFont.descender) -
        CGFloat(0.5 * appleFont.capHeight) +
        CGFloat(0.5 * plusIconSize)
#else
        offsetToVerticallyAlignTextWithkeyboard =
        CGFloat(screenSize.height) -
        CGFloat(keyboardHeight) -
        CGFloat(textHeight) -
        CGFloat(infoUiFontSize)

        offsetToVerticallyAlignIconWithText =
        CGFloat(screenSize.height) -
        CGFloat(keyboardHeight) -
        CGFloat(infoUiFontSize) -
        CGFloat(plusIconSize) +
        CGFloat(appleFont.descender) -
        CGFloat(0.5 * appleFont.capHeight) +
        CGFloat(0.5 * plusIconSize)
#endif
                
        if isPortraitPhone {
            displayWidth = calculatorWidth - 2.0 * displayHorizontalPadding
        } else {
            displayWidth = calculatorWidth -
            2.0 * displayHorizontalPadding -
            iconsWidth -
            plusIconTrailingPadding
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

    func replacingFirstOccurrence(of target: String, with replacement: String) -> String {
        guard let range = self.range(of: target) else { return self }
        return self.replacingCharacters(in: range, with: replacement)
    }
    
    func textWidth(kerning: CGFloat, appleFont: AppleFont) -> CGFloat {
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[.kern] = kerning
        attributes[.font] = appleFont
        return self.size(withAttributes: attributes).width
    }
    
    func textHeight(kerning: CGFloat, appleFont: AppleFont) -> CGFloat {
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[.kern] = kerning
        attributes[.font] = appleFont
        return self.size(withAttributes: attributes).height
    }

}

