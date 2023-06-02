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
            
                if size == .small {
                    
                    let width = self.width*0.98
                    let height = min(buttonHeight, width*0.95/4)
                    
                    VStack(spacing:0) {
                        ScrollRow(width: width, buttonHeight: height*0.8, theme: theme, active: active)
                            .padding(.bottom, self.width*0.005)
                        NumPad(width: width, buttonHeight: height, theme: theme, active: active)
                    }
                    .overlay(ButtonOverlay(size: size, orientation: orientation, width: width, buttonHeight: height*(4.8/5)))
                    
                    ControlPad(width: width, buttonHeight: height*0.8, active: active)
                        .padding(.top, self.width*0.005)
                    
                } else {
                    
                    let width = self.width*0.98
                    let height = min(buttonHeight, width*0.95/8)
                        
                    VStack(spacing:0) {
                        PortraitPadBTop(width: width, buttonHeight: height, theme: theme, active: active)
    
                        HStack(spacing:0) {
                            PortraitPadBSide(width: width*4/8, buttonHeight: height, theme: theme, active: active)
                            NumPad(width: width*4/8, buttonHeight: height, theme: theme, active: active)
                        }
                    }
                    .overlay(ButtonOverlay(size: size, orientation: orientation, width: width, buttonHeight: height))
                    
                    ControlPad(width: width, buttonHeight: height*0.8, active: active)
                        .padding(.top, self.width*0.005)
                }
            }
            .padding(.horizontal, self.width*0.01)
            .padding(.top, self.width*0.01)
            .padding(.bottom, size == .small ? self.width*0.005 : self.width*0.01)
        }
        
        else if orientation == .landscape {
            
            let width = size == .large ? self.width*0.98 : self.width*0.99
            let height = min(buttonHeight, width*0.95/11)
            
            HStack(spacing:0) {
                
                LandscapePad(width: width*7/11, buttonHeight: height, theme: theme, active: active)
                    .overlay(ButtonOverlay(size: size, orientation: orientation, width: width*7/11, buttonHeight: height))
                
                VStack(spacing:0) {
                    NumPad(width: width*4/11, buttonHeight: height, theme: theme, active: active)
                    ControlPad(width: width*4/11, buttonHeight: height, active: active)
                }
            }
            .padding(.horizontal, size == .large ? self.width*0.01 : self.width*0.005)
            .padding(.top, size == .large ? self.width*0.01 : self.width*0.001)
            .padding(.bottom, size == .large ? self.width*0.01 : 0)
        }
    }
}

enum ButtonDisplayMode {
    case basic
    case funcs
    case vars
    case units
}
