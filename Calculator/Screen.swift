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

    static func == (lhs: Screen, rhs: Screen) -> Bool { /// used to detect rotation
        lhs.keySize == rhs.keySize
    }
    static func appleFont(ofSize size: CGFloat, portrait: Bool, weight: AppleFont.Weight = .thin) -> AppleFont {
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
    private var isMac: Bool = false

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
    var offsetToVerticallyIconWithText: CGFloat = 0.0
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
        self.isMac = true
        backgroundColor = Color(white: 80.0/255.0)
        defaultTextColor = Color(white: 236.0/255.0)
        isPad = false
        let isPortrait = false
        isPortraitPhone = false
        keySpacing = 1.0
        horizontalPadding = 0.0
        displayHorizontalPadding = 10
#else
        self.isMac = false
        backgroundColor = .black
        defaultTextColor = .white
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
        displayHorizontalPadding = screenSize.width * 0.035
#endif
        
        portraitIPhoneDisplayBottomPadding = screenSize.height * 0.012
        
        calculatorWidth = screenSize.width - 2 * horizontalPadding
        let keyWidth: CGFloat
        let keyHeight: CGFloat
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
                keyboardHeight = isPortrait ? screenSize.height * 0.4 : screenSize.height * 0.5
            } else {
                /// iPhone landscape
                keyboardHeight = 0.8 * screenSize.height
            }
            keyHeight = (keyboardHeight - 4.0 * keySpacing) * 0.2
            bottomPadding = 0.0
        }
        
        keySize = CGSize(width: keyWidth, height: keyHeight)
        
        plusIconSize = keyboardHeight * 0.13
        iconsWidth   = keyboardHeight * 0.16
        plusIconTrailingPadding = plusIconSize * 0.4
        ePadding = isPortraitPhone ? plusIconSize * 0.1 : plusIconSize * 0.3
#if os(macOS)
        uiFontSize = 0.22 * keyboardHeight
        infoUiFontSize = uiFontSize * 0.25
#else
        uiFontSize = 0.16 * keyboardHeight
        if isPortraitPhone { uiFontSize = 0.125 * keyboardHeight }
        infoUiFontSize = uiFontSize * 0.3
#endif
        uiFontSize = uiFontSize.rounded()
        appleFont = Self.appleFont(ofSize: uiFontSize, portrait: isPortraitPhone)
        infoUiFont = Screen.appleFont(ofSize: infoUiFontSize, portrait: isPortrait, weight: .regular)

        kerning = -0.02 * uiFontSize
        
        textHeight     = textHeight("0", kerning: kerning)
        infoTextHeight = textHeight("0", appleFont: infoUiFont, kerning: 0.0)
        print("infoTextHeight", infoTextHeight)
        radWidth       = textWidth("Rad", appleFont: infoUiFont, kerning: 0.0)
        digitWidth     = textWidth("0", kerning: kerning)

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
        CGFloat(appleFont.descender) -
        CGFloat(0.5 * appleFont.capHeight) +
        CGFloat(0.5 * plusIconSize)
                
        if isPortraitPhone {
            displayWidth = calculatorWidth - 2.0 * displayHorizontalPadding
        } else {
            displayWidth = calculatorWidth -
            2.0 * displayHorizontalPadding -
            iconsWidth -
            plusIconTrailingPadding
        }
    }

    private func textSize(string: String, appleFont: AppleFont?, kerning: CGFloat) -> CGSize {
        let font: AppleFont
        if appleFont != nil {
            font = appleFont!
        } else {
            font = self.appleFont
        }
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[.kern] = kerning
        attributes[.font] = font
        return string.size(withAttributes: attributes)
    }
    func textWidth(_ string: String, appleFont: AppleFont? = nil, kerning: CGFloat) -> CGFloat {
        textSize(string: string, appleFont: appleFont, kerning: kerning).width
    }

    func textHeight(_ string: String, appleFont: AppleFont? = nil, kerning: CGFloat) -> CGFloat {
        textSize(string: string, appleFont: appleFont, kerning: kerning).height
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

