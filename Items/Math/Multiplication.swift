//
//  Multiplication.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {
    
    // MARK: - Multiplication
    
    static func * (factor1: Value, factor2: Value) -> Value {
        
        var product = Value()
        
        let factor1 = setValue(factor1)
        let factor2 = setValue(factor2)
        
        // ERROR
        guard !(factor1 is Error), !(factor2 is Error) else { return Error() }
        
        // NUMBERS only - Multiply directly
        if let factor1 = factor1 as? Number, let factor2 = factor2 as? Number {
            
            // Multiply them
            product = number(factor1.value * factor2.value)
        }
        
        // SIMPLIFY
        else if factor1.canSimplify, factor2.canSimplify {
            
            // ONE present - Cancels out
            if (factor1 as? Number)?.value == 1 || (factor2 as? Number)?.value == 1 {

                // Product is the other value
                product = (factor2 as? Number)?.value == 1 ? factor1 : factor2
            }

            // ZERO present - Results in identity
            else if (factor1 as? Number)?.value == 0 || (factor2 as? Number)?.value == 0 {

                // Product is additive identity
                product = Number(0)
            }

            // LIKE BASES - Add exponents together
            else if likeBases(factor1, factor2) {

                // Split the terms at the exponent
                var power1 = split(factor1, at: .pow)
                var power2 = split(factor2, at: .pow)
                
                // Add an implied power of 1 if necessary
                if power1.count == 1 { power1.append(Number(1)) }
                if power2.count == 1 { power2.append(Number(1)) }

                // Get the base
                let base = power1[0]

                // Find the resulting power
                let power = power1[1] + power2[1]

                // Set the product
                product = base ^ power
            }

            // POLYNOMIAL included - Distribute/foil terms
            else if factor1.hasOperation(.add) || factor2.hasOperation(.add) {

                // Split into terms at addition operators
                let terms1 = split(factor1, at: .add)
                let terms2 = split(factor2, at: .add)

                // Distribute terms
                for term1 in terms1 {
                    for term2 in terms2 {
                        if product.empty {
                            product = term1 * term2
                        } else {
                            product = product + ( term1 * term2 )
                        }
                    }
                }
            }

            // TERM included - Multiply all factors together
            else if factor1.hasOperation(.mlt) || factor2.hasOperation(.mlt) {

                // Split the terms into their factors
                var factors = split(factor1, at: .mlt) + split(factor2, at: .mlt)

                // Multiply like terms
                var index1 = 0
                while index1 < factors.count {
                    var index2 = index1+1
                    while index2 < factors.count {

                        // Attempt multiplication if both numbers or like bases
                        if factors[index1] is Number && factors[index2] is Number || likeBases(factors[index1], factors[index2]) {

                            // Multiply them together
                            let factorProduct = factors[index1] * factors[index2]

                            // Replace the original terms with the sum
                            factors[index1] = factorProduct
                            factors.remove(at: index2)

                            // Break and start over
                            index1 = -1
                            break
                        }

                        index2 += 1
                    }
                    index1 += 1
                }

                // Coefficients should always come first
                factors = factors.filter({ $0 is Number }) + factors.filter({ $0 is Letter }) + factors.filter({ !($0 is Number) && !($0 is Letter) })

                // Multiply all of the terms together
                var combinedFactors: [Item] = []
                for factor in factors {
                    combinedFactors += [factor, Operation(.con)]
                }
                combinedFactors.removeLast()

                // Set the product
                if combinedFactors.count == 1, let value = combinedFactors[0] as? Value {
                    product = value
                } else {
                    product = Expression(combinedFactors)
                }
            }

            // EXPONENTIAL included - Multiply through
            else if factor1.hasOperation(.exp) || factor2.hasOperation(.exp) {

                // Split the term into the base and power
                let exp1 = split(factor1, at: .exp)
                let exp2 = split(factor2, at: .exp)

                // Multiply the bases
                let base = exp1[0] * exp2[0]

                // Add the powers
                var power: Value {
                    if exp1.count > 1 && exp2.count > 1 {
                        return exp1[1] + exp2[1]
                    }
                    else if exp1.count > 1 {
                        return exp1[1]
                    }
                    else if exp2.count > 1 {
                        return exp2[1]
                    }
                    return Number(0)
                }

                // Set the product
                product = exponential(base: base, power: power)
            }
            
            // CANNOT SIMPLIFY - Create term with factors
            else {
                if let factor2 = factor2 as? Number {
                    product = Expression([factor2, Operation(.con), factor1])
                } else {
                    product = Expression([factor1, Operation(.con), factor2])
                }
            }
        }
        
        // DO NOT SIMPLIFY - Create term with factors
        else {
            if let factor2 = factor2 as? Number {
                product = Expression([factor2, Operation(.con), factor1])
            } else {
                product = Expression([factor1, Operation(.con), factor2])
            }
        }
        
        return product
    }
    
    // MARK: - Division
    
    static func / (dividend: Value, divisor: Value) -> Value {
        
        var quotient = Value()
        
        let dividend = setValue(dividend)
        let divisor = setValue(divisor)
        
        // ERROR
        guard !(dividend is Error), !(divisor is Error) else { return Error() }
        
        // NUMBERS only - Divide directly
        if let dividend = dividend as? Number, let divisor = divisor as? Number {
            
            // Divide them
            quotient = number(dividend.value / divisor.value)
        }
        
        // OTHER - Multiply by the inverse
        else {
            quotient = dividend * (divisor ^ Number(-1))
        }
        
        return quotient
    }
    
    // MARK: - Modulo
    
    static func mod(_ dividend: Value, _ modulus: Value) -> Value {

        var remainder = Value()
        
        let dividend = setValue(dividend)
        let modulus = setValue(modulus)
        
        // ERROR
        guard !(dividend is Error), !(modulus is Error) else { return Error() }

        // NUMBERS ONLY - Direct mod
        if let dividend = dividend as? Number, let modulus = modulus as? Number {

            // Take the remainder
            let value = dividend.value.truncatingRemainder(dividingBy: modulus.value)

            // Set the result
            remainder = number(value)
        }
        
        // DO NOT SIMPLIFY - Create a modulo expression
        else {
            remainder = Expression([dividend, Operation(.mod), modulus])
        }

        return remainder
    }
}
