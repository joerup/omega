//
//  PastCalculationContextMenu.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 4/21/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct PastCalculationContextMenu: View {

    @ObservedObject var calculation: PastCalculation

    var body: some View {

        Group {
            
            Section {
                Button(action: calculation.insert) {
                    Image(systemName: "plus.circle")
                    Text("Insert")
                }
                Button(action: calculation.edit) {
                    Image(systemName: "pencil")
                    Text("Edit")
                }
                Button(action: calculation.copy) {
                    Image(systemName: "doc.on.clipboard\(calculation.copied ? ".fill" : "")")
                    Text("Copy")
                }
            }
            
            Section {
                Button(action: calculation.save) {
                    Image(systemName: "folder\(calculation.saved ? ".fill" : "")")
                    Text("Save")
                }
                Button(action: calculation.store) {
                    Image(systemName: "character.textbox")
                    Text("Assign")
                }
            }
            
            Section {
                Button(action: calculation.delete) {
                    Image(systemName: "trash")
                    Text("Delete")
                }
            }
        }
    }
}

struct PastCalculationMultipleContextMenu: View {

    @State var calculations: [PastCalculation]

    var body: some View {

        Group {
            
            Section {
                Button(action: {
                    PastCalculation.saveSelected(calculations)
                }) {
                    Image(systemName: "folder\(calculations.contains(where: { $0.saved }) ? ".fill" : "")")
                    Text("Save")
                }
                Button(action: {
                    PastCalculation.exportSelected(calculations)
                }) {
                    Image(systemName: "arrow.up.doc")
                    Text("Export")
                }
            }
            
            Button(action: {
                PastCalculation.deleteSelected(calculations)
            }) {
                Image(systemName: "trash")
                Text("Delete")
            }
        }
    }
}

