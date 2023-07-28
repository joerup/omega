//
//  Queueing.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 11/19/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

extension Queue {
    
    // -------------------- //
    
    // MARK: - Regulate Queueing
    
    // -------------------- //
    
    // Ready Queueing
    func readyQueueing() {
        
        // Add an empty backspace state
        if empty {
            backspaceStates += [copyState()]
            undoStates += [copyState()]
        }
        
        // Remove highlighted region
        queue1.removeAll(where: { $0.highlighted })
        current.removeAll(where: { $0.highlighted })
        queue2.removeAll(where: { $0.highlighted })
        queue3.removeAll(where: { $0.highlighted })
        queue3.removeAll(where: { $0.highlighted })
        
        // If active placeholder at end of queue
        if let index = queue1.firstIndex(where: { $0 is Placeholder && ($0 as! Placeholder).active }) {
            
            // Set the placeholder
            let placeholder = queue1[index] as! Placeholder

            // Split the queue
            splitQueue(index, gap: true)

            // Queue parentheses if indicated
            openParentheses(type: placeholder.grouping, pattern: placeholder.pattern)
            
        }
        // If active placeholder in current item
        else if current.contains(where: { $0 is Placeholder && ($0 as! Placeholder).active }) {

            // Queue the current item
            queueCurrent()

            // Attempt to ready queueing again
            readyQueueing()
            
        }
        // If active placeholder in second queue
        else if queue2.contains(where: { $0 is Placeholder && ($0 as! Placeholder).active }) {
            
            // Queue the current item
            queueCurrent(nextPlaceholder: true)
            
            // Combine the queues
            queue1 += queue2
            queue2.removeAll()
            
            // Attempt to ready queueing again
            readyQueueing()
            // if this breaks, just put all the contents of the first clause in here instead
        }
    }
    
    // -------------------- //
    
    // Finish Queueing
    func finishQueueing(backspace: Bool = true) {
        
        // Fix encroaching items
        fixEncroachingItems()
        
        // Construct items from variables
        constructItems()
        
        // Add current state to the backspace and undo states
        if backspace {
            backspaceStates += [copyState()]
            undoStates += [copyState()]
        }
        
        // Print the queue
        printQueue()
    }
    
    // -------------------- //
    
    // MARK: - Queueing Button Inputs
    
    // -------------------- //
    
    // MARK: Numbers
    func queue(_ number: InputNumber, _ pressType: PressType = .tap) {
        
        // Numbers - Digits 0 to 9
        // Initially added to the num variable until queued by another input
        // This makes it possible to add multiple digits to one number
        
        // Make a new num
        newNum(allowSoloNegative: true)
        
        // Exit the grouping
        exitGrouping(exitFunctions: false, noNumber: true)
        
        // Add implied multiplication
        impliedMultiplication()
        
        // Add parentheses if connector
        autoParentheses(numberInput: true)
        
        // Add the digit to the num
        num += number.rawValue
    }
    
    // -------------------- //
    
    // MARK: Number Formats
    func queue(_ format: InputNumberFormat, _ pressType: PressType = .tap) {
        
        // Number Formats - Special characters to modify numbers
        // Decimal points, sign changes, vinculums
        
        // Decimal points
        if format == .dec {
            
            // Repeating decimal
            if pressType == .hold {
                queue(.vinc, pressType)
                return
            }
            
            // Make a new num
            newNum(allowSoloNegative: true)
            
            // Exit the grouping
            exitGrouping(exitFunctions: false, noNumber: true)
            
            // Add implied multiplication
            impliedMultiplication()
            
            // Add parentheses if connector
            autoParentheses(numberInput: true)
            
            // Make sure the lagging num does not have a decimal
            if queue2.isEmpty, let number = queue3.first as? Number {
                guard !number.string.contains(".") else { return }
            }
            
            // Add a zero if empty
            if num.isEmpty {
                num = "0."
            }
            
            // Add a decimal point to the num
            else if !num.contains(".") {
                num += format.rawValue
            }
        }
        
        // Sign changes
        else if format == .sign {
            
            // Continue any result
            continueResult()
            
            // Make a new num
            newNum(allowSoloNegative: false)
            
            // Exit the grouping
            exitGrouping(exitFunctions: false, noNumber: true)
            
            // Create parentheses if before power, before factorial
            if (queue2.first as? Operation)?.operation == .pow || [.fac,.dfac].contains((queue2.first as? Modifier)?.modifier) {
                openParentheses()
            }
            
            // If a negative ends the queue
            if (queue1.last as? Number)?.string == "#-1" {
                
                // Remove the negative
                queue1.removeLast()
                
                // Queue a placeholder
                queue1 += [Placeholder(true)]
            }
            else if let number = current.first as? Number, number.negative, !number.string.contains("#"), num.isEmpty {
                
                // Remove the negative
                current.removeFirst()
                
                // Add the positive number
                current = [Number(number.double)]+current
            }
            else {
                
                // Determine if a num is present
                let hadNum = !num.isEmpty
                
                // Exit the grouping if indicated
                exitGrouping(exitFunctions: true, notEmpty: true, endOnly: true)
                
                // Expand the current item
                expandCurrent(includeFunctions: pressType == .hold, unify: false, expandThird: num.isEmpty)
                
                // If there was a num
                if current.last is Number && hadNum && (current.count == 1 || pressType == .tap) {
                    
                    // Set the num
                    num = (current.last as! Number).string
                    current.removeLast()

                    // Add a negative to the number
                    if num.first != "-" {
                        num = "-"+num
                    }

                    // Or remove a negative from the number
                    else if num.first == "-" {
                        num.removeFirst()
                    }
                } else {
                    
                    // Add parentheses if connector
                    autoParentheses(numberInput: true)
                    
                    // If there is a current item
                    if !current.isEmpty {
                        
                        // If a number begins the current item in a connector
                        if current.count >= 2, let number = current[0] as? Number, (current[1] as? Operation)?.operation == .con {
                                
                            // Add the negative
                            current[0] = number * Number(-1)
                            
                            // Fix connectors of 1
                            if let newNumber = current[0] as? Number, newNumber.value == 1 {
                                if newNumber.negative {
                                    current[0] = Number("#-1")
                                } else {
                                    current.remove(at: 0)
                                    current.remove(at: 0)
                                    if current.count == 1, let expression = current[0] as? Expression, !expression.parentheses {
                                        current = expression.value
                                    }
                                }
                            }
                        }
                        // If a number begins the current item with a modifier or exponential
                        else if current.count >= 2, let number = current[0] as? Number, (current[1] is Modifier || (current[1] as? Operation)?.operation == .exp) {
                            
                            // Add the negative
                            current[0] = number * Number(-1)
                        }
                        else if !(current.count == 1 && (current[0] as? Number)?.negative ?? false) {
                            
                            // Add automatic parentheses
                            autoParentheses()
                            
                            // Add the negative
                            current = [Number("#-1"),Operation(.con)]+current
                        }
                    }
                    else {
                        // Add the negative
                        queue1 += [Number("#-1"),Placeholder(true)]
                    }
                }
            }
            
            // Queue a placeholder
            if queue1.last is Operation && current.isEmpty && num.isEmpty {
                queue1 += [Placeholder(true)]
            }
        }
        
        // Vinculum
        else if format == .vinc {
            
            // Make sure there is a num which has a decimal point
            guard !num.isEmpty, num.contains("."), num.last != "." else { return }
                
            // Get the number of decimal places
            var decimalPlaces = 0
            var vincPlaces = 0
            var decIndex = num.index(after: num.firstIndex(of: ".")!)
            while decIndex < num.endIndex {
                if num[decIndex] == " ̅" {
                    vincPlaces += 1
                } else {
                    decimalPlaces += 1
                }
                decIndex = num.index(after: decIndex)
            }
            
            // Make sure there are more decimal places than vinculums
            guard decimalPlaces > vincPlaces else { return }
            
            // Make a new num
            newNum()
            
            // Add the vinculum to the number
            num += " ̅"
        }
    }
    
