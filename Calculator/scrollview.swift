//
//  scrollview.swift
//  scrollview
//
//  Created by Joachim Neumann on 10/19/21.
//

import SwiftUI

struct ContentView: View {
    let keyboardHeight: CGFloat
    let mantissa: String
    let exponent: String?
    @State var scrollviewContentHeight: CGFloat = 0
        
    var body: some View {
        
        ZStack {
            HStack {
                ScrollView {
                    Text(mantissa)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            GeometryReader { proxy in
                                Color.clear.onAppear {
                                    scrollviewContentHeight = proxy.size.height
                                    print(scrollviewContentHeight)
                                }
                            }
                        )
                }
                .disabled(scrollviewContentHeight < 321)
                if let exponent = exponent {
                    VStack {
                        Text(exponent)
                        Spacer(minLength: 0.0)
                    }
                }
            }
            VStack {
                Spacer(minLength: 0.0)
                Rectangle()
                    .foregroundColor(Color.yellow.opacity(0.3))
                    .frame(height: 200)
            }
        }
    }
}

//struct ContentView: View {
//    let mantissa: String
//    let exponent: String?
//    @State var scrollviewContentHeight: CGFloat = 0
//    var body: some View {
//        HStack(spacing: 0.0) {
//            ScrollView {
//                Text(mantissa)
//                    .multilineTextAlignment(.leading)
//                    .lineLimit(1000)
//            }
//            //.frame(width: 200)
//            .background(Color.orange)
//            .overlay(
//                GeometryReader { proxy in
//                    Color.clear.onAppear {
//                        scrollviewContentHeight = proxy.size.height
//                        print(scrollviewContentHeight) }
//                }
//            )
//            if let exponent = exponent {
//                VStack {
//                    Text(exponent)
//                        .background(Color.green)
//                    Spacer(minLength: 0.0)
//                }
//            }
//        }
//        .ignoresSafeArea()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let exponent = "e13"
//        var mantissa = "4.1415826"
////        let _ = mantissa += "1111111111111"
////        let _ = mantissa += "2222222222222"
////        let _ = mantissa += "3333333333333"
//        ContentView(mantissa: mantissa, exponent: exponent)
//    }
//}
