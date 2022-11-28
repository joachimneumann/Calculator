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
    
    private var previouslyPendingKey: String? = nil
    func updatePendingKey(notification: Notification) {
        if let userInfo = notification.userInfo {
            if userInfo[C.notificationDictionaryKey] as? String == nil {
                /// no pending key. Set the previous one back to normal?
                if let previous = previouslyPendingKey {
                    DispatchQueue.main.async { self.colorsOf[previous] = C.operatorColors }
                }
                previouslyPendingKey = nil
            } else {
                /// we have a pending key
                if let newPendingkey = userInfo[C.notificationDictionaryKey] as? String {
                    /// Set the pending key
                    DispatchQueue.main.async { self.colorsOf[newPendingkey] = C.pendingOperatorColors }

                    /// And set the previous one back to normal?
                    if let previous = previouslyPendingKey {
                        /// wait, are the different?
                        if previous != newPendingkey {
                            DispatchQueue.main.async { self.colorsOf[previous] = C.operatorColors }
                        }
                    }
                    previouslyPendingKey = newPendingkey
                }
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