    // -------------------- //
    
    // MARK: Letters
    func queue(_ value: InputLetter, _ pressType: PressType = .tap) {
        
        // Letters - Other values such as variables and constants
        // Added along with multiplication or a connector if no operator specified
        
        // Set the letter
        var letterItem: Letter {
            if let last = queue1.last as? Parentheses, last.type == .bound {
                return Letter(value.rawValue, type: .bound)
            } else {
                return Letter(value.rawValue, type: .variable)
            }
        }
        
        // Exit the grouping
        exitGrouping(exitFunctions: false, notEmpty: true)
        
        // Expand the current item
        expandCurrent(unify: false)
        
        // Add automatic parentheses
        if !current.isEmpty || (queue1.last as? Number)?.string == "#-1" {
            autoParentheses()
        }
        
        // Queue the current item
        queueCurrent(nextPlaceholder: true, reset: true)
        
        // Add implied multiplication
        impliedMultiplication(connector: true)
        
        // Queue the letter
        current += [letterItem]
        
        // Move forward if bound inputted
        if letterItem.type == .bound {
            closeParentheses()
            if let expression = queue3.first as? Expression, expression.pattern == .stuckLeft {
                forward()
            }
        }
        
        // Next position
        nextPosition(nextPlaceholder: true)
        
        // Match all letters
        matchLetters(to: letterItem, usePrevious: true)
    }
    
    // -------------------- //
    
    // MARK: Units
    func queue(_ value: InputUnit, _ pressType: PressType = .tap) {
        
        // Units - Units to numerical values
        // Added only immediately after numbers
        
        // Set the unit
        let unitItem = Unit(symbol: value.name)
        
        // Exit the grouping
        exitGrouping(exitFunctions: false, notEmpty: true)
        
        // Expand the current item
        expandCurrent(unify: false)
        
        // Add automatic parentheses
        if !current.isEmpty || (queue1.last as? Number)?.string == "#-1" {
            autoParentheses()
        }
        
        // Queue the current item
        queueCurrent(nextPlaceholder: true, reset: true)
        
        // Add implied multiplication
        impliedMultiplication(connector: true)
        
        // Queue the unit
        current += [unitItem]
        
        // Next position
        nextPosition(nextPlaceholder: true)
    }
    
    // -------------------- //
    
    // MARK: Operations A
    func queue(_ operation: InputOperationA, _ pressType: PressType = .tap) {
        
        // Operations A - Simple two-value operations
        // Separates current item from everything else
        // Add, subtract, multiply, divide, etc.
        
        // Continue any result
        continueResult()
        
        // Exit the grouping
        exitGrouping()
        
        // Queue the current item
        queueCurrent()
        
        // Add a placeholder if negative present
        negativePlaceholder()
        
        // Set a placeholders if no value ready
        setPlaceholder()
        
        // Set the operation
        var operationType: OperationType {
            return OperationType.init(rawValue: operation.rawValue) ?? .add
        }
        
        // Queue the operation
        queue1 += [Operation(operationType)]
    }
    
    // -------------------- //
    
    // MARK: Operations B
    func queue(_ operation: InputOperationB, _ pressType: PressType = .tap) {
        
        // Operations B - Operations acting within a single current item
        // Goes AFTER current item (and adds extra items AFTER itself)
        // Powers, exponentials, cofficients, fractions, etc.
        
        // Set the operation
        var operationType: OperationType {
            if let type = OperationType.init(rawValue: operation.rawValue) {
                return type
            }
            switch operation {
            case .exp:
                return .exp
            case .nPr:
                return .nPr
            case .nCr:
                return .nCr
            case .mod:
                return .mod
            case .mix:
                return .con
            default:
                return .pow
            }
        }
        
        // Set the extra items
        var extra: [Item] {
            switch operation {
            case .squ:
                return [Expression([Number(2)], grouping: .temporary, pattern: .stuckLeft)]
            case .cube:
                return [Expression([Number(3)], grouping: .temporary, pattern: .stuckLeft)]
            case .inv:
                return [Expression([Number(-1)], grouping: .temporary, pattern: .stuckLeft)]
            case .pow, .frac, .nPr, .nCr, .mod:
                return [Placeholder(active: true, grouping: pressType == .hold ? .hidden : .temporary, pattern: .stuckLeft)]
            case .con:
                return [Placeholder(active: true)]
            case .mix:
                return [Placeholder(active: true, grouping: .temporary, pattern: .stuckRight), Operation(.fra), Placeholder(grouping: .temporary, pattern: .stuckLeft)]
            default:
                return [Placeholder(active: true, grouping: .temporary, pattern: .stuckLeft)]
            }
        }
        
        // Continue any result
        continueResult()
        
        // Exit the grouping
        exitGrouping(exitFunctions: operation == .con || pressType == .hold, endOnly: true)
        
        // Powers
        if operationType == .pow {
            
            // Expand the current item but separate connected terms
            expandCurrent(separateTerms: pressType == .tap, includeFunctions: pressType == .hold, pattern: .stuckRight)
            
            // Add automatic parentheses
            autoParentheses()
        }
        // Coefficients
        else if operationType == .con {
            
            // Not ready for operation
            if !readyForOperation() && operation != .mix {
                setPlaceholder(active: true)
                return
            }
            
            // Add a placeholder if negative present
            negativePlaceholder()
            
            // Expand the current item but separate connected terms
            expandCurrent(separateTerms: true, unify: false)
        }
        // Fractions/Exponentials/Modulo
        else if [.fra,.exp,.mod].contains(operationType) {
            
            // Expand the current item if there is no num or the button was held
            expandCurrent(includeFunctions: pressType == .hold, pattern: .stuckRight)
            
            // Add automatic parentheses
            autoParentheses()
        }
        // Other
        else {
            
            // Expand the current item
            expandCurrent(includeFunctions: pressType == .hold, pattern: .stuckRight)
            
            // Add automatic parentheses
            autoParentheses()
        }
        
        // Queue the current item
        queueCurrent()
        
        // Get the extra items
        let extraItems = extra
        
        // Set a placeholders if no value ready
        setPlaceholder(active: true, grouping: [.fra,.nPr,.nCr].contains(operationType) ? .hidden : .temporary, pattern: .stuckRight, deactivate: extraItems)
        
        // Queue the operation
        queue1 += [Operation(operationType)]
        
        // Queue the extra items
        queue1 += extraItems
    }
    
    // -------------------- //
    
