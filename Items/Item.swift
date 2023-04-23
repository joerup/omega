//
//  Value.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 11/9/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation
import CryptoKit

// MARK: - Item
class Item: Equatable, Identifiable {
    
    var id = UUID()
    
    var highlighted: Bool = false
    
    var text: String {
        
        if let number = self as? Number {
            return number.string
        }
        else if let letter = self as? Letter {
            return (letter.type == .constant ? "¶" : "»")+letter.name
        }
        else if let unit = self as? Unit {
            return "_"+unit.symbol
        }
        else if let expression = self as? Expression {
            return Item.printQueue(expression.value, brackets: expression.parentheses ? ["(",")"] : ["[","]"])
        }
        else if let operation = self as? Operation {
            return operation.operation.rawValue
        }
        else if let function = self as? Function {
            return function.function.rawValue
        }
        else if let modifier = self as? Modifier {
            return modifier.modifier.rawValue
        }
        else if let parentheses = self as? Parentheses {
            return parentheses.display
        }
        else if let placeholder = self as? Placeholder {
            return placeholder.string
        }
        else if let pointer = self as? Pointer {
            return pointer.string
        }
        else if let _ = self as? Error {
            return "ERROR"
        }
        return ""
    }
    
    var raw: String {
        
        if let number = self as? Number {
            return "number,double:\(number.double),string:\(number.string),negative:\(String(number.negative))"
        }
        else if let letter = self as? Letter {
            return "letter,name:\(letter.name),type:\(letter.type.rawValue),value:”\(letter.value?.items.map{ $0.raw }.joined(separator: " ") ?? "")’"
        }
        else if let unit = self as? Unit {
            return "unit,symbol:\(unit.symbol),name:\(unit.name)"
        }
        else if let expression = self as? Expression {
            return "expression,value:”\(expression.value.map{ $0.raw }.joined(separator: " "))’,type:\(expression.grouping.rawValue),pattern:\(expression.pattern.rawValue)"
        }
        else if let operation = self as? Operation {
            return "operation,type:\(operation.operation.rawValue)"
        }
        else if let function = self as? Function {
            return "function,type:\(function.function.rawValue)"
        }
        else if let modifier = self as? Modifier {
            return "modifier,type:\(modifier.modifier.rawValue)"
        }
        else if let _ = self as? Parentheses {
            return "parentheses"
        }
        else if let _ = self as? Pointer {
            return "pointer"
        }
        else if let _ = self as? Placeholder {
            return "placeholder"
        }
        else if let _ = self as? Error {
            return "error"
        }
        return ""
    }
    
    func highlight() {
        self.highlighted.toggle()
        if let expression = self as? Expression {
            expression.value.forEach { $0.highlight() }
        }
    }
    
