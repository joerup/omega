//
//  StoredVarView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/15/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct StoredVarView: View {
        
    @ObservedObject var settings = Settings.settings
    
    var storedVar: StoredVar
    
    @State private var name = ""
    
    var body: some View {
        
        GeometryReader { geometry in
                
            ScrollView {
                
                VStack {
                    
                    // Name
                    
                    HStack {
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color.init(white: 0.2))
                                .frame(width: 85, height: 85)
                                .cornerRadius(85/4)
                            TextDisplay(strings: [storedVar.variable.text], size: 50, color: color(settings.theme.color1, edit: true))
                        }
                        .padding(.top, -3)

                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 0) {

                            TextField(NSLocalizedString("Variable", comment: ""), text: self.$name, onCommit: {
                                while self.name.last == " " {
                                    self.name.removeLast()
                                }
                                while self.name.first == " " {
                                    self.name.removeFirst()
                                }
                                if self.name == "" {
                                    self.name = ""
                                }
                                storedVar.rename(to: name)
                            })
                            .font(Font.system(.title2, design: .rounded).weight(.bold))
                            .foregroundColor(color(self.settings.theme.color1, edit: true))
                            .padding(.top, -3)

                            HStack(spacing: 5) {
                                
                                Text(self.dateString(self.storedVar.date ?? Date(), dateStyle: .medium, timeStyle: .none))
                                    .font(Font.system(.subheadline, design: .rounded))
                                    .foregroundColor(Color.init(white: 0.6))
                                
                                Text("•")
                                    .font(Font.system(.subheadline, design: .rounded))
                                    .foregroundColor(Color.init(white: 0.8))
                                
                                Text(self.dateString(self.storedVar.date ?? Date(), dateStyle: .none, timeStyle: .short))
                                    .font(Font.system(.subheadline, design: .rounded))
                                    .foregroundColor(Color.init(white: 0.6))
                            }
                            .padding(.leading, 0.5)
                            .padding(.bottom, 2)
                            
                            HStack(spacing: 5) {
                                Image(systemName: "character.textbox")
                                    .imageScale(.small)
                                    .foregroundColor(color(settings.theme.color1))
                                Text(LocalizedStringKey(storedVar.variable.typeString))
                                    .font(Font.system(.subheadline, design: .rounded))
                                    .foregroundColor(Color.init(white: 0.5))
                            }
                        }
                        .padding(.leading, 6)
                        
                        Spacer()
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 1)
                    
                    // Display

                    TextInput(queue: storedVar.value, size: 55, scrollable: true, onChange: { value in
                        self.storedVar.setValue(to: value)
                    })
                    .padding(.vertical, 20)
                    .padding(.horizontal, 10)
                    .background(Color.init(white: 0.2))
                    .cornerRadius(20)
                
                    // Buttons
                    
                    HStack {
                        LargeIconButton(text: "Insert", image: "plus.circle", action: {
                            storedVar.insert()
                        })
                        LargeIconButton(text: "Copy", image: "doc.on.clipboard\(storedVar.copied ? ".fill" : "")", action: {
                            storedVar.copy()
                        })
                        LargeIconButton(text: "Delete", image: "trash", action: {
                            storedVar.delete()
                        })
                    }
                    
                    // Squares
                    
                    HStack(spacing: 0) {
                        CalculationVisuals(calculation: Calculation(storedVar.value), width: geometry.size.width-30, height: geometry.size.width/2-30, lightBackground: true)
                    }
                    .id(Calculation.current.update)
                    
                    // Substitute
                    
                    if !storedVar.value.allLetters.filter{ !$0.systemConstant }.isEmpty {
                        VariablePlugView(queue: storedVar.value)
                            .background(Color.init(white: 0.2))
                            .cornerRadius(20)
                            .id(Calculation.current.update)
                    }
                    
                    Spacer()
                        .frame(height: 60)
                }
                .id(storedVar)
            }
            .padding(10)
            .onAppear {
                self.name = self.storedVar.name ?? ""
            }
            .onChange(of: self.storedVar) { storedVar in
                self.name = storedVar.name ?? ""
            }
        }
        .proLock()
    }
    
    func dateString(_ date: Date?, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.doesRelativeDateFormatting = true

        return dateFormatter.string(from: date ?? Date())
    }
}
