//
//  InputButtonType.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 11/19/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation

protocol InputButtonType {
    var name: String { get }
}

enum InputControl: String, InputButtonType {
    
    case enter = "enter"
    case backspace = "backspace"
    case clear = "clear"
    case forward = "forward"
    case backward = "backward"
    case nothing = "nothing"
    
    var name: String {
        return rawValue
    }
}

enum InputNumber: String, InputButtonType {
    
    case n0 = "0"
    case n1 = "1"
    case n2 = "2"
    case n3 = "3"
    case n4 = "4"
    case n5 = "5"
    case n6 = "6"
    case n7 = "7"
    case n8 = "8"
    case n9 = "9"
    
    var name: String {
        return rawValue
    }
}

enum InputNumberFormat: String, InputButtonType {
    
    case dec = "."
    case sign = "+/-"
    case vinc = "vinc"
    
    var name: String {
        return rawValue
    }
}

enum InputLetter: String, InputButtonType {
    
    case inf = "∞"
    
    case a = "a"
    case b = "b"
    case c = "c"
    case d = "d"
    case e = "e"
    case f = "f"
    case g = "g"
    case h = "h"
    case i = "i"
    case j = "j"
    case k = "k"
    case l = "l"
    case m = "m"
    case n = "n"
    case o = "o"
    case p = "p"
    case q = "q"
    case r = "r"
    case s = "s"
    case t = "t"
    case u = "u"
    case v = "v"
    case w = "w"
    case x = "x"
    case y = "y"
    case z = "z"
    
    case A = "A"
    case B = "B"
    case C = "C"
    case D = "D"
    case E = "E"
    case F = "F"
    case G = "G"
    case H = "H"
    case I = "I"
    case J = "J"
    case K = "K"
    case L = "L"
    case M = "M"
    case N = "N"
    case O = "O"
    case P = "P"
    case Q = "Q"
    case R = "R"
    case S = "S"
    case T = "T"
    case U = "U"
    case V = "V"
    case W = "W"
    case X = "X"
    case Y = "Y"
    case Z = "Z"
    
    case α = "α"
    case β = "β"
    case γ = "γ"
    case δ = "δ"
    case ε = "ε"
    case ζ = "ζ"
    case η = "η"
    case θ = "θ"
    case ι = "ι"
    case κ = "κ"
    case λ = "λ"
    case μ = "μ"
    case ν = "ν"
    case ξ = "ξ"
    case ο = "ο"
    case π = "π"
    case ρ = "ρ"
    case σ = "σ"
    case τ = "τ"
    case υ = "υ"
    case φ = "φ"
    case χ = "χ"
    case ψ = "ψ"
    case ω = "ω"
    
    case Α = "Α"
    case Β = "Β"
    case Γ = "Γ"
    case Δ = "Δ"
    case Ε = "Ε"
    case Ζ = "Ζ"
    case Η = "Η"
    case Θ = "Θ"
    case Ι = "Ι"
    case Κ = "Κ"
    case Λ = "Λ"
    case Μ = "Μ"
    case Ν = "Ν"
    case Ξ = "Ξ"
    case Ο = "Ο"
    case Π = "Π"
    case Ρ = "Ρ"
    case Σ = "Σ"
    case Τ = "Τ"
    case Υ = "Υ"
    case Φ = "Φ"
    case Χ = "Χ"
    case Ψ = "Ψ"
    case Ω = "Ω"
    
    var name: String {
        return rawValue
    }
}

enum InputUnit: String, InputButtonType, CaseIterable {
    
    case meter = "_m"
    case kilogram = "_kg"
    case second = "_s"
    case foot = "_ft"
    case inch = "_in"
    case yard = "_yd"
    case pound = "_lb"
    
    var name: String {
        return rawValue
    }
}

enum InputOperationA: String, InputButtonType {
    
    case add = "+"
    case sub = "-"
    case mlt = "×"
    case div = "÷"
    
    var name: String {
        return rawValue
    }
}

enum InputOperationB: String, InputButtonType {
    
    case con = "*"
    case frac = "/"
    case mix = "*/"
    case squ = "^2"
    case cube = "^3"
    case pow = "^"
    case inv = "^-1"
    case exp = "EXP"
    case mod = "mod"
    case nPr = "nPr"
    case nCr = "nCr"
    
    var name: String {
        return rawValue
    }
}

enum InputOperationC: String, InputButtonType {
    
    case sqrt = "√"
    case cbrt = "3√"
    case nrt = "n√"
    case b10 = "10^"
    case be = "e^"
    case b2 = "2^"
    case bn = "n^"
    
    var name: String {
        return rawValue
    }
}

enum InputFunction: String, InputButtonType {
    
    case abs = "abs"
    case rand = "rand"
    case randint = "randint"
    case round = "round"
    case floor = "floor"
    case ceil = "ceil"
    
    case log = "log"
    case ln = "ln"
    case log2 = "log2"
    case logn = "logn"
    
    case sin = "sin"
    case cos = "cos"
    case tan = "tan"
    case cot = "cot"
    case sec = "sec"
    case csc = "csc"
    
    case sinh = "sinh"
    case cosh = "cosh"
    case tanh = "tanh"
    case coth = "coth"
    case sech = "sech"
    case csch = "csch"
    
    case sin⁻¹ = "sin⁻¹"
    case cos⁻¹ = "cos⁻¹"
    case tan⁻¹ = "tan⁻¹"
    case cot⁻¹ = "cot⁻¹"
    case sec⁻¹ = "sec⁻¹"
    case csc⁻¹ = "csc⁻¹"
    
    case sinh⁻¹ = "sinh⁻¹"
    case cosh⁻¹ = "cosh⁻¹"
    case tanh⁻¹ = "tanh⁻¹"
    case coth⁻¹ = "coth⁻¹"
    case sech⁻¹ = "sech⁻¹"
    case csch⁻¹ = "csch⁻¹"
    
    case sum = "∑"
    case prod = "∏"
    case deriv = "dx"
    case deriv2 = "dx2"
    case derivn = "dxn"
    case integ = "∫"
    
    var name: String {
        return rawValue
    }
    
    init?(word: String) {
        var newWord: String {
            switch word {
            case "deriv":
                return "dx"
            case "integ":
                return "∫"
            case "dx":
                return ""
            default:
                return word
            }
        }
        self.init(rawValue: newWord)
    }
}

enum InputModifier: String, InputButtonType {
    
    case fac = "!"
    case pcent = "%"
    case pmil = "‰"
    
    var name: String {
        return rawValue
    }
}

enum InputGrouping: String, InputButtonType {
    
    case open = "("
    case close = ")"
    
    var name: String {
        return rawValue
    }
}
