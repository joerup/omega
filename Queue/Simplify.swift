//
//  Simplify.swift
//  Calculator
//
//  Created by Joe Rupertus on 4/15/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

// Perform the calculations and produce a result
extension Queue {
    
    // MARK: - Simplify
    
    func simplify(main: Bool = true, roundPlaces: Int? = nil) -> Queue {
        
        // Set the queue
        var queue: [Item] = self.items
        
        // Make sure no placeholders remain
        guard !containsPlaceholder(queue) else {
            return Queue([Error("Invalid syntax")])
        }
        
        // Set a single value
        if queue.count == 1, let value = queue[0] as? Value {
            queue[0] = Value.setValue(value)
        }
        
        // Reduce bound expressions
        while let index = queue.firstIndex(where: { $0 is Expression && ($0 as! Expression).grouping == .bound }), let bound = queue[index] as? Expression, bound.value.count == 1, let value = bound.value.first {
            
            // Remove the expression
            queue.remove(at: index)
            
            // Add the item
            queue.insert(value, at: index)
        }
        
        // Change implied multiplication
        
        // MARK: Parentheses
        var index = 0
        while index < queue.count {
            
            // Get connectors
            if (queue[index] as? Operation)?.operation == .con, index+1 < queue.count, index-1 >= 0 {
                
                // Get the surrounding items
                let last = queue[index-1]
                let next = queue[index+1]
                
                // Keep implicit negative
                if let number = last as? Number, number.string == "#-1" {
                    index += 1
                }
                // Change to multiplication if expression next
                else if !settings.implicitMultFirst, let expression = next as? Expression, expression.parentheses || (expression.value.first as? Expression)?.parentheses ?? false {
                    queue[index] = Operation(.mlt)
                }
            }
            
            index += 1
        }
        
        // ------------------------------------ //
        // ------------------------------------ //
        // ------------------------------------ //
        
        // MARK: Parentheses
        index = 0
        while index < queue.count {
            
            // Get the item
            let item = queue[index]
            
            // Determine if it is an expression
            if let expression = item as? Expression {
                
                // Get the parenthesesQueue
                let parenthesesQueue = expression.queue
                
                // Set the modes
                parenthesesQueue.modes = self.modes
                
                // Perform the operations on the parenthesesQueue
                let parenthesesResult = parenthesesQueue.simplify(main: false).items
                
                // Remove the original expression from the main queue
                queue.remove(at: index)
                
                // Add the parenthesesResult back into the main queue
                if parenthesesResult.count == 1, parenthesesResult[0] is Expression {
                    queue.insert(parenthesesResult[0], at: index)
                } else {
                    queue.insert(Expression(parenthesesResult, modes: modes, grouping: expression.grouping), at: index)
                }
            }
            
            index += 1
        }
        
        // ------------------------------------ //
        // ------------------------------------ //
        // MARK: - Functions
        // ------------------------------------ //
        // ------------------------------------ //
        
        while queue.contains(where: { $0 is Function }) {
            
            // Find the first function
            let index = queue.firstIndex(where: { $0 is Function })!
            
            // Set the function
            let function = (queue[index] as! Function).function
            
            // ------------------------------------ //
            // ------------------------------------ //
            // ------------------------------------ //
            
            // MARK: Number Functions
            // rand, randint, round, floor, ceil
            if Function.numberFunctions.contains(function) {
                
                // Make sure the operand exists
                guard index+1 < queue.count, queue[index+1] is Value else {
                    return Queue([Error("Invalid syntax")])
                }
                
                // Set the input
                let input = queue[index+1] as! Value
                
                // Perform the operation
                let result = Value.numberFunction(function, input)
                
                // Set the result
                queue[index] = result

                // Remove the operand
                queue.remove(at: index+1)
            }
            
            // ------------------------------------ //
            // ------------------------------------ //
            // ------------------------------------ //
            
            // MARK: Absolute Value
            else if function == .abs {
                
                // Make sure the operand exists
                guard index+1 < queue.count, queue[index+1] is Value else {
                    return Queue([Error("Invalid syntax")])
                }
                
                // Set the input
                let input = queue[index+1] as! Value
                
                // Perform the operation
                let result = Value.absolute(input)
                
                // Set the result
                queue[index] = result

                // Remove the operand
                queue.remove(at: index+1)
            }
            
            // ------------------------------------ //
            // ------------------------------------ //
            // ------------------------------------ //
            
            // MARK: Trigonometry
            // Regular Function
            else if Function.regTrig.contains(function) {

                // Make sure the operand exists
                guard index+1 < queue.count, queue[index+1] is Value else {
                    return Queue([Error("Invalid syntax")])
                }
                
                // Set the angle
                let angle = queue[index+1] as! Value

                // Perform the operation
                let value = Value.trig(function, angle: angle, unit: modes.angleUnit)

                // Set the result
                queue[index] = value

                // Remove the operand
                queue.remove(at: index+1)
            }
            // Power Function
            else if Function.powTrig.contains(function) {

                // Make sure the operands exist
                guard index+1 < queue.count, queue[index+1] is Value, queue[index+2] is Value else {
                    return Queue([Error("Invalid syntax")])
                }
                
                // Set the power and angle
                let power = queue[index+1] as! Value
                let angle = queue[index+2] as! Value

                // Perform the operation
                let value = Value.trig(function, power: power, angle: angle, unit: modes.angleUnit)

                // Set the result
                queue[index] = value

                // Remove the operand
                queue.removeSubrange(index+1...index+2)
            }
            // Inverse Function
            else if Function.invTrig.contains(function) {

                // Make sure the operand exists
                guard index+1 < queue.count, queue[index+1] is Value else {
                    return Queue([Error("Invalid syntax")])
                }
                
                // Set the value
                let value = queue[index+1] as! Value

                // Perform the operation
                let angle = Value.trig(function, value: value, unit: modes.angleUnit)

                // Set the result
                queue[index] = angle

                // Remove the operand
                queue.remove(at: index+1)
            }
            
            // ------------------------------------ //
            // ------------------------------------ //
            // ------------------------------------ //
            
            // MARK: Logarithms
            else if function == .log {
                
                // Make sure the operands exist
                guard index+2 < queue.count, queue[index+1] is Value, queue[index+2] is Value else {
                    return Queue([Error("Invalid syntax")])
                }
                
                // Set the base and value
                let base = queue[index+1] as! Value
                let value = queue[index+2] as! Value

                // Perform the operation
                let result = Value.logarithm(base: base, value: value)

                // Set the result
                queue[index] = result

                // Remove the operands
                queue.removeSubrange(index+1...index+2)
            }
            
            // ------------------------------------ //
            // ------------------------------------ //
            // ------------------------------------ //
            
            // MARK: Limits
            else if function == .lim {
                
                // Make sure the operands exist
                guard index+3 < queue.count, queue[index+1] is Letter, queue[index+2] is Value, queue[index+3] is Value else {
                    return Queue([Error("Invalid syntax")])
                }
                
                // Set the variable, bound, and value
                let variable = queue[index+1] as! Letter
                let limit = queue[index+2] as! Value
                let value = queue[index+3] as! Value
                
                // Perform the operation
                let result = Value.limit(as: variable, approaches: limit, of: value)
                
                // Set the result
                queue[index] = result
                
                // Remove the operands
                queue.removeSubrange(index+1...index+3)
            }
            
            // ------------------------------------ //
            // ------------------------------------ //
            // ------------------------------------ //
            
            // MARK: Derivatives
            else if function == .deriv {
                
                // Make sure the operands exist
                guard index+3 < queue.count, queue[index+1] is Value, queue[index+2] is Letter, queue[index+3] is Value else {
                    return Queue([Error("Invalid syntax")])
                }
                
                // Set the variable and value
                let order = queue[index+1] as! Value
                let variable = queue[index+2] as! Letter
                let value = queue[index+3] as! Value
                
                // Perform the operation
                let result = Value.derivative(value, order: order, withRespectTo: variable)
                
                // Set the result
                queue[index] = result
                
                // Remove the operands
                queue.removeSubrange(index+1...index+3)
            }
            
            // ------------------------------------ //
            // ------------------------------------ //
            // ------------------------------------ //
            
            // MARK: Derivative Values
            else if function == .valDeriv {
                
                // Make sure the operands exist
                guard index+4 < queue.count, queue[index+1] is Value, queue[index+2] is Letter, queue[index+3] is Value, queue[index+4] is Value else {
                    return Queue([Error("Invalid syntax")])
                }
                
                // Set the variable and value
                let order = queue[index+1] as! Value
                let variable = queue[index+2] as! Letter
                let value = queue[index+3] as! Value
                let location = queue[index+4] as! Value
                
                // Perform the operation
                let result = Value.evaluateDerivative(value, order: order, withRespectTo: variable, location: location)
                
                // Set the result
                queue[index] = result
                
                // Remove the operands
                queue.removeSubrange(index+1...index+4)
            }
            
            // ------------------------------------ //
            // ------------------------------------ //
            // ------------------------------------ //
            
            // MARK: Indefinite Integrals
            else if function == .integ {
                
                // Make sure the operands exist
                guard index+2 < queue.count, queue[index+1] is Value, queue[index+2] is Letter else {
                    return Queue([Error("Invalid syntax")])
                }
                
                // Set the integrand and variable
                let integrand = queue[index+1] as! Value
                let variable = queue[index+2] as! Letter
                
                // Perform the operation
                let result = Value.integral(integrand, withRespectTo: variable)
                
                // Set the result
                queue[index] = result
                
                // Remove the operands
                queue.removeSubrange(index+1...index+2)
            }
            
            // ------------------------------------ //
            // ------------------------------------ //
            // ------------------------------------ //
            
            // MARK: Definite Integrals
            else if function == .definteg {
                
                // Make sure the operands exist
                guard index+4 < queue.count, queue[index+1] is Value, queue[index+2] is Value, queue[index+3] is Value, queue[index+4] is Letter else {
                    return Queue([Error("Invalid syntax")])
                }
                
                // Set the bounds, integrand, and variable
                let lowerBound = queue[index+1] as! Value
                let upperBound = queue[index+2] as! Value
                let integrand = queue[index+3] as! Value
                let variable = queue[index+4] as! Letter
                
                // Perform the operation
                let result = Value.definiteIntegral(integrand, from: lowerBound, to: upperBound, withRespectTo: variable)
                
                // Set the result
                queue[index] = result
                
                // Remove the operands
                queue.removeSubrange(index+1...index+4)
            }
            
            // ------------------------------------ //
            // ------------------------------------ //
            // ------------------------------------ //
            
            // MARK: Summation / Product
            else if function == .sum || function == .prod {
                
                // Make sure the operands exist
                guard index+4 < queue.count, queue[index+1] is Letter, queue[index+2] is Value, queue[index+3] is Value, queue[index+4] is Value else {
                    return Queue([Error("Invalid syntax")])
                }
                
                // Set the variable, bounds, and value
                let variable = queue[index+1] as! Letter
                let lowerBound = queue[index+2] as! Value
                let upperBound = queue[index+3] as! Value
                let value = queue[index+4] as! Value
                
                // Perform the operation
                let result = Value.sumprod(function, variable, from: lowerBound, to: upperBound, of: value)
                
                // Set the result
                queue[index] = result
                
                // Remove the operands
                queue.removeSubrange(index+1...index+4)
            }
            
            // ------------------------------------ //
            // ------------------------------------ //
            // ------------------------------------ //
            
            // Step & print
            queue = step(queue: queue)
        }
        
        // ------------------------------------ //
        // ------------------------------------ //
        // MARK: - Operations
        // ------------------------------------ //
        // ------------------------------------ //
        
        // MARK: Exponents
        while queue.contains(where: { ($0 as? Operation)?.operation == .pow }) {

            // Find the first exponent
            let index = queue.firstIndex(where: { ($0 as? Operation)?.operation == .pow })!

            // Make sure the operands exist
            guard index-1 >= 0, index+1 < queue.count, queue[index-1] is Value, queue[index+1] is Value else {
                return Queue([Error("Invalid syntax")])
            }
            
            // Set the base and power
            let base = queue[index-1] as! Value
            let power = queue[index+1] as! Value

            // Perform the operation
            let result = base ^ power

            // Set the result
            queue[index] = result
            
            // Remove the operands
            queue.remove(at: index-1)
            queue.remove(at: index)
            
            // Step & print
            queue = step(queue: queue)
        }
        
        // ------------------------------------ //
        // ------------------------------------ //
        // ------------------------------------ //
        
        // MARK: Radicals
        while queue.contains(where: { ($0 as? Operation)?.operation == .rad }) {

            // Find the first radical
            let index = queue.firstIndex(where: { ($0 as? Operation)?.operation == .rad })!

            // Make sure the operands exist
            guard index-1 >= 0, index+1 < queue.count, queue[index-1] is Value, queue[index+1] is Value else {
                return Queue([Error("Invalid syntax")])
            }
            
            // Set the index and radicand
            let rinx = queue[index-1] as! Value
            let radicand = queue[index+1] as! Value

            // Perform the operation
            let result = radicand ^ (rinx ^ Number(-1))

            // Set the result
            queue[index] = result

            // Remove the operands
            queue.remove(at: index-1)
            queue.remove(at: index)
            
            // Step & print
            queue = step(queue: queue)
        }
        
        // ------------------------------------ //
        // ------------------------------------ //
        // ------------------------------------ //
        
        // MARK: Percents
        while queue.contains(where: { ($0 as? Modifier)?.modifier == .pcent || ($0 as? Modifier)?.modifier == .pmil }) {
            
            // Find the first percent
            let index = queue.firstIndex(where: { ($0 as? Modifier)?.modifier == .pcent || ($0 as? Modifier)?.modifier == .pmil })!
            
            // Set the modifier
            let modifier = (queue[index] as? Modifier)?.modifier
            
            // Make sure the operand exists
            guard index-1 < queue.count, queue[index-1] is Value else {
                return Queue([Error("Invalid syntax")])
            }
            
            // Set the input
            let input = queue[index-1] as! Value
            
            // Perform the modification
            var result: Value {
                if let num = input as? Number {
                    return Number(num.string + modifier!.rawValue)
                } else if let expression = input as? Expression, expression.value.count == 1, let num = expression.value.first as? Number {
                    return Number(num.string + modifier!.rawValue)
                } else {
                    return Expression([input, Modifier(modifier!)])
                }
            }
            
            // Set the result
            queue[index] = result

            // Remove the operand
            queue.remove(at: index-1)
            
            // Step & print
            queue = step(queue: queue)
        }
        
        // ------------------------------------ //
        // ------------------------------------ //
        // ------------------------------------ //
        
        // MARK: Factorial
        while queue.contains(where: { ($0 as? Modifier)?.modifier == .fac }) {
            
            // Find the first factorial
            let index = queue.firstIndex(where: { ($0 as? Modifier)?.modifier == .fac })!
            
            // Make sure the operand exists
            guard index-1 >= 0, queue[index-1] is Value else {
                return Queue([Error("Invalid syntax")])
            }
            
            // Set the input
            let input = queue[index-1] as! Value
            
            // Perform the modification
            let result = Value.factorial(input: input)
            
            // Set the result
            queue[index] = result
            
            // Remove the operand
            queue.remove(at: index-1)
            
            // Step & print
            queue = step(queue: queue)
        }
        
        // ------------------------------------ //
        // ------------------------------------ //
        // ------------------------------------ //
        
        // MARK: Exponential Notation
        while queue.contains(where: { ($0 as? Operation)?.operation == .exp }) {

            // Find the first EXP
            let index = queue.firstIndex(where: { ($0 as? Operation)?.operation == .exp })!

            // Make sure the operands exist
            guard index-1 >= 0, index+1 < queue.count, queue[index-1] is Value, queue[index+1] is Value else {
                return Queue([Error("Invalid syntax")])
            }
            
            // Set the base and power
            let base = queue[index-1] as! Value
            let power = queue[index+1] as! Value

            // Perform the operation
            let result = Value.exponential(base: base, power: power)

            // Set the result
            queue[index] = result

            // Remove the operands
            queue.remove(at: index-1)
            queue.remove(at: index)
            
            // Step & print
            queue = step(queue: queue)
        }
        
        // ------------------------------------ //
        // ------------------------------------ //
        // ------------------------------------ //
        
        // MARK: Combinatorics
        while queue.contains(where: { ($0 as? Operation)?.operation == .nPr || ($0 as? Operation)?.operation == .nCr }) {
            
            // Find the first permutation/combination
            let index = queue.firstIndex(where: { ($0 as? Operation)?.operation == .nPr || ($0 as? Operation)?.operation == .nCr })!
            
            // Set the operation
            let operation = (queue[index] as! Operation).operation
            
            // Make sure the operands exist
            guard index-1 >= 0, index+1 < queue.count, queue[index-1] is Value, queue[index+1] is Value else {
                return Queue([Error("Invalid syntax")])
            }
            
            // Set n and r
            let n = queue[index-1] as! Value
            let r = queue[index+1] as! Value
            
            // Perform the operation
            let result = Value.combinatorics(operation, n: n, r: r)
            
            // Set the result
            queue[index] = result
            
            // Remove the operands
            queue.remove(at: index-1)
            queue.remove(at: index)
            
            // Step & print
            queue = step(queue: queue)
        }
        
        // ------------------------------------ //
        // ------------------------------------ //
        // ------------------------------------ //
        
        // MARK: Connectors / Fractions
        while queue.contains(where: { ($0 as? Operation)?.operation == .con || ($0 as? Operation)?.operation == .fra }) {

            // Find the first connector
            let index = queue.firstIndex(where: { ($0 as? Operation)?.operation == .con || ($0 as? Operation)?.operation == .fra })!
            
            // Set the operation
            let operation = (queue[index] as? Operation)?.operation

            // Make sure the operands exist
            guard index-1 >= 0, index+1 < queue.count, queue[index-1] is Value, queue[index+1] is Value else {
                return Queue([Error("Invalid syntax")])
            }
            
            // Mixed Numbers
            if operation == .con, !((queue[index-1] as? Expression)?.parentheses ?? false), index+3 < queue.count, (queue[index+2] as? Operation)?.operation ?? .con == .fra, queue[index+3] is Value {
                
                // Set the values
                let value1 = queue[index-1] as! Value
                let value2 = queue[index+1] as! Value
                let value3 = queue[index+3] as! Value
                
                let negative = (value1 as? Number)?.negative ?? false
                
                // Perform the operation
                let result = value1 + (value2 / value3) * Number(negative ? -1 : 1)
                
                // Set the result
                queue[index] = result
                
                // Remove the extra operands
                queue.remove(at: index+2)
                queue.remove(at: index+2)
            }
            // Coefficients
            else if operation == .con {
                
                // Set the values
                let value1 = queue[index-1] as! Value
                let value2 = queue[index+1] as! Value

                // Perform the operation
                let result = value1 * value2

                // Set the result
                queue[index] = result
            }
            // Fractions
            else if operation == .fra {
                
                // Set the numerator and denominator
                let numerator = queue[index-1] as! Value
                let denominator = queue[index+1] as! Value

                // Perform the operation
                let quotient = numerator / denominator

                // Set the result
                queue[index] = quotient
            }

            // Remove the operands
            queue.remove(at: index-1)
            queue.remove(at: index)
            
            // Step & print
            queue = step(queue: queue)
        }
        
        // ------------------------------------ //
        // ------------------------------------ //
        // ------------------------------------ //
        
        // MARK: Multiplication / Division / Modulo
        while queue.contains(where: { ($0 as? Operation)?.operation == .mlt || ($0 as? Operation)?.operation == .div || ($0 as? Operation)?.operation == .mod }) {

            // Find the first multiplication operator
            let index = queue.firstIndex(where: { ($0 as? Operation)?.operation == .mlt || ($0 as? Operation)?.operation == .div || ($0 as? Operation)?.operation == .mod })!
            
            // Set the operation
            let operation = (queue[index] as? Operation)?.operation

            // Make sure the operands exist
            guard index-1 >= 0, index+1 < queue.count, queue[index-1] is Value, queue[index+1] is Value else {
                return Queue([Error("Invalid syntax")])
            }
            
            // Multiplication
            if operation == .mlt {
                
                // Set the factors
                let factor1 = queue[index-1] as! Value
                let factor2 = queue[index+1] as! Value
                
                // Perform the operation
                let product = factor1 * factor2

                // Set the result
                queue[index] = product
            }
            // Division
            else if operation == .div {
                
                // Set the dividend and divisor
                let dividend = queue[index-1] as! Value
                let divisor = queue[index+1] as! Value
                
                // Perform the operation
                let quotient = dividend / divisor

                // Set the result
                queue[index] = quotient
            }
            // Modulo
            else if operation == .mod {
                
                // Set the dividend and modulus
                let dividend = queue[index-1] as! Value
                let modulus = queue[index+1] as! Value
                
                // Perform the operation
                let remainder = Value.mod(dividend, modulus)
                
                // Set the result
                queue[index] = remainder
            }

            // Remove the operands
            queue.remove(at: index-1)
            queue.remove(at: index)
            
            // Step & print
            queue = step(queue: queue)
        }
        
        // ------------------------------------ //
        // ------------------------------------ //
        // ------------------------------------ //
        
        // MARK: Addition / Subtraction
        while queue.contains(where: { ($0 as? Operation)?.operation == .add || ($0 as? Operation)?.operation == .sub }) {

            // Find the first operator
            let index = queue.firstIndex(where: { ($0 as? Operation)?.operation == .add || ($0 as? Operation)?.operation == .sub })!
            
            // Set the operation
            let operation = (queue[index] as? Operation)?.operation

            // Make sure the operands exist and are values
            guard index-1 >= 0, index+1 < queue.count, queue[index-1] is Value, queue[index+1] is Value else {
                return Queue([Error("Invalid syntax")])
            }
            
            // Addition
            if operation == .add {
                
                // Set the addends
                let addend1 = queue[index-1] as! Value
                let addend2 = queue[index+1] as! Value
                
                // Perform the operation
                let sum = addend1 + addend2
                
                // Set the result
                queue[index] = sum
            }
            // Subtraction
            else if operation == .sub {
                
                // Set the minuend and subtrahend
                let minuend = queue[index-1] as! Value
                let subtrahend = queue[index+1] as! Value
                
                // Perform the operation
                let difference = minuend - subtrahend
                
                // Set the result
                queue[index] = difference
            }

            // Remove the operands
            queue.remove(at: index-1)
            queue.remove(at: index)
            
            // Step & print
            queue = step(queue: queue)
        }
        
        // ------------------------------------ //
        // ------------------------------------ //
        // ------------------------------------ //
        
        // Finalize the result
        if main {
            queue = finalizeResult(queue, roundPlaces: roundPlaces)
        }
        
        // Set the queue
        let finalQueue = Queue(queue)
        
        // Set the modes
        finalQueue.setModes(to: self.modes)
        
        // Return the result
        return finalQueue
    }
    
    
    // MARK: Finalize Result
    
