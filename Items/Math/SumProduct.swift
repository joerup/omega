//
//  SumProduct.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {
    
    // MARK: - Summation/Product
    
    static func sumprod(_ function: FunctionType, _ variable: Letter, from lower: Value, to upper: Value, of value: Value) -> Value {
        
        var result = Value()
        
        let lower = setValue(lower)
        let upper = setValue(upper)
        let value = setValue(value)
        
        // ERROR
        guard !(lower is Error), !(upper is Error), !(value is Error) else { return Error() }
        
        // INTEGERS in bounds
        if let lower = lower as? Number, let upper = upper as? Number {
            
            // GUARD: Only allow integers where lower < upper
            guard lower.integer, upper.integer, lower.value <= upper.value else {
                return Error("Invalid \(function == .sum ? "Summation" : "Product")")
            }
            
            // Set the bounds
            let lower = Int(lower.value)
            let upper = Int(upper.value)
            
            // Summation
            if function == .sum {
                
                // Set the identity
                result = Number(0)
                
                // Sum the terms
                for i in lower...upper {
                    result = result + value.plugIn(Number(Double(i)), to: variable)
                }
            }
            
            // Product
            else if function == .prod {
                
                // Set the identity
                result = Number(1)
                
                // Multiply the terms
                for i in lower...upper {
                    result = result * value.plugIn(Number(Double(i)), to: variable)
                }
            }
        }
        
        // DO NOT SIMPLIFY - Create a function expression
        else if !(value is Expression) {
            result = Expression([Function(function), variable, lower, upper, Expression([value])])
        } else {
            result = Expression([Function(function), variable, lower, upper, value])
        }
        
        return result
    }
}
