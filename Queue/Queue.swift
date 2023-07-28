//
//  Queue.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/20/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

class Queue: ObservableObject, Equatable {
    
    @ObservedObject var settings = Settings.settings
    
    var id = UUID()
    
    var queue1: [Item] = []
    var queue2: [Item] = []
    var queue3: [Item] = []
    var current: [Item] = []
    var num: String = ""
    
    var items: [Item] {
        if editing, (queue1+current+queue2+queue3).contains(where: { $0 is Placeholder && ($0 as! Placeholder).active }) {
            return queue1 + current + (num.isEmpty ? []:[Number(num)]) + queue2 + queue3
        }
        return queue1 + current + (num.isEmpty ? []:[Number(num)]) + (editing ? [Pointer()]:[]) + queue2 + queue3
    }
    var raw: [String] {
        return items.map { $0.raw }
    }
    var strings: [String] {
        return convertItems().strings
    }
    var map: [[Int]] {
        return convertItems().map
    }
    var final: Queue {
        return Queue(items.filter { !($0 is Pointer) })
    }
    var firstHalf: Queue {
        return Queue(queue1 + current + (num.isEmpty ? []:[Number(num)]))
    }
    
    var backspaceStates: [Queue] = []
    var undoStates: [Queue] = []
    
    var modes: ModeSettings = Settings.settings.modes
    
    var editing: Bool
    
    var empty: Bool {
        return queue1.isEmpty && queue2.isEmpty && queue3.isEmpty && current.isEmpty && num.isEmpty
    }
    var count: Int {
        return final.items.count
    }
    var error: Bool {
        return count == 1 && final.items.first is Error
    }
    func placeholderIsActive() -> Bool {
        return items.contains(where: { $0 is Placeholder && ($0 as! Placeholder).active || $0 is Expression && ($0 as! Expression).queue.placeholderIsActive() })
    }
    func copyState() -> Queue {
        return Queue(queue1: queue1, queue2: queue2, queue3: queue3, current: current, num: num, modes: modes)
    }
    func combined() -> Queue {
        let queue = self.copyState()
        queue.enter()
        return queue
    }
    static func == (a: Queue, b: Queue) -> Bool {
        return a.id == b.id && a.items == b.items
    }
    
    // -------------------- //
    
    // MARK: Initializers
    // Initialize the queue
    
    // -------------------- //
    
    init() {
        self.queue1 = []
        self.editing = true
    }
    
    init(_ items: [Item], modes: ModeSettings? = nil) {
        self.queue1 = items
        self.modes = modes ?? Settings.settings.modes
        self.editing = false
    }
    
    init(queue1: [Item], queue2: [Item], queue3: [Item], current: [Item], num: String, modes: ModeSettings) {
        self.queue1 = queue1
        self.queue2 = queue2
        self.queue3 = queue3
        self.current = current
        self.num = num
        self.modes = modes
        self.editing = true
    }
    
    // -------------------- //
    
    // MARK: Raw Initializer
    // Initialize queue items from raw items
    
    // -------------------- //

    init(raw: [String], modes: ModeSettings = Settings.settings.modes, resetStored: Bool = false) {
        
        var queue: [Item] = []
        let rawItems = raw.map { Item.splitRawString($0) }
        
        for rawItem in rawItems {
            if let item = rawItem["item"] {
                switch item {
                case "number":
                    queue += [Number(raw: rawItem)]
                case "letter":
                    queue += [Letter(raw: rawItem, resetStored: resetStored)]
                case "unit":
                    queue += [Unit(raw: rawItem)]
                case "expression":
                    queue += [Expression(raw: rawItem)]
                case "operation":
                    queue += [Operation(raw: rawItem)]
                case "function":
                    queue += [Function(raw: rawItem)]
                case "modifier":
                    queue += [Modifier(raw: rawItem)]
                default:
                    queue += []
                }
            }
        }
        
        self.queue1 = queue
        self.editing = false
        self.setModes(to: modes)
    }
    
    // -------------------- //
    
    // MARK: Letters
    // List of all constants and variables in the queue
    
    // -------------------- //
    
    var letters: [Letter] {
        
        var letters: [Letter] = []
        
        for item in items {
            if let letter = item as? Letter {
                if !letters.contains(where: { $0.name == letter.name }) {
                    letters += [letter]
                }
            }
            else if let expression = item as? Expression {
                for letter in Queue(expression.value).letters {
                    if !letters.contains(where: { $0.name == letter.name }) {
                        letters += [letter]
                    }
                }
            }
        }
        return letters
    }
    
