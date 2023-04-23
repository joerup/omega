//
//  MenuSheetView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/10/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct MenuSheetView<Content: View>: View {
    
    var content: () -> Content
    
    var onDismiss: (() -> Void)? = nil
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            content()
            
            Spacer()
            
        }
        .overlay(ZStack {
            if let onDismiss = onDismiss {
                VStack {
                    Rectangle()
                        .fill(Color.init(white: 0.1))
                        .opacity(0.02)
                        .frame(height: 30)
                        .gesture(DragGesture(minimumDistance: 30)
                            .onChanged { value in
                                if abs(value.translation.height) > abs(value.translation.width) && value.translation.height > 50 {
                                    onDismiss()
                                }
                            }
                        )
                    Spacer()
                }
                XButtonOverlay(action: onDismiss)
            }
        })
        .frame(maxWidth: .infinity)
        .background(Color.init(white: 0.15))
        .cornerRadius(20)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.default)
        .transition(.move(edge: .bottom))
    }
}
