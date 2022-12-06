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
    let displayTrailingOffset: CGFloat
    let displayBottomOffset: CGFloat
    let keyboardPaddingBottom: CGFloat
    @State private var orientation = UIDeviceOrientation.unknown
    
    var body: some View {
        NavigationStack {
            //        let _ = print("Calculator body displayLength \(displayLength)")
            //        let _ = model.oneLineWithCommaLength = displayLength[0]
            //        let _ = model.oneLineWithoutCommaLength = displayLength[1]
            //        let _ = print("displayLength \(displayLength)")
            Rectangle()
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
                                    precisionString: "model.precision.useWords",
                                    displayWidth: model.displayWidth)
                                .offset(x: -displayTrailingOffset, y: displayBottomOffset)
                                //                        .background(Color.green).opacity(0.4)
                                .animation(Animation.easeInOut(duration: 0.4), value: model.zoomed)
                            }
                            //.background(Color.yellow)
                            Spacer()
                        }
                    }
                }
            
                .overlay() { /// Icons
//                    AnimatedDots(color: .gray)

                    if !isPortrait {
                        HStack(spacing: 0.0) {
                            Spacer(minLength: 0.0)
                            let size = keyboardSize.height * 0.13
                            VStack(spacing: 0.0) {
                                if model.isCalculating {
                                    AnimatedDots(color: .gray)
                                        .padding(.top, size * 0.55)
                                        .animation(Animation.easeInOut(duration: 0.4), value: model.zoomed)
                                } else {
                                    PlusKey(keyInfo: model.keyInfo["plusKey"]!, model: model, size: CGSize(width: size, height: size))
                                        .padding(.top, size * 0.25)
                                    //                                    .offset(y: size * 0.25)
                                    if model.zoomed {
                                        NavigationLink {
                                            Settings(model: model, copyAndPastePurchased: .constant(true))
                                        } label: {
                                            Image(systemName: "switch.2")
                                                .resizable()
                                                .scaledToFit()
                                                .font(.system(size: keyboardSize.height, weight: .thin))
                                                .frame(width: size, height: size)
                                                .foregroundColor(Color(uiColor: UIColor(white: 0.9, alpha: 1.0)))
                                        }
                                        .padding(.top, size * 0.5)
                                        Text("copy")
                                            .foregroundColor(.white)
                                            .padding(.top, size * 0.5)
                                        Text("paste")
                                            .foregroundColor(.white)
                                            .padding(.top, size * 0.5)
                                    }
                                }
                                Spacer(minLength: 0.0)
                            }
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
                .background(Color.black)
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
