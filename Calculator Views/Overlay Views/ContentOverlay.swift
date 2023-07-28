//
//  ContentOverlay.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/10/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct ContentOverlay: ViewModifier {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ObservedObject var settings = Settings.settings
    
    var size: Size
    var orientation: Orientation
    var width: CGFloat
    var buttonHeight: CGFloat
    
    func body(content: Content) -> some View {
        
        content
            .overlay {
                ZStack {
                    PopUpView()
                    
                    if let queue = settings.keypadInput {
                        Rectangle()
                            .opacity(1e-10)
                            .frame(maxWidth: .infinity)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture(perform: closeKeypad)
                        VStack {
                            Spacer()
                            let buttonHeight = verticalSizeClass == .regular ? (horizontalSizeClass == .regular ? max(buttonHeight*0.5, 55) : buttonHeight*0.5) : buttonHeight*0.75
                            Keypad(queue: queue, size: size, orientation: orientation, width: width, buttonHeight: buttonHeight) { queue in
                                settings.keypadInput = queue
                                settings.keypadUpdate.toggle()
                            } onDismiss: {
                                closeKeypad()
                            }
                            .padding([.horizontal, .top], 5)
                            .frame(width: width)
                            .background(Color.clear.overlay(.thinMaterial).cornerRadius(20).edgesIgnoringSafeArea(.all).shadow(radius: 10))
                        }
                    }
                }
                .transition(.move(edge: .bottom))
            }
    }
    
    private func closeKeypad() {
        withAnimation {
            settings.keypadInput = nil
            settings.keypadUpdate.toggle()
            SoundManager.play(haptic: .light)
        }
    }
}

struct KeypadShift: ViewModifier {
    
    @ObservedObject var settings = Settings.settings
    
    let size = UIScreen.main.bounds.height
    
    func body(content: Content) -> some View {
        content
            .animation(.default, value: settings.keypadInput != nil)
            .offset(y: settings.keypadInput != nil && settings.popUp == nil ? -size*0.2 : 0)
    }
}

extension View {
    func contentOverlay(size: Size, orientation: Orientation, width: CGFloat, buttonHeight: CGFloat) -> some View {
        modifier(ContentOverlay(size: size, orientation: orientation, width: width, buttonHeight: buttonHeight))
    }
}

extension View {
    func keypadShift() -> some View {
        modifier(KeypadShift())
    }
}