    func finalizeResult(_ result: [Item], roundPlaces: Int? = nil) -> [Item] {
        
        var queue: [Item] = result
        
        var index = 0
        while index < queue.count {
            
            let item = queue[index]
            let next = index+1 < queue.count ? queue[index+1] : Item()
            
            // Finalize any number
            if let num = queue[index] as? Number, num.string.first != "#" {
                queue[index] = Value.number(num.value, roundPlaces: roundPlaces)
            }
            
            // Finalize any expression
            if let expression = item as? Expression {
                let items = finalizeResult(expression.value, roundPlaces: roundPlaces)
                if items.count == 1, items[0] is Error {
                    queue[index] = Error()
                } else {
                    queue[index] = Expression(items, grouping: expression.grouping, pattern: expression.pattern)
                }
            }

            // Coefficient of one
            if let number = item as? Number, number.double == 1, (next as? Operation)?.operation == .con {
                if number.negative {
                    queue[index] = Number("#-1")
                } else {
                    queue.remove(at: index)
                    queue.remove(at: index)
                }
            }

            // Change adding a negative to subtraction
            if let operation = item as? Operation, operation.operation == .add {
                if let number = next as? Number, number.negative {
                    // Change to subtraction
                    queue[index] = Operation(.sub)
                    // Change negative to positive
                    queue[index+1] = number * Number(-1)
                }
                else if let expression = next as? Expression, expression.value.count >= 2, let number = expression.value[0] as? Number, number.negative, (expression.value[1] as? Operation)?.operation == .con {
                    // Change to subtraction
                    queue[index] = Operation(.sub)
                    // Change negative to positive
                    queue[index+1] = expression * Number(-1)
                }
            }
            
            // Change coefficient to fraction
//            if let operation = item as? Operation, operation.operation == .cof, let number = prev as? Number {
//                if let inverse = (number ^ Number(-1)) as? Number, inverse.double > 1, inverse.integer {
//                    queue[index-1] = Expression([Number(1), Operation(.fra), inverse], parentheses: false)
//                }
//            }
            
            // Queue contains error
            if queue[index] is Error {
                queue = [Error()]
            }
            
            index += 1
        }
        
        // Letters remain - set to queue
        if !Queue(queue).allLetters.isEmpty {
            queue = self.items
        }
        
        // Take out of expression
        while queue.count == 1, let expression = queue[0] as? Expression {
            queue = expression.value
        }
        
        return queue
    }
    
