//
//  Function.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 11/17/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation

class Function: NonValue {
    
    var function: FunctionType
    
    static let baseTrig: [FunctionType] = [.sin, .cos, .tan, .cot, .sec, .csc]
    static let regTrig: [FunctionType] = [.sin, .cos, .tan, .cot, .sec, .csc, .sinh, .cosh, .tanh, .coth, .sech, .csch]
    static let powTrig: [FunctionType] = [.sinp, .cosp, .tanp, .cotp, .secp, .cscp, .sinhp, .coshp, .tanhp, .cothp, .sechp, .cschp]
    static let invTrig: [FunctionType] = [.sin⁻¹, .cos⁻¹, .tan⁻¹, .cot⁻¹, .sec⁻¹, .csc⁻¹, .sinh⁻¹, .cosh⁻¹, .tanh⁻¹, .coth⁻¹, .sech⁻¹, .csch⁻¹]
    static let trig: [FunctionType] = [.sin, .cos, .tan, .cot, .sec, .csc, .sinp, .cosp, .tanp, .cotp, .secp, .cscp, .sin⁻¹, .cos⁻¹, .tan⁻¹, .cot⁻¹, .sec⁻¹, .csc⁻¹, .sinh, .cosh, .tanh, .coth, .sech, .csch, .sinhp, .coshp, .tanhp, .cothp, .sechp, .cschp, .sinh⁻¹, .cosh⁻¹, .tanh⁻¹, .coth⁻¹, .sech⁻¹, .csch⁻¹]
    
    static let numberFunctions: [FunctionType] = [.rand, .randint, .round, .floor, .ceil]
    
    static let parenthesesFunctions: [FunctionType] = invTrig + numberFunctions
    static let autoHiddenParFunctions: [FunctionType] = [.deriv, .valDeriv, .integ, .definteg]
    
    var parameters: [Value] {
        return Function.parameters(function)
    }
    var arguments: Int {
        switch self.function {
        case .sum, .prod, .definteg, .valDeriv:
            return 4
        case .lim, .deriv:
            return 3
        case _ where Function.powTrig.contains(self.function), .integ, .log:
            return 2
        default:
            return 1
        }
    }
    var mainArgument: Int {
        switch self.function {
        case .sum, .prod:
            return 3
        case .lim, .deriv, .definteg:
            return 2
        case _ where Function.powTrig.contains(self.function), .integ, .log:
            return 1
        default:
            return 0
        }
    }
    var parentheses: Bool {
        return Function.parenthesesFunctions.contains(self.function)
    }
    var autoHiddenPar: Bool {
        return Function.autoHiddenParFunctions.contains(self.function)
    }
    
    init(_ function: FunctionType) {
        self.function = function
    }
    
    init(raw: [String:String]) {
        if let rawType = raw["type"], let type = FunctionType(rawValue: rawType) {
            self.function = type
        } else {
            self.function = .abs
        }
    }
    
    static func parameters(_ functionType: FunctionType, inputValue: Value = Placeholder(active: true, pattern: .stuckLeft)) -> [Value] {
        switch functionType {
        case .sum, .prod:
            return [
                Placeholder(grouping: .bound, pattern: .stuckLeft),
                Placeholder(grouping: .hidden, pattern: .stuckLeft),
                Placeholder(grouping: .hidden, pattern: .stuckLeft),
                inputValue
            ]
        case .definteg:
            return [
                Placeholder(grouping: .hidden, pattern: .stuckLeft),
                Placeholder(grouping: .hidden, pattern: .stuckLeft),
                inputValue,
                Placeholder(grouping: .bound, pattern: .stuckLeft)
            ]
        case .valDeriv:
            return [
                Placeholder(grouping: .hidden, pattern: .stuckLeft),
                Placeholder(grouping: .bound, pattern: .stuckLeft),
                inputValue,
                Placeholder(grouping: .temporary, pattern: .stuckLeft)
            ]
        case .lim:
            return [
                Placeholder(grouping: .bound, pattern: .stuckLeft),
                Placeholder(grouping: .hidden, pattern: .stuckLeft),
                inputValue
            ]
        case .deriv:
            return [
                Placeholder(grouping: .hidden, pattern: .stuckLeft),
                Placeholder(grouping: .bound, pattern: .stuckLeft),
                inputValue
            ]
        case .integ:
            return [
                inputValue,
                Placeholder(grouping: .bound, pattern: .stuckLeft)
            ]
        case .log:
            return [
                Placeholder(grouping: .hidden, pattern: .stuckLeft),
                inputValue
            ]
        case _ where powTrig.contains(functionType):
            return [
                Placeholder(grouping: .hidden, pattern: .stuckLeft),
                inputValue
            ]
        default:
            return [inputValue]
        }
    }
}

enum FunctionType: String {
    
    case abs = "abs"
    case rand = "rand"
    case randint = "randint"
    case round = "round"
    case floor = "floor"
    case ceil = "ceil"
    
    case log = "log"
    
    case sin = "sin"
    case cos = "cos"
    case tan = "tan"
    case cot = "cot"
    case sec = "sec"
    case csc = "csc"
    
    case sinp = "sinp"
    case cosp = "cosp"
    case tanp = "tanp"
    case cotp = "cotp"
    case secp = "secp"
    case cscp = "cscp"
    
    case sin⁻¹ = "sin⁻¹"
    case cos⁻¹ = "cos⁻¹"
    case tan⁻¹ = "tan⁻¹"
    case cot⁻¹ = "cot⁻¹"
    case sec⁻¹ = "sec⁻¹"
    case csc⁻¹ = "csc⁻¹"
    
    case sinh = "sinh"
    case cosh = "cosh"
    case tanh = "tanh"
    case coth = "coth"
    case sech = "sech"
    case csch = "csch"
    
    case sinhp = "sinhp"
    case coshp = "coshp"
    case tanhp = "tanhp"
    case cothp = "cothp"
    case sechp = "sechp"
    case cschp = "cschp"
    
    case sinh⁻¹ = "sinh⁻¹"
    case cosh⁻¹ = "cosh⁻¹"
    case tanh⁻¹ = "tanh⁻¹"
    case coth⁻¹ = "coth⁻¹"
    case sech⁻¹ = "sech⁻¹"
    case csch⁻¹ = "csch⁻¹"
    
    case sum = "∑"
    case prod = "∏"
    case lim = "lim"
    case deriv = "d/d"
    case valDeriv = "d/d|"
    case integ = "∫i"
    case definteg = "∫d"
}
