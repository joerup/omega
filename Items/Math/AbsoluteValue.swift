//
//  AbsoluteValue.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {
    
    // MARK: - Absolute Value
    
    static func absolute(_ input: Value) -> Value {

        var result = Value()
        
        let input = setValue(input)
        
        // ERROR
        guard !(input is Error) else { return Error() }

        // NUMBER - Direct absolute value
        if let input = input as? Number {

            // Set the value
            let input = input.value

            // Perform the function
            let value = abs(input)

            // Set the result
            result = number(value)
        }
        
        // SIMPLIFY
        else if input.canSimplify {
            
            // TERM present in value - Distribute abs
            if input.hasOperation(.mlt) {

                // Split the term into its factors
                let factors = split(input, at: .mlt)

                // Distribute the absolute value
                for factor in factors {
                    if result.empty {
                        result = absolute(factor)
                    } else {
                        result = result * absolute(factor)
                    }
                }
            }

            // EXPONENTIAL present in log - Take abs of base
            else if input.hasOperation(.exp) {

                // Split the term into the base and power
                let exp = split(input, at: .exp)

                // Take the absolute value of the base
                result = exponential(base: absolute(exp[0]), power: exp[1])
            }

            // ABSOLUTE VALUE present in value - Simplify
            else if input.hasFunction([.abs]), let expression = input as? Expression, expression.value.count == 2, expression.value[1] is Value {

                // Remove the outside absolute value and return the inside part
                result = absolute(expression.value[1] as! Value)
            }
            
            // CANNOT SIMPLIFY - Create an absolute value expression
            else {
                result = Expression([Function(.abs), input])
            }
        }
        
        // DO NOT SIMPLIFY - Create an absolute value expression
        else {
            result = Expression([Function(.abs), input])
        }

        return result
    }
}