    func simplify() -> Value? {
        
        guard self is Value else { return nil }
        
        // Simplify the value
        let result = Queue([self]).simplify().items
        
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
    
    public static func printQueue(_ queue: [Item], brackets: [String] = ["〈","〉"]) -> String {
        
        var expression = brackets[0] + " "
        
        for item in queue {
            expression += item.text + " "
        }
        
        return expression + brackets[1]
    }
    
    static func == (a: Item, b: Item) -> Bool {
        if let a = a as? Number, let b = b as? Number {
            return a.string == b.string
        }
        else if let a = a as? Letter, let b = b as? Letter {
            return a.name == b.name
        }
        else if let a = a as? Unit, let b = b as? Unit {
            return a.name == b.name
        }
        else if let a = a as? Expression, let b = b as? Expression {
            return a.value == b.value
        }
        else if let a = a as? Operation, let b = b as? Operation {
            return a.operation == b.operation
        }
        else if let a = a as? Function, let b = b as? Function {
            return a.function == b.function
        }
        else if let a = a as? Modifier, let b = b as? Modifier {
            return a.modifier == b.modifier
        }
        else if let a = a as? Parentheses, let b = b as? Parentheses {
            return a.grouping == b.grouping
        }
        else if a is Placeholder && b is Placeholder {
            return true
        }
        else if a is Pointer && b is Pointer {
            return true
        }
        else if a is Error && b is Error {
            return true
        }
        return false
    }
    
    // Split Raw String
    static func splitRawString(_ rawString: String) -> [String:String] {
        
        var string = rawString
        var stringDictionary: [String:String] = [:]
        var currentKey = "item"
        var currentValue = ""
        
        var value: Bool = true
        var brackets = 0
        while !string.isEmpty {
            
            if string.first == ":" && brackets == 0 {
                value = true
            }
            else if string.first == "," && brackets == 0 && !currentKey.isEmpty && !currentValue.isEmpty {
                stringDictionary[currentKey] = currentValue
                currentKey.removeAll()
                currentValue.removeAll()
                value = false
            }
            else if string.first == "”" {
                brackets += 1
                currentValue += ["”"]
            }
            else if string.first == "’" {
                brackets -= 1
                currentValue += ["’"]
            }
            else if let first = string.first {
                if value {
                    currentValue += [first]
                } else {
                    currentKey += [first]
                }
            }
            
            string.removeFirst()
        }
        
        if !currentKey.isEmpty && !currentValue.isEmpty {
            stringDictionary[currentKey] = currentValue
        }
        
        return stringDictionary
    }
    
    // Convert Raw String Array
    static func convertRawStringArray(_ rawStringArray: String, resetStored: Bool = false) -> Queue? {
        
        var string = rawStringArray
        guard string.first == "”" && string.last == "’" && string.count > 2 else { return nil }
        
        string.removeFirst()
        string.removeLast()
        
        var stringArray: [String] = []
        var currentString = ""
        
        var brackets = 0
        while !string.isEmpty {
            
            if string.first == " " && brackets == 0 {
                stringArray += [currentString]
                currentString.removeAll()
            }
            else if string.first == "”" {
                brackets += 1
                currentString += ["”"]
            }
            else if string.first == "’" {
                brackets -= 1
                currentString += ["’"]
            }
            else if let first = string.first {
                currentString += [first]
            }
            
            string.removeFirst()
        }
        
        if !currentString.isEmpty {
            stringArray += [currentString]
        }
        
        return Queue(raw: stringArray, resetStored: resetStored)
    }
    
    // Display Parentheses
    static func displayParentheses(expression: Expression, inside: Bool = false, prev: Item, prev2: Item, prev3: Item, prev4: Item, next: Item, lastNonValue: NonValue? = nil, nextNonValue: NonValue? = nil) -> Bool {
        
        // Parentheses
        if expression.parentheses {
            return true
        }
        // Cannot enter
        if !expression.canEnter {
            return false
        }
        // Bound grouping
        if expression.grouping == .bound {
            return false
        }
        // Another expression inside
        if expression.queue.final.count == 1 && expression.value.contains(where: { ($0 as? Expression)?.parentheses ?? false }) || expression.value.first is Parentheses && (expression.value.first as! Parentheses).visible && (expression.value.first as! Parentheses).open && expression.value.last is Parentheses && (expression.value.last as! Parentheses).visible && (expression.value.last as! Parentheses).close {
            return false
        }
        // Number with connector
        else if !expression.pattern.stuck, expression.value.first is Number, (prev as? Operation)?.operation == .con {
            return true
        }
        // Before modifier
        else if next is Modifier {
            return true
        }
        // After absolute value
        else if (prev as? Function)?.function == .abs {
            return false
        }
        // Absolute value inside
        else if expression.queue.final.count == 2 && (expression.queue.final.items.first as? Function)?.function == .abs {
            return false
        }
        // Fake temporary parentheses with nonvalue before
        else if expression.grouping == .temporary, lastNonValue?.beforeFakePar ?? false {
            return !expression.smallEnoughLast(for: lastNonValue) || ((next as? Operation)?.operation == .con)
        }
        // Fake temporary parentheses with nonvalue after
        else if expression.grouping == .temporary, nextNonValue?.afterFakePar ?? false {
            return !expression.smallEnoughNext(for: nextNonValue) || ((expression.queue.final.items.count > 1 || expression.value.first is Number) && (prev as? Operation)?.operation == .con && (prev2 as? Number)?.string != "#-1") //|| ((prev as? Operation)?.operation == .con && prev2 is Expression && !((prev2 as! Expression).grouping == .temporary))
        }
        // Auto hidden parentheses function before
        else if expression.grouping == .hidden, (lastNonValue as? Function)?.autoHiddenPar ?? false {
            return !expression.smallEnoughLast(for: lastNonValue)
        }
        // Exponential Notation
        else if (lastNonValue as? Operation)?.operation == .exp && !Settings.settings.displayX10 {
            return !expression.smallGroup
        }
        // Other temporary or hidden
        else if expression.grouping == .temporary || expression.grouping == .hidden {
            return false
        }
        
        return !expression.smallGroup
    }
}
