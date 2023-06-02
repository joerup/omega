//
//  PastCalcSaveView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/28/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct PastCalcSaveView: View {
    
    var calculation: PastObject
    
    var body: some View {
        
        FileFolderView(folders: [calculation.folder], unsave: calculation.saved, saveAction: { folder in
            if !Settings.settings.pro && PastObject.savedAmount() >= PastObject.savedLimit {
                Settings.settings.warning = Warning(
                    headline: "Reached Saved Limit",
                    message: "You have reached the limit of \(PastObject.savedLimit) saved calculations. You can unsave others to free up space, or upgrade to Omega Pro for unlimited saved calculations.",
                    continueAction: {
                        Settings.settings.popUp = .none
                        Settings.settings.calculatorOverlay = .saved
                    }
                )
            } else {
                calculation.confirmSave(to: folder)
                PastObject.refresh.toggle()
                Settings.settings.popUp = .none
            }
        }, unsaveAction: {
            if (calculation.date ?? Date()).addingTimeInterval(PastCalculation.expirationLength) < Date() {
                Settings.settings.warning = Warning(
                    headline: "Unsave",
                    message: "This calculation is more than \(Int(PastCalculation.expirationDays)) days old and will be deleted if unsaved. Are you sure you want to delete it?",
                    continueString: "Unsave",
                    continueAction: {
                        calculation.confirmUnsave()
                        PastObject.refresh.toggle()
                        Settings.settings.popUp = .none
                    }
                )
            } else {
                Settings.settings.warning = Warning(
                    headline: "Unsave",
                    message: "Are you sure you want to unsave this calculation?",
                    continueString: "Unsave",
                    continueAction: {
                        calculation.confirmUnsave()
                        PastObject.refresh.toggle()
                        Settings.settings.popUp = .none
                    }
                )
            }
        })
    }
}

struct PastCalcMultipleSaveView: View {
    
    var calculations: [PastObject]
    
    var body: some View {
        
        FileFolderView(folders: calculations.map { $0.folder }, unsave: calculations.contains(where: { $0.saved }), saveAction: { folder in
            if !Settings.settings.pro && PastObject.savedAmount()+calculations.count > PastObject.savedLimit {
                Settings.settings.warning = Warning(
                    headline: "Reached Saved Limit",
                    message: calculations.count == 1 ? "You have reached the limit of \(PastObject.savedLimit) saved calculations. You can delete some to make room, or upgrade to Omega Pro for unlimited saved calculations." : "Saving these calculations exceeds the limit of \(PastObject.savedLimit) saved calculations. You can unsave others to free up space, or upgrade to Omega Pro for unlimited saved calculations.",
                    continueAction: {
                        Settings.settings.popUp = .none
                        Settings.settings.calculatorOverlay = .saved
                    }
                )
            } else if calculations.count > 1 {
                Settings.settings.warning = Warning(
                    headline: "Save",
                    message: folder.isEmpty ? "Are you sure you want to save the \(calculations.count) selected calculations?" : "Are you sure you want to save the \(calculations.count) selected calculations to the \(folder) folder?",
                    continueString: "Save",
                    continueAction: {
                        calculations.forEach { $0.confirmSave(to: folder) }
                        PastObject.refresh.toggle()
                        Settings.settings.popUp = .none
                    }
                )
            } else {
                calculations.forEach { $0.confirmSave(to: folder) }
                PastObject.refresh.toggle()
                Settings.settings.popUp = .none
            }
        }, unsaveAction: {
            if calculations.contains(where: { ($0.date ?? Date()).addingTimeInterval(PastCalculation.expirationLength) < Date() }) {
                Settings.settings.warning = Warning(
                    headline: "Unsave",
                    message: calculations.count > 1 ? "One or more of the selected calculations is more than \(Int(PastCalculation.expirationDays)) days old and will be deleted if unsaved. Are you sure you want to unsave the \(calculations.count) selected calculations and delete those that have expired?" : "The selected calculation is more than \(Int(PastCalculation.expirationDays)) days old and will be deleted if unsaved. Are you sure you want to delete it?",
                    continueString: "Unsave",
                    continueAction: {
                        calculations.forEach { $0.confirmUnsave() }
                        PastObject.refresh.toggle()
                        Settings.settings.popUp = .none
                    }
                )
            }
            else {
               Settings.settings.warning = Warning(
                   headline: "Unsave",
                   message: calculations.count > 1 ? "Are you sure you want to unsave the \(calculations.count) selected calculations?" : "Are you sure you want to unsave the selected calculation?",
                   continueString: "Unsave",
                   continueAction: {
                       calculations.forEach { $0.confirmUnsave() }
                       PastObject.refresh.toggle()
                       Settings.settings.popUp = .none
                   }
               )
            }
        })
    }
}
