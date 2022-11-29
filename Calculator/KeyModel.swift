//
//  keyModel.swift
//  bg
//
//  Created by Joachim Neumann on 11/27/22.
//

import Foundation

class KeyModel : ObservableObject {
    let brain = Brain(precision: 1000000)
    @Published var colorsOf: [String: ColorsOf] = [:]
    @Published var _AC = true
    @Published var _2ndActive = false
    @Published var _rad = false
    @Published var isCalculating = false
    @Published var last: String = "0"
    @Published var precisionDescription = "unknown"

    var oneLineWithoutCommaLength: Int = 4
    var oneLineWithCommaLength: Int = 4

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
        brain.haveResultCallback = haveResultCallback
        brain.pendingOperatorCallback = pendingOperatorCallback
        brain.isCalculatingCallback = isCalculatingCallback
    }
    
    private func haveResultCallback() {
        if brain.last.isNull {
            DispatchQueue.main.async {
                self._AC = true
            }
        } else {
            DispatchQueue.main.async {
                self._AC = false
            }
        }
        let res = brain.last.multipleLines(withoutComma: oneLineWithoutCommaLength, withComma: oneLineWithCommaLength)
        DispatchQueue.main.async {
            self.last = res.oneLine
            self.precisionDescription = self.brain.precision.useWords
        }
    }

    private var previouslyPendingKey: String? = nil
    func pendingOperatorCallback(op: String?) {
        if op == nil {
            /// no pending key. Set the previous one back to normal?
            if let previous = previouslyPendingKey {
                DispatchQueue.main.async { self.colorsOf[previous] = C.operatorColors }
            }
            previouslyPendingKey = nil
        } else {
            /// we have a pending key
            if let newPendingkey = op {
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

    
    func isCalculatingCallback(calculating: Bool) {
        print("isCalculatingCallback \(calculating)")
        DispatchQueue.main.async { self.isCalculating = calculating }
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
                case "=":
                    brain.execute(priority: Operator.equalPriority)
                    brain.haveResultCallback()
                default:
                    brain.asyncOperation(symbol)
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
