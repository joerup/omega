//
//  KeyboardManager.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/26/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import Combine
import UIKit
import SwiftUI

struct KeyboardCommands: Commands {
    
    static let numberKeys: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    static let letterKeys: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    static let operationKeys: [Character] = ["-","/","."]
    static let operationShiftKeys: [Character] = ["1","5","6","8","9","0","-","=","/"]
    
    private let keyInputSubject = KeyInputSubjectWrapper()
    
    @CommandsBuilder var body: some Commands {
        CommandMenu("Keyboard") {
            ForEach(KeyboardCommands.numberKeys, id: \.self) { char in
                keyInput(KeyEquivalent(char))
            }
            ForEach(KeyboardCommands.letterKeys, id: \.self) { char in
                keyInput(KeyEquivalent(char))
                keyInput(KeyEquivalent(char), modifiers: .shift)
            }
            ForEach(KeyboardCommands.operationKeys, id: \.self) { char in
                keyInput(KeyEquivalent(char))
            }
            ForEach(KeyboardCommands.operationShiftKeys, id: \.self) { char in
                keyInput(KeyEquivalent(char), modifiers: .shift)
            }
            keyInput(.space)
            keyInput(.return)
            keyInput(.delete)
        }
    }
    
    func keyInput(_ key: KeyEquivalent, modifiers: EventModifiers = .none) -> some View {
        keyboardShortcut(key, sender: keyInputSubject, modifiers: modifiers)
    }
}

extension KeyEquivalent {
    
    func pressButton(with modifiers: EventModifiers) {
        
        // Must be pro
        guard Settings.settings.pro else { return }
        
        // Set up input
        Calculation.current.setUpInput()
        
        // Get the button
        var button: InputButton? {
            
            if self == .return {
                return InputButton("enter")
            }
            else if self == .delete {
                return InputButton("backspace")
            }
            else if self == .space {
                return InputButton("clear")
            }
            else if self == .leftArrow {
                return InputButton("backward")
            }
            else if self == .rightArrow {
                return InputButton("forward")
            }
            else if modifiers.contains(.shift), KeyboardCommands.operationShiftKeys.contains(self.character) {
                return InputButton(self.switchShift)
            }
            else if KeyboardCommands.operationKeys.contains(self.character) {
                return InputButton(self.character)
            }
            else if KeyboardCommands.numberKeys.contains(self.character) {
                return InputButton(self.character)
            }
            else if modifiers.contains(.shift), KeyboardCommands.letterKeys.contains(self.character) {
                return InputButton(self.character.uppercased())
            }
            else if KeyboardCommands.letterKeys.contains(self.character) {
                return InputButton(self.character)
            }
            return nil
        }
        
        if let button = button {
            
            guard !button.disabled || proCheckNotice() else { return }
            
            // Play the sound
            button.playSound()
            
            if let button = button.button as? InputControl {
                
                // Set up input
                Calculation.current.setUpInput(new: false)
                
                // Perform the control action
                switch button {
                case .clear:
                    Calculation.current.clear()
                case .backspace:
                    Calculation.current.backspace()
                case .enter:
                    Calculation.current.enter()
                case .forward:
                    Calculation.current.queue.forward()
                case .backward:
                    Calculation.current.queue.backward()
                case .nothing:
                    print("hi")
                }
                
            } else {
                
                // Set up input
                Calculation.current.setUpInput()
                
                // Queue the button
                Calculation.current.queue.button(button, pressType: .tap)
            }
        }
        
        // Refresh the calculation
        Calculation.current.update.toggle()
    }
    
    var switchShift: String {
        switch self.character {
        case "1": return "!"
        case "5": return "%"
        case "6": return "^"
        case "8": return "×"
        case "9": return "("
        case "0": return ")"
        case "-": return "+/-"
        case "=": return "+"
        case "/": return "÷"
        default: return "0"
        }
    }
    
    var lowerCaseName: String? {
        switch self {
        case .space: return "space"
        case .clear: return "clear"
        case .delete: return "delete"
        case .deleteForward: return "delete forward"
        case .downArrow: return "down arrow"
        case .end: return "end"
        case .escape: return "escape"
        case .home: return "home"
        case .leftArrow: return "left arrow"
        case .pageDown: return "page down"
        case .pageUp: return "page up"
        case .return: return "return"
        case .rightArrow: return "right arrow"
        case .space: return "space"
        case .tab: return "tab"
        case .upArrow: return "up arrow"
        default: return String(self.character).lowercased()
        }
    }
    
    var name: String? {
        lowerCaseName
    }
}

extension KeyEquivalent: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.character == rhs.character
    }
}

public typealias KeyInputSubject = PassthroughSubject<KeyEquivalent, Never>

public final class KeyInputSubjectWrapper: ObservableObject, Subject {
    public func send(_ value: Output) {
        objectWillChange.send(value)
    }
    
    public func send(completion: Subscribers.Completion<Failure>) {
        objectWillChange.send(completion: completion)
    }
    
    public func send(subscription: Subscription) {
        objectWillChange.send(subscription: subscription)
    }
    

    public typealias ObjectWillChangePublisher = KeyInputSubject
    public let objectWillChange: ObjectWillChangePublisher
    public init(subject: ObjectWillChangePublisher = .init()) {
        objectWillChange = subject
    }
}

// MARK: Publisher Conformance
public extension KeyInputSubjectWrapper {
    typealias Output = KeyInputSubject.Output
    typealias Failure = KeyInputSubject.Failure
    
    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output {
        objectWillChange.receive(subscriber: subscriber)
    }
}

public func keyboardShortcut<Sender, Label>(
    _ key: KeyEquivalent,
    sender: Sender,
    modifiers: EventModifiers = .none,
    @ViewBuilder label: () -> Label
) -> some View where Label: View, Sender: Subject, Sender.Output == KeyEquivalent {
    
    Button(action: {
        print("Key pressed: \(key)")
        key.pressButton(with: modifiers)
    }, label: label)
        .keyboardShortcut(key, modifiers: modifiers)
}


public func keyboardShortcut<Sender>(
    _ key: KeyEquivalent,
    sender: Sender,
    modifiers: EventModifiers = .none
) -> some View where Sender: Subject, Sender.Output == KeyEquivalent {
    
    guard let nameFromKey = key.name else {
        return AnyView(EmptyView())
    }
    return AnyView(keyboardShortcut(key, sender: sender, modifiers: modifiers) {
        Text("\(nameFromKey)")
    })
}


public extension EventModifiers {
    static let none = Self()
}

extension KeyEquivalent: CustomStringConvertible {
    public var description: String {
        name ?? "\(character)"
    }
}
