//
//  DictionaryBootcamp.swift
//  SwiftCuncurrencyBootcamp
//
//  Created by Joachim Neumann on 1/4/23.
//

import SwiftUI


class DictionaryBootcampViewModel: ObservableObject {
    @Published var dict: [String: ColorsOf] = [:]
    @Published var colorsOf: ColorsOf = ColorsOf(textColor: .yellow, upColor: .yellow, downColor: .yellow)
    
    init() {
        dict["press 0"] = ColorsOf(textColor: .white, upColor: .gray, downColor: .black)
        dict["press 1"] = ColorsOf(textColor: .white, upColor: .gray, downColor: .black)
        dict["press 2"] = ColorsOf(textColor: .white, upColor: .gray, downColor: .black)
        dict["press 3"] = ColorsOf(textColor: .white, upColor: .gray, downColor: .black)
    }
    func pressed() {
        self.colorsOf.upColor = Color.random
        self.objectWillChange.send()
    }
}

struct KKey: View {
    let text: String
    @ObservedObject var viewModel: DictionaryBootcampViewModel
    var body: some View {
        let _ = Self._printChanges()
        Text(text)
            .foregroundColor(.white)
            .onTapGesture {
                viewModel.pressed()
            }
            .frame(width: 150, height: 40)
            .background(viewModel.colorsOf.upColor)
            .modifier(Backgrounds(color: $viewModel.colorsOf.upColor, upColor: viewModel.colorsOf.upColor, downColor: .black))
            .clipShape(Capsule())
    }
}

struct DictionaryBootcamp: View {
    @StateObject private var viewModel = DictionaryBootcampViewModel()
    var body: some View {
        let _ = print("DictionaryBootcamp body: viewModel.colorsOf.upColor", viewModel.colorsOf.upColor)
        let _ = Self._printChanges()
        VStack(spacing: 40) {
            KKey(
                text: "press 0",
                viewModel: viewModel
            )
            KKey(
                text: "press 1",
                viewModel: viewModel
            )
            Text("press 2")
                .frame(width: 250, height: 40)
                .foregroundColor(Color.white)
                .background(viewModel.colorsOf.upColor)
                .onTapGesture {
                    viewModel.pressed()
                }
                .modifier(Backgrounds(color: $viewModel.colorsOf.upColor, upColor: .gray, downColor: .black))
                .clipShape(Capsule())
            Text("press 3")
                .frame(width: 250, height: 40)
                .foregroundColor(Color.white)
                .background(viewModel.colorsOf.upColor)
                .onTapGesture {
                    viewModel.pressed()
                }
                .modifier(Backgrounds(color: $viewModel.colorsOf.upColor, upColor: .gray, downColor: .black))
                .clipShape(Capsule())
            Rectangle()
                .foregroundColor(viewModel.colorsOf.upColor)
                .frame(width: 100, height: 100)
        }
    }
}

struct DictionaryBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryBootcamp()
    }
}