    // MARK: Operations C
    func queue(_ operation: InputOperationC, _ pressType: PressType = .tap) {
        
        // Operations C - Operations acting within a single current item
        // Goes BEFORE current item (and adds extra items BEFORE itself)
        // Exponent bases, radicals, absolute value, etc.
        
        // Set the operation
        var operationType: OperationType {
            if let type = OperationType.init(rawValue: operation.rawValue) {
                return type
            }
            switch operation {
            case .sqrt, .cbrt, .nrt:
                return .rad
            default:
                return .pow
            }
        }
        
        // Set the extra items
        var extra: [Item] {
            switch operation {
            case .sqrt:
                return [Expression([Number("#2")], grouping: .temporary, pattern: .stuckRight)]
            case .cbrt:
                return [Expression([Number(3)], grouping: .temporary, pattern: .stuckRight)]
            case .nrt:
                return [Placeholder(grouping: .temporary, pattern: .stuckRight)]
            case .b10:
                return [Expression([Number(10)], grouping: .temporary, pattern: .stuckRight)]
            case .b2:
                return [Expression([Number(2)], grouping: .temporary, pattern: .stuckRight)]
            case .be:
                return [Expression([Letter("e", type: .constant, value: Queue([Number(M_E)]))], grouping: .temporary, pattern: .stuckRight)]
            case .bn:
                return [Placeholder(grouping: .temporary, pattern: .stuckRight)]
            }
        }
        
        // Continue any result
        continueResult()
        
        // Exit the grouping
        exitGrouping(exitFunctions: pressType == .hold, notEmpty: pressType == .tap, endOnly: true)
        
        // Expand the current item but separate connected terms for radicals
        expandCurrent(separateTerms: operationType == .rad && pressType == .tap, includeFunctions: pressType == .hold, expandThird: true, pattern: .stuckLeft)
        
        // Add automatic parentheses - after connectors for numerical bases
        autoParentheses(afterCof: [.b10, .b2, .bn].contains(operation))
        
        // Add to queue if no current item
        if current.isEmpty {
            
            // Queue the extra items
            queue1 += extra
            
            // Activate the placeholder
            if queue1.last is Placeholder {
                (queue1[queue1.count-1] as! Placeholder).activate()
            }
            
            // Queue the operation
            queue1 += [Operation(operationType)]
            
            // Queue a placeholder
            queue1 += [Placeholder(active: !extra.contains(where: { $0 is Placeholder }), grouping: pressType == .hold ? .hidden : .temporary, pattern: .stuckLeft)]
        }
        
        // Add to current item
        else {
            
            // Add the operation
            current = [Operation(operationType)]+current
            
            // Add the extra items
            current = extra+current
            
            // Activate the placeholder
            if current.first is Placeholder {
                (current[0] as! Placeholder).activate()
            }
        }
    }
    
    // -------------------- //
    
    // MARK: Functions
    func queue(_ function: InputFunction, _ pressType: PressType = .tap) {
        
        // Functions - Different types of functions
        // Goes BEFORE current item (but might add extra items AFTER itself)
        // Logarithms, trig functions, rounding, etc.
        
        // Set the function
        var functionType: FunctionType {
            if let type = FunctionType.init(rawValue: function.rawValue) {
                return type
            }
            switch function {
            case .ln, .log2, .logn:
                return .log
            case .deriv, .deriv2, .derivn:
                return .valDeriv
            case .integ:
                return .definteg
            default:
                return .log
            }
        }
        
        // Set the extra items
        var extra: [Item] {
            var items: [Item] = Function.parameters(functionType)
            switch function {
            case .log:
                items[0] = Expression([Number("#10")], grouping: .hidden, pattern: .stuckLeft)
            case .ln:
                items[0] = Expression([Number("#e")], grouping: .hidden, pattern: .stuckLeft)
            case .log2:
                items[0] = Expression([Number(2)], grouping: .hidden, pattern: .stuckLeft)
            case .deriv:
                items[0] = Expression([Number("#1")], grouping: .hidden, pattern: .stuckLeft)
            case .deriv2:
                items[0] = Expression([Number(2)], grouping: .hidden, pattern: .stuckLeft)
            default:
                items += []
            }
            return items
        }
        
        // Continue any result
        continueResult()
        
        // Exit the grouping
        exitGrouping(exitFunctions: !(Function.trig+[.log]).contains(functionType) || pressType == .hold, notEmpty: pressType == .tap, endOnly: true)
        
        // Expand the current item
        expandCurrent(includeFunctions: !(Function.trig+[.log]).contains(functionType) || pressType == .hold, expandThird: true, pattern: .stuckLeft)
        
        // Add automatic parentheses
        autoParentheses()
        
        // Add to queue if no current item
        if current.isEmpty {
            
            // Queue the function
            queue1 += [Function(functionType)]
            
            // Queue the extra items
            queue1 += extra
            
            // Queue parentheses
            if pressType == .hold || settings.autoParFunction || Function.parenthesesFunctions.contains(functionType) {
                if let placeholderIndex = extra.firstIndex(where: { $0 is Placeholder && ($0 as! Placeholder).active }) {
                    (queue1[queue1.count - (extra.count-placeholderIndex)] as! Placeholder).grouping = function == .abs ? .hidden : .parentheses
                }
            }
            // Queue hidden parentheses
            else if Function.autoHiddenParFunctions.contains(functionType) {
                if let placeholderIndex = extra.firstIndex(where: { $0 is Placeholder && ($0 as! Placeholder).active }) {
                    (queue1[queue1.count - (extra.count-placeholderIndex)] as! Placeholder).grouping = .hidden
                }
            }
            // Queue temporary parentheses
            else {
                if let placeholderIndex = extra.firstIndex(where: { $0 is Placeholder && ($0 as! Placeholder).active }) {
                    (queue1[queue1.count - (extra.count-placeholderIndex)] as! Placeholder).grouping = .temporary
                }
            }
            
            // Activate the first placeholder
            if let placeholderIndex = extra.firstIndex(where: { $0 is Placeholder }), let placeholder = queue1[queue1.count - (extra.count-placeholderIndex)] as? Placeholder {
                deactivatePlaceholders()
                placeholder.activate()
            }
        }
        
        // Add to current item
        else {
            
            // Add parentheses if an expression is not already present
            if current.count == 1, let expression = current.first as? Expression {
                if (settings.autoParFunction || pressType == .hold || Function.parenthesesFunctions.contains(functionType)) {
                    expression.grouping = .parentheses
                } else if function == .abs {
                    expression.grouping = .hidden
                }
            }
            
            // Place the current item at the active placeholder in the extra items
            let placeholderIndex = extra.lastIndex(where: { $0 is Placeholder && ($0 as! Placeholder).active }) ?? extra.count-1
            current = extra[0 ..< placeholderIndex].map({$0}) + current + extra[placeholderIndex+1 ..< extra.count].map({$0})
            
            // Activate the first placeholder
            if let placeholderIndex = current.firstIndex(where: { $0 is Placeholder }) {
                (current[placeholderIndex] as! Placeholder).activate()
            }
            
            // Add the function
            current = [Function(functionType)]+current
        }
    }
    
    // -------------------- //
     
    // MARK: Modifiers
    func queue(_ modifier: InputModifier, _ pressType: PressType = .tap) {
        
        // Modifiers
        // Goes AFTER current item (but might add extra items BEFORE itself)
        // Percent, factorial, etc.
        
        // Set the modifier
        var modifierType: ModifierType {
            return ModifierType.init(rawValue: modifier.rawValue) ?? .fac
        }
        
        // Continue any result
        continueResult()
        
        // Exit the grouping
        exitGrouping(exitFunctions: false, notEmpty: true, endOnly: true)
            
        // Expand the current item
        expandCurrent(includeFunctions: pressType == .hold)
        
        // Add automatic parentheses
        autoParentheses()
        
        // Set a placeholders if no value ready
        setPlaceholder(active: true)
        
        // Add the modifier
        if queue1.last is Placeholder {
            queue1 += [Modifier(modifierType)]
        } else {
            current += [Modifier(modifierType)]
        }
    }
    
    // -------------------- //
    
