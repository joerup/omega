//
//  ControlPad.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/7/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct ControlPad: View {
    
    @ObservedObject var settings = Settings.settings
    
    var queue: Queue? = nil
    
    var width: CGFloat
    var buttonHeight: CGFloat
    
    var active: Bool = true
    var showText: Bool = true
    var onChange: (Queue) -> Void = { _ in }
    
    var body: some View {
        
        HStack(spacing:0) {
            
            let color = Color.init(white: 0.15)
            
            ButtonView(button: InputButton("clear"), input: queue, backgroundColor: color, width: width*0.95/3, height: buttonHeight, relativeSize: 0.4, active: active, showText: showText, onChange: onChange)
                .padding(.horizontal, width*0.025/3)
                .keyboardShortcut("c")
            
            ButtonView(button: InputButton("backspace"), input: queue, backgroundColor: color, width: width*0.95/3, height: buttonHeight, relativeSize: 0.4, active: active, showText: showText, onChange: onChange)
                .padding(.horizontal, width*0.025/3)
            
            ButtonView(button: InputButton("enter"), input: queue, backgroundColor: color, width: width*0.95/3, height: buttonHeight, relativeSize: 0.4, active: active, showText: showText, onChange: onChange)
                .padding(.horizontal, width*0.025/3)
            
        }
        .frame(width: width)
        .padding(.vertical, buttonHeight*0.025)
        .border(Color.red, width: self.settings.guidelines ? 1 : 0)
    }
}

