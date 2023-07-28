//
//  Inputting.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit
import CryptoKit
import AVFoundation

extension Queue {
    
    // -------------------- //
    
    // MARK: Button
    // Input a button
    
    // -------------------- //
    
    func button(_ button: InputButton, pressType: PressType) {
        
        var button = button
        
        // Make sure the button can be inputted
        guard canInput(letter: button.button is InputLetter) else { return }
        
        // Ready queueing
        readyQueueing()
        
        // Switch button
        if pressType == .hold && button.button.name == InputOperationA.mlt.name {
            button = InputButton(InputOperationB.con.name)
        }
        if pressType == .hold && button.button.name == InputOperationA.div.name {
            button = InputButton(InputOperationB.frac.name)
        }
        
        // Control
        if let button = button.button as? InputControl {
            switch button {
            case .clear:
                clear()
            case .backspace:
                backspace()
            case .enter:
                enter()
            case .forward:
                forward()
            case .backward:
                backward()
            case .nothing:
                print("hi")
            }
            finishQueueing(backspace: false)
            return
        }
        // Number
        else if let button = button.button as? InputNumber {
            queue(button, pressType)
        }
        // Number Format
        else if let button = button.button as? InputNumberFormat {
            queue(button, pressType)
        }
        // Value
        else if let button = button.button as? InputLetter {
            queue(button, pressType)
        }
        // Unit
        else if let button = button.button as? InputUnit {
            queue(button, pressType)
        }
        // Operation A
        else if let button = button.button as? InputOperationA {
            queue(button, pressType)
        }
        // Operation B
        else if let button = button.button as? InputOperationB {
            queue(button, pressType)
        }
        // Operation C
        else if let button = button.button as? InputOperationC {
            queue(button, pressType)
        }
        // Function
        else if let button = button.button as? InputFunction {
            queue(button, pressType)
        }
        // Modifier
        else if let button = button.button as? InputModifier {
            queue(button, pressType)
        }
        // Grouping
        else if let button = button.button as? InputGrouping {
            queue(button, pressType)
        }
        
        // Finish queueing
        finishQueueing()
    }
    
    // -------------------- //
    
    // MARK: Clear
    // Reset all properties of the queue
    
    // -------------------- //
    
    func clear() {
        queue1.removeAll()
        queue2.removeAll()
        queue3.removeAll()
        current.removeAll()
        num.removeAll()
        backspaceStates.removeAll()
        undoStates.removeAll()
        editing = true
    }
    
    // -------------------- //
    
    // MARK: Backspace
    // Return to the previous state or remove the last item
    
    // -------------------- //
    
