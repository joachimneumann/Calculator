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
    let leadingPaddingNeeded : Bool
    let trailingPaddingNeeded : Bool
    let bottomPaddingNeeded : Bool
    
    let orientationDidChangeNotification =
      NotificationCenter
        .default
        .publisher(for: UIDevice.orientationDidChangeNotification)
     
    
    var body: some View {
        GeometryReader { geo in
            Color.clear
              .onReceive(orientationDidChangeNotification) { _ in
                  print(geo.size.height)
                  print(geo.size.height)
                  print(geo.size.height)
                  print(geo.size.height)
              }
            let isPortrait = geo.size.height > geo.size.width
            let fraction = isPortrait ? TE.portraitSpacingFraction : TE.landscapeSpacingFraction
            let horizontalFactor: CGFloat = CGFloat(1.0) -
            (leadingPaddingNeeded ? fraction : 0) -
            (trailingPaddingNeeded ? fraction : 0 )
            let verticalFactor: CGFloat = CGFloat(1.0) -
            (bottomPaddingNeeded ? TE.landscapeSpacingFraction : 0.0)
            
//            let _ = print("geometry.safeAreaInsets \(geo.safeAreaInsets)")
            // TODO: only redraw when EdgeInsets are noce numbers, e.g., max 1 digit
            let appFrame = CGSize(
                width: geo.size.width * horizontalFactor,
                height: geo.size.height * verticalFactor)
//            let _ = print("appFrame \(appFrame.width)x\(appFrame.height)")
            let t = TE(appFrame: appFrame)
            MainView(brain: brain, t: t)
                .padding(.leading,   leadingPaddingNeeded ? geo.size.width * fraction : 0)
                .padding(.trailing, trailingPaddingNeeded ? geo.size.width * fraction : 0)
                .padding(.bottom,   bottomPaddingNeeded   ? t.spaceBetweenKeys : 0)
        }
        .background(Color.green).opacity(0.8)
    }
}

#endif

struct Previews_iOSSize_Previews: PreviewProvider {
    static var previews: some View {
        iOSSize(brain: Brain(), leadingPaddingNeeded: false, trailingPaddingNeeded: false, bottomPaddingNeeded: false)
    }
}
