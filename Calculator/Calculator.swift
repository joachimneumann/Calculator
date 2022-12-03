//
//  Calculator.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct Calculator: View {
    @StateObject var keyModel: KeyModel
    let isPad: Bool
    var isPortrait: Bool
    let size: CGSize
    
    var keyboardSize: CGSize
    var keyHeight: CGFloat
    var singleLineFontSize: CGFloat
    let displayXOffset: CGFloat
    let displayYOffset: CGFloat
    let displayPaddingBottom: CGFloat
    let keyboardPaddingBottom: CGFloat
    let displayLength: [Int]
    var body: some View {
        Rectangle()
            .offset(x: -30)
            .foregroundColor(Color.yellow)
            .padding(30)
            .overlay() {
                VStack(spacing: 0.0) {
                    if !isPortrait {
                        HStack(spacing: 0.0) {
                            Spacer(minLength: 0.0)
                            PlusKey(keyInfo: keyModel.keyInfo["plusKey"]!, keyModel: keyModel, size: CGSize(width: keyboardSize.height * 0.13, height: keyboardSize.height * 0.13))
                                .offset(y: displayYOffset)
                        }
                        .padding(.top, keyHeight * 0.15)
                        Spacer(minLength: 0.0)
                    }
                }
            }
            .overlay() {
                LongDisplay(
                    zoomed: keyModel.zoomed,
                    smallFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: .thin))
                )
                .animation(.linear(duration: 00), value: keyModel.zoomed)
//                .withAnimation(Animation.linear(duration: 0.0))
            }
            .overlay() {
                if !keyModel.zoomed {
                    let info = "\(keyModel._hasBeenReset ? "Precision: "+keyModel.precisionDescription+" digits" : "\(keyModel._rad ? "Rad" : "")")"
                    VStack(spacing: 0.0) {
                        Spacer()
                        HStack(spacing: 0.0) {
                            Text(info).foregroundColor(.white)
                                .offset(x: keyHeight * 0.3, y: keyHeight * -0.05)
                            Spacer()
                        }
                        KeysView(keyModel: keyModel, isScientific: !isPortrait, size: keyboardSize)
                    }
                    .transition(.move(edge: .bottom))
                }
//                .offset(y: keyModel.zoomed ? size.height : 0)
            }
    }
    /*
    @StateObject var keyModel: KeyModel
    let isPad: Bool
    var isPortrait: Bool
    let size: CGSize
    
    var keyboardSize: CGSize
    var keyHeight: CGFloat
    var singleLineFontSize: CGFloat
    let displayXOffset: CGFloat
    let displayYOffset: CGFloat
    let displayPaddingBottom: CGFloat
    let keyboardPaddingBottom: CGFloat
    let displayLength: [Int]
    
    var body: some View {
        
        VStack {
            HStack(spacing: 0.0) {
                let multipleLines = keyModel.zoomed ? keyModel.multipleLines : MultipleLiner(left: "0", abbreviated: false)
                //                let multipleLines = MultipleLiner(left: "ksdjhf skjfh skdjhf skdjfh sdkjhf sdkjfh sdkjfh sdkhfj sdkjhf skdjfh sdkjhf skdjhf skdjhf ksdjhf sdkjhf sdkjhf skdjhf skdjfh skdjhf sdkjhf sdkjhf sdkjhf sdkjfh sdkjhf sdkfjh", abbreviated: false)
                let left = keyModel.zoomed ? multipleLines.left : keyModel.oneLineP
                let right = keyModel.zoomed ? multipleLines.right : nil
                let abbreviated = keyModel.zoomed ? multipleLines.abbreviated : false
                LongDisplay(
                    mantissa: left,
                    exponent: right,
                    abbreviated: abbreviated,
                    smallFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: .thin)),
                    largeFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize * 1.5, weight: .thin)),
                    scaleFont: isPortrait,
                    isCopyingOrPasting: false,
                    precisionString: keyModel.precision.useWords,
                    scrollingDisabled: !keyModel.zoomed)
                .background(Color.yellow).opacity(0.4)
                .offset(x: displayXOffset, y: displayYOffset)
                .animation(Animation.easeInOut(duration: 0.4), value: keyModel.zoomed)
            }
            Spacer()
        }
        
        .overlay() { /// Icons
            VStack(spacing: 0.0) {
                if !isPortrait {
                    HStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        PlusKey(keyInfo: keyModel.keyInfo["plusKey"]!, keyModel: keyModel, size: CGSize(width: keyboardSize.height * 0.13, height: keyboardSize.height * 0.13))
                            .offset(y: displayYOffset)
                    }
                    .padding(.top, keyHeight * 0.15)
                    Spacer(minLength: 0.0)
                }
            }
        }
        
        .overlay() { /// keyboard
            let info = "\(keyModel._hasBeenReset ? "Precision: "+keyModel.precisionDescription+" digits" : "\(keyModel._rad ? "Rad" : "")")"
            VStack(spacing: 0.0) {
                Spacer()
                HStack(spacing: 0.0) {
                    Text(info).foregroundColor(.white)
                        .offset(x: keyHeight * 0.3, y: keyHeight * -0.05)
                    Spacer()
                }
                KeysView(keyModel: keyModel, isScientific: !isPortrait, size: keyboardSize)
            }
            .transition(.move(edge: .bottom))
            .offset(y: keyModel.zoomed ? size.height : 0)
        }
    }
     */
}


//struct Calculator_Previews: PreviewProvider {
//    static var previews: some View {
//        Calculator(isPad: false, isPortrait: true, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//            .background(Color.black)
//    }
//}
