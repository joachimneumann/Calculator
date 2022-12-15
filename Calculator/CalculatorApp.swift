//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

struct ScreenInfo {
    let isPad: Bool
    let isPortraitPhone: Bool
    let calculatorSize: CGSize
    let keyboardHeight: CGFloat
    let keySize: CGSize
    let keySpacing: CGFloat
    
    /// needed to correcty calculate the lengths in init()
    let singleLineFontSize: CGFloat
    let displayTrailingOffset: CGFloat

    init(hardwareSize: CGSize, insets: UIEdgeInsets, appOrientation: UIDeviceOrientation, model: Model) {
        /// appOrientation is used here to trigger a redraw when the orientation changes ???????
        
        isPad = UIDevice.current.userInterfaceIdiom == .pad
        isPortraitPhone = isPad ? false : UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width

        calculatorSize = CGSize(width: hardwareSize.width - insets.left - insets.right, height: hardwareSize.height - insets.top - insets.bottom)

        let iPadPortrait = UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width

        if isPortraitPhone {
            keySpacing = 0.02 * calculatorSize.width
        } else {
            // with scientific keyboard: narrower spacing
            keySpacing = 0.012 * calculatorSize.width
        }

        let tempKeyWidth: CGFloat
        let tempKeyheight: CGFloat

        if isPortraitPhone || iPadPortrait {
            /// Round keys
            tempKeyWidth = isPad ? (calculatorSize.width - 9.0 * keySpacing) * 0.1 : (calculatorSize.width - 3.0 * keySpacing) * 0.25
            tempKeyheight = tempKeyWidth
            keyboardHeight = 5 * tempKeyheight + 4 * keySpacing
        } else {
            /// wider keys
            tempKeyWidth = (calculatorSize.width - 9.0 * keySpacing) * 0.1
            if isPad {
                /// landscape iPad: half of the screen is the keyboard
                keyboardHeight = iPadPortrait ? calculatorSize.height * 0.4 : calculatorSize.height * 0.5
            } else {
                /// iPhone landscape
                keyboardHeight = 0.8 * calculatorSize.height
            }
            tempKeyheight = (keyboardHeight - 4.0 * keySpacing) * 0.2
        }
        
        displayTrailingOffset = isPortraitPhone ? tempKeyWidth * 0.2 : 0.0

        keySize = CGSize(width: tempKeyWidth, height: tempKeyheight)
                
        singleLineFontSize = ((isPortraitPhone ? 0.14 : 0.16) * keyboardHeight).rounded()
        C.kerning = -0.055555555555556 * singleLineFontSize
        let displayWidth = calculatorSize.width - displayTrailingOffset
        let temp = lengthMeasurement(width: displayWidth, fontSize: singleLineFontSize, ePadding: tempKeyWidth * 0.2)
        model.lengths = temp
        // lengths is used in Model.haveResultCallback()

        //print("display length \(model.lengths.withCommaScientific)")
    }
}

@main
struct CalculatorApp: App {
    let model: Model = Model()
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var appOrientation = UIDeviceOrientation.landscapeLeft
    var body: some Scene {
        WindowGroup {
            ZStack {
                Calculator(
                    model: model,
                    screenInfo: ScreenInfo (
                        hardwareSize: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height),
                        insets: UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets(),
                        appOrientation: appOrientation,
                        model: model))
                .background(Rectangle()
                    /// this stops white background from showing *during* a device rotation
                    .frame(width: max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) * 2.0,
                           height: max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) * 2.0)
                        .foregroundColor(C.appBackground))
            }
            .onRotate { newOrientation in
                appOrientation = newOrientation
                //print("newOrientation \(newOrientation.rawValue)")
            }
            .onAppear() {
                appOrientation = UIDevice.current.orientation
            }
            .preferredColorScheme(.dark)
        }
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

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
