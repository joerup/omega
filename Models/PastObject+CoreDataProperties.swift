//
//  PastObject+CoreDataProperties.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/3/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftUI

extension PastObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PastObject> {
        return NSFetchRequest<PastObject>(entityName: "PastObject")
    }
    
    @NSManaged public var uuid: UUID
    @NSManaged public var date: Date?
    @NSManaged public var mode: String?
    
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var folder: String?
    
    static var refresh = false
    
    var saved: Bool {
        return folder != nil
    }
    
    var listType: ListDisplayType {
        if let calculation = self as? PastCalculation {
            if !calculation.result.allVariables.isEmpty {
                return .expressions
            }
            return .numbers
        }
        return .all
    }
    
    var modes: ModeSettings {
        return ModeSettings(raw: mode)
    }
    
    // MARK: Save
    
    func save() {
        guard proCheck(maxFreeVersion: 0) else { return }
        Settings.settings.popUp = AnyView(
            PastCalcSaveView(calculation: self)
        )
    }
    static func saveSelected(_ calculations: [PastObject]) {
        guard !calculations.isEmpty, proCheckNotice(.misc, maxFreeVersion: 0) else { return }
        Settings.settings.popUp = AnyView(
            PastCalcMultipleSaveView(calculations: calculations)
        )
    }
    func confirmSave(to folder: String) {
        guard proCheckNotice(.misc, maxFreeVersion: 0) else { return }
        self.folder = folder
        Settings.settings.folders = Settings.settings.folders.filter { $0 == folder } + Settings.settings.folders.filter { $0 != folder }
        PersistenceController.shared.save()
        Settings.settings.notification = .save
    }
    func confirmUnsave() {
        self.folder = nil
        PersistenceController.shared.save()
        Settings.settings.notification = .unsave
    }
    
    // MARK: Export
    
    func export() {
        guard proCheckNotice(.misc) else { return }
        Settings.settings.popUp = AnyView(
            ExportView(calculation: self)
        )
    }
    static func exportSelected(_ calculations: [PastObject]) {
        guard proCheckNotice(.misc) else { return }
        Settings.settings.popUp = AnyView(
            ExportView(calculations: calculations)
        )
    }
    
    // MARK: Delete
    
    func delete() {
        Settings.settings.warning = Warning(
            headline: "Delete",
            message: "Are you sure you want to delete this calculation? This cannot be undone.",
            continueString: "Delete",
            continueAction: {
                self.confirmDelete()
                PastObject.refresh.toggle()
            }
        )
    }
    static func deleteSelected(_ calculations: [PastObject]) {
        guard !calculations.isEmpty else { return }
        Settings.settings.warning = Warning(
            headline: "Delete",
            message: calculations.count > 1 ? "Are you sure you want to delete the \(calculations.count) selected calculations? This cannot be undone." : "Are you sure you want to delete the selected calculation? This cannot be undone.",
            continueString: "Delete",
            continueAction: {
                if calculations.count >= 10 {
                    Settings.settings.warning = Warning(
                        headline: "Delete",
                        message: "Are you ABOLUTELY POSITIVELY sure you want to delete ALL of the \(calculations.count) selected calculations? This cannot be undone.",
                        continueString: "Delete",
                        continueAction: {
                            calculations.forEach { $0.confirmDelete() }
                            PastObject.refresh.toggle()
                        }
                    )
                } else {
                    calculations.forEach { $0.confirmDelete() }
                    PastObject.refresh.toggle()
                }
            }
        )
    }
    func confirmDelete() {
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
    
    // MARK: - Get Objects
    
    static var savedLimit: Int = 30
    
    static func savedAmount() -> Int {
        
        // Create the fetch request for saved objects
        let fetchRequest = NSFetchRequest<PastObject>(entityName: "PastObject")
        fetchRequest.predicate = NSPredicate(format: "folder != NULL")

        // Fetch the objects
        do {
            let objects = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            return objects.count
        }
        catch {
            return 0
        }
        
    }
}

extension PastObject : Identifiable {

}
