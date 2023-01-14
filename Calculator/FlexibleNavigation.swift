//
//  FlexibleNavigation.swift
//  Calculator
//
//  Created by Joachim Neumann on 1/14/23.
//

import SwiftUI

struct FlexibleNavigation<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack(root: content)
        } else {
            NavigationView(content: content)
        }
    }
}
