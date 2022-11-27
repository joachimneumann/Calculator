//
//  keyModel.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import Foundation

class KeyModel : ObservableObject {
    @Published var colorsOf: [String: ColorsOf] = [:]
    @Published var _2ndActive = false
    @Published var _rad = false
    @Published var isCalculating = false

    init() {
        for key in [C.digitKeys, C.operatorKeys, C.scientificKeys].joined() {
            colorsOf[key] = C.getKeyColors(for: key)
        }
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(C.notificationNameUp),
            object: nil, queue: nil,
            using: keyUpEvent)
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(C.notificationNameDown),
            object: nil, queue: nil,
            using: keyDownEvent)
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(C.notificationNamePending),
            object: nil, queue: nil,
            using: updatePendingKey)
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(C.notificationNameisCalculating),
            object: nil, queue: nil,
            using: isCalculating)
        
    }
    
    private var lastPending: String? = nil
    func updatePendingKey(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let pendingSymbol = userInfo[C.notificationDictionaryKey] as? String? {
                
                /// did something change?
                guard lastPending != pendingSymbol else { return }

                if let lastPending = self.lastPending {
                    DispatchQueue.main.async { self.colorsOf[lastPending] = C.operatorColors }
                }
                if let pendingSymbol = pendingSymbol {
                    DispatchQueue.main.async { self.colorsOf[pendingSymbol] = C.pendingOperatorColors }
                }
                self.lastPending = pendingSymbol
            }
        }
    }

    func isCalculating(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let isCalculating = userInfo[C.notificationDictionaryKey] as? Bool {
                DispatchQueue.main.async { self.isCalculating = isCalculating }
            }
        }
    }

    
    
    func keyUpEvent(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let symbol = userInfo[C.notificationDictionaryKey] as? String {
                switch symbol {
                case "2nd":
                    if _2ndActive {
                        _2ndActive = false
                        colorsOf["2nd"] = C.scientificColors
                    } else {
                        _2ndActive = true
                        colorsOf["2nd"] = C.pendingScientificColors
                    }
                case "Rad":
                        _rad = false
                case "Deg":
                        _rad = true
                default: break
                }
            }
        }
    }
    
    func keyDownEvent(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let symbol = userInfo[C.notificationDictionaryKey] as? String {
                //                colorsOf[symbol]! = C.disabledColors
            }
        }
    }
}
