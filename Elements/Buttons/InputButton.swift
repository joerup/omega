//
//  InputButton.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

class InputButton: Equatable {
    
    var id = UUID()
    var button: InputButtonType
    
    var name: String {
        return button.name
    }
    
    var disabled: Bool {
        if !Settings.settings.pro, let button = button as? InputFunction {
            return [.sum, .prod, .deriv, .deriv2, .derivn, .integ].contains(button)
        }
        return false
    }
    
    init(_ string: String) {
        if let button = InputControl(rawValue: string) {
            self.button = button
        }
        else if let button = InputNumber(rawValue: string) {
            self.button = button
        }
        else if let button = InputNumberFormat(rawValue: string) {
            self.button = button
        }
        else if let button = InputLetter(rawValue: string) {
            self.button = button
        }
        else if let button = InputUnit(rawValue: string) {
            self.button = button
        }
        else if let button = InputOperationA(rawValue: string) {
            self.button = button
        }
        else if let button = InputOperationB(rawValue: string) {
            self.button = button
        }
        else if let button = InputOperationC(rawValue: string) {
            self.button = button
        }
        else if let button = InputFunction(rawValue: string) {
            self.button = button
        }
        else if let button = InputModifier(rawValue: string) {
            self.button = button
        }
        else if let button = InputGrouping(rawValue: string) {
            self.button = button
        }
        else {
            self.button = InputControl.nothing
        }
    }
    
    convenience init(_ char: Character) {
        self.init(String(char))
    }
    
    static func == (lhs: InputButton, rhs: InputButton) -> Bool {
        return lhs.name == rhs.name
    }
    
    func playSound(hold: Bool = false) {
        if self.name == "enter" {
            SoundManager.play(sound: .click3, haptic: .heavy)
        }
        else if self.name == "backspace" {
            SoundManager.play(sound: .click2, haptic: .medium)
        }
        else if self.name == "clear" {
            SoundManager.play(sound: .click3, haptic: .heavy)
        }
        else if hold {
            SoundManager.play(sound: .click1, haptic: .medium)
        }
        else {
            SoundManager.play(sound: .click1, haptic: .light)
        }
    }
}

class Input {
    
    var id = UUID()
    var buttons: [InputButton] = []
    
    init(_ strings: [String]) {
        buttons = strings.map{ InputButton($0) }
    }

    static var numPad = Input([
        "7", "8", "9",
        "4", "5", "6",
        "1", "2", "3",
        "0", ".", "+/-"
    ])
    static var opPad = Input([
        "÷",
        "×",
        "-",
        "+"
    ])
    
    static var landscapePad = [
        Input([
            "(", ")", "%", "*", "/", "*/", "abs",
            "∑", "!", "^2", "^3", "^", "^-1", "EXP",
            "∏", "rand", "√", "3√", "n√", "π", "e",
            "dx", "nPr", "sin", "cos", "tan", "10^", "e^",
            "∫", "nCr", "sin⁻¹", "cos⁻¹", "tan⁻¹", "log", "ln"
        ]),
        Input([
            "(", ")", "%", "*", "/", "*/", "abs",
            "∑", "!", "^2", "^3", "^", "^-1", "EXP",
            "∏", "rand", "√", "3√", "n√", "π", "e",
            "dx", "nPr", "sinh", "cosh", "tanh", "2^", "n^",
            "∫", "nCr", "sinh⁻¹", "cosh⁻¹", "tanh⁻¹", "log2", "logn"
        ])
    ]

    static var scrollRow = Input([
        "(", ")", "%", "^2", "√", "/", "*/", "EXP", "^", "π", "e", "sin", "cos", "tan", "log", "ln"
    ])

    static var portraitPadTop = Input([
        "(", ")", "^2", "^3", "^", "π", "%", "/",
        "abs", "EXP", "√", "3√", "n√", "e", "^-1", "*/",
    ])
    static var portraitPadSide = [
        Input([
            "!", "sin", "cos", "tan",
            "rand", "sin⁻¹", "cos⁻¹", "tan⁻¹",
            "∑", "dx", "log", "ln",
            "∏", "∫", "10^", "e^"
        ]),
        Input([
            "nPr", "sinh", "cosh", "tanh",
            "nCr", "sinh⁻¹", "cosh⁻¹", "tanh⁻¹",
            "∑", "dx", "log2", "logn",
            "∏", "∫", "2^", "n^"
        ])
    ]
    
    static var shortNumRow = Input([
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
    ])
    static var shortScroll = Input([
        "/", "^", "√",
        "π", "e", "3√",
        "log", "ln", "EXP"
    ])
    static var shortFormatRow = Input([
        "+/-", "."
    ])
    
    static var alphaLower = Input([
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
    ])
    static var alphaUpper = Input([
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
    ])
    static var greekLower = Input([
        "α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ", "λ", "μ", "ν", "ξ", "ο", "π", "ρ", "σ", "τ", "υ", "φ", "χ", "ψ", "ω"
    ])
    static var greekUpper = Input([
        "Α", "Β", "Γ", "Δ", "Ε", "Ζ", "Η", "Θ", "Ι", "Κ", "Λ", "Μ", "Ν", "Ξ", "Ο", "Π", "Ρ", "Σ", "Τ", "Υ", "Φ", "Χ", "Ψ", "Ω"
    ])
    
    static var units = Input(InputUnit.allCases.map { $0.name })
    
    static var funcPad = [
        Input([
            "(", ")", "%", "/", "*/",
            "^2", "^3", "^", "^-1", "EXP",
            "√", "3√", "n√", "π", "e",
            "sin", "cos", "tan", "10^", "e^",
            "sin⁻¹", "cos⁻¹", "tan⁻¹", "log", "ln",
            "∑", "dx", "!", "rand", "abs"
        ]),
        Input([
            "(", ")", "%", "/", "*/",
            "^2", "^3", "^", "^-1", "EXP",
            "√", "3√", "n√", "π", "e",
            "sinh", "cosh", "tanh", "2^", "n^",
            "sinh⁻¹", "cosh⁻¹", "tanh⁻¹", "log2", "logn",
            "∏", "∫", "nPr", "nCr", "abs"
        ])
    ]
}