    // MARK: Grouping
    func queue(_ grouping: InputGrouping, _ pressType: PressType = .tap) {
        
        // Grouping Symbols - Parentheses dictate precedence
        // Open parentheses are added to the queue directly, and everything inside it gets added right after
        // When a parenthetical expression is completed (closed), everything inside it is converted into an expression
        // The expression becomes the current item and its components are removed from the queue
        // This allows entire expressions to be manipulated as one after they are completed
        
        // Open Parenthesis
        if grouping == .open {
            
            // Exit the grouping
            exitGrouping(notEmpty: true)
            
            // Queue a new open parentheses
            if pressType == .tap {
                
                // Expand the current item
                expandCurrent(unify: false)
                
                // Add automatic parentheses
                if !current.isEmpty && !(queue1.last is Expression) || (queue1.last as? Number)?.string == "#-1" {
                    autoParentheses()
                }
                
                // Queue the current item
                queueCurrent()
                
                // Add implied multiplication
                impliedMultiplication(connector: true)
                
                // Open parentheses
                openParentheses()
            }
            
            // Put the entire queue in parentheses
            else if pressType == .hold {
                
                // Add a placeholder if negative present
                negativePlaceholder()
                
                // Open parentheses
                openParentheses(entireQueue: true)
            }
        }
        
        // Close Parenthesis
        if grouping == .close {
            
            // Continue any result
            continueResult()
            
            // Exit the grouping
            if queue2.contains(where: { $0 is Parentheses && ($0 as! Parentheses).close && ($0 as! Parentheses).type == .temporary }) {
                exitGrouping(notEmpty: true)
            }
            
            // If there is a parenthesis waiting to close
            if let closePar = queue2.first(where: { ($0 as? Parentheses)?.close ?? false }) as? Parentheses, closePar.visible {
                
                // Close the parentheses
                closeParentheses()
            }
            
            // If there is a parenthesis in the third queue waiting to close
            else if let closePar = queue3.first as? Parentheses, closePar.visible, closePar.close {
                
                // Move it over
                queue2 += [closePar]
                queue3.removeFirst()
                
                // Close the parentheses
                closeParentheses()
            }
            
            // Put the current item in an expression
            else {
                
                // Add a placeholder if negative present
                negativePlaceholder()
                
                // Expand the current item
                expandCurrent(separateTerms: pressType == .tap, includeFunctions: pressType == .hold, unify: false)
                
                // Open parentheses
                openParentheses()
            }
        }
    }
    
    // -------------------- //
    
    // MARK: - Helper Methods
    
    // -------------------- //
    
    // Complete Num
    func completeNum(replaceNegative: Bool = true) {
        
        // Add any num being created to the current item
        if !num.isEmpty {
            
            // Add negative placeholder
            if num == "-" && replaceNegative {
                queue1 += [Number("#-1")]
                negativePlaceholder()
            }
            // Add the num
            else {
                current += [Number(num)]
            }
            
            // Remove the num
            num = ""
        }
    }
    
    // -------------------- //
    
    // Queue Current
    func queueCurrent(replaceNegative: Bool = true, nextPlaceholder: Bool = false, reset: Bool = false) {
        
        // Add the current item to the queue
        
        // replaceNegative replaces a negative num with #-1 and a placeholder
        // nextPlaceholder means the queue will immediately find the next placeholder in the queue
        // reset calls a re-setup if something else is going to be inputted immediately
        
        // Complete any number
        completeNum(replaceNegative: replaceNegative)
        
        if !current.isEmpty {
            
            // Add the current to the queue
            queue1 += current
            current.removeAll()
            
            // Activate next placeholder/operation
            nextPosition(nextPlaceholder: nextPlaceholder, reset: reset)
        }
    }
    
    // -------------------- //
    
    // Open Parentheses
    func openParentheses(type: GroupingType = .parentheses, pattern: GroupingPattern = .none, entireQueue: Bool = false) {
        
        // Create a new parentheses expression
        
        guard type != .none else { return }
        
        // Make entire queue into expression
        if entireQueue {
            // Add open parentheses to the first queue
            queue1 = [Parentheses(.open, type, pattern)] + queue1
            // Add close parentheses to the second queue
            queue2 += [Parentheses(.close, type, pattern)]
        }
        // Make current item into expression
        else {
            // Add open parentheses to the first queue
            queue1 += [Parentheses(.open, type, pattern)]
            // Add close parentheses to the second queue
            queue2 = [Parentheses(.close, type, pattern)] + queue2
        }
    }
    
    // -------------------- //
    
    // Close Parentheses
    func closeParentheses(addPlaceholder: Bool = true) {
        
        // Complete a parentheses expression
        
        // addPlaceholder means a placeholder will be added if not ready to close
        
        // Find the close parenthesis
        if let parenthesesIndex = queue2.firstIndex(where: { ($0 as? Parentheses)?.grouping == .close }) {
            
            // Queue the current item
            queueCurrent()
            
            // Set the parentheses queue
            var parenthesesQueue: [Item] = []
            
            // Add everything before the parentheses in queue2
            var parIndex = parenthesesIndex-1
            while parIndex >= 0 {
                let item = queue2[parIndex]
                parenthesesQueue.insert(item, at: 0)
                parIndex -= 1
            }
            // Find the matching open parenthesis and add everything up to it in queue1
            parIndex = queue1.count-1
            while parIndex >= 0 {
                let item = queue1[parIndex]
                if (item as? Parentheses)?.grouping == .open {
                    break
                }
                parenthesesQueue.insert(item, at: 0)
                parIndex -= 1
            }
            // Set a placeholder if not ready for operation
            if !readyForOperation() && addPlaceholder {
                parenthesesQueue += [Placeholder()]
            }
            
            // Success - Open Parenthesis found
            // Create an expression
            if parIndex >= 0, let openPar = queue1[parIndex] as? Parentheses, !queue2.isEmpty {
                
                // Set the expression
                let expression = Expression(parenthesesQueue, grouping: openPar.type, pattern: openPar.pattern)
                
                // Remove the components from the queue
                queue1.removeSubrange(parIndex ..< queue1.count)
                
                // Remove the close par from the second queue
                queue2.removeSubrange(0 ... parenthesesIndex)
                
                // Add the expression to the current item
                current = [expression]
            }
            
            // Next position
            if addPlaceholder {
                nextPosition(nextPlaceholder: true)
            }
        }
    }
    
    // -------------------- //
    
