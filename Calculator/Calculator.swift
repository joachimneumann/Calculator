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
    
    var body: some View {
        //        let _ = print("Calculator body displayLength \(displayLength)")
        //        let _ = keyModel.oneLineWithCommaLength = displayLength[0]
        //        let _ = keyModel.oneLineWithoutCommaLength = displayLength[1]
        //        let _ = print("displayLength \(displayLength)")
        Rectangle()
            .foregroundColor(.black)
            .overlay() {
                VStack {
                    HStack(spacing: 0.0) {
                        let multipleLines: MultipleLiner? = keyModel.zoomed ? keyModel.multipleLines : nil
                        let left = keyModel.zoomed ? multipleLines!.left : keyModel.oneLineP.left
                        let right: String? = keyModel.zoomed ? multipleLines!.right : keyModel.oneLineP.right
                        let abbreviated = keyModel.zoomed ? multipleLines!.abbreviated : keyModel.oneLineP.abbreviated
                        let ePadding = keyModel.lengthMeasurementResult.ePadding
                        LongDisplay(
                            zoomed: keyModel.zoomed,
                            mantissa: left,
                            exponent: right,
                            ePadding: ePadding,
                            abbreviated: abbreviated,
                            smallFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: .thin)),
                            largeFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize * 1.5, weight: .thin)),
                            scaleFont: isPortrait,
                            isCopyingOrPasting: false,
                            precisionString: keyModel.precision.useWords,
                            scrollingDisabled: !keyModel.zoomed)
                        .background(Color.yellow).opacity(0.4)
                        .offset(x: -displayXOffset, y: displayYOffset)
                        .frame(maxWidth: keyModel.displayWidth)
                        .animation(Animation.easeInOut(duration: 0.4), value: keyModel.zoomed)
                    }
                    Spacer()
                }
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
}


//struct Calculator_Previews: PreviewProvider {
//    static var previews: some View {
//        Calculator(isPad: false, isPortrait: true, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//            .background(Color.black)
//    }
//}
