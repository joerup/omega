//
//  ButtonOverlay.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/16/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct ButtonOverlay: View {
    
    @ObservedObject var settings = Settings.settings
    
    var size: Size
    var orientation: Orientation
    
    var width: CGFloat
    var buttonHeight: CGFloat
    
    var active: Bool = true
    
    var body: some View {
                
        if settings.buttonDisplayMode == .math {
            
            VStack(spacing: 0) {
                if orientation == .landscape {
                    MathPad(width: width, buttonHeight: buttonHeight, size: size, orientation: orientation, expanded: true, active: active)
                } else {
                    MathPad(width: width, buttonHeight: buttonHeight*(size == .large ? 1.0 : settings.portraitExpanded ? 1 : 5/6), size: size, orientation: orientation, active: active)
                }
            }
        }
    
        else if settings.buttonDisplayMode == .alpha {
            
            VStack(spacing: 0) {
                if orientation == .landscape {
                    AlphaPad(width: width, buttonHeight: buttonHeight, size: size, orientation: orientation, expanded: true, active: active)
                } else {
                    AlphaPad(width: width, buttonHeight: buttonHeight*(size == .large ? 1.0 : settings.portraitExpanded ? 6/7 : 5/7), size: size, orientation: orientation, active: active)
                }
            }
        }
    }
}
