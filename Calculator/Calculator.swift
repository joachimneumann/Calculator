//
//  Calculator.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/18/22.
//

import SwiftUI

struct Calculator: View {
    @StateObject var model: Model
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
    @State private var orientation = UIDeviceOrientation.unknown

    var body: some View {
        //        let _ = print("Calculator body displayLength \(displayLength)")
        //        let _ = model.oneLineWithCommaLength = displayLength[0]
        //        let _ = model.oneLineWithoutCommaLength = displayLength[1]
        //        let _ = print("displayLength \(displayLength)")
        Rectangle()
            .foregroundColor(.black)
            .overlay() {
                VStack(spacing: 0.0) {
                    if isPortrait {
                        let text = model.oneLineP.asOneLine
                        PortraitDisplay(
                            text: text,
                            isAbbreviated: false,
                            smallFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: .thin)),
                            largeFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize * 1.5, weight: .thin)),
                            fontScaleFactor: 1.5,
                            displayWidth: model.displayWidth)
                        //.background(Color.yellow)
                        .padding(.bottom, keyboardSize.height)
//                        .offset(y: displayYOffset)
                    } else {
                        HStack(spacing: 0.0) {
                            let multipleLines: MultipleLiner? = model.zoomed ? model.multipleLines : nil
                            let left = model.zoomed ? multipleLines!.left : model.oneLineP.left
                            let right: String? = model.zoomed ? multipleLines!.right : model.oneLineP.right
                            let abbreviated = model.zoomed ? multipleLines!.abbreviated : model.oneLineP.abbreviated
                            let ePadding = model.lengthMeasurementResult.ePadding
                            LongDisplay(
                                zoomed: model.zoomed,
                                mantissa: left,
                                exponent: right,
                                ePadding: ePadding,
                                abbreviated: abbreviated,
                                font: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: .thin)),
                                isCopyingOrPasting: false,
                                precisionString: model.precision.useWords,
                                displayWidth: model.displayWidth)
                            .offset(x: -displayXOffset, y: displayYOffset)
                            //                        .background(Color.green).opacity(0.4)
                            .animation(Animation.easeInOut(duration: 0.4), value: model.zoomed)
                        }
                        //.background(Color.yellow)
                        Spacer()
                    }
                }
            }
            .overlay() { /// Icons
                VStack(spacing: 0.0) {
                    if !isPortrait {
                        HStack(spacing: 0.0) {
                            Spacer(minLength: 0.0)
                            PlusKey(keyInfo: model.keyInfo["plusKey"]!, model: model, size: CGSize(width: keyboardSize.height * 0.13, height: keyboardSize.height * 0.13))
                                .offset(y: displayYOffset)
                        }
                        .padding(.top, keyHeight * 0.15)
                        Spacer(minLength: 0.0)
//                        NavigationLink(destination: Settings(model: model, copyAndPastePurchased: _copyAndPastePurchased)) {
//                            Image(systemName: "switch.2")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: size*0.8, height: size*0.8)
//                                .font(.system(size: size, weight: .thin))
//                                .foregroundColor(color)
//                                .padding(.top, topPadding)
//                        }
                    }
                }
            }
        
            .overlay() { /// keyboard
                let info = "\(model._hasBeenReset ? "Precision: "+model.precisionDescription+" digits" : "\(model._rad ? "Rad" : "")")"
                VStack(spacing: 0.0) {
                    Spacer()
                    HStack(spacing: 0.0) {
                        Text(info).foregroundColor(.white)
                            .offset(x: keyHeight * 0.3, y: keyHeight * -0.05)
                        Spacer()
                    }
                    KeysView(model: model, isScientific: !isPortrait, size: keyboardSize)
                }
                .transition(.move(edge: .bottom))
                .offset(y: model.zoomed ? size.height : 0)
            }
            .onRotate { newOrientation in
                model.haveResultCallback()
                orientation = newOrientation
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

//struct Calculator_Previews: PreviewProvider {
//    static var previews: some View {
//        Calculator(isPad: false, isPortrait: true, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//            .background(Color.black)
//    }
//}
