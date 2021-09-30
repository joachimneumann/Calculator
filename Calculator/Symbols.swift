//
//  Symbols.swift
//  Calculator
//
//  Created by Joachim Neumann on 23/09/2021.
//

import SwiftUI

struct SquareRootShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w: CGFloat = rect.size.width
        let h: CGFloat = rect.size.height
        let s: CGFloat = min(w,h)
        let steepness: CGFloat = 2.8
        let f: CGFloat = 0.6
        let startX: CGFloat = 0.4 * s
        let startY: CGFloat = 0.55 * s
        let downX: CGFloat = startX+f*0.08*s
        let downY: CGFloat = startY+f*0.08*steepness*s
        let upX: CGFloat = downX+f*0.2*s
        let upY: CGFloat = downY-f*0.2*steepness*s
        let endX: CGFloat = upX+f*0.35*s
        let endY: CGFloat = upY
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: downX, y: downY))
        path.addLine(to: CGPoint(x: upX,   y: upY))
        path.addLine(to: CGPoint(x: endX,  y: endY))
        return path
    }
}

struct SlashShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w: CGFloat = rect.size.width
        let h: CGFloat = rect.size.height
        let s: CGFloat = min(w,h)
        let steepness: CGFloat = 1.5
        let startX: CGFloat = 0.5 * s
        let startY: CGFloat = 0.65 * s
        let upX: CGFloat = startX+0.18*s
        let upY: CGFloat = startY-0.18*steepness*s
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: upX,   y: upY))
        return path
    }
}

struct Root: View {
    let root: String
    let strokeColor: Color
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let s = min(geo.size.width, geo.size.height)
                let fontSize1:CGFloat = CGFloat(0.21276) * s
                let fontSize2:CGFloat = CGFloat(0.27659) * s
                let offsetX1:CGFloat  = CGFloat(0.33) * s
                let offsetY1:CGFloat  = CGFloat(0.25) * s
                let offsetX2:CGFloat  = CGFloat(0.58) * s
                let offsetY2:CGFloat  = CGFloat(0.37) * s
                Text(root)
                    .font(.system(size: fontSize1, weight: .semibold))
                    .offset(x: offsetX1, y: offsetY1)
                SquareRootShape()
                    .stroke(strokeColor, style: StrokeStyle(lineWidth: 1.6*s/47, lineCap: CGLineCap.square, lineJoin: CGLineJoin.bevel))
                Text("X")
                    .font(.system(size: fontSize2, weight: .semibold))
                    .offset(x: offsetX2, y: offsetY2)
            }
        }
    }
    init(_ root: String, strokeColor: Color) {
        self.strokeColor = strokeColor
        self.root = root
    }
}

struct One_x: View {
    let strokeColor: Color
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let s = min(geo.size.width, geo.size.height)
                Text("1")
                    .font(.system(size: s*0.25))
                    .offset(x: 0.4*s, y: 0.3*s)
                SlashShape()
                    .stroke(strokeColor, style: StrokeStyle(lineWidth: 1.6*s/47, lineCap: CGLineCap.square, lineJoin: CGLineJoin.bevel))
                Text("x")
                    .font(.system(size: s*0.25))
                    .offset(x: 0.65*s, y: 0.45*s)
            }
        }
        //.background(Color.yellow)
    }
}



struct Log10: View {
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let s = min(geo.size.width, geo.size.height)
                Text("log")
                    .font(.system(size: s*0.4))
                    .offset(x: 0.2*s, y: 0.25*s)
                Text("10")
                    .font(.system(size: s*0.22))
                    .offset(x: 0.73*s, y: 0.5*s)
            }
        }
    }
}

struct Logx: View {
    let base: String
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let s = min(geo.size.width, geo.size.height)
                Text("log")
                    .font(.system(size: s*0.4))
                    .offset(x: 0.25*s, y: 0.25*s)
                Text(base)
                    .font(.system(size: s*0.22))
                    .offset(x: 0.78*s, y: 0.5*s)
            }
        }
    }
    init(_ base: String) { self.base = base }
}

struct Pow: View {
    let base: String
    let exponent: String
    let baseXOffset: CGFloat
    let exponentXOffset: CGFloat
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let s = min(geo.size.width, geo.size.height)
                Text(base)
                    .font(.system(size: s*0.4))
                    .offset(x: (0.4-exponentXOffset+baseXOffset)*s, y: 0.25*s)
                Text(exponent)
                    .font(.system(size: s*0.22))
                    .offset(x: (0.62+exponentXOffset+baseXOffset)*s, y: 0.25*s)
            }
        }
    }
}

