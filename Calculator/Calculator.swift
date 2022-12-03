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
    let displayPaddingLeading: CGFloat
    let displayPaddingTrailing: CGFloat
    let displayPaddingTop: CGFloat
    let displayPaddingBottom: CGFloat
    let keyboardPaddingBottom: CGFloat
    let displayLength: [Int]
    
    var body: some View {
        //        let _ = print("Calculator body displayLength \(displayLength)")
        //        let _ = keyModel.oneLineWithCommaLength = displayLength[0]
        //        let _ = keyModel.oneLineWithoutCommaLength = displayLength[1]
        //        let _ = print("displayLength \(displayLength)")
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
                    font: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: .thin)),
                    isCopyingOrPasting: false,
                    precisionString: keyModel.precision.useWords,
                    scrollingDisabled: !keyModel.zoomed)
                .background(Color.yellow)
                .offset(y: displayPaddingTop)
                .animation(Animation.easeInOut(duration: 0.4), value: keyModel.zoomed)
            }
            .padding(.trailing, displayPaddingTrailing)
        }
        
        .overlay() { /// Icons
            VStack(spacing: 0.0) {
                if !isPortrait {
                    HStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        PlusKey(keyInfo: keyModel.keyInfo["plusKey"]!, keyModel: keyModel, size: CGSize(width: keyboardSize.height * 0.13, height: keyboardSize.height * 0.13))
                            .offset(y: displayPaddingTop)
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
        
        .overlay() { /// Info texts
            VStack(spacing: 0.0) {
                if !isPortrait {
                    HStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        PlusKey(keyInfo: keyModel.keyInfo["plusKey"]!, keyModel: keyModel, size: CGSize(width: keyboardSize.height * 0.13, height: keyboardSize.height * 0.13))
                            .offset(y: displayPaddingTop)
                    }
                    .padding(.top, keyHeight * 0.15)
                    Spacer(minLength: 0.0)
                }
            }
        }
    }
}


//struct Calculator_Previews: PreviewProvider {
//    static var previews: some View {
//        Calculator(isPad: false, isPortrait: true, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//            .background(Color.black)
//    }
//}
