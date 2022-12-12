//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

struct ScreenInfo {
    let isPad: Bool
    let isPortrait: Bool
    let calculatorSize: CGSize
    let keyboardSize: CGSize
    let keyHeight: CGFloat
    let singleLineFontSize: CGFloat
    let keyboardPaddingBottom: CGFloat
    let displayTrailingOffset: CGFloat
    let displayBottomOffset: CGFloat
    let lengths: Lengths
    init(hardwareSize: CGSize, insets: UIEdgeInsets, appOrientation: UIDeviceOrientation, model: Model) {
        
        /// appOrientation is used here to trigger a redraw when the orientation changes ???????
        
        isPad = UIDevice.current.userInterfaceIdiom == .pad
        isPortrait = UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width
        calculatorSize = CGSize(width: hardwareSize.width - insets.left - insets.right, height: hardwareSize.height - insets.top - insets.bottom)
        let spaceBetweenKeys: CGFloat = C.spaceBetweenkeysFraction(withScientificKeys: !isPortrait) * calculatorSize.width
        let keyWidth: CGFloat = (calculatorSize.width - (isPortrait ? 3.0 : 9.0) * spaceBetweenKeys) * (isPortrait ? 0.25 : 0.1)
        keyHeight = isPortrait ? keyWidth : (calculatorSize.height - 5.0 * spaceBetweenKeys) / 6.17
        let allKeysheight = 5 * keyHeight + 4 * spaceBetweenKeys
        keyboardSize = CGSize(width: calculatorSize.width, height: allKeysheight)
        singleLineFontSize = ((isPortrait ? 0.14 : 0.16) * keyboardSize.height).rounded()
        keyboardPaddingBottom = 0.0//isPortrait ? keyHeight * 0.1 : 0.0
        displayTrailingOffset = isPortrait ? 0.0 :keyWidth * 0.7
        displayBottomOffset = isPortrait ? calculatorSize.height - keyboardSize.height - keyboardPaddingBottom - keyHeight * 1.2 : 0.0
        let displayWidth = calculatorSize.width - displayTrailingOffset
        lengths = lengthMeasurement(width: displayWidth, fontSize: singleLineFontSize, ePadding: 0.0)
        print("display length \(lengths.withoutComma)")
        model.lengths = lengths // lengths is used in Model.haveResultCallback()
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
                        hardwareSize: UIScreen.main.bounds.size,
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
