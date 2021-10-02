//
//  iOSSize.swift
//  Calculator
//
//  Created by Joachim Neumann on 02/10/2021.
//

import SwiftUI

struct iOSSize: View {
    let brain: Brain
    @State var leadingPaddingNeeded: Bool = false
    @State var trailingPaddingNeeded: Bool = false
    @State var bottomPaddingNeeded: Bool = false
    @State private var orientation = UIDeviceOrientation.unknown

    func calculatePadding(_ newOrientation: UIDeviceOrientation) {
        let windowCandidate = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        
        var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if windowCandidate != nil { insets = windowCandidate!.safeAreaInsets }
        leadingPaddingNeeded  = (insets.left   == 0)
        trailingPaddingNeeded = (insets.right  == 0)
        bottomPaddingNeeded   = (insets.bottom == 0)
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let horizontalFactor:CGFloat = 1.0 -
                (leadingPaddingNeeded   ? Configuration.spacingFration : 0) -
                (trailingPaddingNeeded  ? Configuration.spacingFration : 0 )
                let verticalFactor:CGFloat = 1.0 -
                (bottomPaddingNeeded ? Configuration.spacingFration : 0.0)
                
                let appFrame = CGSize(
                    width: geo.size.width * horizontalFactor,
                    height: geo.size.height * verticalFactor)
                let c = Configuration(appFrame: appFrame)
                
                /// make the app frame smaller if there is no safe area.
                /// If there already is safe area, no padding is needed

                IOSContentView(brain: brain, c: c)
                    .padding(.leading, leadingPaddingNeeded ? c.spaceBetweenkeys : 0)
                    .padding(.trailing, trailingPaddingNeeded ? c.spaceBetweenkeys : 0)
                    .padding(.bottom, bottomPaddingNeeded ? c.spaceBetweenkeys : 0)
//                Group {
//                    if orientation.isPortrait {
//                        Text("Portrait")
//                    } else if orientation.isLandscape {
//                        Text("Landscape")
//                    } else if orientation.isFlat {
//                        Text("Flat")
//                    } else {
//                        Text("Unknown")
//                    }
//                }
//                .foregroundColor(Color.white)
                .onRotate { newOrientation in
                    orientation = newOrientation
                }
                
            }
            .onRotate() { orientation in calculatePadding(orientation) }
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
