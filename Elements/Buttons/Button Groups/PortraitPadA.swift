//
//  PortraitPadA.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/7/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct PortraitPadATop: View {
    
    @ObservedObject var settings = Settings.settings
    
    var queue: Queue? = nil
    
    var width: CGFloat
    var buttonHeight: CGFloat
    
    var theme: Theme? = nil
    
    var active: Bool = true
    var onChange: (Queue) -> Void = { _ in }
    
    var body: some View {
        
        VStack(spacing:0) {
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 5), spacing: 0) {
                
                ForEach(Input.portraitPadATop.buttons, id: \.id) { button in
                    ButtonView(button: button, input: queue, backgroundColor: color((theme ?? self.settings.theme).color3), width: width*0.95/5, height: buttonHeight, relativeSize: 0.35, active: active, onChange: onChange)
                        .padding(.vertical, buttonHeight*0.025)
                        .padding(.horizontal, width*0.025/5)
                }
            }
        }
        .frame(width: width)
        .border(Color.pink, width: self.settings.guidelines ? 1 : 0)
    }
}

struct PortraitPadASide: View {
    
    @ObservedObject var settings = Settings.settings
    
    var queue: Queue? = nil
    
    var width: CGFloat
    var buttonHeight: CGFloat
    
    var theme: Theme? = nil
    
    var active: Bool = true
    var onChange: (Queue) -> Void = { _ in }
    
    var body: some View {

        VStack(spacing:0) {

            ForEach(Input.portraitPadASide.buttons, id: \.id) { button in
                ButtonView(button: button, input: queue, backgroundColor: color((theme ?? self.settings.theme).color3), width: width*0.95, height: buttonHeight, relativeSize: 0.35, active: active, onChange: onChange)
                    .padding(.vertical, buttonHeight*0.025)
                    .padding(.horizontal, width*0.025)
            }
        }
        .frame(width: width)
        .border(Color.pink, width: self.settings.guidelines ? 1 : 0)
    }
}
