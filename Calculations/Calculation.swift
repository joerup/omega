//
//  Calculation.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 3/20/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

class Calculation: ObservableObject, Equatable {
    
    @ObservedObject var settings = Settings.settings
    var managedObjectContext = PersistenceController.shared.container.viewContext
    
    // MARK: Class Properties
    
    static var calculations: [Calculation] = [Calculation()]
    
    static var current: Calculation {
        return calculations.last ?? Calculation()
    }
    static var last: Calculation? {
        return calculations.dropLast().last
    }
    
    static func new() {
        calculations += [Calculation()]
    }
    static func get(_ id: UUID) -> Calculation {
        return calculations.first(where: { $0.id == id }) ?? Calculation()
    }
    static func clearHistory() {
        calculations = [calculations.last ?? Calculation()]
    }
    static func == (a: Calculation, b: Calculation) -> Bool {
        return a.id == b.id
    }
    
    // MARK: Calculation Properties
    
    var id = UUID()
    
    var queue: Queue = Queue()
    var result: Queue = Queue()
    
    var completed: Bool {
        return !result.empty
    }
    var showResult: Bool {
        return queue.items != result.items
    }
    
    @Published var update: Bool = false
    
    // MARK: Initializers
    
    init() {
        self.queue = Queue()
    }
    init(_ queue: Queue) {
        self.queue = queue
    }
    init(_ items: [Item]) {
        self.queue = Queue(items)
    }
    init(_ raw: [String]) {
        self.queue = Queue(raw: raw)
    }
    
    // MARK: Enter
    
    func enter() {
        
        // Make sure the calculation is not yet completed and not empty
        guard !self.completed, !self.queue.empty else { return }
        
        // Set all the modes
        setModes(to: queue.modes)
        
        // Enter the queue
        queue.enter()
        
        // Perform calculation and set result
        result = queue.final.simplify()
        
        // Encode a past calculation
        encode()
        
        // Done editing
        queue.editing = false
        
        // Finish input
        queue.finishQueueing(backspace: false)
        
        // Print the result
        result.printQueue()
    }
    
    // MARK: Clear
    
    func clear() {
        
        self.id = UUID()
        
        self.queue.clear()
        self.result.clear()
        
        Calculation.clearHistory()
    }
    
    // MARK: Backspace
    
    func backspace(undo: Bool = false) {
        
        if completed {
            result.clear()
            queue.editing = true
        }
        else if undo {
            queue.undo()
        }
        else {
            queue.backspace()
        }
    }
    
    // MARK: Encode
    
    func encode() {
        
        // No error
        guard !result.error else { return }
                    
        let calculation = PastCalculation(context: managedObjectContext)

        // Set the metadata
        calculation.uuid = id
        calculation.name = ""
        calculation.date = Date()
        calculation.mode = queue.modes.raw

        // Set the queue and result
        calculation.rawQueue = queue.raw
        calculation.rawResult = result.raw
        
        PersistenceController.shared.save()
    }
    
    // MARK: Refresh
    
    func refresh(result: Queue? = nil) {
        
        // Calculate a new result
        if let result = result {
            self.result = result
        }
        else if completed {
            self.result = queue.final.simplify()
            self.result.printQueue()
        }
        
        // Reset past calculation
        if let pastCalculation = PastCalculation.get(id) {
            pastCalculation.replace(with: self)
        }
        
        // Refresh the queue
        self.update.toggle()
    }
    
    // MARK: Set Modes
    
    func setModes(to modes: ModeSettings) {
        
        // Set the queue/result modes
        self.queue.setModes(to: modes)
        self.result.setModes(to: modes)
    }
    
    // MARK: Set Up Input
    
    func setUpInput(new: Bool = true) {
        
        // Must be called externally before any input function
        // new means a new calculation will be created if the previous one is completed
        
        // Remove the overlay
        if self == Calculation.current {
            settings.showMenu = false
            settings.calculatorOverlay = .none
            settings.detailOverlay = .none
            settings.buttonDisplayMode = .basic
            settings.buttonUppercase = false
        }
        
        // Create a new current item
        if new, self == Calculation.current, self.completed {
            Calculation.new()
            return
        }
    }
}
