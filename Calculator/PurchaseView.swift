//
//  PurchaseView.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/11/22.
//

import SwiftUI

struct PurchaseView: View {
    @Environment(\.presentationMode) var presentation
    @ObservedObject var store: Store
    let brainModel: BrainModel
    let screen: Screen
    let font: Font
    
    var body: some View {
        Group {
            if let product = store.products.first {
                VStack(spacing: 0.0) {
                    HStack {
                        Button {
                            self.presentation.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: screen.infoUiFontSize * 0.7)
                                .padding(.trailing, screen.infoUiFontSize * 0.1)
                            Text("Back")
                        }
                        .padding(.bottom, 40)
                        Spacer()
                    }
                    VStack(alignment: .leading, spacing: 0.0) {
                        Text("Copy & Paste is disabled in the free version.")
                        Text("Purchase this feature to copy results with all digits into other iOS applications. You can then also paste numbers into the calculator.")
                            .padding(.top, 5)
                    }
                    VStack(alignment: .center, spacing: 0.0) {
                        Button {
                            if store.purchasedIDs.isEmpty {
                                store.purchase(store.products.first!)
                            }
                        } label: {
                            Text(store.purchasedIDs.isEmpty ? "Purchase Copy & Paste (\(product.displayPrice))" : "Purchased")
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 300, height: 50)
                                .background(store.purchasedIDs.isEmpty ? .blue : .green)
                                .cornerRadius(10)
                        }
                        .disabled(!store.purchasedIDs.isEmpty)
                        .padding(.top, 30)
                        if store.purchasedIDs.isEmpty {
                            Button {
                                store.restorePurchases()
                            } label: {
                                Text("restore")
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 50)
                                    .background(.blue)
                                    .cornerRadius(10)
                            }
                            .padding(.top, 30)
                        }
                    }
                    Spacer()
                }
            } else {
                VStack(alignment: .leading, spacing: 0.0) {
                    Text("...loading products")
                        .padding(.top, 60)
                        .padding(.bottom, 10)
                    Text("(check your Internet connection)").italic()
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .font(font)
        .foregroundColor(.white)
        .padding()
        .onAppear() {
            Task {
                await store.requestProducts()
            }
            brainModel.hideKeyboard = true
        }
        .onDisappear() {
            brainModel.hideKeyboard = false
            //brainModel.haveResultCallback()
        }
    }
}


//struct PurchaseView_Previews: PreviewProvider {
//    static var previews: some View {
//        PurchaseView(store: Store(), brainModel: Model(), font: Font(UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .light)))
//    }
//}