    var variables: [Letter] {
        return letters.filter { $0.type == .variable }
    }
    var constants: [Letter] {
        return letters.filter { $0.type == .constant }
    }
    var bounds: [Letter] {
        return letters.filter { $0.type == .bound }
    }
    var dummies: [Letter] {
        return letters.filter { $0.type == .dummy }
    }
    
    var allLetters: [Letter] {
        var letters = letters
        var substituted = self
        while !substituted.letters.filter({ $0.storedValue && !$0.systemConstant }).isEmpty {
            substituted = substituted.substituted
            for letter in (substituted.letters) {
                if !letters.contains(letter) {
                    letters += [letter]
                }
            }
        }
        return letters
    }
    
    var allVariables: [Letter] {
        return allLetters.filter { $0.type == .variable }
    }
    var allConstants: [Letter] {
        return allLetters.filter { $0.type == .constant }
    }
    var allBounds: [Letter] {
        return allLetters.filter { $0.type == .bound }
    }
    var allDummies: [Letter] {
        return allLetters.filter { $0.type == .dummy }
    }
    
    // Whereas the others return only one variable of each name,
    // this returns every single one - useful for matching purposes
    var allIndividualLetters: [Letter] {
        var letters: [Letter] = []
        
        for item in items {
            if let letter = item as? Letter {
                letters += [letter] + (letter.value?.allIndividualLetters ?? [])
            } else if let expression = item as? Expression {
                letters += Queue(expression.value).allIndividualLetters
            }
        }
        return letters
    }
    
    // -------------------- //
    
    // MARK: Units
    // List of all units
    
    // -------------------- //
    
    func otherUnits() -> [Queue] {
        
        var queues: [Queue] = []
        
        for i in items.indices {

            if let unit = items[i] as? Unit {
                for otherUnit in unit.otherUnits {
                    var replacement = items
                    replacement[i] = Expression(unit.convert(to: otherUnit))
                    queues.append(Queue(replacement).simplify(roundPlaces: 5))
                }
            }
            else if let expression = items[i] as? Expression {
                for conversion in expression.queue.otherUnits() {
                    var replacement = items
                    replacement[i] = Expression(conversion)
                    queues.append(Queue(replacement).simplify(roundPlaces: 5))
                }
            }
        }
        
        return queues
    }
    
    // -------------------- //
    
    // MARK: Modes
    // Set the modes
    
    // -------------------- //
    
    func setModes(to modes: ModeSettings) {
        
        // Set the modes
        self.modes = modes
        
        // Set the letter value modes
        self.items.filter { $0 is Letter }.forEach { ($0 as! Letter).value?.setModes(to: modes) }
        
        // Set the expression modes
        self.items.filter { $0 is Expression }.forEach { ($0 as! Expression).queue.setModes(to: modes) }
    }
    
    // -------------------- //
    
    // MARK: Substitute
    // Substitute a value for some letter
    
    // -------------------- //
    
    func substitute(_ variable: Letter, with value: Value) -> Queue {
        
        var items: [Item] = items
        
        // Loop through the items
        var index = 0
        while index < items.count {
            
            let item = items[index]
            
            // Variable matches
            if let itemVariable = item as? Letter, itemVariable == variable {
                items[index] = value
            }
            // Variable value contains match
            else if let itemVariable = item as? Letter, itemVariable.storedValue {
                items[index] = Letter(itemVariable.name, type: itemVariable.type, value: itemVariable.value!.substitute(variable, with: value))
            }
            // Expression - recursive call
            else if let expression = item as? Expression {
                items[index] = Expression(expression.queue.substitute(variable, with: value), grouping: expression.grouping, pattern: expression.pattern)
            }
            
            index += 1
        }
        
        return Queue(items, modes: modes)
    }
    
    // -------------------- //
    
    // MARK: Substituted
    // Queue with letter values subsituted in
    
    // -------------------- //
    
    var substituted: Queue {
        
        var items: [Item] = items
        
        // Replace all letters with their values
        for i in items.indices {
            if let variable = items[i] as? Letter, variable.storedValue, !variable.systemConstant {
                items[i] = Expression(variable.value!.items)
            }
            else if let expression = items[i] as? Expression {
                items[i] = Expression(Queue(expression.value).substituted.items, grouping: expression.grouping, pattern: expression.pattern)
            }
        }
        
        return Queue(items, modes: modes)
    }
    
    // -------------------- //
    
    // MARK: Accessors
    // Accessors to find specific queue items
    
    // --------------------- //
    
    func lastNonValue(before index: Int) -> NonValue? {
        guard index > 0 && index < queue1.count else { return nil }
        var parentheses = 0
        for i in queue1[..<index].indices.reversed() {
            let item = queue1[i]
            if let item = item as? Parentheses {
                parentheses += item.open ? 1 : -1
            } else if let item = item as? NonValue, parentheses == 0 {
                return item
            }
        }
        return nil
    }
    
