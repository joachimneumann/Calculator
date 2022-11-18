//
//  iOSSize.swift
//  Calculator
//
//  Created by Joachim Neumann on 02/10/2021.
//

#if targetEnvironment(macCatalyst)
// nothing to compile here...
#else

import SwiftUI


//struct ContentView: View {
//  let orientationDidChangeNotification =
//    NotificationCenter
//      .default
//      .publisher(for: UIDevice.orientationDidChangeNotification)
//   
//  var body: some View {
//      Color.clear
//        .onReceive(orientationDidChangeNotification) { _ in
//            GeometryReader { geometryProxy in
//          let _ = print(geometryProxy.size.height)
//        }
//    }
//  }
//}

struct iOSSize: View {
    var brain: Brain
    let leadingPaddingNeeded:  Bool
    let trailingPaddingNeeded: Bool
    let bottomPaddingNeeded:   Bool
    let topPaddingNeeded:      Bool
    let orientationDidChangeNotification =
      NotificationCenter
        .default
        .publisher(for: UIDevice.orientationDidChangeNotification)
     
    
    var body: some View {
        GeometryReader { geo in
            // TODO: investigate it it makes sense to only redraw the MainView when EdgeInsets are round numbers (or max 1 digit)
            var t = TE(appFrame: geo.size)
            let appFrame = CGSize(
                width: geo.size.width   - (leadingPaddingNeeded ? t.spaceBetweenKeys : 0) - (trailingPaddingNeeded ? t.spaceBetweenKeys : 0),
                height: geo.size.height - (topPaddingNeeded     ? t.spaceBetweenKeys : 0) - (bottomPaddingNeeded   ? t.spaceBetweenKeys : 0))
            let _ = t = TE(appFrame: appFrame)
            CalculatorView(brain: brain, t: t)
                .padding(.leading,   leadingPaddingNeeded ? t.spaceBetweenKeys : 0)
                .padding(.trailing, trailingPaddingNeeded ? t.spaceBetweenKeys : 0)
                .padding(.top,         topPaddingNeeded   ? t.spaceBetweenKeys : 0)
                .padding(.bottom,   bottomPaddingNeeded   ? t.spaceBetweenKeys : 0)
        }
//        .background(Color.green).opacity(0.8)
    }
}

#endif

struct Previews_iOSSize_Previews: PreviewProvider {
    static var previews: some View {
        iOSSize(brain: Brain(precision: 100), leadingPaddingNeeded: false, trailingPaddingNeeded: false, bottomPaddingNeeded: false, topPaddingNeeded: false)
    }
}