    // Exit Grouping
    func exitGrouping(exitFunctions: Bool = true, notEmpty: Bool = false, endOnly: Bool = false, noNumber: Bool = false) {
        
        // allowFunctions means function grouping will be exited
        // notEmpty means grouping may not be empty in order to exit
        // endOnly means for fake par after nonvalue, this must be the end of the grouping in order to exit; for fake par before nonvalue, this must NOT be the end
        // noNumber means may only exit if there is not a number starting/ending the expression
        
        // Get the open parenthesis
        while let openParIndex = queue1.lastIndex(where: { $0 is Parentheses }), let openPar = queue1[openParIndex] as? Parentheses, openPar.type == .temporary, openPar.pattern.stuck {
            
            // Get the close parenthesis
            var queue: Int = 2
            var closeParIndex: Int? = nil
            if let index = queue2.firstIndex(where: { $0 is Parentheses }) {
                closeParIndex = index
            } else if let index = queue3.firstIndex(where: { $0 is Parentheses }) {
                closeParIndex = index
                queue = 3
            }
            guard let closeParIndex = closeParIndex else { return }
            let expression = Expression(Array(self.final.items[(openParIndex + 1)..<(self.firstHalf.items.count + (queue == 3 ? queue2.count : 0) + closeParIndex)]))
            
            // Get the last nonvalue causing the temporary parentheses
            if openPar.pattern == .stuckLeft, let nonValue = lastNonValue(before: openParIndex) {

                // Make sure the parentheses are invisible
                if nonValue.beforeFakePar, !expression.smallEnoughLast(for: nonValue) {
                    return
                }
                if nonValue is Function && !exitFunctions {
                    return
                }
            }
            // Get the next nonvalue causing the temporary parentheses
            else if openPar.pattern == .stuckRight, let nonValue = nextNonValue(after: closeParIndex, in: queue == 2 ? queue2+queue3 : queue3) {
                
                // Make sure the parentheses are invisible
                if nonValue.afterFakePar, !expression.smallEnoughNext(for: nonValue) {
                    return
                }
            }
            
            // Do not exit
            guard !settings.stayInGroups || lastNonValue(before: openParIndex)?.beforeFakePar ?? false || nextNonValue(after: closeParIndex, in: queue == 2 ? queue2+queue3 : queue3)?.afterFakePar ?? false else { return }
                
            // Make sure there is something inside
            guard !notEmpty || !current.isEmpty || !num.isEmpty || expression.value.contains(where: { !($0 is Placeholder) && ($0 as? Number)?.string != "#-1" }) else { return }
            
            // Make sure this is the end if indicated
            if endOnly {
                guard openPar.pattern != .stuckLeft || closeParIndex == 0 else { return }
                guard openPar.pattern != .stuckRight || (openParIndex == queue1.count-1 && current.isEmpty && num.isEmpty) else { return }
            }
            // Make sure there is a number
            if noNumber {
                guard !expression.value.isEmpty, !(expression.value.first is Number) else { return }
            }
            
            // Queue the current item
            queueCurrent(nextPlaceholder: false)
            
            // Close a stuck left expression
            if openPar.pattern == .stuckLeft {
                
                // Move the close parentheses to the beginning of the second queue
                if queue == 2 {
                    queue2.remove(at: closeParIndex)
                } else if queue == 3 {
                    queue3.remove(at: closeParIndex)
                }
                queue2 = [Parentheses(.close, openPar.type, openPar.pattern)] + queue2
                
                // Close parentheses
                closeParentheses()
            }
            
            // Close a stuck right expression
            else if openPar.pattern == .stuckRight {
                
                // Bring the contents of the expression to the front and close it
                if queue == 2 {
                    
                    // Already at the end
                    if closeParIndex == 0 {
                        
                        // Combine queues
                        combineQueues()
                        
                    } else {
                        
                        // Move the open parentheses to the end of the first queue
                        queue1.remove(at: openParIndex)
                        queue1 += [Parentheses(.open, openPar.type, openPar.pattern)]
                        
                        // Move the expression to the first queue
                        queue1 += queue2[0..<closeParIndex]
                        queue2.removeSubrange(0..<closeParIndex)
                        
                        // Close parentheses
                        closeParentheses(addPlaceholder: false)
                        
                        // Combine all the queues
                        combineQueues()
                    }
                    
                } else if queue == 3 {
                    
                    // Move the open parentheses to the end of the first queue
                    queue1.remove(at: openParIndex)
                    queue1 += [Parentheses(.open, openPar.type, openPar.pattern)]
                    
                    // Move the expression to the first queue and the close par to the second
                    queue1 += queue2 + queue3[0..<closeParIndex]
                    queue2 = [queue3[closeParIndex]]
                    queue3.removeSubrange(0...closeParIndex)
                    
                    // Close parentheses
                    closeParentheses(addPlaceholder: false)
                }
                
                // Move the completed expression to the third queue
                if let expression = current.first as? Expression {
                    if expression.value.isEmpty {
                        queue2 += [Placeholder(active: true, grouping: expression.grouping, pattern: expression.pattern)]
                    } else {
                        queue3.insert(expression, at: 0)
                    }
                    current.removeAll()
                }
            }
        }
    }
    
    // -------------------- //
    
    // Can Input
    func canInput(letter: Bool = false) -> Bool {
        
        var activePlaceholder: Placeholder? {
            if let placeholder = queue1.last(where: { $0 is Placeholder && ($0 as! Placeholder).active }) as? Placeholder {
                return placeholder
            } else if let placeholder = current.last(where: { $0 is Placeholder && ($0 as! Placeholder).active }) as? Placeholder {
                return placeholder
            } else if let placeholder = queue2.last(where: { $0 is Placeholder && ($0 as! Placeholder).active }) as? Placeholder {
                return placeholder
            }
            return nil
        }
        
        if !letter {
            // Bound placeholder - combine it
            if activePlaceholder?.grouping == .bound {
                deactivatePlaceholders()
                queueCurrent()
                combineQueues()
                return true
            }
            // Inside bound expression - cant do anything
            else if let lastParIndex = queue1.lastIndex(where: { $0 is Parentheses }), let lastPar = queue1[lastParIndex] as? Parentheses, lastPar.type == .bound {
                return false
            }
        }
        return true
    }
    
    // -------------------- //
    
    // Next Position
    func nextPosition(nextPlaceholder: Bool = false, reset: Bool = false) {
        
        // nextPlaceholder means placeholders are activated
        // reset means there is something that must be inputted on the placeholder NOW
        
        // Make sure there are no waiting parentheses or active placeholder already there
        guard !(queue1.contains(where: { $0 is Parentheses }) && (queue2.first as? Parentheses)?.grouping == .close ) else { return }
        if queue1.contains(where: { $0 is Placeholder && ($0 as! Placeholder).active }) { return }
        
        // Combine the queues if indicated
        if !nextPlaceholder {
            deactivatePlaceholders()
            queueCurrent()
            combineQueues()
        }
        
        // Activate the first placeholder or find the first operator
        var index = queue1.count
        let combinedQueues = queue1 + current + queue2
        
        while index < combinedQueues.count && index >= 0 {
            
            let item = combinedQueues[index]
            
            if let placeholder = item as? Placeholder {
                if nextPlaceholder {
                    placeholder.activate()
                    break
                }
            }
            else if let operation = item as? Operation, operation.isPrimary {
                queueCurrent()
                combineQueues()
                splitQueue(index)
                break
            }
            else if index == combinedQueues.count-1 {
                queueCurrent()
                combineQueues()
                break
            }
            
            index += 1
        }
        
        if reset {
            readyQueueing()
        }
    }
    
    // -------------------- //
    
