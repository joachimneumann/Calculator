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
        Text("x=\(z.toLongString())")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
