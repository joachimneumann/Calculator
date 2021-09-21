//
//  NumberKeys.swift
//  Calculator
//
//  Created by Joachim Neumann on 20/09/2021.
//

import SwiftUI


struct NumberKeys: View {
    let size: KeySize
    
    let digitProperties = TextKeyproperties(
        textColor: Color.white,
        color: Color(
            red:    52.0/255.0,
            green:  52.0/255.0,
            blue:   52.0/255.0),
        downColor: Color(
            red:   115/255.0,
            green: 115/255.0,
            blue:  115/255.0))
    let operatorProperties = TextKeyproperties(
        textColor: Color.white,
        color: Color(
            red:    81.0/255.0,
            green: 181.0/255.0,
            blue:  235.0/255.0),
        downColor: Color(
            red:   209/255.0,
            green: 222/255.0,
            blue:  243/255.0))

    var body: some View {
        VStack(spacing: size.space) {
            HStack(spacing: size.space) {
                Key(text: "C",
                        fontSize: size.fontSize,
                        properties: operatorProperties) {}
                        .frame(width: size.width, height: size.height)
                Key(text: "+/-",
                        fontSize: size.fontSize,
                        properties: digitProperties) {}
                        .frame(width: size.width, height: size.height)
                Key(text: "%",
                        fontSize: size.fontSize,
                        properties: digitProperties) {}
                        .frame(width: size.width, height: size.height)
                Key(text: "÷",
                        fontSize: size.fontSize,
                        properties: operatorProperties) {}
                        .frame(width: size.width, height: size.height)
            }
            HStack(spacing: size.space) {
                Key(text: "7",
                        fontSize: size.fontSize,
                        properties: digitProperties) {}
                        .frame(width: size.width, height: size.height)
                Key(text: "8",
                        fontSize: size.fontSize,
                        properties: digitProperties) {}
                        .frame(width: size.width, height: size.height)
                Key(text: "9",
                        fontSize: size.fontSize,
                        properties: digitProperties) {}
                        .frame(width: size.width, height: size.height)
                Key(text: "x",
                        fontSize: size.fontSize,
                        properties: operatorProperties) {}
                        .frame(width: size.width, height: size.height)
            }
            HStack(spacing: size.space) {
                Key(text: "4",
                        fontSize: size.fontSize,
                        properties: digitProperties) {}
                        .frame(width: size.width, height: size.height)
                Key(text: "5",
                        fontSize: size.fontSize,
                        properties: digitProperties) {}
                        .frame(width: size.width, height: size.height)
                Key(text: "6",
                        fontSize: size.fontSize,
                        properties: digitProperties) {}
                        .frame(width: size.width, height: size.height)
                Key(text: "-",
                        fontSize: size.fontSize,
                        properties: operatorProperties) {}
                        .frame(width: size.width, height: size.height)
            }
            HStack(spacing: size.space) {
                Key(text: "1",
                        fontSize: size.fontSize,
                        properties: digitProperties) {}
                        .frame(width: size.width, height: size.height)
                Key(text: "2",
                        fontSize: size.fontSize,
                        properties: digitProperties) {}
                        .frame(width: size.width, height: size.height)
                Key(text: "3",
                        fontSize: size.fontSize,
                        properties: digitProperties) {}
                        .frame(width: size.width, height: size.height)
                Key(text: "+",
                        fontSize: size.fontSize,
                        properties: operatorProperties) {}
                        .frame(width: size.width, height: size.height)
            }
            HStack(spacing: size.space) {
                Key(text: "0",
                        fontSize: size.fontSize,
                        properties: digitProperties) {}
                        .frame(width: size.doubleWidth, height: size.height)
                Key(text: ",",
                        fontSize: size.fontSize,
                        properties: digitProperties) {}
                        .frame(width: size.width, height: size.height)
                Key(text: "=",
                        fontSize: size.fontSize,
                        properties: operatorProperties) {}
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
        let keySize = KeySize(roundKeys: true, width: 320)
        NumberKeys(size: keySize)
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}
