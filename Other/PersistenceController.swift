//
//  PersistenceController.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/19/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation
import CoreData

struct PersistenceController {
    // A singleton for our entire app to use
    static let shared = PersistenceController()

    // Storage for Core Data
    let container: NSPersistentContainer

    // An initializer to load Core Data
    init(inMemory: Bool = false) {
        
        container = NSPersistentContainer(name: "Model")
        
        // Model 1 - 1.6.0 Original PastCalculation
        // Model 2 - 2.0.0 Transitional to rename old PastCalculation
        // Model 3 - 2.0.0 New PastCalculation now inherits from PastObject; StoredVar

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // Save
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                print("Saved")
            } catch {
                // Show some error here
                print("No changes")
            }
        }
    }
    
    
    // MARK: - Past Calculations
    
    
    // MARK: Remove Expired Calculations
    
    // All unsaved past calculations are removed after a certain amount of time to save space
    // The amount of time is dictated by the settings, by default 14 days
    
    func removeExpiredCalculations() {
        
        // Fetch all calculations
        var allCalculations: [PastCalculation] = []
        let fetchRequest: NSFetchRequest<PastCalculation> = PastCalculation.fetchRequest()
        do {
            let items = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            allCalculations = items
        }
        catch let error as NSError {
            print("Error getting calculations: \(error.localizedDescription), \(error.userInfo)")
        }
        
        // Find unsaved calculations older than the limit
        for calculation in allCalculations {
            if !calculation.saved && (calculation.date ?? Date()).addingTimeInterval(PastCalculation.expirationLength) < Date() {
                // Delete calculation
                PersistenceController.shared.container.viewContext.delete(calculation)
            }
        }
        PersistenceController.shared.save()
    }
    
    
    // MARK: Convert Old Calculations
    
    // The structure of the queue was completely changed in version 2.0.0, meaning past calculations' queues must be adapted
    // The PastCalculation object now stores a raw version of the Item objects, and they are converted back when needed (this is reflected in Model 3)
    // The previous PastCalculation objects (OldPastCalculation) from 1.7.0 and earlier must be converted into new PastCalculation objects
    // TODO: Remove this late 2024
    
    func convertOldCalculations() {
        
        // Loop through all past calculations
        var calculations: [OldPastCalculation] = []

        // Create the fetch request
        let fetchRequest = NSFetchRequest<OldPastCalculation>(entityName: "OldPastCalculation")

        // Order by most recent date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        // Fetch the old calculations
        do {
            calculations = try container.viewContext.fetch(fetchRequest)
        }
        catch {
            fatalError("Failed to get calculations")
        }

        // Delete each calculation
        for old in calculations {
            
            // Create a new calculation
            let new = PastCalculation(context: container.viewContext)
            
            new.uuid = old.uuid
            new.date = old.date
            new.name = old.name
            new.folder = "Saved"
            
            new.rawQueue = convertOldStrings(old.queue)
            new.rawResult = convertOldStrings(old.result)
            
            // Delete the old calculation
            container.viewContext.delete(old)
            PersistenceController.shared.save()
        }
        
        PersistenceController.shared.save()
    }
    
    func convertOldStrings(_ old: [String]) -> [String] {
        
        var strings = old
        
        var index = 0
        while index < strings.count {
            
            let item = strings[index]
            let next = index+1 < strings.count ? strings[index+1] : ""
            
            // Replace old factorial/percent coefficients which are no longer used
            if item == "*" && (next == "!" || next == "%") {
                strings.remove(at: index)
                index -= 1
            }
            // Replace old invisible 1
            else if item == "01" && next == "*" {
                strings.remove(at: index)
                strings.remove(at: index)
                index -= 1
            }
            // Replace old negative
            else if item == "-01" {
                strings[index] = Number("#-1").raw
            }
            // Replace old invisible multiplier
            else if item == "#×" {
                strings[index] = Operation(.mlt).raw
            }
            // Replace invisible numbers
            else if item == "#10" || item == "#2" || item == "#e" {
                strings[index] = Number(item).raw
            }
            // Replace old repeating decimals
            else if item.contains("R") {
                var repeater = item
                var repeating = 0
                while repeater.last == "R" {
                    repeater.removeLast()
                    repeating += 1
                }
                if repeating > 0 {
                    var digits = ""
                    for _ in 0..<repeating {
                        if !repeater.isEmpty {
                            digits = [repeater.last ?? " "] + digits
                            repeater.removeLast()
                        }
                    }
                    while repeater.count < 20 {
                        repeater += digits
                    }
                }
                strings[index] = Number(Double(repeater) ?? 0).raw
            }
            // Replace old repeating decimals
            else if item.contains(" ̅") {
                strings[index] = Number(item).raw
            }
            // Permutation/Combination
            else if item == "P" || item == "C", let operation = OperationType(rawValue: "n"+item+"r") {
                strings[index] = Operation(operation).raw
            }
            // Exponential
            else if item == "E" {
                strings[index] = Operation(.exp).raw
            }
            // Exponential
            else if item == "| |" {
                strings[index] = Function(.abs).raw
            }
            // Random
            else if item == "rand" {
                strings[index] = Expression([Number(1)], grouping: .parentheses, pattern: .stuckLeft).raw
                strings.insert(Function(.rand).raw, at: index)
                index += 1
            }
            // Number
            else if let number = Double(item) {
                strings[index] = Number(number).raw
            }
            // Letter
            else if let letter = InputLetter(rawValue: item) {
                strings[index] = Letter(letter.name, type: .variable).raw
            }
            // Expression
            else if item.contains("(") {
                strings.remove(at: index)
                
                var expressionQueue: [String] = []
                var parentheses = 1
                
                while index < strings.count {
                    
                    let item = strings[index]
                    
                    if item.contains("(") {
                        parentheses += 1
                    }
                    else if item.contains(")") {
                        parentheses -= 1
                    }
                    
                    if parentheses == 0 {
                        expressionQueue = convertOldStrings(expressionQueue)
                        strings[index] = Expression(Queue(raw: expressionQueue).items).raw
                        break
                    }
                    else {
                        expressionQueue += [item]
                        strings.remove(at: index)
                    }
                }
            }
            // Operation
            else if let operation = OperationType(rawValue: item) {
                strings[index] = Operation(operation).raw
            }
            // Function
            else if let function = FunctionType(rawValue: item) {
                strings[index] = Function(function).raw
            }
            // Modifier
            else if let modifier = ModifierType(rawValue: item) {
                strings[index] = Modifier(modifier).raw
            }
            // Old identifiers
            else if ["§","¶"].contains(item) {
                strings.remove(at: index)
                index -= 1
            }
            // Unknown - Make a placeholder
            else {
                strings[index] = Placeholder().raw
            }
            
            index += 1
        }
        
        strings = newQueueGrouping(raw: strings)
        
        print("----")
        print(old)
        print(" |  ")
        print("\\/")
        print(strings)
        print(" |  ")
        print("\\/")
        Queue(raw: strings).printQueue()
        print("----")
        
        return strings
    }
    
    func newQueueGrouping(raw: [String]) -> [String] {
        
        var items = Queue(raw: raw).items
        
        var index = 0
        while index < items.count {
            
            let item = items[index]
            
            // Expression
            if let expression = item as? Expression {
                
                // Set the item
                items[index] = Expression(Queue(raw: newQueueGrouping(raw: expression.queue.raw)), grouping: expression.grouping, pattern: expression.pattern)
            }
            
            // Functions
            else if let function = item as? Function {
                var findIndex = index+1
                var lastItem: Item? = nil
                
                // Loop through
                while findIndex < items.count {
                    let nextItem = items[findIndex]
                    if nextItem is Value {
                        if lastItem is Value {
                            break
                        }
                    } else if (nextItem as? Operation)?.isPrimary ?? false {
                        break
                    }
                    lastItem = nextItem
                    findIndex += 1
                }
                
                // Add it all
                if index+1 >= 0, findIndex <= items.count, index+1 <= findIndex {
                    let expression = Expression(Array(items[(index+1)..<findIndex]), grouping: .temporary, pattern: .stuckLeft)
                    items.removeSubrange((index+1)..<findIndex)
                    items.insert(expression, at: index+1)
                    
                    // Extra value for log
                    if function.function == .log {
                        let midIndex = index+1
                        findIndex = index+2
                        lastItem = nil
                        
                        // Loop through
                        while findIndex < items.count {
                            let nextItem = items[findIndex]
                            if nextItem is Value {
                                if lastItem is Value {
                                    break
                                }
                            } else if (nextItem as? Operation)?.isPrimary ?? false {
                                break
                            }
                            lastItem = nextItem
                            findIndex += 1
                        }
                        
                        // Add it all
                        if midIndex+1 >= 0, findIndex <= items.count, midIndex+1 <= findIndex {
                            let expression = Expression(Array(items[(midIndex+1)..<findIndex]), grouping: .temporary, pattern: .stuckLeft)
                            items.removeSubrange((midIndex+1)..<findIndex)
                            items.insert(expression, at: midIndex+1)
                        }
                    }
                }
            }
            
            // Operations
            else if let operation = item as? Operation, !operation.isPrimary, ![.con].contains(operation.operation) {
                var findIndex = index+1
                var lastItem: Item? = nil
                
                // Loop through forward
                while findIndex < items.count {
                    let nextItem = items[findIndex]
                    if nextItem is Value {
                        if lastItem is Value {
                            break
                        }
                    } else if (nextItem as? Operation)?.isPrimary ?? false {
                        break
                    }
                    lastItem = nextItem
                    findIndex += 1
                }
                
                // Add it all
                if index+1 >= 0, findIndex <= items.count, index+1 <= findIndex {
                    let expression1 = Expression(Array(items[(index+1)..<findIndex]), grouping: .temporary, pattern: .stuckLeft)
                    items.removeSubrange((index+1)..<findIndex)
                    items.insert(expression1, at: index+1)
                }
                
                // Reset to go back
                findIndex = index-1
                lastItem = nil
                
                // Loop through backward
                while findIndex >= 0 {
                    let nextItem = items[findIndex]
                    if nextItem is Value {
                        if lastItem is Value {
                            break
                        }
                    } else if (nextItem as? Operation)?.isPrimary ?? false {
                        break
                    }
                    lastItem = nextItem
                    findIndex -= 1
                }
                
                // Add it all
                if findIndex+1 >= 0, index <= items.count, findIndex+1 <= index {
                    let expression2 = Expression(Array(items[(findIndex+1)..<index]), grouping: .temporary, pattern: .stuckRight)
                    items.removeSubrange((findIndex+1)..<index)
                    items.insert(expression2, at: index-1)
                }
                
            }
            
            index += 1
        }
        
        return Queue(items).raw
    }
}
