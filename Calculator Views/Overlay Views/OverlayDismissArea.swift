//
//  OverlayDismissArea.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/13/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct OverlayDismissArea: View {
    
    @ObservedObject var settings = Settings.settings
    
    var body: some View {
        
        ZStack {
            
            if settings.calculatorOverlay != .none {
                
                Rectangle()
                    .fill(Color.black)
                    .opacity(1e-6)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            settings.calculatorOverlay = .none
                        }
                        SoundManager.play(haptic: .light)
                    }
                
            } else if settings.detailOverlay != .none {
                
                Rectangle()
                    .fill(Color.black)
                    .opacity(1e-6)
                    .edgesIgnoringSafeArea(.all)
                    .simultaneousGesture(TapGesture()
                        .onEnded { _ in
                            settings.detailOverlay = .none
                            SoundManager.play(haptic: .light)
                        }
                    )
            }
        }
    }
}
