//
//  PortraitPadB.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/7/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct PortraitPadBTop: View {
    
    @ObservedObject var settings = Settings.settings
    
    var queue: Queue? = nil
    
    var width: CGFloat
    var buttonHeight: CGFloat
    
    var theme: Theme? = nil
    
    var active: Bool = true
    var onChange: (Queue) -> Void = { _ in }
    
    var body: some View {
        
        VStack(spacing:0) {
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 8), spacing: 0) {
                
                ForEach(Input.portraitPadBTop.buttons, id: \.id) { button in
                    ButtonView(button: button, input: queue, backgroundColor: color((theme ?? self.settings.theme).color3), width: width*0.95/8, height: buttonHeight, relativeSize: 0.35, active: active, onChange: onChange)
                        .padding(.vertical, buttonHeight*0.025)
                        .padding(.horizontal, width*0.025/8)
                }
            }
        }
        .frame(width: width)
        .border(Color.pink, width: self.settings.guidelines ? 1 : 0)
    }
}

struct PortraitPadBSide: View {
    
    @ObservedObject var settings = Settings.settings
    
    var queue: Queue? = nil
    
    var width: CGFloat
    var buttonHeight: CGFloat
    
    var theme: Theme? = nil
    
    var active: Bool = true
    var onChange: (Queue) -> Void = { _ in }
    
    var body: some View {
        
        if settings.buttonUppercase {
            
            VStack(spacing:0) {
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 4), spacing: 0) {
                    
                    ForEach(Input.portraitPadBSide[1].buttons, id: \.id) { button in
                        ButtonView(button: button, input: queue, backgroundColor: color((theme ?? self.settings.theme).color3), width: width*0.95/4, height: buttonHeight, relativeSize: 0.35, active: active, onChange: onChange)
                            .padding(.vertical, buttonHeight*0.025)
                            .padding(.horizontal, width*0.025/4)
                    }
                }
                .animation(nil)
            }
            .frame(width: width)
            .border(Color.pink, width: self.settings.guidelines ? 1 : 0)
        }
        else {
            
            VStack(spacing:0) {
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 4), spacing: 0) {
                    
                    ForEach(Input.portraitPadBSide[0].buttons, id: \.id) { button in
                        ButtonView(button: button, input: queue, backgroundColor: color((theme ?? self.settings.theme).color3), width: width*0.95/4, height: buttonHeight, relativeSize: 0.35, active: active, onChange: onChange)
                            .padding(.vertical, buttonHeight*0.025)
                            .padding(.horizontal, width*0.025/4)
                    }
                }
                .animation(nil)
            }
            .frame(width: width)
            .border(Color.pink, width: self.settings.guidelines ? 1 : 0)
        }
    }
}

    
