//
//  Differentiation.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {
    
    // MARK: - Derivative
    
    static func derivative(_ value: Value, order: Value = Number(1), withRespectTo variable: Letter) -> Value {
        
        var result = Value()
        
        let value = setValue(value)
        let order = setValue(order)
        
        // ERROR
        guard !(value is Error), !(order is Error) else { return Error() }
        
        // NUMBER order
        if let order = order as? Number, order.integer, order.value > 0, order.value <= 1000 {
            
            // Take the derivative
            for _ in 0..<Int(order.value) {
                if result.empty {
                    result = differentiate(value, withRespectTo: variable)
                } else {
                    result = differentiate(result, withRespectTo: variable)
                }
            }
        }
        
        // DO NOT SIMPLIFY - Create a function expression
        else if !(value is Expression) {
            result = Expression([Function(.deriv), order, variable, Expression([value])])
        } else {
            result = Expression([Function(.deriv), order, variable, value])
        }
        
        return result
    }
    
    // MARK: - Evaluate Derivative
    
    static func evaluateDerivative(_ value: Value, order: Value = Number(1), withRespectTo variable: Letter, location: Value) -> Value {
        
        var result = Value()
        
        let value = setValue(value)
        let order = setValue(order)
        let location = setValue(location)
        
        // ERROR
        guard !(value is Error), !(order is Error), !(location is Error) else { return Error() }
        
        // Set numbers
        guard let order = order as? Number, let location = location as? Number, Queue([value]).allVariables.isEmpty else {
            return Expression([Function(.valDeriv), Expression(order, grouping: .hidden, pattern: .stuckLeft), Expression(variable, grouping: .bound, pattern: .stuckLeft), Expression(value, grouping: .hidden, pattern: .stuckLeft), Expression(location, grouping: .hidden, pattern: .stuckLeft)])
        }
        
        // Set the bounds
        let dx = 1e-5
        let x1 = location - Number(dx/2)
        let x2 = location + Number(dx/2)
        
        // Set the values
        let y1 = value.plugIn(x1, to: variable)
        let y2 = value.plugIn(x2, to: variable)
        
        guard order.value == 1 else { return Error() }
//        guard order.integer, !order.negative, order.value <= 100 else { return Error() }
        
        // Set the result
        result = (y2 - y1) / (x2 - x1)
        
        // Go to zero
        if (setValue(result, keepExp: false) as? Number)?.double ?? 1 < 1e-12 {
            return Number(0)
        }
        // Go to infinity
        if (setValue(result, keepExp: false) as? Number)?.double ?? 1 > 1e8 {
            return Error()
        }
        
        return result
    }
    
    // MARK: - Differentiation
    
    static func differentiate(_ value: Value, withRespectTo: Letter) -> Value {
        
        var result = Value()
        
        let value = setValue(value, keepExp: false)
        
        // ERROR
        guard !(value is Error) else { return Error() }
        
        // NUMBERS ONLY - Constants
        if value is Number {
            
            // Result is zero
            result = Number(0)
        }
        
        // Letter same as letter with respect to
        else if let letter = value as? Letter, letter == withRespectTo {
            
            // Result is 1
            result = Number(1)
        }
        
        // POLYNOMIAL present in value - Take the derivative of each term
        else if value.hasOperation(.add) {
            
            // Split into terms at addition operators
            let terms = split(value, at: .add)
            
            // Add together the derivative of each
            for term in terms {
                if result.empty {
                    result = differentiate(term, withRespectTo: withRespectTo)
                } else {
                    result = result + differentiate(term, withRespectTo: withRespectTo)
                }
            }
        }
        
        // TERM present in value - Product rule
        else if value.hasOperation(.mlt) {
            
            // Split the term into its factors
            var factors = split(value, at: .mlt)
            
            // Combine all factors beyond the second into the second
            var index = 2
            while index < factors.count {
                factors[1] = factors[1] * factors[index]
                index += 1
            }
            
            // Set the factors
            let factor1 = factors[0]
            let factor2 = factors[1]
            
            // Perform the product rule
            result = factor1 * differentiate(factor2, withRespectTo: withRespectTo) + factor2 * differentiate(factor1, withRespectTo: withRespectTo)
        }
        
        // POWER present in value
        else if value.hasOperation(.pow) {
            
            // Split the value into the base and power
            let basePower = split(value, at: .pow)
            
            // Set the base and power
            let base = basePower[0]
            let power = basePower[1]
            
            // NUMBER/other variable in POWER - POWER RULE
            if base.hasValue(withRespectTo) && !power.hasValue(withRespectTo) {
                
                // Multiply the power by the base raised to the power-1, times the derivative of the base (chain rule)
                result = power * ( base ^ (power - Number(1)) ) * differentiate(base, withRespectTo: withRespectTo)
            }
            // NUMBER/other variable in BASE - e^x RULE
            else if power.hasValue(withRespectTo) && !base.hasValue(withRespectTo) {
                
                // Multiply the base raised to the power by the natural log of the base, times the derivative of the power (chain rule)
                result = (base ^ power) * logarithm(base: Number("#e"), value: base) * differentiate(power, withRespectTo: withRespectTo)
            }
            else {
                result = Expression([Function(.deriv), Number("#1"), withRespectTo, value])
            }
        }
        
        // LOGARITHM present in value
        else if value.hasFunction([.log]), let expression = value as? Expression, let base = expression.value[1] as? Value, let inside = expression.value[2] as? Value {
            
            // NUMBER/other variable in INSIDE - ln x RULE
            if inside.hasValue(withRespectTo) && !base.hasValue(withRespectTo) {
                
                // Return the inverse of the inside times the natural log of the base, times the derivative of the inside (chain rule)
                result = Number(1) / (inside * logarithm(base: Number("#e"), value: base)) * differentiate(inside, withRespectTo: withRespectTo)
            }
            else {
                result = Expression([Function(.deriv), Number("#1"), withRespectTo, value])
            }
        }
        
        // TRIG FUNCTION present in value
//        else if value.hasFunction(Function.trig), let expression = value as? Expression, let function = expression.value[0] as? Function, let inside = expression.value[1] as? Value {
//
            // Take the derivative of the function
//            var outsideDerivative: Value {
//                switch function.function {
//                case .sin:
//                    return trig(.cos, angle: inside)
//                case .cos:
//                    return Number(-1) * trig(.sin, angle: inside)
//                case .tan:
//                    return trig(.sec, angle: inside) ^ Number(2)
//                case .cot:
//                    return Number(-1) * (trig(.csc, angle: inside) ^ Number(2))
//                case .sec:
//                    return trig(.sec, angle: inside) * trig(.tan, angle: inside)
//                case .csc:
//                    return Number(-1) * trig(.csc, angle: inside) * trig(.cot, angle: inside)
//                case .sin⁻¹:
//                    return (Number(1) - (inside ^ Number(2))) ^ Number(-1/2)
//                case .cos⁻¹:
//                    return Number(-1) * ((Number(1) - (inside ^ Number(2))) ^ Number(-1/2))
//                case .tan⁻¹:
//                    return (Number(1) + (inside ^ Number(2))) ^ Number(-1)
//                case .cot⁻¹:
//                    return Number(-1) * ((Number(1) + (inside ^ Number(2))) ^ Number(-1))
//                case .sec⁻¹:
//                    return (inside * (((inside ^ Number(2)) - Number(1)) ^ Number(1/2))) ^ Number(-1)
//                case .csc⁻¹:
//                    return Number(-1) * ((inside * (((inside ^ Number(2)) - Number(1)) ^ Number(1/2))) ^ Number(-1))
//                case .sinh:
//                    return trig(.cosh, angle: inside)
//                case .cosh:
//                    return trig(.sinh, angle: inside)
//                case .tanh:
//                    return trig(.sech, angle: inside) ^ Number(2)
//                case .coth:
//                    return Number(-1) * (trig(.csch, angle: inside) ^ Number(2))
//                case .sech:
//                    return Number(-1) * trig(.sech, angle: inside) * trig(.tanh, angle: inside)
//                case .csch:
//                    return Number(-1) * trig(.csch, angle: inside) * trig(.coth, angle: inside)
//                case .sinh⁻¹:
//                    return ((inside ^ Number(2)) + Number(1)) ^ Number(-1/2)
//                case .cosh⁻¹:
//                    return ((inside ^ Number(2)) - Number(1)) ^ Number(-1/2)
//                case .tanh⁻¹:
//                    return (Number(1) - (inside ^ Number(2))) ^ Number(-1)
//                case .coth⁻¹:
//                    return (Number(1) - (inside ^ Number(2))) ^ Number(-1)
//                case .sech⁻¹:
//                    return Number(-1) * ((inside * ((Number(1) - (inside ^ Number(2))) ^ Number(1/2))) ^ Number(-1))
//                case .csch⁻¹:
//                    return Number(-1) * ((absolute(inside) * (((inside ^ Number(2)) + Number(1)) ^ Number(1/2))) ^ Number(-1))
//                default:
//                    return inside
//                }
//            }
//
//            // Set the result and multiply by the derivative of the inside (CHAIN RULE)
//            result = outsideDerivative * differentiate(inside, withRespectTo: withRespectTo)
//        }
//
//        // ABSOLUTE VALUE present in value
//        else if value.hasFunction([.abs]), let expression = value as? Expression, expression.value.count == 2, let inside = expression.value[1] as? Value {
//
//            // Result is x/|x|
//            let outsideDerivative = inside / absolute(inside)
//
//            // Set the result and multiply by the derivative of the inside (CHAIN RULE)
//            result = outsideDerivative * differentiate(inside, withRespectTo: withRespectTo)
//        }
        
        // ERROR
        else {
            result = Error()
        }
        
        return result
    }
}
