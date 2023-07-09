//
//  ContentOverlay.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/10/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct ContentOverlay: ViewModifier {
    
    @ObservedObject var settings = Settings.settings
    
    let size = UIScreen.main.bounds.height
    
    func body(content: Content) -> some View {
        
        content
            .overlay(ZStack {
                
                PopUpView()
                
                if let keypad = settings.keypad {
                    
                    ZStack {
                        
                        Rectangle()
                            .opacity(1e-10)
                            .frame(maxWidth: .infinity)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    keypad.onDismiss(keypad.queue)
                                    settings.keypad = nil
                                    SoundManager.play(haptic: .light)
                                }
                            }
                        
                        VStack(spacing: 0) {
                            Spacer()
                            keypad
                                .frame(height: size*0.3)
                                .padding(.vertical, 5)
                                .background(Color.init(white: 0.2)
                                    .cornerRadius(20)
                                    .edgesIgnoringSafeArea(.bottom)
                                )
                        }
                    }
                }
            })
    }
}

struct KeypadShift: ViewModifier {
    
    @ObservedObject var settings = Settings.settings
    
    let size = UIScreen.main.bounds.height
    
    func body(content: Content) -> some View {
        
        content
            .animation(.default, value: settings.keypad != nil)
            .offset(y: settings.keypad != nil && settings.popUp == nil ? -size*0.3 : 0)
        
    }
}

extension View {
    func contentOverlay() -> some View {
        modifier(ContentOverlay())
    }
}

extension View {
    func keypadShift() -> some View {
        modifier(KeypadShift())
    }
}

