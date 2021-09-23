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
        let w = rect.size.width
        let h = rect.size.height
        let s = min(w,h)
        let steepness = 2.8
        let f = 0.6
        let startX = 0.4 * s
        let startY = 0.55 * s
        let downX = startX+f*0.08*s
        let downY = startY+f*0.08*steepness*s
        let upX = downX+f*0.2*s
        let upY = downY-f*0.2*steepness*s
        let endX = upX+f*0.35*s
        let endY = upY
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: downX, y: downY))
        path.addLine(to: CGPoint(x: upX,   y: upY))
        path.addLine(to: CGPoint(x: endX,  y: endY))
        
        return path
    }
}

struct SquareRoot: View {
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let s = min(geo.size.width, geo.size.height)
                Text("2")
                    .font(.system(size: 10.0, weight: .semibold))
                    .offset(x: 0.33*s, y: 0.25*s)
                SquareRootShape()
                    .stroke(Configuration.shared.LightGrayKeyProperties.textColor, style: StrokeStyle(lineWidth: 1.8, lineCap: CGLineCap.square, lineJoin: CGLineJoin.bevel))
                Text("X")
                    .font(.system(size: 13.0, weight: .semibold))
                    .offset(x: 0.58*s, y: 0.37*s)
            }
        }
    }
}

struct CubeRoot: View {
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let s = min(geo.size.width, geo.size.height)
                Text("3")
                    .font(.system(size: 10.0, weight: .semibold))
                    .offset(x: 0.33*s, y: 0.25*s)
                SquareRootShape()
                    .stroke(Configuration.shared.LightGrayKeyProperties.textColor, style: StrokeStyle(lineWidth: 1.8, lineCap: CGLineCap.square, lineJoin: CGLineJoin.bevel))
                Text("X")
                    .font(.system(size: 13.0, weight: .semibold))
                    .offset(x: 0.58*s, y: 0.37*s)
            }
        }
    }
}

struct YRoot: View {
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let s = min(geo.size.width, geo.size.height)
                Text("y")
                    .font(.system(size: 10.0, weight: .semibold))
                    .offset(x: 0.33*s, y: 0.25*s)
                SquareRootShape()
                    .stroke(Configuration.shared.LightGrayKeyProperties.textColor, style: StrokeStyle(lineWidth: 1.8, lineCap: CGLineCap.square, lineJoin: CGLineJoin.bevel))
                Text("X")
                    .font(.system(size: 13.0, weight: .semibold))
                    .offset(x: 0.58*s, y: 0.37*s)
            }
        }
    }
}
