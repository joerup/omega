//
//  Addition.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {
    
    // MARK: - Addition
    
    static func + (addend1_: Value, addend2_: Value) -> Value {
        
        var sum = Value()
        
        let addend1 = setValue(addend1_)
        let addend2 = setValue(addend2_)
        
        // ERROR
        guard !(addend1 is Error), !(addend2 is Error) else { return Error() }
        
        // NUMBERS only - Add directly
        if let addend1 = addend1 as? Number, let addend2 = addend2 as? Number, addend2.per == 1 || addend1.per == addend2.per {
            
            // Add them
            sum = number(addend1.value + addend2.value)
        }
        
        // PERCENT second - Add percent
        else if let addend2 = addend2 as? Number, addend2.per != 1 {
            
            // Multiply to increase
            sum = addend1 * Number(1 + addend2.value)
        }
        
        // SIMPLIFY
        else if addend1.canSimplify, addend2.canSimplify {
            
            // IDENTITY present - Cancels out
            if (addend1 as? Number)?.value == 0 || (addend2 as? Number)?.value == 0 {

                // Sum is the other value
                sum = (addend2 as? Number)?.value == 0 ? addend1 : addend2
            }

            // LIKE TERMS - Add coefficients together
            else if likeTerms(addend1, addend2) {

                // Split the terms into their factors
                let factors1 = split(addend1, at: .mlt)
                let factors2 = split(addend2, at: .mlt)

                // Find the resulting coefficient
                sum = (factors1.first(where: {$0 is Number}) ?? Number(1)) + (factors2.first(where: {$0 is Number}) ?? Number(1))

                // Multiply the coefficient by each factor
                for factor in factors1.filter({ !($0 is Number) }) {
                    sum = sum * factor
                }
            }

            // POLYNOMIAL included - Add all terms together
            else if addend1.hasOperation(.add) || addend2.hasOperation(.add) {

                // Split into terms at addition operators
                var terms = split(addend1, at: .add) + split(addend2, at: .add)

                // Combine like terms
                var index1 = 0
                while index1 < terms.count {
                    var index2 = index1+1
                    while index2 < terms.count {

                        // Attempt addition if like terms or zeroes present
                        if likeTerms(terms[index1], terms[index2]) || (terms[index1] as? Number)?.value == 0 || (terms[index2] as? Number)?.value == 0 {

                            // Combine the terms
                            let termSum = terms[index1] + terms[index2]

                            // Replace the original terms with the sum
                            terms[index1] = termSum
                            terms.remove(at: index2)

                            // Break and go back
                            index1 -= 2
                            if index1 < 0 { index1 = -1 }
                            break
                        }

                        index2 += 1
                    }
                    index1 += 1
                }

                // Add all of the terms together
                var combinedTerms: [Item] = []
                for term in terms {
                    combinedTerms += [term, Operation(.add)]
                }
                combinedTerms.removeLast()

                // Set the sum
                if combinedTerms.count == 1, let value = combinedTerms[0] as? Value {
                    sum = value
                } else {
                    sum = Expression(combinedTerms)
                }
            }

            // EXPONENTIAL included - Attempt to add
            else if addend1.hasOperation(.exp) || addend2.hasOperation(.exp) {
                
                // Split each term into the base and power
                let exp1 = split(addend1, at: .exp)
                let exp2 = split(addend2, at: .exp)

                // Only numbers allowed
                if !exp1.contains(where: { !($0 is Number) }) && !exp2.contains(where: { !($0 is Number) }) {

                    // Set the bases and powers
                    var base1 = (exp1[0] as! Number).value
                    var base2 = (exp2[0] as! Number).value
                    var power1 = exp1.count > 1 ? (exp1[1] as! Number).value : 0
                    var power2 = exp2.count > 1 ? (exp2[1] as! Number).value : 0

                    // Fix the bases and powers
                    while round(abs(base1)*1e12)/1e12 >= 12 {
                        base1 /= 10
                        power1 += 1
                    }
                    while round(abs(base1)*1e12)/1e12 < 1 {
                        base1 *= 10
                        power1 -= 1
                    }
                    while round(abs(base2)*1e12)/1e12 >= 12 {
                        base2 /= 10
                        power2 += 1
                    }
                    while round(abs(base2)*1e12)/1e12 < 1 {
                        base2 *= 10
                        power2 -= 1
                    }

                    // Powers more than 12 apart - bigger addend wins
                    if power2-power1 > 12 {
                        sum = addend2
                    }
                    else if power1-power2 > 12 {
                        sum = addend1
                    }
                    else {

                        // power1 is larger - increase power2 to power1
                        while power2 < power1 {
                            power2 += 1
                            base2 /= 10
                        }
                        // power2 is larger - increase power1 to power2
                        while power1 < power2 {
                            power1 += 1
                            base1 /= 10
                        }

                        // Add the bases
                        let baseSum = Number(base1 + base2)

                        // Set the power
                        let newPower = Number(power1)

                        // Set the new exponential
                        sum = exponential(base: baseSum, power: newPower)
                    }
                }
                else {
                    sum = Expression([addend1, Operation(.add), addend2])
                }
            }
            
            // CANNOT SIMPLIFY - Create polynomial with addends
            else {
                sum = Expression([addend1, Operation(.add), addend2])
            }
        }
        
        // DO NOT SIMPLIFY - Create polynomial with addends
        else {
            sum = Expression([addend1, Operation(.add), addend2])
        }
        
        return sum
    }
    
    // MARK: - Subtraction
    
    static func - (minuend: Value, subtrahend: Value) -> Value {
        
        var difference = Value()
        
        let minuend = setValue(minuend)
        let subtrahend = setValue(subtrahend)
        
        // ERROR
        guard !(minuend is Error), !(subtrahend is Error) else { return Error() }
        
        // NUMBERS only - Subtract directly
        if let minuend = minuend as? Number, let subtrahend = subtrahend as? Number, subtrahend.per == 1 || minuend.per == subtrahend.per {
            
            // Subtract them
            difference = number(minuend.value - subtrahend.value)
        }
        
        // PERCENT second - Subtract percent
        else if let subtrahend = subtrahend as? Number, subtrahend.per != 1 {
            
            // Multiply to decrease
            difference = minuend * Number(1 - subtrahend.value)
        }
        
        // OTHER - Add the negative
        else {
            difference = minuend + Number(-1)*subtrahend
        }
        
        return difference
    }
}
