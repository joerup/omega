//
//  PastCalculation+CoreDataProperties.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/3/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//
//

import Foundation
import UIKit
import SwiftUI
import CoreData

extension PastCalculation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PastCalculation> {
        return NSFetchRequest<PastCalculation>(entityName: "PastCalculation")
    }
    
    @NSManaged public var rawQueue: [String]?
    @NSManaged public var rawResult: [String]?
    
    var queue: Queue {
        return Queue(raw: rawQueue ?? [], modes: modes)
    }
    var result: Queue {
        return Queue(raw: rawResult ?? [], modes: modes)
    }
    
    var extraResults: [Queue] {
        return self.newCalculation().extraResult()
    }
    var otherUnits: [Queue] {
        return self.newCalculation().result.otherUnits()
    }
    
    var showResult: Bool {
        return result.variables.isEmpty && queue.items != result.items
    }
    var copied: Bool {
        return Settings.settings.clipboard == result.items
    }
    var stored: Bool {
        return StoredVar.getAllVariables().contains(where: { $0.uuid == self.uuid })
    }
    
    // MARK: Expiration
    
    static var expirationDays: Double {
        return Settings.settings.pro ? 180 : 14
    }
    static var expirationLength: Double {
        return expirationDays * 86400
    }
    
    // MARK: Insert
    
    func insert() {
        guard !result.error else { return }
        if !result.allVariables.isEmpty {
            Settings.settings.popUp = AnyView(
                PastCalcInsertView(calculation: self)
            )
            SoundManager.play(sound: .click3, haptic: .heavy)
        } else {
            Calculation.current.setUpInput()
            if Calculation.current.queue.empty {
                Calculation.current.id = uuid
                Calculation.current.queue = queue
                Calculation.current.result = result
            } else {
                Calculation.current.queue.insertToQueue(result)
            }
            SoundManager.play(sound: .click3, haptic: .medium)
            PersistenceController.shared.save()
            PastCalculation.refresh.toggle()
        }
    }
    
    // MARK: Edit
    
    func edit() {
        Calculation.current.setUpInput()
        Calculation.current.queue.setToQueue(queue)
        SoundManager.play(sound: .click3, haptic: .heavy)
        PersistenceController.shared.save()
        PastCalculation.refresh.toggle()
    }
    
    // MARK: Copy
    
    func copy() {
        UIPasteboard.general.string = result.exportString()
        Settings.settings.clipboard = result.items
        Settings.settings.notification = .copy
        PersistenceController.shared.save()
        PastCalculation.refresh.toggle()
    }
    
    // MARK: Store
    
    func store() {
        Settings.settings.popUp = AnyView(
            StoredVarSetView(value: result, uuid: uuid)
        )
    }
    
    // MARK: Replace Result
    
    func replace(with calculation: Calculation) {
        self.rawQueue = calculation.queue.raw
        self.rawResult = calculation.result.raw
        self.mode = calculation.queue.modes.raw
        PersistenceController.shared.save()
        PastCalculation.refresh.toggle()
    }
    func replaceResult(with result: Queue) {
        self.rawResult = result.raw
        PersistenceController.shared.save()
        PastCalculation.refresh.toggle()
    }
    
    // MARK: - New Calculation
    
    func newCalculation() -> Calculation {
        
        let calculation = Calculation()
        
        calculation.id = uuid
        
        calculation.queue = queue
        calculation.result = result
        
        return calculation
    }
    
    // MARK: - Create Past Calculation
    
    static func createPastCalculation(queue: Queue, result: Queue) -> PastCalculation {
        
        let calculation = PastCalculation(context: PersistenceController.shared.container.viewContext)

        calculation.uuid = UUID()
        calculation.name = ""
        calculation.date = Date()
        calculation.mode = queue.modes.raw
        
        calculation.rawQueue = queue.raw
        calculation.rawResult = result.raw
        
        PersistenceController.shared.save()
        return calculation
    }
    
    // MARK: - Get Calculations
    
    static func getCalculations(count: Int? = nil, folder: String? = nil, dates: Range<Date>? = nil) -> [PastCalculation] {
        
        // Create the fetch request
        let fetchRequest = NSFetchRequest<PastCalculation>(entityName: "PastCalculation")

        // Order by most recent date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        // Limit by saved/unsaved
        if let folder = folder {
            fetchRequest.predicate = NSPredicate(format: "folder MATCHES %@", folder)
        }
        // Limit by date
        if let dates = dates {
            fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date =< %@", argumentArray: [dates.lowerBound, dates.upperBound])
        }
        // Limit only to the number of offsets
        if let count = count {
            fetchRequest.fetchLimit = count
        }

        // Fetch the calculations
        do {
            let calculations = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            return calculations
        }
        catch {
            return []
        }
    }
    
    static func get(_ id: UUID) -> PastCalculation? {
        
        // Create the fetch request
        let fetchRequest = NSFetchRequest<PastCalculation>(entityName: "PastCalculation")

        // Filter the id
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", id as CVarArg)

        // Fetch the calculations
        do {
            let calculations = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            return calculations.first
        }
        catch {
            return nil
        }
    }
}
