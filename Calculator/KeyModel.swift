//
//  keyModel.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import Foundation

class KeyModel : ObservableObject {
    @Published var colorsOf: [String: ColorsOf] = [:]
    
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
    }
    
    private var lastPending: String = "none"
    func updatePendingKey(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let symbol = userInfo[C.notificationDictionaryKey] as? String {
                guard lastPending != symbol else { return }

                DispatchQueue.main.async {
                    if self.lastPending != "none" {
                        self.colorsOf[self.lastPending] = C.operatorColors
                    }
                    if symbol != "none" {
                        self.colorsOf[symbol] = C.pendingOperatorColors
                    }
                    self.lastPending = symbol
                }
            }
        }
    }
    
    
    
    func keyUpEvent(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let symbol = userInfo[C.notificationDictionaryKey] as? String {
//                                colorsOf[symbol] = C.disabledColors
                //
                //                if symbol == "/" {
                //                    colorsOf["/"]! = C.pendingOperatorColors
                //                } else if symbol == "x" {
                //                    colorsOf["x"]! = C.pendingOperatorColors
                //                } else {
                //                    colorsOf["x"]! = C.operatorColors
                //                }
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
