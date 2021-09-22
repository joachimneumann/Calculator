//
//  ContentView.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let x: Gmp = Gmp("1.0", precision: 10)
        let y: Gmp = Gmp("2.0", precision: 10)
        let z: Gmp = x + y
        print("z=\(z)")
//        let x = funnyAdd(2, 3)
//        Text("z=\(z.toShortString(maxPrecision: 10))")
//            .padding()
        return ZStack {
            Rectangle()
            NumberKeys(roundKeys: true, width: 320)
        }
            .background(Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
