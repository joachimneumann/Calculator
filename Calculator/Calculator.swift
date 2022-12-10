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
        let _ = print("Calculator body")
        NavigationStack {
            Rectangle()
                .overlay() {
                    VStack(spacing: 0.0) {
                        if isPortrait {
                            let todo_exponent_with_epadding_in_portrait = 0
                            PortraitDisplay(
                                displayData: model.displayData,
                                fullLength: model.displayData.short.count == model.lengths.withoutComma,
                                //ePadding: model.lengths.ePadding,
                                smallFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: .thin)),
                                largeFont: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize * 1.5, weight: .thin)),
                                fontScaleFactor: 1.5,
                                displayWidth: model.displayWidth)
                            //.background(Color.yellow)
                            .padding(.bottom, keyboardSize.height)
                            //                        .offset(y: displayYOffset)
                        } else {
                            HStack(spacing: 0.0) {
                                LandscapeDisplay(
                                    zoomed: model.zoomed,
                                    displayData: model.displayData,
                                    ePadding: model.lengths.ePadding,
                                    font: Font(UIFont.monospacedDigitSystemFont(ofSize: singleLineFontSize, weight: .thin)),
                                    isCopyingOrPasting: false,
                                    precisionString: "Model.precision.useWords",
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
                    if !isPortrait {
                        HStack(spacing: 0.0) {
                            Spacer(minLength: 0.0)
                            let size = keyboardSize.height * 0.13
                            VStack(spacing: 0.0) {
                                //let _ = print("model.isCalculating \(model.isCalculating)")
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
                                            .frame(width: size, height: size)
                                            .minimumScaleFactor(0.01)
                                        Text("paste")
                                            .foregroundColor(.white)
                                            .padding(.top, size * 0.5)
                                            .frame(width: size, height: size)
                                            .minimumScaleFactor(0.01)
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
                    .offset(y: (model.zoomed && !isPortrait) ? size.height : 0)
                }
                .onRotate { newOrientation in /// this magically reduces the number of haveResultCallback() calls to one per rotation
                    orientation = newOrientation
                }
                .background(Color.black)
        }
        .accentColor(.white) // for the navigation back button
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
