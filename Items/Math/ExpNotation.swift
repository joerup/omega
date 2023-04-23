//
//  ExpNotation.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {
    
    // MARK: - Exponential Notation
    
    static func exponential(base: Value, power: Value) -> Value {
        
        var result = Value()
        
        let base = setValue(base)
        let power = setValue(power)
        
        // ERROR
        guard !(base is Error), !(power is Error) else { return Error() }
        
        // NUMBERS only - Direct power
        if let base = base as? Number, let power = power as? Number {
            
            // Take the power if under 1E300
            if abs(power.value) < 300 {
                let value = base.value * pow(10, power.value)
                result = number(value)
            }
            
            // Create exponential notation
            else {
                result = reduceExponential(base: base.value, power: power.value)
            }
        }
        
        // SIMPLIFY
        else if base.canSimplify, power.canSimplify {
            
            // EXPONENTIAL present in base - Multiply through
            if base.hasOperation(.exp) {

                // Split the term into the base and power
                let exp = split(base, at: .exp)

                // Set the base
                let base = exp[0]

                // Add the powers
                let power = exp[1] + power

                // Set the result
                result = exponential(base: base, power: power)
            }

            // TERM present in base - Multiply in
            else if base.hasOperation(.mlt) {

                // Split the term into its factors
                let factors = split(base, at: .mlt)

                // Multiply the first factor by the exponential, and the rest of the terms
                var combinedFactors: [Item] = []
                for factor in factors {
                    if combinedFactors.isEmpty {
                        combinedFactors = [exponential(base: factor, power: power)]
                    } else {
                        combinedFactors += [factor]
                    }
                    combinedFactors += [Operation(.con)]
                }
                combinedFactors.removeLast()

                // Set the result
                result = Expression(combinedFactors)
            }

            // POLYNOMIAL present in base - Distribute exponential
            else if base.hasOperation(.add) {

                // Split into terms at addition operators
                let terms = split(base, at: .add)

                // Distribute terms
                for term in terms {
                    if result.empty {
                        result = exponential(base: term, power: power)
                    } else {
                        result = result + exponential(base: term, power: power)
                    }
                }
            }

            // EXPONENTIAL present in power - OVERFLOW
            else if power.hasOperation(.exp) {

                // ERROR
                result = Error("Overflow")
            }
            
            // CANNOT SIMPLIFY - Create a term/factor with exponent and base
            else {
                result = Expression([base, Operation(.exp), power])
            }
        }
        
        // DO NOT SIMPLIFY - Create a term/factor with exponent and base
        else {
            result = Expression([base, Operation(.exp), power])
        }
        
        return result
    }
}
