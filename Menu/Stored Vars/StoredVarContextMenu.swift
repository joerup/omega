//
//  StoredVarContextMenu.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/22/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct StoredVarContextMenu: View {
    
    @State var storedValue: StoredVar

    var body: some View {

        Group {
            
            Section {
                Button(action: storedValue.insert) {
                    Image(systemName: "plus.circle")
                    Text("Insert")
                }
                Button(action: storedValue.copy) {
                    Image(systemName: "doc.on.clipboard\(storedValue.copied ? ".fill" : "")")
                    Text("Copy")
                }
            }
            
            Section {
                Button(action: storedValue.delete) {
                    Image(systemName: "trash")
                    Text("Delete")
                }
            }
        }
    }
}

struct StoredVarMultipleContextMenu: View {

    @State var storedVars: [StoredVar]

    var body: some View {

        Group {
            
            Button(action: {
                StoredVar.deleteSelected(storedVars)
            }) {
                Image(systemName: "trash")
                Text("Delete")
            }
        }
    }
}

