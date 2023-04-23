//
//  StoredVar+CoreDataProperties.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 5/25/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension StoredVar {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredVar> {
        return NSFetchRequest<StoredVar>(entityName: "StoredVar")
    }
    
    @NSManaged public var uuid: UUID
    @NSManaged public var date: Date?
    
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    
    @NSManaged public var varName: String?
    @NSManaged public var rawValue: [String]?
    
    static var refresh = false
    
    var variable: Letter {
        return Letter(varName ?? "x", constant: value)
    }
    var value: Queue {
        return Queue(raw: rawValue ?? [], resetStored: true)
    }
    
    var copied : Bool {
        return Settings.settings.clipboard == value.items
    }
    
    // MARK: Insert
    
    func insert() {
        Calculation.current.setUpInput()
        Calculation.current.queue.insertToQueue(Queue([variable]), addCoefficient: true)
        SoundManager.play(sound: .click3, haptic: .medium)
        StoredVar.refresh.toggle()
    }
    
    // MARK: Copy
    
    func copy() {
        UIPasteboard.general.string = value.exportString()
        Settings.settings.clipboard = value.items
        Settings.settings.notification = .copy
        StoredVar.refresh.toggle()
    }
    
    // MARK: Delete
    
    func delete() {
        Settings.settings.warning = Warning(
            headline: "Delete",
            message: "Are you sure you want to delete this value? This cannot be undone.",
            continueString: "Delete",
            continueAction: {
                self.confirmDelete()
                StoredVar.refresh.toggle()
            }
        )
    }
    static func deleteSelected(_ storedVars: [StoredVar]) {
        guard !storedVars.isEmpty else { return }
        Settings.settings.warning = Warning(
            headline: "Delete",
            message: storedVars.count > 1 ? "Are you sure you want to delete the \(storedVars.count) selected values? This cannot be undone." : "Are you sure you want to delete the selected value? This cannot be undone.",
            continueString: "Delete",
            continueAction: {
                if storedVars.count >= 10 {
                    Settings.settings.warning = Warning(
                        headline: "Delete",
                        message: "Are you ABOLUTELY POSITIVELY sure you want to delete ALL of the \(storedVars.count) selected values? This cannot be undone.",
                        continueString: "Delete",
                        continueAction: {
                            storedVars.forEach { $0.confirmDelete() }
                            StoredVar.refresh.toggle()
                        }
                    )
                } else {
                    storedVars.forEach { $0.confirmDelete() }
                    StoredVar.refresh.toggle()
                }
            }
        )
    }
    func confirmDelete() {
        if Calculation.current.queue.allLetters.contains(where: { $0.name == variable.name && $0.value?.items ?? [] == value.items }) {
            Calculation.current.queue.matchLetters(to: Letter(variable.name))
            Calculation.current.refresh()
        }
        Settings.settings.menuSheetRefresh.toggle()
        PersistenceController.shared.container.viewContext.delete(self)
        PersistenceController.shared.save()
        Settings.settings.notification = .delete
    }
    
    // MARK: Rename
    
    func rename(to name: String) {
        self.name = name
        PersistenceController.shared.save()
    }
    
    // MARK: Set Value
    
    func setValue(to value: Queue) {
        self.rawValue = value.raw
        Calculation.current.queue.matchLetters(to: Letter(variable.name, type: .constant, value: value))
        Calculation.current.refresh()
        PastObject.refresh.toggle()
        StoredVar.refresh.toggle()
    }
    
    // MARK: Getter
    
    static func getAllVariables(type: ListDisplayType = .all) -> [StoredVar] {
        
        var vars: [StoredVar] = []

        // Create the fetch request
        let fetchRequest = NSFetchRequest<StoredVar>(entityName: "StoredVar")

        // Fetch the calculations
        do {
            vars = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
        }
        catch {
            fatalError("Failed to get calculations")
        }

        return vars.filter {
            type == .numbers ? ( $0.value.allVariables.isEmpty && $0.value.allDummies.isEmpty ) :
            type == .expressions ? !( $0.value.allVariables.isEmpty && $0.value.allDummies.isEmpty ) :
            true
        }
    }
    
    static func getVariable(_ variableName: String) -> StoredVar? {
        return getAllVariables().first(where: { $0.varName == variableName })
    }
}

extension StoredVar : Identifiable {

}
