//
//  Integration.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {
    
    // MARK: - Indefinite Integration
    
    static func integral(_ integrand: Value, withRespectTo variable: Letter, constant: Bool = true) -> Value {
        
        var result = Value()
        
        let integrand = setValue(integrand)
        
        // ERROR
        guard !(integrand is Error) else { return Error() }
        
        // NUMBERS ONLY
        if integrand is Number {
            
            // Result is integrand times variable
            result = integrand * variable //+ C()
        }
        
        // LETTER same as letter with respect to
        else if let letter = integrand as? Letter, letter == variable {
            
            // Result is 1/2 number squared
            result = Number(1/2) * ( integrand ^ Number(2) ) //+ C()
        }
        
        // POLYNOMIAL present in integrand - Integrate each term
        else if integrand.hasOperation(.add) {
            
            // Split into terms at addition operators
            let terms = split(integrand, at: .add)
            
            // Add together the integral of each
            for term in terms {
                if result.empty {
                    result = integral(term, withRespectTo: variable) //+ C()
                } else {
                    result = result + integral(term, withRespectTo: variable) //+ C()
                }
            }
        }
        
        // TERM present in integrand - Bring out constant or integrate by parts
        else if integrand.hasOperation(.mlt) {
            
            // Split the term into its factors
            let factors = split(integrand, at: .mlt)
            
            // Make sure the first term is a constant
            if factors.count == 2 && factors[0] is Number {
                
                // Bring the constant to the outside
                result = factors[0] * integral(factors[1], withRespectTo: variable)
            }
            else {
                result = Expression([Function(.integ), integrand, variable])
            }
        }
        
        // POWER present in integrand
        else if integrand.hasOperation(.pow) {
            
            // Split the integrand into the base and power
            let basePower = split(integrand, at: .pow)
            
            // Set the base and power
            let base = basePower[0]
            let power = basePower[1]
            
            // NUMBER/other variable in POWER - INTEGRATE
            if base == variable { //base.hasValue(withRespectTo) && !power.hasValue(withRespectTo) {
                
                // Power is -1, result is natural log
                if power == Number(-1) {
                    result = logarithm(base: Number("#e"), value: absolute(base)) //+ C()
                } else {
                    
                    // Increase the power by 1 and divide by the new power
                    result = (base ^ (power + Number(1))) / (power + Number(1)) //+ C()
                }
            }
            // NUMBER/other variable in BASE - e^x RULE
            else if power == variable { //power.hasValue(withRespectTo) && !base.hasValue(withRespectTo) {
                
                // Divide the base raised to the power by the natural log of the base
                result = (base ^ power) / logarithm(base: Number("#e"), value: base) //+ C()
            }
            else {
                result = Expression([Function(.integ), integrand, variable])
            }
        }
        
        // TRIG FUNCTION present in integrand
//        else if integrand.hasFunction(Function.trig), let expression = integrand as? Expression, let function = expression.value[0] as? Function, let inside = expression.value[1] as? Value {
//
            // Take the integral of the function
//            var integral: Value {
//                switch function.function {
//                case .sin:
//                    return Number(-1) * trig(.cos, angle: inside) //+ C()
//                case .cos:
//                    return trig(.sin, angle: inside) //+ C()
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
//                    return Error()
//                }
//            }
//
//            // Set the result
//            result = integral
//        }
        
        // DO NOT SIMPLIFY - Create a function expression
        else if !(integrand is Expression) {
            result = Expression([Function(.integ), Expression([integrand]), variable])
        } else {
            result = Expression([Function(.integ), integrand, variable])
        }
        
        return result
    }
    
    // MARK: - Definite Integration
    
    static func definiteIntegral(_ integrand: Value, from lower: Value, to upper: Value, withRespectTo variable: Letter) -> Value {
        
        var result = Value()
        
        let integrand = setValue(integrand)
        let lower = setValue(lower)
        let upper = setValue(upper)
        
        // ERROR
        guard !(integrand is Error), !(lower is Error), !(upper is Error) else { return Error() }
        
        // Set numbers
        guard let lower = lower as? Number, let upper = upper as? Number, Queue([integrand]).allVariables.isEmpty else {
            return Expression([Function(.definteg), Expression(lower, grouping: .hidden, pattern: .stuckLeft), Expression(upper, grouping: .hidden, pattern: .stuckLeft), Expression(integrand, grouping: .hidden, pattern: .stuckLeft), Expression(variable, grouping: .bound, pattern: .stuckLeft)])
        }
        
        // Set the intervals
        let intervals = 2500
        let dx = (upper.value - lower.value) / Double(intervals)
        var total: Double = 0
        var y0: Double? = nil

        // Loop through each trapezoid
        for i in 0...intervals {

            // Set the x value
            let x = lower.value + Double(i)*dx

            // Plug in the x value
            let y = integrand.plugIn(Number(x), to: variable)

            // Set the y value
            if let y = (setValue(y, keepExp: false) as? Number)?.value {

                // Add the 2x trapezoid area
                if let y0 = y0 {
                    total += y0 + y
                }

                // Set the last value
                y0 = y
            }
            else if i == 0 || i == intervals {
                
            }
            else {
                return Error()
            }
        }

        // Half the area to average the sum
        result = number(dx*total/2)
        
        // Go to zero
        if (setValue(result, keepExp: false) as? Number)?.double ?? 1 < 1e-12 {
            return Number(0)
        }
        
        return result
    }
}
