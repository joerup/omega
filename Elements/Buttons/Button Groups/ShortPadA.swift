//
//  ShortPadA.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/14/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct ShortPadA: View {
    
    @ObservedObject var settings = Settings.settings
    
    var queue: Queue? = nil
    
    var width: CGFloat
    var buttonHeight: CGFloat
    
    var theme: Theme? = nil
    
    var active: Bool = true
    var showText: Bool = true
    var onChange: (Queue) -> Void = { _ in }
    
    @State private var more: Bool = false
    
    var body: some View {
        
        ScrollView {
        
            HStack(spacing:0) {
                
                VStack(spacing: 0) {
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0) {
                        ForEach(Input.shortScroll.buttons, id: \.id) { button in
                            ButtonView(button: button, input: queue, backgroundColor: color((theme ?? self.settings.theme).color3), width: width*0.95/6, height: buttonHeight, relativeSize: 0.4, active: active, showText: showText, onChange: onChange)
                                .padding(.vertical, buttonHeight*0.025)
                                .padding(.horizontal, width*0.025/6)
                        }
                    }
                    .frame(height: buttonHeight*1.05*3)
                    .padding(.vertical, buttonHeight*0.025)
                    
                    HStack(spacing: 0) {
                        
                        ButtonView(button: InputButton("clear"), input: queue, backgroundColor: Color.init(white: 0.2), width: width*0.95/4, height: buttonHeight, relativeSize: 0.4, active: active, showText: showText, onChange: onChange)
                            .padding(.vertical, buttonHeight*0.025)
                            .padding(.horizontal, width*0.025/4)
                        
                        ButtonView(button: InputButton("backspace"), input: queue, backgroundColor: Color.init(white: 0.2), width: width*0.95/4, height: buttonHeight, relativeSize: 0.4, active: active, showText: showText, onChange: onChange)
                            .padding(.vertical, buttonHeight*0.025)
                            .padding(.horizontal, width*0.025/4)
                    }
                }
                .frame(width: width/2)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0) {
                    
                    ForEach(Input.numPad.buttons, id: \.id) { button in
                        ButtonView(button: button, input: queue, backgroundColor: color((theme ?? self.settings.theme).color1), width: width*0.95/6, height: buttonHeight, relativeSize: 0.4, active: active, showText: showText, onChange: onChange)
                            .padding(.vertical, buttonHeight*0.025)
                            .padding(.horizontal, width*0.025/6)
                    }
                }
                .frame(width: width/2)
            }
        }
        .frame(width: width, height: (buttonHeight*1.1)*4)
        .border(Color.blue, width: self.settings.guidelines ? 1 : 0)
    }
}
