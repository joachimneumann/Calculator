//
//  ContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

#if targetEnvironment(macCatalyst)
struct CatalystContentView: View {
    @ObservedObject var brain = Brain()
    @State var zoomed: Bool = false
    @State var copyPasteHighlight = false
    let appFrame = CGSize (width: 0, height: 0) // not used in catalyst, the sizes are gard-coded
    var body: some View {
        ZStack {
            if zoomed && brain.hasMoreDigits {
                AllDigitsView(
                    brain: brain,
                    textColor: copyPasteHighlight ? Color.orange : Configuration.DigitKeyProperties.textColor)
                    .padding(.trailing, Configuration.scientificKeySize(appFrame: appFrame).width)
                    .padding(.leading, 10)
            } else {
                ZStack {
                    VStack {
                        Display(
                            text: brain.display,
                            textColor: copyPasteHighlight ? Color.orange : Configuration.DigitKeyProperties.textColor)
                            .padding(.trailing, Configuration.scientificKeySize(appFrame: appFrame).width)
                        Spacer(minLength: 0)
                        if !zoomed {
                            LandscapeKeys(brain: brain, appFrame: appFrame)
                                .transition(.move(edge: .bottom))
                        }
                    }
                    if brain.rad && !zoomed {
                        Rad()
                            .transition(.move(edge: .bottom))
                    }
                }
                .transition(.move(edge: .bottom))
            }
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                // from here on: trailing
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer(minLength: 0)
                        Zoom(active: brain.hasMoreDigits, zoomed: $zoomed, showCalculating: brain.showCalculating)
                            .padding(.top, 12) // hardcoded. The correct height depends on the display font and I was lazy...
                        Spacer(minLength: 0)
                    }
                    if zoomed {
                        Copy(longString: brain.combinedLongDisplayString(longDisplayString: brain.longDisplayString)) {
                            copyPasteHighlight = true
                            let now = DispatchTime.now()
                            var whenWhen: DispatchTime
                            whenWhen = now + DispatchTimeInterval.milliseconds(300)
                            DispatchQueue.main.asyncAfter(deadline: whenWhen) {
                                copyPasteHighlight = false
                            }
                        }
                        .padding(.top, 40)
                        Paste() { fromPasteboard in
                            copyPasteHighlight = true
                            let now = DispatchTime.now()
                            var whenWhen: DispatchTime
                            whenWhen = now + DispatchTimeInterval.milliseconds(300)
                            DispatchQueue.main.asyncAfter(deadline: whenWhen) {
                                copyPasteHighlight = false
                            }
                            brain.fromPasteboard(fromPasteboard)
                        }
                        .padding(.top, 20)
                    }
                    Spacer()
                }
                .frame(maxWidth: Configuration.scientificKeySize(appFrame: appFrame).width+3)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CatalystContentView()
            .frame(width: 575.0, height: 320.0)
    }
}
#endif



