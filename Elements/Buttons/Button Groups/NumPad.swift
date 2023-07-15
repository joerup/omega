//
//  NumberPadView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/7/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct NumPad: View {
    
    @ObservedObject var settings = Settings.settings
    
    var queue: Queue? = nil
    
    var width: CGFloat
    var buttonHeight: CGFloat
    
    var theme: Theme? = nil
    
    var active: Bool = true
    var showText: Bool = true
    var onChange: (Queue) -> Void = { _ in }
    
    var body: some View {
        
        HStack(spacing:0) {
             
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0) {
                
                ForEach(Input.numPad.buttons, id: \.id) { button in
                    ButtonView(button: button, input: queue, backgroundColor: color((theme ?? self.settings.theme).color1), width: width*0.95/4, height: buttonHeight, relativeSize: 0.5, active: active, showText: showText, onChange: onChange)
                        .padding(.vertical, buttonHeight*0.025)
                        .padding(.horizontal, width*0.025/4)
                }
            }
            .frame(width: width*3/4)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 1), spacing: 0) {
                
                ForEach(Input.opPad.buttons, id: \.id) { button in
                    ButtonView(button: button, input: queue, backgroundColor: color((theme ?? self.settings.theme).color2), width: width*0.95/4, height: buttonHeight, relativeSize: 0.5, active: active, showText: showText, onChange: onChange)
                        .padding(.vertical, buttonHeight*0.025)
                        .padding(.horizontal, width*0.025/4)
                }
            }
            .frame(width: width/4)
        }
        .frame(width: width)
        .border(Color.blue, width: self.settings.guidelines ? 1 : 0)
    }
}
