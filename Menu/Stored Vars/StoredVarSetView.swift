//
//  StoredVarSetView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 5/25/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI
import CoreData

struct StoredVarSetView: View {
    
    @ObservedObject var settings = Settings.settings
    var managedObjectContext = PersistenceController.shared.container.viewContext
    
    var initialValue: Queue
    var editing: Bool
    var uuid: UUID?
    
    let columns = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    
    @State private var value: Queue? = nil
    @State private var letter = ""
    @State private var varSubscript = ""
    
    @State private var uppercase: Bool = false
    @State private var alphabet: Alphabet = .english
    private var letters: [InputButton] {
        switch alphabet {
        case .english:
            return uppercase ? Input.alphaUpper.buttons : Input.alphaLower.buttons
        case .greek:
            return uppercase ? Input.greekUpper.buttons : Input.greekLower.buttons
        }
    }
    
    init(value: Queue = Queue(), uuid: UUID? = nil) {
        self.initialValue = value
        self._value = State(initialValue: value)
        self.uuid = uuid
        self.editing = value.empty
    }
    
    var body: some View {
        
        PopUpSheet(title: "Assign", confirmAction: {
            
            let variables = StoredVar.getAllVariables()
            guard !letter.isEmpty else { return }
            
            // Overwrite other variable
            guard !variables.contains(where: { $0.varName == self.letter }) else {
                settings.warning = Warning(
                    headline: "Overwrite Variable",
                    message: "This variable already contains a value. Would you like to overwrite it?",
                    continueString: "Overwrite",
                    continueAction: {
                        for variable in variables.filter({ $0.varName == self.letter }) {
                            variable.confirmDelete()
                        }
                        setVariable()
                    }
                )
                return
            }
            // Overwrite Constant
            guard !Letter.constants.contains(where: { $0.name == self.letter }) else {
                settings.warning = Warning(
                    headline: "Overwrite Constant",
                    message: "This letter is used as a constant. Would you like to overwrite it and use the new value instead?",
                    continueString: "Overwrite",
                    continueAction: {
                        for variable in variables.filter({ $0.varName == self.letter }) {
                            variable.confirmDelete()
                        }
                        setVariable()
                    }
                )
                return
            }
            
            setVariable()
            
        }) {
            
            GeometryReader { geometry in
                
                VStack {
                    
                    HStack {
                        
                        if !letter.isEmpty {
                            HStack {
                                TextDisplay(strings: ["»"+letter], size: 45)
                                TextDisplay(strings: ["="], size: 36, colorContext: .secondary)
                            }
                            .transaction { $0.animation = nil }
                        }

                        Spacer()
                            
                        TextInput(queue: self.value, size: 30, scrollable: true, onChange: { value in
                            self.value = value
                        })
                        .disabled(!editing)
                        .transaction { $0.animation = nil }
                    }
                    .frame(height: 50)
                    .padding(10)
                    .background(Color.init(white: 0.3))
                    .cornerRadius(20)
                    .padding(.vertical, 10)
                    
                    ScrollView {
                        
                        VStack {
                            
                            let count = geometry.size.width > 400 ? 10 : 8
                            
                            HStack {
                                Text("Select Variable")
                                    .font(.system(.body, design: .rounded).weight(.semibold))
                                Spacer()
                                AlphabetButton(alphabet: $alphabet,
                                               uppercase: $uppercase,
                                               width: 50,
                                               backgroundColor: Color.init(white: 0.3),
                                               smallerSmall: true
                                )
                                SmallIconButton(symbol: uppercase ? "capslock.fill" : "capslock",
                                                color: Color.init(white: 0.3),
                                                textColor: .white,
                                                smallerSmall: true,
                                                sound: .click3
                                ) {
                                    uppercase.toggle()
                                }
                            }
                            .padding(.horizontal, 5)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: count), spacing: 0) {
                                
                                ForEach(self.letters, id: \.id) { button in
                                    ButtonView(button: button, backgroundColor: color(button.name == letter ? self.settings.theme.color1 : self.settings.theme.color3), width: geometry.size.width*0.95/CGFloat(count), height: geometry.size.width*0.95/CGFloat(count), relativeSize: 0.45, customAction: {
                                        self.letter = button.name
                                    })
                                    .padding(.vertical, geometry.size.width*0.95/CGFloat(count)*0.025)
                                    .padding(.horizontal, geometry.size.width*0.95/CGFloat(count)*0.025/CGFloat(count))
                                }
                            }
                            .transaction { $0.animation = nil }
                        }
                    }
                }
            }
        }
    }
    
    func setVariable() {
        
        guard proCheckNotice(.variables), let value = value, !value.allLetters.contains(where: { $0.name == letter }) else { return }
        
        let storedVar = StoredVar(context: managedObjectContext)
        
        storedVar.uuid = uuid ?? UUID()
        storedVar.date = Date()
        
        storedVar.varName = letter
        storedVar.setValue(to: value.final)
        
        PersistenceController.shared.save()
        
        settings.notification = .assign
        settings.popUp = nil
    }
}