    // Expand Current
    func expandCurrent(separateTerms: Bool = false, includeFunctions: Bool = false, unify: Bool = true, expandThird: Bool = false, pattern: GroupingPattern = .none) {
        
        // Determine which elements of the queue are part of the "current item" being operated on, and assign them to it
        // Then determine if the current item needs to be put into its own expression (parentheses)
        
        // separateTerms means each factor in the current item will be treated individually and will not be expanded to the whole term
        // includeFunctions means functions will be a part of the expansion
        // unify means any current item with more than a single item will be expanded; otherwise there can be exceptions (see below)
        // expandFirst means if there is no current item but the third queue has a value first, it will be expanded instead
        // pattern is the grouping pattern to apply to any resulting expression
        
        // Complete any number
        completeNum()
        
        // Make sure there is a current item present OR the last item in the queue is a value
        guard !current.isEmpty || queue1.last is Value || queue3.first is Value || queue3.first is Function else { return }
        var separateTerms = separateTerms
        
        // Determine if there is a bound variable
        let boundVar = current.count == 1 && current[0] is Letter && (current[0] as! Letter).type == .bound
        
        // Expand something in the third queue
        if expandThird, backspaceStates.count <= 1, queue2.isEmpty, queue3.first is Value || queue3.first is Function {
            
            // Queue the current item
            queueCurrent()
            
            // Implied multiplication
            impliedMultiplication(connector: true)
            separateTerms = true
            
            // Add the third queue items
            let thirdIndex = queue3.firstIndex(where: { ($0 as? Operation)?.isPrimary ?? false || $0 is Parentheses }) ?? queue3.count
            current += queue3[..<thirdIndex]
            queue3.removeSubrange(..<thirdIndex)
        }

        // Find the stopper - the previous A-type operator, modifier, parentheses, etc. in the queue
        // If using separate terms, connectors will count as A-type operators, and if including functions, functions will too
        var stopper: Int {
            var index = queue1.count - 1
            while index >= 0 {
                let item = queue1[index]
                if ([.add,.sub,.mlt,.div,.mod]+(separateTerms || boundVar ? [.con]:[])).contains((item as? Operation)?.operation) {
                    return index
                } else if item is Modifier || item is Parentheses {
                    return index
                } else if let function = item as? Function {
                    if index+function.arguments < queue1.count {
                        if !(includeFunctions || boundVar), !(queue1[index+function.arguments] is Expression), function.arguments > queue1.count-2-index, (Function.parameters(function.function)[queue1.count-2-index] as? Placeholder)?.grouping != .bound {
                            return index
                        }
                    } else if !(includeFunctions || boundVar) {
                        return index
                    }
                }
                else if (queue1.last as? Number)?.string == "#-1" {
                    return index
                }
                index -= 1
            }
            return -1
        }
        
        // Determine the number of items after the stopper
        // Increase the stopper index if the function has multiple arguments
        var last: Int {
            if stopper != -1, let function = queue1[stopper] as? Function {
                if queue1.last is Placeholder {
                    return queue1.count - stopper
                }
                return queue1.count - (stopper+function.arguments-1) - 1
            }
            return queue1.count - stopper - 1
        }
        
        // Add everything after the stopper to the current item
        if queue1.count >= last && last >= 0 {
            current = queue1.suffix(last) + current
            queue1.removeLast(last)
        }
        
        // Create an expression
        var expression: Bool {
            // Unify all if pattern is given
            if !current.isEmpty && pattern != .none {
                return true
            }
            // More than one item is present - unify or contain something OTHER THAN a connector/fraction/power/radical/exponential/absolute/percent
            if current.count > 1, unify || (current.contains(where: {($0 is Operation && ![.con,.fra,.pow,.rad,.exp].contains(($0 as! Operation).operation) || ($0 is Modifier && ![.pcent, .pmil].contains(($0 as! Modifier).modifier))) })) {
                return true
            }
            return false
        }
        if expression {
            current = [Expression(current, grouping: .temporary, pattern: pattern)]
        }
    }
    
    // -------------------- //
    
    // Automatic Parentheses
    func autoParentheses(numberInput: Bool = false, afterCof: Bool = false) {
        
        // Determine if open parentheses need to be be added at the end of the queue, and add them
        // This makes it possible to add more operators, functions, etc. within other ones
        
        // numberInput means a number is being inputted
        // afterCof means add parentheses after a connector
        
        var negative = false
        if (queue1.last as? Number)?.string == "#-1" {
            queue1.removeLast()
            negative = true
        }
        
        // Determine if parentheses must be added
        var addParentheses: Bool {
            
            // Find the last operation/function/parentheses in the queue
            let last = queue1.last(where: { $0 is NonValue })
            
            // Must be added after connector if a number is being inputted
            if numberInput {
                return (last as? Operation)?.operation == .con && current.isEmpty && (queue2.first as? Operation)?.operation != .rad
            }
            // Must be added before non-A-type operation in second queue
            else if queue2.first is Operation && ![.add,.sub,.mlt,.div,.mod].contains((queue2.first as! Operation).operation) {
                return true
            }
            // Must not be added before stuck grouping
            else if let expression = current.first as? Expression, expression.pattern.stuck {
                return false
            }
            // Must be added after connector if indicated and current is empty
            else if afterCof && current.isEmpty && num.isEmpty && (last as? Operation)?.operation == .con && (queue1.last(where: {$0 is Value}) as? Number)?.string != "#-1" {
                return true
            }
            // Must be added after operation (except A-type operations, only sometimes for division)
            else if last is Operation {
                return !([.add,.sub,.mlt,.div,.con,.mod]).contains((last as! Operation).operation)
            }
            // Must be added after functions only if function inputted
            else if last is Function && !(queue1.last is Expression) {
                return true
            }
            // Must not be added after open parentheses
            else if last is Parentheses {
                return false
            }
            
            // Make sure the queue has something in it
            guard !queue1.isEmpty else { return false }
            
            return true
        }
        
        // Add temporary parentheses to the queue
        if addParentheses {
            openParentheses(type: numberInput ? .parentheses : .temporary)
        }
        // Add a negative inside
        if negative {
            queue1 += [Number("#-1"),Operation(.con)]
        }
    }
    
    // -------------------- //
    
    // Implied Multiplication
    func impliedMultiplication(connector: Bool = false) {
        
        // Add an implied multiplication operator or connector if another operator/function is not present
        // Triggered when variables, numbers, parentheses, etc. are inputted without operators preceding them already
        
        // Test if the queue is ready for an operation
        if readyForOperation() && (num.isEmpty || num.last == " ̅") {
            
            // Make sure not invisible
            if let number = queue1.last as? Number, number.string.first == "#" {
                queue1.removeLast()
                return
            }
            
            // Exit the grouping
            exitGrouping(exitFunctions: false, notEmpty: true)
            
            // Queue the current item
            queueCurrent()
            
            // Add the operation
            queue1 += [Operation(connector ? .con : .mlt)]
        }
    }
    
    // -------------------- //
    
    // New Num
    func newNum(allowSoloNegative: Bool = false) {
        
        // Create a new num from a number in the queue
        
        // allowSoloNegative means "-" can be a num
        
        if let number = queue1.last as? Number, !(num.contains(".") && number.string.contains(".")) && !(number.string == "#-1" && num.isEmpty && !allowSoloNegative) {
            queue1.removeLast()
            if number.string == "#-1" {
                num = num.first != "-" ? ("-" + num) : String(num.dropFirst())
            } else if !num.contains("-") {
                num = number.string + num
            }
        }
    }
    
    // -------------------- //
    
    // Ready For Operation
    func readyForOperation(useCurrent: Bool = true) -> Bool {
        
        // Determine if the queue is ready for an operation to be entered
        
        // If a value is present, a modifier is present, a current item is present, ready (in most cases)
        if queue1.last is Value || queue1.last is Modifier || (useCurrent && (!current.isEmpty || !num.isEmpty)) {
            
            // If second queue does not have a value last (and there are no parentheses in the queue), not ready
            // When an operation is added, the second queue is re-queued unless there are parentheses
            if !queue2.isEmpty && !(queue2.last is Value) && !(queue1.contains(where: { $0 is Parentheses })) {
                return false
            }
            
            return true
        }
        
        return false
    }
    
    // -------------------- //
    
    // Modify Function
    func modifyFunction(operation: OperationType, extra: [Item] = [], beforeExp: Bool = false) -> Bool {
        
        // Expand current if expression comes after function at the end of the queue
        if beforeExp && queue1.count >= 2 && num.isEmpty && queue1.last is Expression && queue1[queue1.count-2] is Function {
            expandCurrent(unify: false)
        }
        
        // Function last in queue
        if let function = queue1.last as? Function, current.isEmpty, num.isEmpty {
            
            // New Function
            var newFunction = function.function
            
            // Change regular trig function to power function
            if operation == .pow, Function.regTrig.contains(function.function) {
                queue1.removeLast()
                newFunction = FunctionType.init(rawValue: function.function.rawValue+"p")!
                queue1 += [Function(newFunction)]
            } else {
                return false
            }
            
            // Add the extra items
            var parameters = Function.parameters(newFunction)
            for i in extra.indices {
                if i < parameters.count, extra[i] is Value {
                    parameters[i] = extra[i] as! Value
                }
            }
            
            // Add the parameters
            queue1 += parameters
            
            // Activate the first placeholder
            if let placeholderIndex = parameters.firstIndex(where: { $0 is Placeholder }) {
                (queue1[queue1.count - (parameters.count-placeholderIndex)] as! Placeholder).activate()
            }
            
            return true
        }
        
        // Function first in current
        else if !current.isEmpty, let function = current[0] as? Function {
            
            // Change regular trig function to power function
            if operation == .pow, Function.regTrig.contains(function.function), current.count == 2 {
                current.removeFirst()
                current = [Function(FunctionType.init(rawValue: function.function.rawValue+"p")!)]+current
            } else {
                return false
            }
            
            // Add the extra items
            current.insert(contentsOf: extra, at: 1)
            
            return true
        }
        
        return false
    }
    
