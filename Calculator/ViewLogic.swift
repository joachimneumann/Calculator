////
////  ViewLogic.swift
////  Calculator
////
////  Created by Joachim Neumann on 11/18/22.
////
//
//import SwiftUI
//
//extension Calculator {
//    @MainActor class ViewLogic: ObservableObject {
//        let size: CGSize
//        @Published var isZoomed: Bool = false
//        @Published var longText = "longtext"
//        @Published var isCopyingOrPasting = false
//        @Published var textColor = Color.red
//        let displayUIFont: UIFont
//        
//        init(size: CGSize) {
//            self.size = size
//            let keySize = CGSize(width: 0.1 * size.height, height: 0.1 * size.height)
//            let displayFontSize           = keySize.height * 0.79
//            displayUIFont = UIFont.monospacedDigitSystemFont(ofSize: displayFontSize, weight: .thin)
//        }
////        var t: TE
////        let brain: Brain
//        
//        
////        init(precision: Int) {
////            brain = Brain(precision: precision)
////        }
//    }
//}