    func backspace() {
        
        // --- Backspace States --- //
        
        // Remove the state
        if !backspaceStates.isEmpty {
            backspaceStates.removeLast()
        }
        
        // Set the current queues to the last state
        if let lastState = backspaceStates.last {
            
            // Reset the states
            self.queue1 = lastState.queue1
            self.queue2 = lastState.queue2
            self.queue3 = lastState.queue3
            self.current = lastState.current
            self.num = lastState.num
            
        }
        
        else {
        
            // --- Prepare --- //
            
            // Move current placeholder
            if current.count == 1, let placeholder = current.first as? Placeholder, placeholder.active {
                queue2 = current + queue2
                current.removeAll()
            }
            // Deactivate all other placeholders
            if !((queue1.last as? Placeholder)?.active ?? false) {
                deactivatePlaceholders()
            }
            // Remove invisible grouping
            if let expression = queue1.last as? Expression, !expression.canEnter {
                queue1.removeLast()
                if expression.pattern.stuck {
                    queue1 += [Placeholder(active: true, grouping: expression.grouping, pattern: expression.pattern)]
                }
            }
            // Exit grouping for invisible temporary stuck right open parentheses
            if let parentheses = queue1.last as? Parentheses, parentheses.open, parentheses.type == .temporary, parentheses.pattern == .stuckRight {
                exitGrouping()
            }
            
            // --- Backspace --- //
            
            // Remove a digit from num
            if !num.isEmpty {
                num.removeLast()
            }
            // Remove an item from current
            else if !current.isEmpty {
                current.removeLast()
            }
            // Make a number that comes last into a num
            else if let number = queue1.last as? Number {
                queue1.removeLast()
                if !number.string.contains("#") {
                    num = number.string
                    num.removeLast()
                }
            }
            // Enter an expression that comes last
            else if let expression = queue1.last as? Expression {
                // Remove entire bound expression
                queue1.removeLast()
                if expression.grouping != .bound {
                    openParentheses(type: expression.grouping, pattern: expression.pattern)
                    queue1 += expression.value
                } else {
                    queue1 += [Placeholder(active: true, grouping: expression.grouping, pattern: expression.pattern)]
                }
            }
            // Remove an operation that comes last but sometimes its first value
            else if let operation = queue1.last as? Operation {
                if operation.operation == .rad && queue1.count >= 2 {
                    if queue1[queue1.count-2] is Placeholder || !((queue1[queue1.count-2] as? Expression)?.canEnter ?? true) {
                        queue1.removeLast(2)
                    } else {
                        queue1[queue1.count-2] = Placeholder(true)
                    }
                } else {
                    queue1.removeLast()
                }
                if queue2.first is Placeholder {
                    queue2.removeFirst()
                }
            }
            // Remove a function that comes last along with its arguments
            else if let function = queue1.last as? Function {
                queue1.removeLast()
                if function.arguments <= queue2.count {
                    queue2.removeSubrange(..<function.arguments)
                }
                else if function.arguments <= queue2.count+queue3.count {
                    queue3.removeSubrange(..<(function.arguments-queue2.count))
                    queue2.removeAll()
                }
            }
            // Remove the entire following expression if open parentheses come last
            else if let parentheses = queue1.last as? Parentheses, parentheses.open {
                queue1.removeLast()
                if let closeParIndex = queue2.firstIndex(where: { $0 is Parentheses && ($0 as! Parentheses).close }) {
                    queue2.removeSubrange(...closeParIndex)
                } else if let closeParIndex = queue3.firstIndex(where: { $0 is Parentheses && ($0 as! Parentheses).close }) {
                    queue3.removeSubrange(...closeParIndex)
                }
                // Add stationary placeholder back
                if parentheses.pattern.stuck {
                    queue1 += [Placeholder(active: true, grouping: parentheses.type, pattern: parentheses.pattern)]
                }
            }
            // Modify a placeholder that comes last
            else if let placeholder = queue1.last as? Placeholder {
                if placeholder.pattern.stuck {
                    queue2 = [placeholder] + queue2
                }
                if placeholder.active {
                    queue1.removeLast()
                    backspace()
                } else {
                    queue1.removeLast()
                }
            }
            // Remove the last item
            else if !queue1.isEmpty {
                queue1.removeLast()
            }
            
            // --- Modify Leftovers --- //
            
            // Last item is an implicit temporary expression following function or operation - move
            if !queue1.isEmpty, current.isEmpty, num.isEmpty, let expression = queue1.last as? Expression, expression.grouping == .temporary, let lastNonValue = lastNonValue(before: queue1.count-1), lastNonValue.beforeFakePar, expression.smallEnoughLast(for: lastNonValue) {
                queue1.removeLast()
                openParentheses(type: expression.grouping, pattern: expression.pattern)
                queue1.append(contentsOf: expression.value)
            }
            
            // Add placeholder if a non-primary operator in the third queue now follows a value
            if let operation = queue3.first as? Operation, !operation.isPrimary, queue2.isEmpty {
                queue3 = [Placeholder()] + queue3
            }
            
            // Adjust negative num to negative modifier
            if num == "-" {
                num.removeAll()
                queue1 += [Number("#-1"), Operation(.con), Placeholder(true)]
            }
            // Placeholder dead coefficient
            if let operation = queue1.last as? Operation, operation.operation == .con {
                queue1 += [Placeholder(true)]
            }
            // Remove dead negative
            if let number = queue1.last as? Number, number.string == "#-1" {
                queue1.removeLast()
            }
        }
        
        // ----------------- //
        
        // Connect adjacent items
        queue1 = connectAdjacentItems(queue: queue1)
        queue3 = connectAdjacentItems(queue: queue3)

        // Backspaced queue identical to last calculation result
        if let last = Calculation.last, self.final.raw == last.result.raw {
            Calculation.calculations.removeLast()
        }
        
        // Remove extra active placeholders
        let placeholders = items.filter({ $0 is Placeholder && ($0 as! Placeholder).active }).map({ $0 as! Placeholder })
        if placeholders.count > 1 {
            placeholders[1...].forEach { $0.deactivate() }
        }
        
        // Finish queueing
        finishQueueing(backspace: false)
    }
    