    // -------------------- //
    
    // Get Queue Item
    func getQueueItem(_ index: [Int]) -> Item {
        
        var path = index
        
        guard !path.isEmpty else { return Item() }
        
        var queue: [Item] = queue1 + current + (num.isEmpty ? [] : [Number(num)]) + queue2 + queue3
        
        // Find the item in the queue
        var queueItem: Item? = nil
        while !path.isEmpty, path[0] < queue.count {
            let index = path[0]
            
            let item = queue[index]
            
            // Expression
            if let expression = item as? Expression {
                
                // Set the queue to the expression only
                queue = expression.value
                queueItem = item
                
                // Go to the next path index
                path.remove(at: 0)
            }
            // Item
            else {
                queueItem = item
                path.removeAll()
            }
        }
        
        return queueItem ?? Item()
    }
    
    // -------------------- //
    
    // Match Letters
    func matchLetters(to letter: Letter, usePrevious: Bool = false) {
        
        // Get all the individual letters with matching names
        let matchingLetters = allIndividualLetters.filter { $0.name == letter.name && $0.type != .dummy } + [letter]
        
        // Set the type and value
        var type = letter.type
        var value = letter.value
        
        // Bounds take priority
        if matchingLetters.contains(where: { $0.type == .bound }) {
            type = .bound
            value = nil
        }
        // Use previous
        else if usePrevious, let previous = matchingLetters.first {
            type = previous.type
            value = previous.value
        }
        
        // Set all matching letter types and values
        for matchingLetter in matchingLetters {
            matchingLetter.type = type
            matchingLetter.value = value
        }
        
        // Match any variables in the inputted letter's value
        if let value = letter.value, !value.allLetters.isEmpty {
            value.allLetters.forEach { matchLetters(to: $0, usePrevious: usePrevious) }
        }
    }
    
    // -------------------- //
    
    // Construct Items
    func constructItems() {
        
        // Remove invisible open par
        var tempParentheses: Parentheses? = nil
        if let parentheses = queue1.last as? Parentheses, parentheses.type == .temporary, parentheses.invisible {
            queue1.removeLast()
            tempParentheses = parentheses
        }
        
        // Letters
        if queue1.last is Letter, current.isEmpty, num.isEmpty {
            
            // Word
            var word = ""
            
            // Find a series of connected letters
            var index = queue1.count-1
            while index >= 0, let letter = queue1[index] as? Letter {
                // Add the letter
                word = letter.name + word
                index -= 1
                if index >= 0, let operation = queue1[index] as? Operation, operation.operation == .con {
                    index -= 1
                } else {
                    break
                }
            }
            
            // Replace word
            if index+1 < queue1.count {
                
                // Function
                if let function = InputFunction.init(word: word.lowercased()) {
                    
                    // Remove the word
                    queue1.removeSubrange((index+1)...)
                    current.removeAll()
                    backspaceStates.removeAll()
                    
                    // Return temp parentheses
                    if let tempParentheses = tempParentheses {
                        queue1 += [tempParentheses]
                    }
                    
                    // Queue the function
                    self.queue(function)
                    return
                }
                
                // Sqrt
                else if word.lowercased() == "sqrt" {
                    
                    // Remove the word
                    queue1.removeSubrange((index+1)...)
                    current.removeAll()
                    backspaceStates.removeAll()
                    
                    // Return temp parentheses
                    if let tempParentheses = tempParentheses {
                        queue1 += [tempParentheses]
                    }
                    
                    // Queue the square root
                    self.queue(.sqrt)
                    return
                }
                
                // Cbrt
                else if word.lowercased() == "cbrt" {
                    
                    // Remove the word
                    queue1.removeSubrange((index+1)...)
                    current.removeAll()
                    backspaceStates.removeAll()
                    
                    // Return temp parentheses
                    if let tempParentheses = tempParentheses {
                        queue1 += [tempParentheses]
                    }
                    
                    // Qeuue the cube root
                    self.queue(.cbrt)
                    return
                }
                
                // Exponential
                else if word.lowercased() == "exp" {
                    
                    // Remove the word
                    queue1.removeSubrange((index+1)...)
                    current.removeAll()
                    backspaceStates.removeAll()
                    
                    // Return temp parentheses
                    if let tempParentheses = tempParentheses {
                        queue1 += [tempParentheses]
                    }
                    
                    // Qeuue the exponential
                    self.queue(.exp)
                    return
                }
            }
        }
        
        // Return temp parentheses
        if let tempParentheses = tempParentheses {
            queue1 += [tempParentheses]
        }
    }
    
    // -------------------- //
    
    // Split Queue
    func splitQueue(_ index: Int, third: Bool = false, gap: Bool = false, midFirst: Bool = false) {
        
        // third means the second half will become the third queue
        // gap means the middle item will not be included
        // midFirst means the middle item, if included, goes with the first half
        
        // Set the sequence after the split
        var afterSplit: [Item] {
            let startIndex = gap || midFirst ? index+1 : index
            if startIndex < queue1.count {
                return queue1.suffix(from: startIndex).map{$0}
            }
            return []
        }
        
        // Add everything after the split to the second/third queue
        if third {
            queue3 = afterSplit + queue2 + queue3
            queue2 = []
        } else {
            queue2 = afterSplit + queue2
        }
        
        // Remove everything after the split from the queue
        let startIndex = midFirst ? index+1 : index
        if startIndex < queue1.count {
            queue1.removeSubrange(startIndex..<queue1.count)
        }
    }
    
    // -------------------- //
    
    // Combine Queues
    func combineQueues(insidePar: Bool = false, all: Bool = false, keepIntact: Bool = false) {
        
        // insidePar means intended to stay in parentheses
        // all means all three queues will be combined
        // keepIntact means nothing additional may be added to any queue
        
        // Combine the main queue with the second queue
        while queue2.count > 0 {
            // Set the item
            let item = queue2[0]
            // Break if only intended to stay within set of parentheses
            if (item as? Parentheses)?.grouping == .close {
                if insidePar {
                    break
                } else {
                    closeParentheses(addPlaceholder: !keepIntact)
                    queueCurrent()
                    continue
                }
            }
            // Add the item
            queue1 += [item]
            // Remove the item
            queue2.removeFirst()
        }
        
        // Combine the main queue with the third queue
        while all && queue3.count > 0 {
            // Set the item
            let item = queue3[0]
            // Break if only intended to stay within set of parentheses
            if (item as? Parentheses)?.grouping == .close {
                if insidePar {
                    break
                } else {
                    queue3.removeFirst()
                    queue2 = [item]
                    closeParentheses(addPlaceholder: !keepIntact)
                    queueCurrent()
                    continue
                }
            }
            // Add each item
            queue1 += [item]
            // Remove the item
            queue3.removeFirst()
        }
    }
    
    // -------------------- //
    
