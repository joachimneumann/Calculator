//
//  PurchaseView.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/11/22.
//

import SwiftUI

struct PurchaseView: View {
    @ObservedObject var store: Store
    var body: some View {
        Rectangle()
            .foregroundColor(.black)
            .background(.black)
            .overlay() {
                VStack {
//                    Spacer()
                    if let product = store.products.first {
                        Text("In the free version you can select any presicion for the calculations and the correct result will be displayed. The limitations are: the number of displayed digits is limited to 10,000 and you can not copy or paste the results.")
                            .padding(.top, 20)
                        Text("If you purchase Copy & Paste, you can access all digits - set with precision in the configuration.")
                            .padding(.top, 10)
                        Button {
                            if store.purchasedIDs.isEmpty {
                                store.purchade()
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
                    } else {
                        Text("...loading products")
                            .padding(.top, 60)
                            .padding(.bottom, 10)
                        Text("(check your Internet connection)").italic()
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .padding()
                .onAppear() {
                    store.fetchProducts()
                }
            }
    }
}

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView(store: Store())
    }
}
