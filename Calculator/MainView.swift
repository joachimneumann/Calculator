//
//  MainView.swift
//  Calculator
//
//  Created by Joachim Neumann on 24/09/2021.
//

/*
 iPhone portrait: no "+", only Single Line Display
 iPhone landscape: "+" and Single Line Display above keyboard. Expand: keyboard disappears
 iPad portrait:    "+" and Single Line Display above keyboard. Expand: above keyboard
 iPad landscape:   "+" and Single Line Display above keyboard. keyboard less high (50% of screen). Expand: above keyboard
 Mac: change window size?
 */
import SwiftUI

struct MainView: View {
    @ObservedObject var brain: Brain
    @State var isZoomed: Bool = false
    @State var copyAndPastePurchased: Bool = false
    @State var isCopyingOrPasting: Bool = false
    var t: TE
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                
                Color.black
                    .navigationBarTitle("Calculator").hidden()
                    .navigationBarHidden(true)
                
                /// Icons - except for portrait iPhone
                if t.isPad || !t.isPortrait {
                    VStack(spacing: 0.0) {
                        HStack(spacing: 0.0) {
                            Spacer()
                            VStack(spacing: 0.0) {
                                PlusIcon(brain: brain, t: t, isZoomed: $isZoomed)
                                if copyAndPastePurchased {
                                    CopyIcon(brain: brain, t: t, isCopyingOrPasting: $isCopyingOrPasting)
                                    PasteIcon(brain: brain, t: t, isCopyingOrPasting: $isCopyingOrPasting)
                                }
                                ControlIcon(brain: brain, t: t, copyAndPastePurchased: $copyAndPastePurchased)
                            }
                        }
                        Spacer()
                    }
                }
                
                /// Display and Keys
                if t.isPad {
                    VStack(spacing: 0.0) {
                        Spacer(minLength: 0.0)
                        if isZoomed {
                            MultiLineDisplay(brain: brain, t: t, isCopyingOrPasting: isCopyingOrPasting)
                                .padding(.trailing, t.trailingAfterDisplay)
                                .opacity(isZoomed ? 1.0 : 0.0)
                                .transition(.move(edge: .bottom))
                        } else {
                            SingleLineDisplay(brain: brain, t: t)
                                .padding(.trailing, t.trailingAfterDisplay)
                                .opacity(isZoomed ? 0.0 : 1.0)
                        }
                        Keys(brain: brain, t: t)
                    }
                } else {
                    VStack(spacing: 0.0) {
                        if isZoomed && !t.isPortrait {
                            MultiLineDisplay(brain: brain, t: t, isCopyingOrPasting: isCopyingOrPasting)
                                .padding(.trailing, t.trailingAfterDisplay)
                        } else {
                            Spacer(minLength: 0.0)
                            SingleLineDisplay(brain: brain, t: t)
                                .padding(.trailing, t.trailingAfterDisplay)
                            Keys(brain: brain, t: t)
                        }
                    }
                }
                
            }
            .foregroundColor(Color.gray)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    struct Keys: View {
        let brain: Brain
        var t: TE
        let bottomPadding: CGFloat
        
        init(brain: Brain, t: TE) {
            self.brain = brain
            self.t = t
            if !t.isPad && t.isPortrait {
                bottomPadding = t.allkeysHeight * 0.07
            } else {
                bottomPadding = 0
            }
        }
        
        var body: some View {
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                HStack(spacing: 0.0) {
                    if t.isPad || !t.isPortrait {
                        ScientificKeys(brain: brain, t: t)
                            .padding(.trailing, t.spaceBetweenKeys)
                    }
                    NumberKeys(brain: brain, t: t)
                }
            }
            .frame(height: t.allkeysHeight)
            .background(Color.black)
            .transition(.move(edge: .bottom))
            .padding(.bottom, bottomPadding)
        }
    }
    
    struct Rad: View {
        let keySize: CGSize
        let textColor: Color
        var body: some View {
            VStack(spacing: 0.0) {
                Spacer(minLength: 0.0)
                Text("Rad")
                    .font(Font.system(size: keySize.height*0.27).monospacedDigit())
                //.foregroundColor(Color.yellow)
                    .padding(.leading, keySize.height*0.27)
                    .padding(.bottom, keySize.height*0.1)
            }
        }
    }
    
}

