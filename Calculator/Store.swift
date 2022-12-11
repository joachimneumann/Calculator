//
//  Store.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/11/22.
//

import StoreKit

class Store: ObservableObject {
    @Published var products: [Product] = []
    @Published var purchasedIDs: [String] = []
    func fetchProducts() {
        Task {
            do {
                let products = try await Product.products(for: ["Calculator.copyPaste.test"])
                DispatchQueue.main.async {
                    self.products = products
                    print("fetchProducts \(products)")
                }
                if let product = products.first {
                    await isPurchased(product)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func isPurchased(_ product: Product) async {
        guard let state = await product.currentEntitlement else { return }
        switch state {
        case .verified(let transaction):
            DispatchQueue.main.async {
                self.purchasedIDs = [transaction.productID]
                print("isPurchased \(self.purchasedIDs)")
            }
        case .unverified(_, _):
            break
        }
    }
    
    func purchade() {
        Task {
            guard let product = products.first else { return }
            do {
                Task {
                    for await result in Transaction.updates {
                        print("Transaction update")
                        if case .verified(let transaction) = result {
                            await transaction.finish()
                        }
                    }
                }
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction):
                        DispatchQueue.main.async {
                            self.purchasedIDs = [transaction.productID]
                        }
                    case .unverified(_, _):
                        break
                    }
                case .userCancelled:
                    break
                case .pending:
                    break
                @unknown default:
                    break
                }
            } catch {
                print(error)
            }
        }
    }
}
