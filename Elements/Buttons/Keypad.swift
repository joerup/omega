//
//  Keypad.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/4/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct Keypad: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Environment(\.presentationMode) var presentationMode
    
    var queue: Queue
    
    var size: Size
    var orientation: Orientation
    var width: CGFloat
    var buttonHeight: CGFloat
    
    var theme: Theme? = nil
    
    var onChange: (Queue) -> Void
    var onDismiss: () -> Void
    
    init(queue: Queue, size: Size, orientation: Orientation, width: CGFloat, buttonHeight: CGFloat, onChange: @escaping (Queue) -> Void = { _ in }, onDismiss: @escaping () -> Void = { }) {
        self.queue = queue
        self.size = size
        self.orientation = orientation
        self.width = width
        self.buttonHeight = buttonHeight
        self.onChange = onChange
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        
        let width = min(self.width*0.98, 8*buttonHeight*1.2)
        let height = min(buttonHeight, width*0.95/4)
        
        VStack(spacing: 0) {
            
            HStack(spacing: 0) {
                Spacer()
                Group {
                    SmallIconButton(symbol: "doc.on.clipboard.fill", color: Color.init(white: 0.25), textColor: Color.init(white: 0.7), smallerSmall: orientation == .landscape, sound: .click2, locked: true) {
                        queue.paste()
                        onChange(queue)
                    }
                    SmallIconButton(symbol: "chevron.backward", color: Color.init(white: 0.25), textColor: Color.init(white: 0.7), smallerSmall: orientation == .landscape, sound: .click2, locked: true) {
                        queue.backward()
                        onChange(queue)
                    }
                    SmallIconButton(symbol: "chevron.forward", color: Color.init(white: 0.25), textColor: Color.init(white: 0.7), smallerSmall: orientation == .landscape, sound: .click1, locked: false) {
                        queue.forward()
                        onChange(queue)
                    }
                }
                .scaleEffect(0.8)
            }
            .frame(width: width)
            
            HStack(spacing: 0) {
                
                Spacer(minLength: 0)
                
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(width/2/4), spacing: 0), count: 4), spacing: 0) {
                    ForEach(Input.keypadFunctions.buttons, id: \.id) { button in
                        ButtonView(button: button, input: queue, backgroundColor: (theme ?? settings.theme).color3, width: width/2*0.95/4, height: buttonHeight, relativeSize: 0.32, onChange: onChange)
                            .padding(.vertical, buttonHeight*0.025)
                            .padding(.horizontal, width/2*0.025/4)
                    }
                }
                .frame(width: width/2)
                
                VStack(spacing:0) {
                    NumPad(queue: queue, width: width/2, buttonHeight: height, theme: theme, onChange: onChange)
                    ControlPad(queue: queue, width: width/2, buttonHeight: height, equivalentRowAmount: 4, color: 0.2, onChange: onChange, onEnter: onDismiss)
                }
                .frame(width: width/2)
                
                Spacer(minLength: 0)
            }
            .padding(self.width*0.005)
        }
    }
}

