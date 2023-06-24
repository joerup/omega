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
        
        if settings.buttonDisplayMode == .funcs && orientation == .portrait && size == .small {
            VStack(spacing: 0) {
                FuncPad(width: width, buttonHeight: buttonHeight*(size == .large ? 1.0 : 5/6), size: size, orientation: orientation, active: active)
            }
        }
        
        else if settings.buttonDisplayMode == .vars {
            VStack(spacing: 0) {
                if orientation == .landscape {
                    VarPad(width: width, buttonHeight: buttonHeight, size: size, orientation: orientation, expanded: true, active: active)
                } else {
                    VarPad(width: width, buttonHeight: buttonHeight*(size == .large ? 1.0 : 5/6), size: size, orientation: orientation, active: active)
                }
            }
        }
        
        else if settings.buttonDisplayMode == .units {
            VStack(spacing: 0) {
                if orientation == .landscape {
                    UnitPad(width: width, buttonHeight: buttonHeight, size: size, orientation: orientation, expanded: true, active: active)
                } else {
                    UnitPad(width: width, buttonHeight: buttonHeight*(size == .large ? 1.0 : 5/6), size: size, orientation: orientation, active: active)
                }
            }
        }
    }
}
