//
//  Logarithms.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {
    
    // MARK: - Logarithms
    
    static func logarithm(base: Value, value: Value) -> Value {

        var result = Value()
        
        let base = setValue(base)
        let value = setValue(value)
        
        // ERROR
        guard !(base is Error), !(value is Error) else { return Error() }

        // NUMBERS only - Direct logarithm
        if let base = base as? Number, let value = value as? Number {

            // Take the logarithm
            let logResult = log(value.value)/log(base.value)

            // Set the result
            result = number(logResult)
        }
        
        // SIMPLIFY
        else if base.canSimplify, value.canSimplify {
            
            // ONE present in log - Results in identity
            if (value as? Number)?.value == 1 {
    
                // Result is zero
                result = Number(0)
            }
    
            // SAME BASE & VALUE - Results in identity
            else if base == value {
    
                // Result is one
                result = Number(1)
            }
    
            // POWER present in log - Bring the power to the front
            else if value.hasOperation(.pow) {
    
                // Split the term into the base and power
                let basePower = split(value, at: .pow)
    
                // Set the result to the power multiplied by the log with remaining base
                result = basePower[1] * logarithm(base: base, value: basePower[0])
            }
    
            // EXPONENTIAL present in log - Expand into log addition
            else if value.hasOperation(.exp) {
    
                // Split the term into the base and power
                let exp = split(value, at: .exp)
    
                // Set the result: log a b + (c / log a)
                result = logarithm(base: base, value: exp[0]) + exp[1] / logarithm(base: Number(10), value: base)
            }
    
            // TERM present in log - Expand into log addition
            else if value.hasOperation(.mlt) {
    
                // Split the term into its factors
                let factors = split(value, at: .mlt)
    
                // Expand into logs added together
                for factor in factors {
                    let separateLog = logarithm(base: base, value: factor)
                    if result.empty {
                        result = separateLog
                    } else {
                        result = result + separateLog
                    }
                }
            }
            
            // CANNOT SIMPLIFY - Create a logarithm expression
            else {
                result = Expression([Function(.log), base, value])
            }
        }

        // DO NOT SIMPLIFY - Create a logarithm expression
        else {
            result = Expression([Function(.log), base, value])
        }

        return result
    }
}