    func nextNonValue(after index: Int, in items: [Item]? = nil) -> NonValue? {
        guard index >= 0 && index+1 < (items ?? queue1).count else { return nil }
        return (items ?? queue1)[(index+1)...].first(where: { $0 is NonValue }) as? NonValue
    }
    
    func withoutExpressions() -> [Item] {
        var items: [Item] = []
        var parentheses = 0
        for item in self.items {
            if let item = item as? Parentheses {
                parentheses += item.open ? 1 : -1
            } else if parentheses == 0 && !(item is Expression) {
                items += [item]
            }
        }
        return items
    }
    
    // -------------------- //
    
    // MARK: Placeholders
    // Deactivation of placeholders
    
    // -------------------- //
    
    func deactivatePlaceholders() {
        
        for item in items {
            // Placeholder
            if let placeholder = item as? Placeholder, placeholder.active {
                placeholder.deactivate()
            }
            // Expression
            else if let expression = item as? Expression {
                let queue = expression.queue
                queue.deactivatePlaceholders()
                expression.queue = queue
            }
        }
    }
    
    // -------------------- //
    
    // MARK: Convert Items
    // Convert queue items to viewable formats
    
    // -------------------- //
    
    func convertItems() -> (strings: [String], map: [[Int]]) {
        
        var result: [String] = []
        var map: [[Int]] = []
        
        // Add items to queue
        var index = 0
        var i = 0
        while i < items.count {
            
            let item = items[i]
            
            if let number = item as? Number {
                result += [number.text]
                map += [[index]]
            }
            
            else if let variable = item as? Letter {
                result += [variable.text]
                map += [[index]]
            }
            
            else if let unit = item as? Unit {
                result += [unit.text]
                map += [[index]]
            }
            
            else if let placeholder = item as? Placeholder {
                if item is Pointer {
                    result += [placeholder.text]
                    map += [[]]
                    index -= 1
                }
                else if placeholder.grouping.visible {
                    result += ["(", placeholder.text, placeholder.active ? "\\)" : ")"]
                    map += [[index],[index],[index]]
                }
                else {
                    result += [placeholder.text]
                    map += [[index]]
                }
            }
            
            else if let expression = item as? Expression {
                
                let expressionData = expression.queue.convertItems()
                var displayParentheses: Bool {
                    if let finalIndex = final.items.firstIndex(where: { $0.id == item.id }) {
                        return Item.displayParentheses(
                            expression: expression,
                            inside: false,
                            prev: finalIndex-1 >= 0 ? final.items[finalIndex-1] : Item(),
                            prev2: finalIndex-2 >= 0 ? final.items[finalIndex-2] : Item(),
                            prev3: finalIndex-3 >= 0 ? final.items[finalIndex-3] : Item(),
                            prev4: finalIndex-4 >= 0 ? final.items[finalIndex-4] : Item(),
                            next: finalIndex+1 < final.items.count ? final.items[finalIndex+1] : Item(),
                            lastNonValue: final.lastNonValue(before: finalIndex),
                            nextNonValue: final.nextNonValue(after: finalIndex)
                        )
                    }
                    return true
                }
                
                if expression.parentheses || displayParentheses {
                    result += ["("]+expressionData.strings+[")"]
                } else {
                    result += ["#("]+expressionData.strings+["#)"]
                }
                map += [[index]]
                for mapIndex in expressionData.map {
                    map += mapIndex.isEmpty ? [[]] : [[index]+mapIndex]
                }
                map += [[index, ((expressionData.map.last(where: { !$0.isEmpty }) ?? [0]).first ?? 0)+1]]
            }
            
            else if let parentheses = item as? Parentheses, parentheses.grouping == .open {
                
                let openIndex = i
                var closeIndex = i
                
                var parenthesesCount = 0
                while i < items.count {
                    
                    let item = items[i]
                    
                    if let parentheses = item as? Parentheses {
                        if parentheses.grouping == .open {
                            parenthesesCount += 1
                        } else if parentheses.grouping == .close {
                            parenthesesCount -= 1
                        }
                    }
                    if parenthesesCount == 0 {
                        closeIndex = i
                        break
                    }
                    
                    i += 1
                }
                
                if closeIndex - openIndex > 0 {
                    
                    let expression = Expression(items[openIndex+1..<closeIndex].map{$0}, grouping: parentheses.type, pattern: parentheses.pattern)
                    let expressionData = expression.queue.convertItems()
                    
                    var displayParentheses: Bool {
                        if let finalOpenIndex = final.items.firstIndex(where: { $0.id == items[openIndex].id }), let finalCloseIndex = final.items.firstIndex(where: { $0.id == items[closeIndex].id }) {
                            return Item.displayParentheses(
                                expression: expression,
                                inside: true,
                                prev: finalOpenIndex-1 >= 0 ? final.items[finalOpenIndex-1] : Item(),
                                prev2: finalOpenIndex-2 >= 0 ? final.items[finalOpenIndex-2] : Item(),
                                prev3: finalOpenIndex-3 >= 0 ? final.items[finalOpenIndex-3] : Item(),
                                prev4: finalOpenIndex-4 >= 0 ? final.items[finalOpenIndex-4] : Item(),
                                next: finalCloseIndex+1 < final.items.count ? final.items[finalCloseIndex+1] : Item(),
                                lastNonValue: final.lastNonValue(before: finalOpenIndex),
                                nextNonValue: final.nextNonValue(after: finalCloseIndex)
                            )
                        }
                        return true
                    }
                    
                    if expression.parentheses || displayParentheses {
                        result += ["("]+expressionData.strings+["\\)"]
                    } else {
                        result += ["#("]+expressionData.strings+["#)"]
                    }
                    map += [[openIndex]]
                    for mapIndex in expressionData.map {
                        map += mapIndex.isEmpty ? [[]] : [[openIndex]+mapIndex]
                    }
                    map += [[openIndex, ((expressionData.map.last(where: { !$0.isEmpty }) ?? [0]).first ?? 0)+1]]
                }
            }
            
            else if let nonValue = item as? NonValue {
                result += [nonValue.text]
                map += [[index]]
            }
            
            else if let error = item as? Error {
                result += [error.text]
                map += [[index]]
            }
            
            i += 1
            index += 1
        }
        
        return (strings: result, map: map)
    }
    
