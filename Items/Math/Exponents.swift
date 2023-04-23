//
//  Exponents.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {
    
    // MARK: - Exponents
    
    static func ^ (base: Value, power: Value) -> Value {
        
        var result = Value()
        
        let base = setValue(base)
        let power = setValue(power, keepExp: false)
        
        // ERROR
        guard !(base is Error), !(power is Error) else { return Error() }
        
        // NUMBERS only - Direct power
        if let base = base as? Number, let power = power as? Number, (!base.negative || power.integer) {
            
            // Take the power
            let value = pow(base.value, power.value)
            
            // Zero to the zero
            if base.value == 0, power.value == 0 {
                return Error("Undefined")
            }
            
            // If too large, break up & try again
            if value.isInfinite && base.value != 0 && base.value.isFinite {
                let newValue = base ^ (power/Number(10))
                return newValue ^ (Number(10))
            }
            // If too small, break up & try again
            else if value == 0 && base.value != 0 && base.value.isFinite {
                let newValue = base ^ (power/Number(10))
                return newValue ^ (Number(10))
            }
            
            // Set the result
            result = number(value)
        }
        
        // NEGATIVE in base and DECIMAL in power
        else if let base = base as? Number, let power = power as? Number, base.negative, !power.integer {

            // Get the inverse of the power
            let inversePower = power ^ Number(-1) as! Number

            // If the inverse power is odd, apply the negative
            if inversePower.integer, Int(inversePower.value) % 2 == 1 {
                result = Number(-1) * (absolute(base) ^ power)
            }
            // If the base is -1, convert to i
            else if base.value == -1 {
                return Error("Undefined")
            }
            // If the inverse power is even, force in terms of i
            else {
                result = (absolute(base) ^ power) * (Number(-1) ^ power)
            }
        }
        
        // SIMPLIFY
        else if base.canSimplify, power.canSimplify {
            
            // ONE present in power - Cancels out
            if (power as? Number)?.value == 1 {

                // Result is the base
                result = base
            }

            // ZERO present in power - Results in identity
            else if (power as? Number)?.value == 0 {

                // Result is multiplicative identity
                result = Number(1)
            }

            // IMAGINARY number present in base - Special properties
//            else if (base as? Variable)?.name == "i", let power = power as? Number, !power.negative {
//
//                return Error("Undefined")

//                // Get the reduced power (subtracting by i^4 = 1)
//                let reducedPower = mod(power, Number(4))
//
//                // Set the result
//                if let reducedPower = reducedPower as? Number {
//                    switch reducedPower.value {
//                    case 0:
//                        result = Number(1)
//                    case 1:
//                        result = base
//                    case 2:
//                        result = Number(-1)
//                    case 3:
//                        result = Number(-1)*base
//                    default:
//                        result = Expression([base, Operation(.pow), power])
//                    }
//                } else {
//                    result = Expression([base, Operation(.pow), power])
//                }
//            }

            // POWER present in base - Multiply powers
            else if base.hasOperation(.pow) {

                // Split the term into the base and power
                let basePower = split(base, at: .pow)

                // Get the base
                let base = basePower[0]

                // Find the resulting power
                let power = basePower[1] * power

                // Set the result
                result = base ^ power
            }

            // EXPONENTIAL present in base - Raise each piece
            else if base.hasOperation(.exp) {

                // Split the term into the base and power
                let exp = split(base, at: .exp)

                // Raise the base to the power
                let base = exp[0] ^ power

                // Multiply the powers
                let power = exp[1] * power

                // Set the product
                result = exponential(base: base, power: power)
            }

            // TERM present in base - Distribute power
            else if base.hasOperation(.mlt) {

                // Split the term into its factors
                let factors = split(base, at: .mlt)

                // Distribute the power
                for factor in factors {
                    if result.empty {
                        result = factor ^ power
                    } else {
                        result = result * ( factor ^ power )
                    }
                }
            }

            // POLYNOMIAL present in base (with integer power 2-10) - Expand terms
            else if base.hasOperation(.add), let power = power as? Number, power.integer, 2...10 ~= Int(power.value) {

                // Expand
                result = base
                for _ in 1..<Int(power.value) {
                    result = result * base
                }
            }

            // TRIG FUNCTION present in base - Make into trig power function
            else if base.hasFunction(Function.regTrig) || base.hasFunction(Function.powTrig), let expression = base as? Expression, let function = expression.value[0] as? Function {

                // Regular trig - Change to power trig
                if Function.regTrig.contains(function.function), let functionValue = expression.value[1] as? Value {

                    // Set the new function
                    let newFunction = FunctionType.init(rawValue: function.function.rawValue+"p")

                    // Set the result
                    if let newFunction = newFunction {
                        result = Expression([Function(newFunction), power, functionValue])
                    }
                }
                // Power trig - Multiply power
                else if let functionPower = expression.value[1] as? Value, let functionValue = expression.value[2] as? Value {

                    // Multiply the powers
                    let newPower = power * functionPower

                    // Set the result
                    result = Expression([function, newPower, functionValue])
                }
            }
            
            // CANNOT SIMPLIFY - Create a term/factor with exponent and base
            else if let number = base as? Number, number.negative {
                result = Expression([Expression([base]), Operation(.pow), power])
            } else {
                result = Expression([base, Operation(.pow), power])
            }
        }
        
        // DO NOT SIMPLIFY - Create a term/factor with exponent and base
        else if let number = base as? Number, number.negative {
            result = Expression([Expression([base]), Operation(.pow), power])
        } else {
            result = Expression([base, Operation(.pow), power])
        }
        
        return result
    }
}
