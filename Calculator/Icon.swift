//
//  Icon.swift
//  Calculator
//
//  Created by Joachim Neumann on 11/10/22.
//

import SwiftUI

enum IconState: Int {
    case plus = 0
    case plusRotated
    case ok
    case noNumber
    func sizeFactor() -> CGFloat {
        switch self {
        case .plus:
            return 1.0
        case .plusRotated:
            return 1.0
        case .ok:
            return 0.7
        case .noNumber:
            return 1.0
        }
    }
    func image() -> Image {
        switch self {
        case .plus:
            return Image(systemName: "plus.circle.fill")
        case .plusRotated:
            return Image(systemName: "plus.circle.fill")
        case .ok:
            return Image("wing")
        case .noNumber:
            return Image("noNumber")
        }
    }
}

struct PlusIcon: View {
    @Binding var iconState: IconState
    let size: CGFloat
    let color: Color
    let topPaddingZoomed: CGFloat
    let topPaddingNotZoomed: CGFloat
    
    init(brain: Brain, t: TE, iconState: Binding<IconState>) {
        size = t.iconSize
        self._iconState = iconState
        color = t.digits_1_9.textColor
        self.topPaddingNotZoomed = t.zoomTopPaddingNotZoomed
        self.topPaddingZoomed = t.zoomTopPaddingZoomed
    }
    
    var body: some View {
        iconState.image()
            .resizable()
            .scaledToFit()
            .frame(width: size*iconState.sizeFactor(), height: size*iconState.sizeFactor())
            .padding(.leading, 0.5*size*(1.0-iconState.sizeFactor()))
            .padding(.top, 0.5*size*(1.0-iconState.sizeFactor()))
            .padding(.bottom, 0.5*size*(1.0-iconState.sizeFactor()))
            .font(.system(size: size, weight: .thin))
            .foregroundColor(color)
            .rotationEffect(iconState == .plusRotated ? .degrees(-45.0) : .degrees(0.0))
            .onTapGesture {
                if iconState == .plus {
                    withAnimation() {
                        iconState = .plusRotated
                    }
                } else if iconState == .plusRotated {
                    withAnimation() {
                        iconState = .plus
                    }
                }
            }
            .padding(.top, iconState == .plusRotated ? topPaddingZoomed : topPaddingNotZoomed)
    }
}

struct CopyIcon: View {
    @Binding var iconState: IconState
    let brain: Brain
    let size: CGFloat
    let color: Color
    let topPadding: CGFloat
    
    init(brain: Brain, t: TE, iconState: Binding<IconState>) {
        self.brain = brain
        self._iconState = iconState
        size = t.iconSize
        color = t.digits_1_9.textColor
        self.topPadding = t.iconSize*0.6
    }
    
    var body: some View {
        Button("Copy") {
            iconState = .ok
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                iconState = .plusRotated
            }
            UIPasteboard.general.string = brain.last.singleLine(len: brain.precision)
        }
        .frame(width: size, height: size)
        .foregroundColor(color)
        //        .opacity(iconState == .plusRotated ? 1.0 : 0.0)
        .padding(.top, topPadding)
    }
}

struct PasteIcon: View {
    @Environment(\.scenePhase) var scenePhase
    @State var hasValidNumberToPaste = false
    @Binding var iconState: IconState
    let brain: Brain
    let size: CGFloat
    let color: Color
    let topPadding: CGFloat
    
    init(brain: Brain, t: TE, iconState: Binding<IconState>) {
        self.brain = brain
        self._iconState = iconState
        size = t.iconSize
        color = t.digits_1_9.textColor
        self.topPadding = t.iconSize*0.4
    }
    
    var body: some View {
        VStack(spacing: 0.0) {
            Button("Paste") {
                iconState = .ok
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    iconState = .plusRotated
                }
                DispatchQueue.main.async {
                    if let s = UIPasteboard.general.string {
                        let valid = Gmp.isValidGmpString(s)
                        if valid {
                            brain.asyncOperation("fromPasteboard")
                        } else {
                            /// TODO error handling
                        }
                    }
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    print("active")
                }
            }
            .frame(width: size, height: size)
            .foregroundColor(color)
            //            .opacity(iconState != .plusRotated ? 1.0 : 0.0)
            .padding(.top, topPadding)
        }
    }
}


struct ControlIcon: View {
    @Binding var iconState: IconState
    let size: CGFloat
    let color: Color
    let topPadding: CGFloat
    
    init(brain: Brain, t: TE, iconState: Binding<IconState>) {
        self._iconState = iconState
        size = t.iconSize
        color = t.digits_1_9.textColor
        self.topPadding = t.iconSize*0.6
    }
    
    var body: some View {
        Image(systemName: "switch.2")
            .resizable()
            .scaledToFit()
            .frame(width: size*0.8, height: size*0.8)
            .font(.system(size: size, weight: .thin))
            .foregroundColor(color)
            .onTapGesture {
                withAnimation(.easeIn) {
                    //                    isZoomed.toggle()
                }
            }
        //            .opacity(iconState == .plusRotated ? 1.0 : 0.0)
            .padding(.top, topPadding)
    }
}