    // -------------------- //
    
    // MARK: Enter
    // Complete the queue to prepare for calculation
    
    // -------------------- //
    
    func enter() {
        
        // Ready queueing
        readyQueueing()
        
        // Continue any result
        continueResult()
        
        // Queue the current item
        queueCurrent()
        
        // Combine all the queues
        combineQueues(all: true)
        
        // Connect adjacent items
        queue1 = connectAdjacentItems(queue: queue1)
        
        // The result is then calculated via the Calculation item
    }
    
    // -------------------- //
    
    // MARK: Undo
    // Undo the previous action
    
    // -------------------- //
    
    func undo() {
        
        // Remove the state
        if !undoStates.isEmpty {
            undoStates.removeLast()
        }
        
        // Set the current queues to the last state
        if let lastState = undoStates.last {
            self.queue1 = lastState.queue1
            self.queue2 = lastState.queue2
            self.queue3 = lastState.queue3
            self.current = lastState.current
            self.num = lastState.num
        } else {
            self.queue1.removeAll()
            self.queue2.removeAll()
            self.queue3.removeAll()
            self.current.removeAll()
            self.num.removeAll()
        }
        
        // Finish queueing
        finishQueueing(backspace: false)
    }
    
    // -------------------- //
    
    // MARK: Jump
    // Move the pointer to a specified index in the queue
    
    // -------------------- //
    
