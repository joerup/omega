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
                                .frame(maxHeight: min(max(size*0.3, min(size*0.5, 300)), 400))
                                .padding(5)
                                .frame(maxWidth: .infinity)
                                .background(Color.init(white: 0.15)
                                    .cornerRadius(20)
                                    .shadow(radius: 5)
                                    .edgesIgnoringSafeArea(.bottom)
                                )
                        }
                    }
                    .transition(.move(edge: .bottom))
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
            .offset(y: settings.keypad != nil && settings.popUp == nil ? -size*0.22 : 0)
        
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

