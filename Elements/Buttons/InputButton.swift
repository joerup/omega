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
            "(", ")", "%", "*", "/", "*/",
            "abs", "^2", "^3", "^", "^-1", "EXP",
            "!", "√", "3√", "n√", "π", "e",
            "rand", "sin", "cos", "tan", "10^", "e^",
            "randint", "sin⁻¹", "cos⁻¹", "tan⁻¹", "log", "ln"
        ]),
        Input([
            "(", ")", "%", "*", "/", "*/",
            "abs", "^2", "^3", "^", "^-1", "EXP",
            "!", "√", "3√", "n√", "π", "e",
            "rand", "sinh", "cosh", "tanh", "2^", "n^",
            "randint", "sinh⁻¹", "cosh⁻¹", "tanh⁻¹", "log2", "logn"
        ])
    ]

    static var scrollRow = Input([
        "(", ")", "^2", "√", "%", "EXP", "^", "/", "*", "π", "e", "sin", "cos", "tan", "log", "ln"
    ])

    static var portraitPadATop = Input([
        "(", ")", "^2", "√", "/",
        "sin", "EXP", "^", "n√", "%"
    ])
    static var portraitPadASide = Input([
        "cos",
        "tan",
        "log",
        "ln"
    ])

    static var portraitPadBTop = Input([
        "(", ")", "%", "/", "^2", "√", "e",
        "abs", "^-1", "EXP", "*", "^", "n√", "π"
    ])
    static var portraitPadBSide = Input([
        "sin", "cos", "tan",
        "sin⁻¹", "cos⁻¹", "tan⁻¹",
        "10^", "e^", "!",
        "log", "ln", "rand"
    ])
    
    static var shortNumRow = Input([
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
    ])
    static var shortScroll = Input([
        "π", "e", "/",
        "^", "√", "EXP",
        "%", "log", "ln",
        "sin", "cos", "tan",
        "+", "-", "×",
        "÷", "(", ")"
    ])
    static var shortFormatRow = Input([
        "+/-", "."
    ])
    
    static var alphaLower = Input([
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
    ])
    static var alphaUpper = Input([
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    ])
    static var alphaGreek = Input([
        "α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ", "λ", "μ", "ν", "ξ", "ο", "π", "ρ", "σ", "τ", "υ", "φ", "χ", "ψ", "ω"
    ])
    
    static var units = Input(InputUnit.allCases.map { $0.name })
    
    static var mathAlg = Input([
        "*", "/", "*/", "^2", "^3", "^",
        "%", "π", "e", "√", "3√", "n√",
        "^-1", "EXP", "10^", "e^", "2^", "n^",
        "!", "rand", "log", "ln", "log2", "logn",
    ])
    static var mathTrig = Input([
        "sin", "cos", "tan", "sin⁻¹", "cos⁻¹", "tan⁻¹",
        "sinh", "cosh", "tanh", "sinh⁻¹", "cosh⁻¹", "tanh⁻¹",
        "csc", "sec", "cot", "csc⁻¹", "sec⁻¹", "cot⁻¹",
        "csch", "sech", "coth", "csch⁻¹", "sech⁻¹", "coth⁻¹",
    ])
    static var mathCalc = Input([
        "dx", "∫", "∑", "∏"
    ])
    static var mathMisc = Input([
        "‰", "abs", "!", "vinc",
        "rand", "randint", "nPr", "nCr",
        "round", "floor", "ceil", "mod"
    ])
}