    func jump(to route: [Int], position: CGFloat = 0, motion: Int? = nil, splitNum: Bool = true) {
        
        // to is the position in the queue to jump to
        // position represents from 0.0-1.0 the horizontal position on the item that was pressed
        // motion represents where the motion of the jump is happening (used for arrow keys) (-1 or 1)
        // splitNum means a number can be split if found
        
        var path = route
        var position = position
        
        guard !path.isEmpty else { return }
        
        // Queue any current item
        queueCurrent(replaceNegative: false)
        
        // Combine the queues
        combineQueues(all: true)
        
        // --- Find the Item --- //
        
        // Set the index and item
        var queueItem: Item? = nil
        var queueIndex: Int? = nil
        
        // Find the item in the queue
        while !path.isEmpty && path[0] >= 0 && path[0] <= queue1.count {
            
            let index = path[0]
            let item = index >= 0 && index < queue1.count ? queue1[index] : nil
            let prev = index-1 >= 0 && index-1 < queue1.count ? queue1[index-1] : nil
            let next = index+1 >= 0 && index+1 < queue1.count ? queue1[index+1] : nil
            
            // Move into the expression
            if let expression = item as? Expression, path.count > 1, proCheck() {
                
                // Edit the index
                
                // Cannot jump anywhere inside a bound expression
                if expression.grouping == .bound {
                    if motion == -1 && path[1] != expression.value.count {
                        path.remove(at: 1)
                        continue
                    } else if let next = next as? Expression, next.pattern == .stuckLeft {
                        path[1] = expression.value.count
                    } else {
                        if motion == -1 {
                            path.remove(at: 1)
                        } else {
                            path[0] += 1
                            path.remove(at: 1)
                        }
                        continue
                    }
                }
                
                // Enter the expression
                if expression.canEnter {
                    
                    // Add the expression back into the queue
                    splitQueue(index, gap: true)
                    openParentheses(type: expression.grouping, pattern: expression.pattern)
                    queue1 += expression.value
                    
                    // Move to the index
                    path[0] += path[1]+1
                    path.remove(at: 1)
                    
                } else {
                    path[0] += motion ?? 1
                }
            }
            
            // Cannot jump LEFT for a stuck left expression
            else if let expression = item as? Expression, expression.pattern == .stuckLeft {
                
                // Go forward
                if motion == nil || motion == 1 {
                    if expression.canEnter, proCheck() {
                        path += [0]
                    } else {
                        path[0] += 1
                    }
                }
                // Go backward
                else if motion == -1 {
                    path[0] -= 1
                    if path.count > 1 {
                        path.remove(at: 1)
                    }
                    if path[0] >= 0, let expression = queue1[path[0]] as? Expression, proCheck() {
                        path += [expression.value.count]
                    }
                }
            }
            
            // Cannot jump RIGHT for a stuck right expression
            else if let expression = prev as? Expression, expression.pattern == .stuckRight {
                
                // Go backward
                if motion == -1 {
                    path[0] -= 1
                    if expression.canEnter, proCheck() {
                        path += [expression.value.count]
                    }
                }
                // Go forward
                else {
                    path[0] += 1
                    if path.count > 1 {
                        path.remove(at: 1)
                    }
                    if path[0] < queue1.count, queue1[path[0]] is Expression, proCheck() {
                        path += [0]
                    }
                }
            }
            
            // Set the item
            else if !(item is Pointer) {
                queueItem = item
                queueIndex = index
                path.removeAll()
            }
        }
        
        // --- Modify the Item --- //
        
        // Item not found – select last item
        if !path.isEmpty, path[0] >= queue1.count {
            queueIndex = queue1.count
            path.removeAll()
        }
        
        // Split a number if indicated
        if splitNum, proCheck(), motion == nil, let index = queueIndex, let number = queueItem as? Number, !number.string.contains("#") {
            
            let string = number.string
            let characters = Int(position * CGFloat(string.count))
            if characters < string.count, characters >= 1 {
                queue1[index] = Number(String(string.dropFirst(characters)), format: false)
                num = String(string.dropLast(string.count-characters))
                position = 0
            } else if characters == 0 {
                queue1[index] = Number(string, format: false)
                num.removeAll()
                position = 0
            } else {
                queueIndex = index+1
                queueItem = index+1 < queue1.count ? queue1[index+1] : nil
            }
        }
        else if splitNum, proCheck(), motion == -1, let index = queueIndex, let number = queueItem as? Number, !number.string.contains("#") {
            
            let string = number.string
            if string.count > 1 {
                queue1[index] = Number(String(string.dropFirst(string.count-1)), format: false)
                num = String(string.dropLast(1))
                position = 0
            }
        }
        else if splitNum, proCheck(), motion == 1, let index = queueIndex, let number = queueItem as? Number, !number.string.contains("#") {
            
            let string = number.string
            if string.count > 1 {
                queue1[index] = Number(String(string.dropFirst(1)), format: false)
                num = String(string.dropLast(string.count-1))
                position = 0
            }
        }
        
        // Select the next item if indicated
        if position >= 0.6, !(queueItem is Placeholder) {
            if let nextIndex = map.firstIndex(of: route) {
                if nextIndex+1 < map.count, !map[nextIndex+1].isEmpty {
                    jump(to: map[nextIndex+1], motion: motion, splitNum: splitNum)
                } else if nextIndex+2 < map.count, !map[nextIndex+2].isEmpty {
                    jump(to: map[nextIndex+2], motion: motion, splitNum: splitNum)
                } else {
                    jump(to: [queue1.count], motion: motion, splitNum: splitNum)
                }
                return
            }
        }
        
        // Last item is an implicit temporary expression following function or operation - move inside it
        if let index = queueIndex, index-1 >= 0, index-1 < queue1.count, proCheck(), let expression = queue1[index-1] as? Expression, expression.grouping == .temporary, !(queueItem is Placeholder), let lastNonValue = lastNonValue(before: index-1), lastNonValue.beforeFakePar, expression.smallEnoughLast(for: lastNonValue) {
            
            if let mapIndex = map.firstIndex(of: route) {
                if motion != 1, let prevMap = map[..<mapIndex].last(where: { !$0.isEmpty }) {
                    jump(to: prevMap, motion: motion, splitNum: false)
                    return
                }
                else if mapIndex+1 < map.count, let nextMap = map[(mapIndex+1)...].first(where: { !$0.isEmpty }) {
                    jump(to: nextMap, motion: motion, splitNum: false)
                    return
                }
                else {
                    jump(to: [queue1.count], motion: motion, splitNum: false)
                    return
                }
            }
            else if let prevMap = map.last(where: { !$0.isEmpty }) {
                jump(to: prevMap, motion: motion, splitNum: false)
                return
            }
        }
        
        // First item is an implicit temporary expression preceding an operation - move inside it
        if let index = queueIndex, index >= 0, index < queue1.count, proCheck(), let expression = queue1[index] as? Expression, expression.grouping == .temporary, !(queueItem is Placeholder), let nextNonValue = nextNonValue(after: index), nextNonValue.afterFakePar, expression.smallEnoughNext(for: nextNonValue) {
            
            if let mapIndex = map.firstIndex(of: route) {
                if motion == -1, let prevMap = map[..<mapIndex].last(where: { !$0.isEmpty }) {
                    jump(to: prevMap, motion: motion, splitNum: false)
                    return
                }
                else if mapIndex+1 < map.count, let nextMap = map[(mapIndex+1)...].first(where: { !$0.isEmpty }) {
                    jump(to: nextMap, motion: motion, splitNum: false)
                    return
                }
                else {
                    jump(to: [queue1.count], motion: motion, splitNum: false)
                    return
                }
            }
            else if let prevMap = map.last(where: { !$0.isEmpty }) {
                jump(to: prevMap, motion: motion, splitNum: false)
                return
            }
        }
        
        // -- Highlighting -- //
        
        // Highlight up to that point
        if let index = queueIndex, let firstHighlight = queue1.firstIndex(where: { $0.highlighted }), let lastHighlight = queue1.lastIndex(where: { $0.highlighted }) {

            // Highlight the preceding items
            if index < firstHighlight {
                for i in index..<firstHighlight {
                    queue1[i].highlight()
                }
            }

            // Highlight the following items
            else if index > lastHighlight {
                if position >= 0.5 {
                    for i in lastHighlight+1...index {
                        queue1[i].highlight()
                    }
                } else {
                    for i in lastHighlight+1..<index {
                        queue1[i].highlight()
                    }
                }
            }

            // Unhighlight some of the items
            else if firstHighlight == lastHighlight && lastHighlight == index {
                queue1[index].highlight()
            }
            else if firstHighlight+1...lastHighlight ~= index {
                if index-firstHighlight > lastHighlight-index {
                    for i in index...lastHighlight {
                        queue1[i].highlight()
                    }
                } else {
                    for i in firstHighlight..<index {
                        queue1[i].highlight()
                    }
                }
            }
        }
        
        // -- Split the Queue -- //
        
        // Go to the item
        if let index = queueIndex, index >= 0, index <= queue1.count {

            // Find where to split off the third queue
            var splitPoint: Int {
                if let item = queueItem {
                    if item is NonValue {
                        return index
                    }
                    // Non-primary operation is next - split after that
                    if index+2 < queue1.count, item is Placeholder, let operation = queue1[index+1] as? Operation, !Operation.primary.contains(operation.operation.rawValue) {
                        return index+3
                    }
                    // Function comes before - split after all arguments
                    if let nvIndex = queue1[0..<index].lastIndex(where: { $0 is NonValue }), let function = queue1[nvIndex] as? Function, index-nvIndex < function.arguments {
                        return nvIndex + function.arguments + 1
                    }
                }
                return index
            }
            
            // Lite jumping - nearest placeholder
            if !proCheck() {
                
                // Set a placeholder
                var placeholder: Placeholder? = nil
                
                // Next placeholder
                if let item = queueItem as? Placeholder, queue1[index...].filter({ $0 is NonValue && !($0 is Parentheses) }).count <= (item.pattern == .stuckRight ? 1 : 0) {
                    placeholder = item
                }
                // Last placeholder
                else if index-1 >= 0, let item = queue1[index-1] as? Placeholder, queue1[(index-1)...].filter({ $0 is NonValue && !($0 is Parentheses) }).count <= (item.pattern == .stuckRight ? 1 : 0) {
                    placeholder = item
                }
                
                // Activate the placeholder
                if let placeholder = placeholder {
                    
                    // Deactivate all placeholders
                    deactivatePlaceholders()
                    
                    // Activate the placeholder
                    placeholder.activate()
                    
                    // Make temporary placeholder pemanent
                    if motion == nil, placeholder.grouping == .temporary, !(lastNonValue(before: index)?.beforeFakePar ?? false), !(nextNonValue(after: index)?.afterFakePar ?? false) {
                        placeholder.grouping = .hidden
                    }
                }
            }
            
            // Placeholder
            else if let placeholder = queueItem as? Placeholder {
                
                // Deactivate all placeholders
                deactivatePlaceholders()    
                
                // Activate the placeholder
                placeholder.activate()
                
                // Make temporary placeholder pemanent
                if motion == nil, placeholder.grouping == .temporary, !(lastNonValue(before: index)?.beforeFakePar ?? false), !(nextNonValue(after: index)?.afterFakePar ?? false) {
                    placeholder.grouping = .hidden
                }
                
                // Split off the third queue
                splitQueue(splitPoint, third: true, midFirst: splitPoint == index)
                
                // Split off the second queue
                splitQueue(index, midFirst: true)
            }

            // Other Item
            else {
                
                // Deactivate all placeholders
                deactivatePlaceholders()
                
                // Make temporary grouping permanent
                var checked: [UUID] = []
                while let openIndex = queue1.lastIndex(where: { ($0 as? Parentheses)?.grouping == .open && !checked.contains($0.id) }), let openPar = queue1[openIndex] as? Parentheses, openPar.type == .temporary {
                    
                    checked += [openPar.id]
                    
                    if let closeIndex = queue2.firstIndex(where: { ($0 as? Parentheses)?.grouping == .close && !checked.contains($0.id) }), let closePar = queue2[closeIndex] as? Parentheses, closePar.type == .temporary {
                        
                        if !(lastNonValue(before: openIndex)?.beforeFakePar ?? false), !(nextNonValue(after: closeIndex, in: queue2)?.afterFakePar ?? false) {
                            openPar.type = .hidden
                            closePar.type = .hidden
                        }
                        checked += [closePar.id]
                    }
                    else if let closeIndex = queue3.firstIndex(where: { ($0 as? Parentheses)?.grouping == .close && !checked.contains($0.id) }), let closePar = queue3[closeIndex] as? Parentheses, closePar.type == .temporary {
                        
                        if !(lastNonValue(before: openIndex)?.beforeFakePar ?? false), !(nextNonValue(after: closeIndex, in: queue3)?.afterFakePar ?? false) {
                            openPar.type = .hidden
                            closePar.type = .hidden
                        }
                        checked += [closePar.id]
                    }
                }

                // Split off the third queue
                splitQueue(splitPoint, third: true)

                // Split off the second queue
                splitQueue(index)
            }
        }
        
        // -- Final Modifications -- //
        
        // Connect adjacent items
        queue1 = connectAdjacentItems(queue: queue1)
        queue3 = connectAdjacentItems(queue: queue3)
        
        // Create a new num
        newNum()
        
        // Reset the backspace states
        if proCheck() {
            backspaceStates = [copyState()]
        }
        
        // Finish queueing
        finishQueueing(backspace: false)
    }
    