    // Determine if there is a placeholder
    func containsPlaceholder(_ queue: [Item]) -> Bool {
        return queue.contains(where: { $0 is Placeholder || $0 is Expression && containsPlaceholder(($0 as! Expression).value) })
    }

    // Step
    func step(queue: [Item]) -> [Item] {
        if queue.contains(where: { $0 is Error || ($0 as? Expression)?.value.contains(where: { $0 is Error }) ?? false || ($0 as? Number)?.value == .nan }) {
            return [Error()]
        }
        return queue
    }
    
}

extension Calculation {
    
    // MARK: - Find Extra Results
    
    func extraResult() -> [Queue] {
        
        var results: [Queue] = []
        
        // Add simplified
        let result = self.result.simplify()
        if result.items != self.result.items {
            results += [result]
        }
        
        // Number
        if result.items.count == 1, let result = result.items[0] as? Number, !result.roundValue().integer {
            
            // fraction
            for i in 2...100 {
                let denominator = Number(Double(i))
                if let numerator = (result * denominator) as? Number, numerator.guaranteedInteger {
                    results += [Queue([Expression(numerator, grouping: .hidden, pattern: .stuckRight), Operation(.fra), Expression(denominator, grouping: .hidden, pattern: .stuckLeft)])]
                    break
                }
            }
            
            // roots
            for i in 2...10 {
                let test = Number(Double(i))
                if let number = (result ^ test) as? Number, number.guaranteedInteger {
                    if result.negative {
                        results += [Queue([Number("#-1"), Operation(.con), Expression(i==2 ? Number("#2") : test, grouping: .hidden, pattern: .stuckRight), Operation(.rad), Expression(Number(number.double).roundValue(), grouping: .hidden, pattern: .stuckLeft)])]
                    } else {
                        results += [Queue([Expression(i==2 ? Number("#2") : test, grouping: .hidden, pattern: .stuckRight), Operation(.rad), Expression(number.roundValue(), grouping: .hidden, pattern: .stuckLeft)])]
                    }
                    break
                }
            }
            // relative roots
            for i in 2...30 {
                let test = Number(Double(i))
                if let sqrt = (test ^ Number(1/2)) as? Number, !sqrt.integer, let relative = relativeValue(result, of: sqrt, placement: [Expression(Number("#2"), grouping: .hidden, pattern: .stuckRight), Operation(.rad), Expression(test, grouping: .hidden, pattern: .stuckLeft)], allowSingles: false) {
                    results += [relative]
                    break
                }
            }
            
            // logs
            for i in [2,M_E,10] {
                let test = Number(Double(i))
                if let power = ( test ^ result ) as? Number, power.guaranteedInteger {
                    results += [Queue([Function(.log), Expression(i==10 ? Number("#10") : i==M_E ? Number("#e") : test, grouping: .hidden, pattern: .stuckLeft), Expression(power, grouping: Settings.settings.autoParFunction ? .parentheses : .hidden, pattern: .stuckLeft)])]
                    break
                }
                if let power = ( test ^ result ) as? Number, let inverse = (power ^ Number(-1)) as? Number, inverse.guaranteedInteger {
                    results += [Queue([Number("#-1"), Operation(.con), Function(.log), Expression(i==10 ? Number("#10") : i==M_E ? Number("#e") : test, grouping: .hidden, pattern: .stuckLeft), Expression(inverse, grouping: Settings.settings.autoParFunction ? .parentheses : .hidden, pattern: .stuckLeft)])]
                    break
                }
            }
            
            // relative values
            if let pi = relativeValue(result, of: Letter("π", type: .constant, value: Queue([Number(.pi)]))) {
                results += [pi]
            }
            if let e = relativeValue(result, of: Letter("e", type: .constant, value: Queue([Number(M_E)]))) {
                results += [e]
            }
            
            // repeating
            if let repeating = result.repeating() {
                results += [Queue([repeating])]
            }
        }
        
        // Remove all identical results
        results.removeAll(where: { $0.items == self.result.items || $0.items == self.queue.items })
        
        return results
    }
    