    // Fix Encroaching Items
    func fixEncroachingItems() {
        
        // Called after every input
        // Adjusts items encroach directly around the pointer
        
        // Format the lagging num
        if num.isEmpty && queue1.last is NonValue, queue2.isEmpty, let laggingNum = queue3.first as? Number {
            queue3[0] = Number(laggingNum.string)
        }
        
        // Remove a connector if last
        if current.isEmpty && num.isEmpty && queue1.last is Operation && (queue1.last as! Operation).operation == .con {
            queue1.removeLast()
        }
        // Remove a connector before temporary open par
        else if current.isEmpty && num.isEmpty, queue1.count >= 2, (queue1[queue1.count-2] as? Operation)?.operation == .con, let parentheses = queue1[queue1.count-1] as? Parentheses, parentheses.open, parentheses.type == .temporary, parentheses.pattern == .stuckRight {
            queue1.remove(at: queue1.count-2)
        }
        
        // Remove a connector if next
        if current.isEmpty, num.isEmpty && queue2.isEmpty && queue3.first is Operation && (queue3.first as! Operation).operation == .con {
            queue3.removeFirst()
        }
        
        // Add a placeholder if necessary
        if current.isEmpty && num.isEmpty && (queue2.isEmpty || queue2.first is Parentheses) && (
            ((queue1.last is Operation && !(queue1.last as! Operation).isPrimary || queue1.last is Function) && (queue2.first is Parentheses || queue3.first is Parentheses || queue3.isEmpty)) ||
            ((queue1.last is Operation || queue1.last is Function || queue1.last is Parentheses || queue1.isEmpty) && (queue3.first is Operation || queue3.first is Modifier))
        ) {
            queue1 += [Placeholder(true)]
        }
        
        // Remove empty invisible parentheses
        if current.isEmpty, num.isEmpty, let openPar = queue1.last as? Parentheses, openPar.invisible, let closePar = queue2.first as? Parentheses, closePar.invisible {
            queue1.removeLast()
            queue2.removeFirst()
            queue1 += [Placeholder(active: true, grouping: openPar.type, pattern: openPar.pattern)]
        }
        if current.isEmpty, num.isEmpty, let openPar = queue1.last as? Parentheses, openPar.invisible, queue2.isEmpty, let closePar = queue3.first as? Parentheses, closePar.invisible {
            queue1.removeLast()
            queue3.removeFirst()
            queue1 += [Placeholder(active: true, grouping: openPar.type, pattern: openPar.pattern)]
        }
        
        // Next item is an implicit temporary expression preceding function or operation - move
        if !queue3.isEmpty, current.isEmpty, num.isEmpty, let expression = queue3.first as? Expression, expression.grouping == .temporary, let nextNonValue = nextNonValue(after: 0, in: queue3), nextNonValue.afterFakePar, expression.smallEnoughNext(for: nextNonValue) {
            queue3.removeFirst()
            openParentheses(type: expression.grouping, pattern: expression.pattern)
            queue3.insert(contentsOf: expression.value + queue2, at: 0)
            queue2.removeAll()  
        }
    }
    
    // Connect Adjacent Items
    func connectAdjacentItems(queue: [Item]) -> [Item] {
        
        // Called only after jumping and after pressing enter
        // Makes sure adjacent items NOT around pointer are compatible and will not cause error
        // Connects incompatable items that are now adjacent as a result of pointer jumping elsewhere
        
        var queue = queue
        var index = 0
        
        while index < queue.count {
            
            let item = queue[index]
            let next = index+1 < queue.count ? queue[index+1] : Item()
            
            // Connect expression
            if let expression = item as? Expression {
                
                // Connect adjacent items
                expression.queue = Queue(connectAdjacentItems(queue: expression.value))
                
                // Stuck right expressions only
                if expression.pattern == .stuckRight {
                    
                    // Remove expressions with their stickies gone
                    if let nextNonValue = nextNonValue(after: index, in: queue) {
                        if !(nextNonValue is Operation && !(nextNonValue as! Operation).isPrimary) {
                            queue.remove(at: index)
                            queue.insert(contentsOf: expression.value, at: index)
                        }
                    } else {
                        queue.remove(at: index)
                        queue.insert(contentsOf: expression.value, at: index)
                    }
                }
            }
            
            // Do not combine if item is stuck
            if (item as? Expression)?.pattern == .stuckRight || (item as? Parentheses)?.pattern == .stuckRight || (item as? Placeholder)?.pattern == .stuckRight {
                index += 1
                continue
            }
            if (next as? Expression)?.pattern == .stuckLeft || (next as? Parentheses)?.pattern == .stuckLeft || (next as? Placeholder)?.pattern == .stuckLeft {
                index += 1
                continue
            }
             
            // Combine numbers
            if let num1 = item as? Number, let num2 = next as? Number, !(num1.string.contains(".") && num2.string.contains(".")) {
                // Connect
                if num1.string.contains("#") {
                    queue.insert(Operation(.con), at: index+1)
                }
                // Multiply
                else if num2.string.contains("#") || num2.string.first == "-" {
                    queue.insert(Operation(.mlt), at: index+1)
                }
                // Combine the numbers
                else {
                    queue.remove(at: index+1)
                    queue[index] = Number(num1.string + num2.string, format: false)
                    index -= 1
                }
            }
            // Add connector
            else if item is Value && (next is Letter || next is Expression || next is Function || (next is Parentheses && (next as! Parentheses).open)) {
                queue.insert(Operation(.con), at: index+1)
            }
            // Add multiplication
            else if item is Value && next is Number || item is Modifier && next is Value || item is Value && next is Letter {
                queue.insert(Operation(.mlt), at: index+1)
            }
            
            // Add multiplication for unintended mixed number
            let next1 = index+1 < queue.count ? queue[index+1] : nil
            let next2 = index+2 < queue.count ? queue[index+2] : nil
            let next3 = index+3 < queue.count ? queue[index+3] : nil
            if let next1, let next2, let next3, item is Value && !(item as! Value).isSingleValue && next1 is Operation && (next1 as! Operation).operation == .con && next2 is Value && next3 is Operation && (next3 as! Operation).operation == .fra {
                queue[index+1] = Operation(.mlt)
            }
            
            // Change connector to multiplication
            if let next1, let next2, item is Number && next2 is Number && next1 is Operation && (next1 as! Operation).operation == .con {
                queue[index+1] = Operation(.mlt)
            }
            
            index += 1
        }
        
        return queue
    }
    
    // -------------------- //
    
    // Set a placeholder and move on
    func setPlaceholder(active: Bool = false, grouping: GroupingType = .none, pattern: GroupingPattern = .none, deactivate: [Item] = []) {
        
        // Make sure the queue is NOT ready for operation
        guard !readyForOperation() else { return }
        
        // Deactivate other placeholders
        deactivate.filter { $0 is Placeholder }.forEach { ($0 as! Placeholder).deactivate() }
        
        // Add a placeholder
        queue1 += [Placeholder(active: active, grouping: grouping, pattern: pattern)]
        
        // Combine the queues
        combineQueues(insidePar: true)
    }
    
    // -------------------- //
    
    // Set a placeholder if negative present
    func negativePlaceholder() {
        if (queue1.last as? Number)?.string == "#-1" {
            queue1 += [Placeholder()]
        }
    }
    
    // -------------------- //
    
    // Continue Result
    func continueResult() {
        
        // Set the current item to the result being displayed so it can be operated on further
        if empty, undoStates.count <= 1, let calculation = Calculation.last {
            
            guard !calculation.result.error else { return }
            
            if calculation.showResult {
                current = calculation.result.items
            } else {
                current = calculation.queue.items
            }
            
            // Add current state to the backspace and undo states
            backspaceStates += [copyState()]
            undoStates += [copyState()]
        }
    }
}