    // -------------------- //
    
    // MARK: Highlight
    // Highlight a certain item in the queue
    
    // -------------------- //
    
    func highlight(_ index: [Int]) {
        
        if items.contains(where: { $0.highlighted }) {
            
            // Unhighlight everything
            items.filter{ $0.highlighted }.forEach{ $0.highlight() }
            
        } else {
            
            // Jump to the highlighted region
            jump(to: index, position: 1.0)
            
            // Highlight the item
            if let last = queue1.last {
                last.highlight()
            }
        }
    }
    func highlighted(_ index: [Int]) -> Bool {
        return getQueueItem(index).highlighted
    }
    
    // -------------------- //
    
    // MARK: Forward
    // Go to the next item
    
    // -------------------- //
    
    func forward() {
        
        // Move to the next position
        if let index = strings.firstIndex(of: "#|"), index+1 < map.count {
            jump(to: map[index+1], position: 1.0, motion: 1, splitNum: queue3.first is Number)
        }
        else if let index = strings.firstIndex(of: "■"), index+1 < map.count {
            jump(to: map[index+1], position: 1.0, motion: 1, splitNum: queue3.first is Number)
        }
    }
    
    // -------------------- //
    
    // MARK: Backward
    // Go to the next item
    
    // -------------------- //
    