    func relativeValue(_ result: Number, of value: Value, placement: [Item]? = nil, allowSingles: Bool = true, precision: Int = 50) -> Queue? {
        
        let placement = placement ?? [value]
        if let proportion = (result / value) as? Number {
            
            // same
            if proportion.roundValue().value == 1 {
                return allowSingles ? Queue(placement) : nil
            }
            // negative
            if proportion.roundValue().value == -1 {
                return allowSingles ? Queue([Number("#-1"), Operation(.con)] + placement) : nil
            }
            // factor
            if proportion.guaranteedInteger {
                return Queue([proportion, Operation(.con)] + placement)
            }
            // inverse
            if let inverse = (proportion ^ Number(-1)) as? Number, inverse.guaranteedInteger {
                return Queue([Expression(placement, grouping: .hidden, pattern: .stuckRight), Operation(.fra), Expression(inverse, grouping: .hidden, pattern: .stuckLeft)])
            }
            // fraction
            for i in 2...precision {
                let denominator = Number(Double(i))
                if let numerator = (proportion * denominator) as? Number, numerator.guaranteedInteger {
                    return Queue([Expression(numerator, grouping: .hidden, pattern: .stuckRight), Operation(.fra), Expression(denominator, grouping: .hidden, pattern: .stuckLeft), Operation(.con)] + placement)
                }
            }
        }
        
        return nil
    }
}