    // -------------------- //
    
    // MARK: Export
    // Export to string
    
    // -------------------- //
    
    func exportString() -> String {

        var string = ""

        var index = 0
        while index < items.count {
            
            let item = items[index]
            let next = index+1 < items.count ? items[index+1] : nil
            let prev3 = index-3 >= 0 ? items[index-3] : nil
            
            // Expression
            if let expression = item as? Expression {
                guard expression.queue.exportString() != "" else { index += 1; continue }
                if !expression.singleGroup || expression.parentheses {
                    string += "(\(expression.queue.exportString()))"
                } else if self.lastNonValue(before: index) is Function && !(expression.value.count == 1 && expression.value.first is Expression) && expression.grouping != .bound {
                    string += "(\(expression.queue.exportString()))"
                } else {
                    string += expression.queue.exportString()
                }
            }
            // Letter
            else if let letter = item as? Letter {
                string += letter.name
            }
            // Unit
            else if let unit = item as? Unit {
                string += unit.symbol
            }
            // Number
            else if let number = item as? Number {
                if number.string == "#-1" {
                    string += "-"
                    if next?.text == "*" {
                        index += 1
                    }
                } else if !number.string.contains("#") {
                    string += number.text
                }
            }
            // Operation
            else if let operation = item as? Operation {
                if operation.isPrimary {
                    string += " "+operation.text+" "
                } else {
                    string += operation.text
                }
            }
            // Function
            else if let function = item as? Function {
                if function.text == "log" && next?.text.contains("#e") ?? false {
                    string += "ln"
                } else if function.text == "d/d|" {
                    string += "d/d"
                } else if function.text == "∫d" {
                    string += "∫"
                } else {
                    string += function.text
                }
            }
            // Modifier
            else if let modifier = item as? Modifier {
                string += modifier.text
            }
            
            // Assorted Additions
            if (prev3 as? Function)?.function == .definteg {
                string += "d"
            }
            if (prev3 as? Function)?.function == .valDeriv {
                string += "|"
            }
            
            index += 1
        }
        
        while string.first == " " {
            string.removeFirst()
        }
        while string.last == " " {
            string.removeLast()
        }

        return string
    }
    
    // -------------------- //
    
    // MARK: Print
    // Print the queue
    
    // -------------------- //
    
    func printQueue() {
        
        let queue1 = Item.printQueue(queue1)
        let queue2 = Item.printQueue(queue2)
        let queue3 = Item.printQueue(queue3)
        let current = Item.printQueue(current+(!num.isEmpty ? [Number(num, format: false)]:[]))
        
        print("\(queue1.isEmpty ? "" : queue1+" ")\(current.isEmpty ? "" : current+" ")\(queue2.isEmpty ? "" : queue2+" ")\(queue3.isEmpty ? "" : queue3)")
    }
}
