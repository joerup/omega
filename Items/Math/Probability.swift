//
//  Probability.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {
    
    // MARK: - Factorial
    
    static func factorial(input: Value) -> Value {
        
        var result = Value()
        
        let input = setValue(input, keepExp: false)
        
        // ERROR
        guard !(input is Error) else { return Error() }
        
        // NUMBERS only - Direct factorial
        if let input = input as? Number {
            
            // Perform the operation
            let gamma = tgamma(input.value + 1)
            
            // Set the result
            result = Number(gamma)
        }
        
        // DO NOT SIMPLIFY - Create a factorial expression
        else if let number = input as? Number, number.negative {
            result = Expression([Expression([input]), Modifier(.fac)])
        } else {
            result = Expression([input, Modifier(.fac)])
        }
        
        return result
    }

    // MARK: - Combinatorics
    
    static func combinatorics(_ operation: OperationType, n: Value, r: Value) -> Value {

        var result = Value()
        
        let n = setValue(n, keepExp: false)
        let r = setValue(r, keepExp: false)
        
        // ERROR
        guard !(n is Error), !(r is Error) else { return Error() }

        // NUMBERS only (positive integers) - Direct combinatorics
        if let n = n as? Number, let r = r as? Number {
            
            // GUARD: Only allow positive integers
            guard n.integer, r.integer, n.value >= 0, r.value > 0 else {
                return Error("Invalid \(operation == .nPr ? "Permutation" : "Combination")")
            }

            // Set the value
            let n = n.value
            let r = r.value

            // Perform the operation
            var value: Value {

                if r > n {
                    return Number(0)
                }
                if r > 50000 {
                    return Number(.infinity)
                }

                // Permutations
                if operation == .nPr {
                    var product: Value = Number(1)
                    var i = n
                    while i > n-r {
                        product = product * Number(Double(i))
                        i -= 1
                    }
                    return product
                }

                // Combinations
                else if operation == .nCr {
                    var product: Value = Number(1)
                    var ni = n
                    var ri = r
                    while ni > n-r {
                        product = product * Number(Double(ni)) / Number(Double(ri))
                        ni -= 1
                        ri -= 1
                    }
                    return product
                }

                return Number(0)
            }

            // Set the result
            result = value
        }
        
        // DO NOT SIMPLIFY - Create a combinatoric expression
        else {
            result = Expression([n, Operation(operation), r])
        }

        return result
    }
}
