//
//  ContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

struct AllDigitsView: View {
    var text: String
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            ScrollView(.vertical, showsIndicators: true) {
                Text(text)
                    .foregroundColor(Color.white)
                    .font(Font.system(size: Configuration.shared.displayFontSize, weight: .thin).monospacedDigit())
                    //.font(.custom("CourierNewPSMT", size: Configuration.shared.displayFontSize)).fontWeight(.ultraLight)
                    .multilineTextAlignment(.trailing)
                //                    .padding(.trailing, 10)
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var model = BrainViewModel()
    @State var zoomed: Bool = false
    var body: some View {
        ZStack {
            if zoomed {
                VStack {
                    AllDigitsView(text: model.longString.show())
                        .padding(.trailing, 15)
                        .padding(.leading, 60)
                    Spacer()
                }
            } else {
                VStack {
                    Display(text: model.mainDisplay)
                        .padding(.trailing, 15)
                    Spacer()
                }
                VStack {
                    Spacer()
                    ExtractedView(model: model)
                }
                .transition(.move(edge: .bottom))
            }
            HStack {
                VStack {
                    Zoom(higherPrecisionAvailable: model.higherPrecisionAvailable, zoomed: $zoomed) {
                        model.getLongString()
                    }
                    .padding(.leading, 5)
                    .padding(.top, 5)
                    Spacer(minLength: 0)
                }
                Spacer()
            }
        }
        .padding(.top, 28)
        .background(Configuration.shared.appBackgroundColor)
        .ignoresSafeArea()
    }
}

//        var longText = ""
//        if zoomed {
//            let n = 2
//            for _ in 1..<n {
//                longText = longText + "\u{00a0}"
//            }
//            longText = longText + model.longString.show()
//        }
//        return ZStack {
//            if zoomed {
////                Text("ZOOMED")
////                    .foregroundColor(Color.white)
//                AllDigitsView(text: "sdflkgjdskjfdlkfjhglkjdfhgkdjhfg")
//                    //.background(Color.yellow.opacity(0.5))
//                    .padding(.trailing, 15)
//                    .padding(.leading, Configuration.shared.zoomButtonSize*1.3)
////                    .transition(.move(edge: .bottom))
//            } else {
////                Text("NOT ZOOMED")
////                    .foregroundColor(Color.white)
//                VStack(spacing: 0) {
//                    Display(text: model.mainDisplay)
//                        //.background(Color.yellow.opacity(0.5))
//                    Spacer(minLength: 0)
//                    ExtractedView(model: model)
//                        .transition(.move(edge: .bottom))
////#if targetEnvironment(macCatalyst)
////#else
////                    NumberKeys(model: brainViewModel, roundKeys: true, width: 370)
////#endif
//                }
//            }
//            HStack {
//                VStack {
//                    Zoom(higherPrecisionAvailable: true, zoomed: $zoomed) { model.getLongString() // model.higherPrecisionAvailable
//                    }
//                    .padding(Configuration.shared.zoomButtonSize*0.35)
//                    Spacer(minLength: 0)
//                }
//                Spacer(minLength: 0)
//            }
//        }
//        .background(Color.red.opacity(0.2))
////        ZStack {
////            VStack {
////                if zoomed {
////                    AllDigitsView(brainViewModel: model)
////                    .background(Color.yellow.opacity(0.5))
////                } else {
//
////                    }
////                }
////            }
////        }
////        .background(Configuration.shared.appBackgroundColor)
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 575.0, height: 320.0)
    }
}

struct ExtractedView: View {
    var model: BrainViewModel
    var body: some View {
        HStack(alignment: .top, spacing: 1) {
            ScientificKeys(
                model: model,
                keyWidth: 56.25+0,
                keyHeight: 47.0-0)
            NumberKeys(
                model: model,
                keyWidth: 56.25+0,
                keyHeight: 47.0-0)
        }
    }
}