    func backward() {
        
        // Move to the previous position
        if let index = strings.firstIndex(of: "#|"), index-1 >= 0 {
            jump(to: map[index-1], position: 0.0, motion: -1)
        }
        else if let index = strings.firstIndex(of: "■"), index-1 >= 0 {
            jump(to: map[index-1], position: 0.0, motion: -1)
        }
    }
    
    // -------------------- //
    
    // MARK: Paste
    // Paste an item into the queue
    
    // -------------------- //
    
    func paste() {
        
        var queue: Queue? {
            // iOS Clipboard
            if let string = UIPasteboard.general.string, Double(string) != nil {
                return Queue([Number(string)])
            }
            // In-App Clipboard
            else if !settings.clipboard.isEmpty {
                return Queue(settings.clipboard)
            }
            return nil
        }
        
        if let queue = queue {
            
            // Insert the queue
            insertToQueue(queue, addCoefficient: true)
            
            // Play the sound
            SoundManager.play(sound: .click3, haptic: .medium)
        }
    }
    
    // -------------------- //
    
    // MARK: Set to Queue
    // Set the queue to another external queue
    
    // -------------------- //
    
    func setToQueue(_ queue: Queue) {
        
        // Clear
        clear()
        
        // Set the queue
        self.queue1 = queue.items
        
        // Add the notification
        settings.notification = .edit
        
        // Finish queueing
        finishQueueing()
    }
    
