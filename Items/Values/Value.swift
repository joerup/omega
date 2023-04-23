//
//  Value.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 12/2/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation

class Value: Item {
    
    var empty: Bool {
        return !( self is Number || self is Letter || self is Unit || self is Expression || self is Placeholder )
    }
    
    static let constants: [InputLetter] = [.π, .e, .inf]
    
    var canSimplify: Bool {
        if self is Letter { return false }
        else if let expression = self as? Expression {
            for item in expression.value {
                if item is Letter { return false }
                if let insideExpression = item as? Expression, !insideExpression.canSimplify { return false }
            }
        }
        return true
    }
    
    // Create new number
    static func number(_ value: Double, roundPlaces: Int? = nil) -> Value {
        
        // Error
        if value.isNaN || value.isInfinite {
            
            // Return an error
            return Error("Infinity")
        }
        
        // Out of numerical range
        if abs(value) >= 1e+12 || abs(value) < 1e-4 {
            
            // Create an exponential
            return reduceExponential(base: value, power: 0)
        }
        
        return Number(value, roundPlaces: roundPlaces)
    }
    
    // Set Value
    static func setValue(_ value: Value, keepExp: Bool = true, keepInf: Bool = false) -> Value {
        
        var value = value
        
        // Substitute a letter value
        if let letter = value as? Letter, let letterValue = letter.value {
            value = Expression(letterValue.simplify())
        }
        
        // Return a single item if the expression only has one value
        if let expression = value as? Expression, expression.value.count == 1, let item = expression.value.first as? Value {
            return setValue(item)
        }
        
        // Return exponential notation as a value if indicated
        if !keepExp, let expression = value as? Expression, expression.hasOperation(.exp) {
            let exponential = split(expression, at: .exp)
            if exponential.count >= 2 {
                let base = exponential[0]
                let power = exponential[1]
                if let base = base as? Number, let power = power as? Number, power.integer {
                    let value = Double("\(round(base.value*1e12)/1e12)e\(Int(power.value))") ?? base.value*pow(10,power.value)
                    return Number(value)
                }
            }
        }
        
        // Return error if infinity if indicated
        if !keepInf, let number = value as? Number, number.value.isInfinite || number.value.isNaN {
            return Error("Infinity")
        }
        
        // Return the value
        return value
    }
    
    // Reduce the exponential to the correct form
    static func reduceExponential(base: Double, power: Double) -> Value {
        
        // Set the base and power
        var base = base
        var power = power
        
        // Only 0 if base is 0
        if base == 0 { return Number(0) }
        
        // Reduce the base to be less than 10, & adjust the power
        while round(abs(base)*1e10)/1e10 >= 10 {
            base /= 10
            power += 1
        }
        // Increase the base to be 1 or greater, & adjust the power
        while round(abs(base)*1e12)/1e12 < 1 {
            base *= 10
            power -= 1
        }
        
        return Expression([Expression(Number(base), grouping: .temporary, pattern: .stuckRight), Operation(.exp), Expression(Number(power), grouping: .temporary, pattern: .stuckLeft)])
    }
    
    // Split the expression at certain operators
    static func split(_ value: Value, at: OperationType) -> [Value] {
        
        // Set the operation
        var operation: OperationType {
            if at == .con { return .mlt }
            return at
        }
        
        // Make sure it is an expression, and one of the working operators was selected
        // Multiplication only possible if there is no addition; powers only possible if there is no multiplication or addition
        guard let expression = value as? Expression ?? (value is Letter ? Expression([value]) : nil),
              [.add,.mlt,.exp,.pow].contains(operation),
            !(operation == .mlt && ( expression.hasOperation(.add) )),
            !(operation == .exp && ( expression.hasOperation(.add) || expression.hasOperation(.mlt) )),
            !(operation == .pow && ( expression.hasOperation(.add) || expression.hasOperation(.mlt) || expression.hasOperation(.exp) ))
        else {
            return [value]
        }
        
        // Set the multiple operations
        var operations: [OperationType] {
            if operation == .mlt { return [.mlt, .con] }
            return [operation]
        }
            
        // Split at selected operator
        let split = expression.value.split(whereSeparator: { $0 is Operation && operations.contains(($0 as? Operation)!.operation) }).map { Array($0) }
        
        // Create terms
        var items: [Value] = []
        for item in split {
            if item.count == 1, let value = item[0] as? Value {
                items += [value]
            } else {
                items += [Expression(item)]
            }
        }
        
        // If split at power with no exponent, add 1
        if operation == .pow && items.count == 1 {
            items += [Number(1)]
        }
        
        return items.map { setValue($0) }
    }
    
    // Plug in and simplify an expression
    func plugIn(_ value: Value, to letter: Letter, using modes: ModeSettings? = nil) -> Value {
        
        let substitution = Queue([self], modes: modes).substitute(letter, with: value)
        
        // Evaluate the expression
        let result = substitution.simplify().items
        
        // Return the result
        if result.count == 1, let value = result[0] as? Value {
            if let expression = value as? Expression, expression.value.count == 1, let expValue = expression.value[0] as? Value {
                return expValue
            } else {
                return value
            }
        } else {
            return Expression(result)
        }
    }
    
    // Determine if two terms are like terms by matching factors
    static func likeTerms(_ term1: Value, _ term2: Value) -> Bool {
        
        // Split the terms into their factors
        let factors1 = split(term1, at: .mlt)
        let factors2 = split(term2, at: .mlt)
        
        // See if all the variables & expressions in 1 are also in 2
        for factor in factors1 {
            if (factor is Letter || factor is Expression) && !factors2.contains(where: { $0 == factor }) {
                return false
            }
        }
        // See if all the variables & expressions in 2 are also in 1
        for factor in factors2 {
            if (factor is Letter || factor is Expression) && !factors1.contains(where: { $0 == factor }) {
                return false
            }
        }
        
        return true
    }
    
    // Determine if two terms are have the same exponent base
    static func likeBases(_ term1: Value, _ term2: Value) -> Bool {
        
        // Split the terms into their base & power
        let power1 = split(term1, at: .pow)
        let power2 = split(term2, at: .pow)
        
        // Make sure there is one base and one power
        guard power1.count <= 2, power2.count <= 2 else { return false }
        
        // See if the bases match
        return power1[0] == power2[0]
    }
    
    // Determine if the value contains a certain inputted value
    func hasValue(_ value: Value) -> Bool {
        
        // Determine if the value is identical to the inputted value
        if self == value { return true }
        
        // Determine if the expression contains the inputted value
        if let expression = self as? Expression {
            for item in expression.value {
                if item == value { return true }
                if let expression = item as? Expression, expression.hasValue(value) { return true }
            }
        }
        
        return false
    }
    
    // Determine if the value is an expression with a certain operation
    func hasOperation(_ operation: OperationType) -> Bool {
        
        // Set the multiple operations
        var operations: [OperationType] {
            if operation == .mlt { return [.mlt, .con] }
            return [operation]
        }
        
        // Determine if the expression contains the operations
        if let expression = self as? Expression {
            return expression.value.contains(where: { $0 is Operation && operations.contains(($0 as? Operation)!.operation) })
        }
        
        return false
    }
    
    // Determine if the value is an expression with a certain function
    func hasFunction(_ functions: [FunctionType]) -> Bool {
        
        // Determine if the expression contains the function with the correct number of arguments
        if let expression = self as? Expression {
            return expression.value.contains(where: { $0 is Function && functions.contains(($0 as! Function).function) && expression.value.count == ($0 as! Function).arguments+1 })
        }
        
        return false
    }
}

