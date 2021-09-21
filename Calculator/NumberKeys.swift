//
//  NumberKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI


struct NumberKeys: View {
    let size: KeySize
    
    var body: some View {
        VStack(spacing: size.space) {
            HStack(spacing: size.space) {
                CKey(AC: false,
                     fontSize: size.fontSize) {}
                     .frame(width: size.width, height: size.height)
                GrayKey(text: "+/-",
                    fontSize: size.fontSize) {}
                    .frame(width: size.width, height: size.height)
                GrayKey(text: "%",
                    fontSize: size.fontSize) {}
                    .frame(width: size.width, height: size.height)
                OpKey(waiting: true,
                      text: "/",
                      fontSize: size.fontSize) {}
                      .frame(width: size.width, height: size.height)
            }
            HStack(spacing: size.space) {
                GrayKey(text: "7",
                    fontSize: size.fontSize) {}
                    .frame(width: size.width, height: size.height)
                GrayKey(text: "8",
                    fontSize: size.fontSize) {}
                    .frame(width: size.width, height: size.height)
                GrayKey(text: "9",
                    fontSize: size.fontSize) {}
                    .frame(width: size.width, height: size.height)
                OpKey(waiting: false,
                      text: "x",
                      fontSize: size.fontSize) {}
                      .frame(width: size.width, height: size.height)
            }
            HStack(spacing: size.space) {
                GrayKey(text: "4",
                    fontSize: size.fontSize) {}
                    .frame(width: size.width, height: size.height)
                GrayKey(text: "5",
                    fontSize: size.fontSize) {}
                    .frame(width: size.width, height: size.height)
                GrayKey(text: "6",
                    fontSize: size.fontSize) {}
                    .frame(width: size.width, height: size.height)
                OpKey(waiting: false,
                      text: "-",
                      fontSize: size.fontSize) {}
                      .frame(width: size.width, height: size.height)
            }
            HStack(spacing: size.space) {
                GrayKey(text: "1",
                    fontSize: size.fontSize) {}
                    .frame(width: size.width, height: size.height)
                GrayKey(text: "2",
                    fontSize: size.fontSize) {}
                    .frame(width: size.width, height: size.height)
                GrayKey(text: "3",
                    fontSize: size.fontSize) {}
                    .frame(width: size.width, height: size.height)
                OpKey(waiting: false,
                      text: "+",
                      fontSize: size.fontSize) {}
                      .frame(width: size.width, height: size.height)
            }
            HStack(spacing: size.space) {
                ZeroKey(fontSize: size.fontSize) {}
                        .frame(width: size.doubleWidth, height: size.height)
                GrayKey(text: ",",
                    fontSize: size.fontSize) {}
                    .frame(width: size.width, height: size.height)
                OpKey(waiting: false,
                      text: "=",
                      fontSize: size.fontSize) {}
                      .frame(width: size.width, height: size.height)
            }
        }
    }
}

struct KeySize {
    let width: CGFloat
    let height: CGFloat
    let space: CGFloat
    let fontSize: CGFloat
    let doubleWidth: CGFloat
    init(roundKeys: Bool, width totalWidth: CGFloat) {
        space = 0.03 * totalWidth
        width = (totalWidth - 3.0 * space) * 0.25
        height = width
        fontSize = width * 0.4
        doubleWidth = 2.0 * width + space
    }
}

struct NumberKeys_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
            let keySize = KeySize(roundKeys: true, width: 320)
            NumberKeys(size: keySize)
        }
            .background(Color.black)
    }
}
