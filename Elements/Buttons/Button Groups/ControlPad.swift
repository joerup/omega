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
    var equivalentRowAmount: Int
    
    var color: Double? = nil
    var active: Bool = true
    var showText: Bool = true
    var onChange: (Queue) -> Void = { _ in }
    var onEnter: (() -> Void)? = nil
    
    var body: some View {
        
        HStack(spacing:0) {
            
            let color = Color.init(white: color ?? 0.12)
            let occupiedFraction: CGFloat = 1 - 0.05*3/CGFloat(equivalentRowAmount)
            let relativeSize = equivalentRowAmount > 4 ? 0.3 : 0.4
            
            ButtonView(button: InputButton("clear"), input: queue, backgroundColor: color, width: width*occupiedFraction/3, height: buttonHeight, relativeSize: relativeSize, active: active, showText: showText, onChange: onChange)
                .padding(.horizontal, width*0.025/CGFloat(equivalentRowAmount))
                .keyboardShortcut("c")
            
            ButtonView(button: InputButton("backspace"), input: queue, backgroundColor: color, width: width*occupiedFraction/3, height: buttonHeight, relativeSize: relativeSize, active: active, showText: showText, onChange: onChange)
                .padding(.horizontal, width*0.025/CGFloat(equivalentRowAmount))
            
            ButtonView(button: InputButton("enter"), input: queue, backgroundColor: color, width: width*occupiedFraction/3, height: buttonHeight, relativeSize: relativeSize, active: active, showText: showText, onChange: onChange, customAction: onEnter)
                .padding(.horizontal, width*0.025/CGFloat(equivalentRowAmount))
            
        }
        .frame(width: width)
        .padding(.vertical, buttonHeight*0.025)
        .border(Color.red, width: self.settings.guidelines ? 1 : 0)
    }
}

