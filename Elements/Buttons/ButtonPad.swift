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
    var display: ButtonDisplayMode? = nil
    var overlay: AnyView? = nil
    
    var width: CGFloat
    var buttonHeight: CGFloat
    
    var queue: Queue? = nil
    
    var theme: Theme? = nil
    
    var active: Bool = true
    var showText: Bool = true
    var showDetails: Bool = true
    var onChange: (Queue) -> Void = { _ in }

    var body: some View {
        
        if orientation == .portrait {
            
            VStack(spacing: 0) {
                
                if size == .small {
                    
                    let width = self.width*0.98
                    let height = min(buttonHeight, width*0.95/4)
                    
                    VStack(spacing:0) {
                        ScrollRow(queue: queue, width: width, buttonHeight: height*0.8, theme: theme, active: active, showText: showText, onChange: onChange)
                            .padding(.bottom, self.width*0.005)
                        NumPad(queue: queue, width: width, buttonHeight: height, theme: theme, active: active, showText: showText, onChange: onChange)
                    }
                    .overlay(contentOverlay(width: width, buttonHeight: height*4.8/5))
                    
                    ControlPad(queue: queue, width: width, buttonHeight: height*0.8, equivalentRowAmount: 4, active: active, showText: showText, onChange: onChange)
                        .padding(.top, self.width*0.0025)
                    
                } else {
                    
                    let width = self.width*0.98
                    let height = min(buttonHeight, width*0.95/8)
                        
                    VStack(spacing:0) {
                        PortraitPadTop(queue: queue, width: width, buttonHeight: height, theme: theme, active: active, showText: showText, onChange: onChange)
    
                        HStack(spacing:0) {
                            PortraitPadSide(queue: queue, width: width*4/8, buttonHeight: height, theme: theme, active: active, showText: showText, onChange: onChange)
                            NumPad(queue: queue, width: width*4/8, buttonHeight: height, theme: theme, active: active, showText: showText, onChange: onChange)
                        }
                    }
                    .overlay(contentOverlay(width: width, buttonHeight: height))
                    
                    ControlPad(queue: queue, width: width, buttonHeight: height*0.8, equivalentRowAmount: 8, active: active, showText: showText, onChange: onChange)
                        .padding(.top, self.width*0.0025)
                }
            }
            .padding(.horizontal, self.width*0.01)
            .padding(.top, self.width*0.01)
            .padding(.bottom, size == .small ? self.width*0.005 : self.width*0.01)
        }
        
        else if orientation == .landscape {
            
            let width = size == .large ? self.width*0.99 : self.width
            let height = min(buttonHeight, width*0.95/11)
            
            HStack(spacing:0) {
                
                LandscapePad(queue: queue, width: width*7/11, buttonHeight: height, size: size, theme: theme, active: active, showText: showText, onChange: onChange)
                    .overlay(contentOverlay(width: width*7/11, buttonHeight: height))
                
                VStack(spacing:0) {
                    NumPad(queue: queue, width: width*4/11, buttonHeight: height, theme: theme, active: active, showText: showText, onChange: onChange)
                        .overlay(SecondDetailOverlay(size: size, orientation: orientation, active: active))
                    ControlPad(queue: queue, width: width*4/11, buttonHeight: height, equivalentRowAmount: 4, active: active, showText: showText, onChange: onChange)
                }
            }
            .padding(.horizontal, size == .large ? self.width*0.005 : 0)
            .padding(.top, self.width*0.005)
            .padding(.bottom, size == .large ? self.width*0.005 : 0)
        }
    }
    
    private func contentOverlay(width: CGFloat, buttonHeight: CGFloat) -> some View {
        ZStack {
            ButtonOverlay(size: size, orientation: orientation, display: display, width: width, buttonHeight: buttonHeight, queue: queue, theme: theme, active: active, showText: showText)
            if showDetails {
                DetailOverlay(size: size, orientation: orientation, active: active)
            }
            if let overlay {
                overlay
            }
        }
    }
}

enum ButtonDisplayMode {
    case basic
    case funcs
    case vars
    case units
}