    // -------------------- //
    
    // MARK: Insert to Queue
    // Insert an item to the queue
    
    // -------------------- //
    
    func insertToQueue(_ queue: Queue, addCoefficient: Bool = false, stayInPar: Bool = false) {
        
        // Make sure allowed to insert
        guard canInput(letter: queue.items.count == 1 && queue.items.first is Letter) else { return }
        
        // Ready queueing
        readyQueueing()
        
        // Insert item to the queue
        if empty {
            queue1 = queue.items
        }
        else if !readyForOperation() {
            
            // Add automatic parentheses
            autoParentheses(numberInput: queue.count == 1 && queue.items.first is Number, afterCof: true)
            
            // Add the items
            if [.sub,.mlt,.div].contains((queue1.last as? Operation)?.operation ?? .add) && queue.items.contains(where: { ($0 as? Operation)?.isPrimary ?? false }) {
                queue1 += [Expression(queue)]
            } else {
                queue1 += queue.items
            }
            
            // Close the parentheses
            if !stayInPar {
                closeParentheses()
            }
        }
        else if queue1.last is Placeholder || addCoefficient {
            impliedMultiplication(connector: true)
            insertToQueue(queue)
        }
        else {
            clear()
            queue1 = queue.items
        }
        
        // Match letters
        for letter in queue.letters {
            matchLetters(to: letter)
        }
        
        // Activate a placeholder
        if let placeholder = queue.items.first(where: { $0 is Placeholder }) as? Placeholder {
            placeholder.activate()
        }
        
        // Add the notification
        settings.notification = .insert
        
        // Finish queueing
        finishQueueing()
    }
}
