//
//  NumberKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI


struct NumberKeys: View {
    let size: CGSize
    let verticalSpace: CGFloat
    let horizontalSpace: CGFloat

    var body: some View {
        VStack(spacing: verticalSpace) {
            HStack(spacing: horizontalSpace) {
                Key("C")
                    .op3(size: size)
                Key("+/-")
                    .op2(size: size)
                Key("%")
                    .op2(size: size)
                Key("/")
                    .op(size: size)
            }
            HStack(spacing: horizontalSpace) {
                Key("7")
                    .digit(size: size)
                Key("8")
                    .digit(size: size)
                Key("9")
                    .digit(size: size)
                Key("x")
                    .op(size: size)
            }
            HStack(spacing: horizontalSpace) {
                Key("4")
                    .digit(size: size)
                Key("5")
                    .digit(size: size)
                Key("6")
                    .digit(size: size)
                Key("-")
                    .op(size: size)
            }
            HStack(spacing: horizontalSpace) {
                Key("1")
                    .digit(size: size)
                Key("2")
                    .digit(size: size)
                Key("3")
                    .digit(size: size)
                Key("+")
                    .op(size: size)
            }
            HStack(spacing: horizontalSpace) {
                Key("0")
                    .zero(size: size, horizontalSpace: horizontalSpace)
                Key(",")
                    .digit(size: size)
                Key("=")
                    .op(size: size)
            }
        }
    }
    init(roundKeys: Bool, width totalWidth: CGFloat) {
        horizontalSpace = 0.03 * totalWidth
        verticalSpace = 0.03 * totalWidth
        let w = (totalWidth - 3.0 * horizontalSpace) * 0.25
        size = CGSize(width: w, height: w)
    }
}

struct NumberKeys_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
            NumberKeys(roundKeys: true, width: 320)
        }
            .background(Color.black)
    }
}
