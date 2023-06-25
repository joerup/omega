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
    var showText: Bool = true
    var onChange: (Queue) -> Void = { _ in }
    
    var customAction: (() -> Void)? = nil
    var extraAction: (() -> Void)? = nil
    
    @State private var isPressed = false
    
    var body: some View {
        
        if active {
            ZStack {
                Button(action: { }) {
                    ButtonText(button: button, fontSize: fontSize)
                        .foregroundColor(.white)
                        .shadow(color: Color.init(white: 0.1), radius: fontSize/2.5)
                        .frame(width: width, height: height, alignment: .center)
                        .background(backgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: 0.42*height, style: .continuous))
                        .onTapGesture {
                            pressButton(pressType: .tap)
                        }
                        .onLongPressGesture {
                            pressButton(pressType: .hold)
                        }
                }
                .scaleEffect(isPressed ? 0.8 : 1.0)
            }
        }
        else if showText {
            ButtonText(button: button, fontSize: fontSize)
                .foregroundColor(.white)
                .shadow(color: Color.init(white: 0.1), radius: fontSize/2.5)
                .frame(width: width, height: height, alignment: .center)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 0.42*height, style: .continuous))
        }
        else {
            Text("")
                .foregroundColor(.white)
                .shadow(color: Color.init(white: 0.1), radius: fontSize/2.5)
                .frame(width: width, height: height, alignment: .center)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 0.42*height, style: .continuous))
        }
    }
    
    // Button Press
    private func pressButton(pressType: PressType) {
        
        // Effects
        
        withAnimation(.easeOut(duration: 0.05)) {
            self.isPressed = true
        }
        withAnimation(.easeIn(duration: 0.1).delay(0.05)) {
            self.isPressed = false
        }
        
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
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
    }
}
