//
//  CalculatorModel.swift
//  ViewBuilder
//
//  Created by Joachim Neumann on 11/20/22.
//

//import SwiftUI
/*
class CalculatorModel: ObservableObject {
    let brain: Brain
    
    //    @Published var _AC = true
    //    @Published var _hasBeenReset = false
    //    @Published var last: String = "0"
    //    @Published var precisionDescription = "unknown"
    
    var _AC = true
    var _hasBeenReset = false
    @Published var last: String = "0"
    var precisionDescription = "unknown"
    
    var oneLineWithoutCommaLength: Int = 4
    var oneLineWithCommaLength: Int = 4
    
    init() {
        brain = Brain(precision: 10000)
        brain.haveResultCallback = haveResultCallback
        self.precisionDescription = self.brain.precision.useWords
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(C.notificationNameUp),
            object: nil, queue: nil,
            using: keyUpEvent)
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
    
//    private func isCalculatingCallback(calculating: Bool) {
        //        if calculating {
        //            DispatchQueue.main.async {
        //                self._isCalculating = true
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        //                    for key in [self.digitKeys, self.operatorKeys, self.scientificKeys].joined() {
        //                        if self._isCalculating {
        //                            self.allKeyColors[key] = self.getKeyColors(for: key, pending: false)
        //                        }
        //                    }
        //                }
        //            }
        //        } else {
        //            DispatchQueue.main.async {
        //                self._isCalculating = false
        //                for key in [self.digitKeys, self.operatorKeys, self.scientificKeys].joined() {
        //                    if self.brain.isValidNumber {
        //                        self.allKeyColors[key] = self.getKeyColors(for: key, pending: self.lastPending == key )
        //                    } else {
        //                        if self.requireValidNumber.contains(key) {
        //                            /// TODO: also disable the button!!! combine color and status!!!
        //                            self.allKeyColors[key] = self.getKeyColors(for: key, pending: self.lastPending == key )
        //                        } else {
        //                            self.allKeyColors[key] = self.getKeyColors(for: key, pending: self.lastPending == key )
        //                        }
        //                    }
        //                }
        //            }
        //        }
//    }
    
    func keyUpEvent(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let symbol = userInfo[C.notificationDictionaryKey] as? String {
                switch symbol {
                case "2nd", "Rad", "Deg":
                    break // handled in keyModel
                case "=":
                    brain.execute(priority: Operator.equalPriority)
                    brain.haveResultCallback()
                default:
                    brain.asyncOperation(symbol)
                }
            }
        }
    }
    //        switch symbol {
    //        case "2nd":
    //            withAnimation() {
    //                _2ndActive.toggle()
    //                if _2ndActive {
    //                    allKeyColors["2nd"] = getKeyColors(for: "2nd", pending: _2ndActive)
    //                } else {
    //                    allKeyColors["2nd"] = getKeyColors(for: "2nd", pending: _2ndActive)
    //                }
    //            }
    //        case "=":
    //            brain.execute(priority: Operator.equalPriority)
    //        default:
    //            if !_isCalculating {
    //                if symbol == "AC" {
    //                    _hasBeenReset = true
    //                    brain.asyncOperation("AC")
    //                } else {
    //                    _hasBeenReset = false
    //                    brain.asyncOperation(symbol)
    //                }
    //            }
    //        }
}



/// color stuff

class KeyColors: ObservableObject {
    var textColor: UIColor
    var upColor: UIColor
    var downColor: UIColor
    init(textColor: UIColor, upColor: UIColor, downColor: UIColor) {
        self.textColor = textColor
        self.upColor = upColor
        self.downColor = downColor
    }
}

extension Int {
    var useWords: String {
        let ret = "\(self)"
        if ret.hasSuffix("000000000000") {
            var substring1 = ret.dropLast(12)
            substring1 = substring1 + " trillion"
            return String(substring1)
        }
        if ret.hasSuffix("000000000") {
            var substring1 = ret.dropLast(9)
            substring1 = substring1 + " billion"
            return String(substring1)
        }
        if ret.hasSuffix("000000") {
            var substring1 = ret.dropLast(6)
            substring1 = substring1 + " million"
            return String(substring1)
        }
        if ret.hasSuffix("000") {
            var substring1 = ret.dropLast(3)
            substring1 = substring1 + " thousand"
            return String(substring1)
        }
        return ret
    }
}
*/
