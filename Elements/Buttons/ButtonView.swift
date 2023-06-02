//
//  ButtonView.swift
//  Calculator
//
//  Created by Joe Rupertus on 4/14/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

// ButtonView manages the view for each button in the calculator

import Foundation
import SwiftUI
import Combine

struct ButtonView: View {
    
    @ObservedObject var settings = Settings.settings
    
    var button: InputButton
    
    var input: Queue?
    var calculation: Calculation {
        return input == nil ? Calculation.current : Calculation(input!)
    }
    var queue: Queue {
        return input ?? Calculation.current.queue
    }
    
    var backgroundColor: Color
    var width: CGFloat
    var height: CGFloat
    var relativeSize: CGFloat
    var fontSize: CGFloat {
        return relativeSize * (width+2*height)/3
    }
    
    var active: Bool = true
    var onChange: (Queue) -> Void = { _ in }
    
    var customAction: (() -> Void)? = nil
    var extraAction: (() -> Void)? = nil
    
    var body: some View {
    
        if active {
            ZStack {
                
                Button(action: {
                    self.pressButton(pressType: .tap)
                }) {
                    ButtonText(button: button, fontSize: fontSize)
                        .shadow(color: Color.init(white: 0.1), radius: fontSize/2.5)
                        .frame(width: width, height: height, alignment: .center)
                        .background(backgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: 0.42*height, style: .continuous))
                        .onTapGesture { self.pressButton(pressType: .tap) }
                        .onLongPressGesture { self.pressButton(pressType: .hold) }
                }
                .buttonStyle(CalculatorButtonStyle())
            }
        } else {
            ButtonText(button: button, fontSize: fontSize)
                .buttonStyle(CalculatorButtonStyle())
                .shadow(color: Color.init(white: 0.1), radius: fontSize/2.5)
                .frame(width: width, height: height, alignment: .center)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 0.42*height, style: .continuous))
        }
    }
    
    // Button Press
    func pressButton(pressType: PressType) {
        
        // Sound & Haptics
        
        button.playSound(hold: pressType == .hold)
        
        // Disabled
        
        guard !button.disabled || proCheckNotice() else { return }
        
        // Other Actions
        
        if let action = customAction {
            action()
            return
        }
        if let action = extraAction {
            action()
        }
        
        // Main Actions
        
        if let button = button.button as? InputControl {
            
            // Set up input
            calculation.setUpInput(new: false)
            
            // Perform the control action
            switch button {
            case .clear:
                calculation.clear()
            case .backspace:
                calculation.backspace(undo: pressType == .hold)
            case .enter:
                calculation.enter()
            case .forward:
                calculation.queue.forward()
            case .backward:
                calculation.queue.backward()
            case .nothing:
                print("hi")
            }
            
        } else {
            
            // Set up input
            calculation.setUpInput()
            
            // Queue the button
            queue.button(button, pressType: pressType)
        }
        
        // Change the calculation
        onChange(queue)
    }
}

enum PressType {
    case tap
    case hold
}

struct CalculatorButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.7 : 1.0)
    }
}
