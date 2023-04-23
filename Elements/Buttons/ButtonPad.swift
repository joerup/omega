//
//  ButtonPad.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/7/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct ButtonPad: View {
    
    @ObservedObject var settings = Settings.settings
    
    var size: Size
    var orientation: Orientation
    
    var width: CGFloat
    var buttonHeight: CGFloat
    
    var theme: Theme? = nil
    
    var active: Bool = true

    var body: some View {
        
        if orientation == .portrait {
            
            VStack(spacing:0) {
            
                if size == .small && !settings.portraitExpanded {
                    
                    VStack(spacing:0) {
                        ScrollRow(width: width, buttonHeight: buttonHeight, theme: theme, active: active)
                        NumPad(width: width, buttonHeight: buttonHeight, theme: theme, active: active)
                    }
                    .overlay(ButtonOverlay(size: size, orientation: orientation, width: width, buttonHeight: buttonHeight))
                    
                    ControlPad(width: width, buttonHeight: buttonHeight, active: active)
                    
                } else {
        
                    if size == .small {
                        
                        VStack(spacing:0) {
                            PortraitPadATop(width: width, buttonHeight: buttonHeight, theme: theme, active: active)
        
                            HStack(spacing:0) {
                                PortraitPadASide(width: width*0.2, buttonHeight: buttonHeight, theme: theme, active: active)
                                NumPad(width: width*0.8, buttonHeight: buttonHeight, theme: theme, active: active)
                            }
                        }
                        .overlay(ButtonOverlay(size: size, orientation: orientation, width: width, buttonHeight: buttonHeight))
    
                        ControlPad(width: width, buttonHeight: buttonHeight, active: active)
                    }
                    else if size == .large {
                        
                        VStack(spacing:0) {
                            PortraitPadBTop(width: width, buttonHeight: buttonHeight, theme: theme, active: active)
        
                            HStack(spacing:0) {
                                PortraitPadBSide(width: width*3/7, buttonHeight: buttonHeight, theme: theme, active: active)
                                NumPad(width: width*4/7, buttonHeight: buttonHeight, theme: theme, active: active)
                            }
                        }
                        .overlay(ButtonOverlay(size: size, orientation: orientation, width: width, buttonHeight: buttonHeight))
    
                        ControlPad(width: width, buttonHeight: buttonHeight, active: active)
                    }
                }
            }
        }
        
        else if orientation == .landscape {
            
            HStack(spacing:0) {
                
                LandscapePad(width: width*0.6, buttonHeight: buttonHeight, theme: theme, active: active)
                    .overlay(ButtonOverlay(size: size, orientation: orientation, width: width*0.6, buttonHeight: buttonHeight))
                
                VStack(spacing:0) {
                    NumPad(width: width*0.4, buttonHeight: buttonHeight, theme: theme, active: active)
                    ControlPad(width: width*0.4, buttonHeight: buttonHeight, active: active)
                }
            }
        }
    }
}

enum ButtonDisplayMode {
    case first
    case second
    case math
    case alpha
}
