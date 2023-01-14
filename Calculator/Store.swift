//
//  Store.swift
//  Calculator
//
//  Created by Joachim Neumann on 12/11/22.
//

import StoreKit

class Store: NSObject, ObservableObject, SKProductsRequestDelegate {
    final let PRODUCT_ID = "Calculator.copyPaste"
//    final let PRODUCT_ID = "Calculator.copyPaste.test2"

    @Published var products: [Product] = []
    @Published var purchasedIDs: [String] = []
    
    func sync() async {
        do {
            try await AppStore.sync()
        } catch {
            print(error)
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        //print("SKReceiptRefreshRequest returned with products n = \(response.products.count)")
        if response.products.count >= 1 {
            //print("restorePurchases products.first = \(response.products.first!)")
        }
        request.cancel()
        Task {
            await requestProducts()
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("SKReceiptRefreshRequest failed with error \(error)")
        request.cancel()
    }
    
    func restorePurchases() {
        let refresh = SKReceiptRefreshRequest()
        refresh.delegate = self
        refresh.start()
    }
    
    func requestProducts() async {
        do {
            let products = try await Product.products(for: [PRODUCT_ID])
            await MainActor.run() {
                self.products = products
                //print("requestProducts n = \(products.count)")
            }
            if let product = products.first {
                //print("checking \(products.debugDescription)")
                await checkIfHasBeenPurchased(product)
            }
        } catch {
            print(error)
        }
    }
    
    func checkIfHasBeenPurchased(_ product: Product) async {
        guard let state = await product.currentEntitlement else {
            //print("not purchased")
            return
        }
        switch state {
        case .verified(let transaction):
            await MainActor.run() {
                self.purchasedIDs = [transaction.productID]
                print("isPurchased \(self.purchasedIDs)")
            }
        case .unverified(_, _):
            break
        }
    }
    
    func purchase(_ product: Product) {
        Task {
            for await transaction in Transaction.updates {
                print("Transaction update")
                switch transaction {
                case .unverified(_, _):
                    break
                case .verified(let verifiedFransaction):
                    await MainActor.run() {
                        self.purchasedIDs = [verifiedFransaction.productID]
                    }
                    await verifiedFransaction.finish()
                }
            }
        }

        Task {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .unverified(_, _):
                    break
                case .verified(let verifiedFransaction):
                    await MainActor.run() {
                        self.purchasedIDs = [verifiedFransaction.productID]
                    }
                    await verifiedFransaction.finish()
                }
            case .userCancelled:
                break
            case .pending:
                break
            @unknown default:
                break
            }
        }
    }
}
