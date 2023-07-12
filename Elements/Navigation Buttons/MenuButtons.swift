//
//  MenuButtonViews.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/6/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct XButton: View {
    
    var action: () -> Void
    
    var body: some View {
        SmallIconButton(symbol: "xmark", color: Color.init(white: 0.25), smallerSmall: true, action: action)
    }
}

struct XButtonOverlay: View {
    
    var action: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                XButton {
                    withAnimation {
                        action()
                    }
                }
                .padding(7.5)
            }
            Spacer()
        }
    }
}

