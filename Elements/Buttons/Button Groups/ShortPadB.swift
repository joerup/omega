//
//  ShortPadB.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/14/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct ShortPadB: View {
    
    @ObservedObject var settings = Settings.settings
    
    var queue: Queue? = nil
    
    var width: CGFloat
    var buttonHeight: CGFloat
    
    var theme: Theme? = nil
    
    var active: Bool = true
    var showText: Bool = true
    var onChange: (Queue) -> Void = { _ in }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack(spacing:0) {
                    
                ForEach(Input.shortNumRow.buttons, id: \.id) { button in
                    ButtonView(button: button, input: queue, backgroundColor: color((theme ?? self.settings.theme).color1), width: width*0.95/10, height: buttonHeight, relativeSize: 0.4, active: active, showText: showText, onChange: onChange)
                        .padding(.vertical, buttonHeight*0.025)
                        .padding(.horizontal, width*0.025/10)
                }
            }
            
            HStack(spacing:0) {
                
                ButtonView(button: InputButton("clear"), input: queue, backgroundColor: Color.init(white: 0.6), width: width*0.95/10, height: buttonHeight, relativeSize: 0.4, active: active, showText: showText, onChange: onChange)
                    .padding(.vertical, buttonHeight*0.025)
                    .padding(.horizontal, width*0.025/10)
            
                ButtonView(button: InputButton("backspace"), input: queue, backgroundColor: Color.init(white: 0.6), width: width*0.95/10, height: buttonHeight, relativeSize: 0.4, active: active, showText: showText, onChange: onChange)
                    .padding(.vertical, buttonHeight*0.025)
                    .padding(.horizontal, width*0.025/10)
                
                ScrollView(.horizontal) {
                    
                    HStack(spacing:0) {
                        
                        ForEach(Input.shortScroll.buttons.indices, id: \.self) { index in
                            
                            let button = Input.shortScroll.buttons[index]
                            
                            ButtonView(button: button, input: queue, backgroundColor: color((theme ?? self.settings.theme).color3), width: width*0.95/10, height: buttonHeight, relativeSize: 0.4, active: active, showText: showText, onChange: onChange)
                                .padding(.leading, index == 0 ? 0 : width*0.025/10)
                                .padding(.trailing, index == Input.shortScroll.buttons.count-1 ? 0 : width*0.025/10)
                        }
                    }
                }
                .frame(width: width*(6/10-2*0.025/10), height: buttonHeight, alignment: .center)
                .background(color((theme ?? self.settings.theme).color3).darker(by: 0.05))
                .cornerRadius((width*0.95/10+buttonHeight)/2 * 0.4)
                .padding(.horizontal, width*0.025/10)
                .padding(.vertical, buttonHeight*0.025)
                    
                ForEach(Input.shortFormatRow.buttons, id: \.id) { button in
                    ButtonView(button: button, input: queue, backgroundColor: color((theme ?? self.settings.theme).color1), width: width*0.95/10, height: buttonHeight, relativeSize: 0.4, active: active, showText: showText, onChange: onChange)
                        .padding(.vertical, buttonHeight*0.025)
                        .padding(.horizontal, width*0.025/10)
                }
            }
        }
        .frame(width: width)
        .border(Color.purple, width: self.settings.guidelines ? 1 : 0)
    }
}
