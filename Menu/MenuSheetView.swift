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
        .overlay {
            if let onDismiss = onDismiss {
                XButtonOverlay(action: onDismiss)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.init(white: 0.15))
        .cornerRadius(20)
        .edgesIgnoringSafeArea(.bottom)
        .transition(.move(edge: .bottom))
    }
}
