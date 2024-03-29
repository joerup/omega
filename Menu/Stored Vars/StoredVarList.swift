//
//  StoredVarList.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 5/25/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI
import CoreData

struct StoredVarList: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var settings = Settings.settings
    
    @State private var vars: [StoredVar] = []
    
    @State private var selectionMode = false
    @State private var selectedVar: StoredVar? = nil
    @State private var selectedVars: [StoredVar] = []
    @State private var selectedAll = false
    
    var size: Size {
        return verticalSizeClass == .compact || horizontalSizeClass == .compact ? .small : .large
    }
    
    var body: some View {
        
        GeometryReader { geometry in
                
            VStack(spacing: 0) {
                
                HStack {
                    
                    if !selectionMode {
                        
                        ListDisplayTypePicker(displayType: $settings.storedVarDisplayType)
                        
                        HStack {
                            
                            Text(vars.count == 1 ? "1 Variable" : "\(vars.count) Variables")
                                .font(Font.system(.headline, design: .rounded).weight(.semibold))
                                .foregroundColor(Color.init(white: 0.6))
                                .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                                .padding(.horizontal, 15)
                            
                            Spacer()
                        
                            SmallIconButton(symbol: "plus", color: Color.init(white: 0.2), textColor: settings.theme.secondaryTextColor, smallerLarge: true, locked: true) {
                                guard proCheckNotice(.variables) else { return }
                                self.settings.popUp = AnyView(
                                    StoredVarSetView()
                                )
                            }
                        }
                        .frame(maxHeight: size == .large ? 50 : 40)
                        .background(Color.init(white: 0.15))
                        .cornerRadius(25)
                        
                    } else {
                        
                        HStack {

                            SmallIconButton(symbol: "checkmark.circle\(selectedVars.isEmpty ? "" : ".fill")", color: Color.init(white: self.selectedAll ? 0.4 : 0.2), smallerLarge: true, action: {
                                withAnimation {
                                    if !selectedVars.isEmpty {
                                        self.resetSelected()
                                    } else {
                                        self.selectedAll = true
                                        self.selectedVars = self.vars
                                    }
                                }
                            })
                            
                            Text("\(String(selectedVars.count))")
                                .font(Font.system(.headline, design: .rounded).weight(.semibold))
                                .lineLimit(0)
                                .foregroundColor(Color.init(white: 0.8))
                                .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                                .padding(.horizontal, 5)

                            Spacer()

                            if !selectedVars.isEmpty {

                                SmallIconButton(symbol: "trash", color: Color.init(white: 0.25), textColor: settings.theme.secondaryTextColor, smallerLarge: true, action: {
                                    StoredVar.deleteSelected(selectedVars)
                                })

                            } else {
                                Rectangle()
                                    .frame(width: 1, height: 1)
                                    .opacity(0)
                            }
                        }
                        .frame(maxHeight: size == .large ? 50 : 40)
                        .background(Color.init(white: 0.15))
                        .cornerRadius(25)
                    }
                    
                    SmallTextButton(text: self.selectionMode ? "Cancel" : "Edit", color: Color.init(white: 0.15), circle: true, smallerLarge: true) {
                        withAnimation {
                            guard proCheckNotice(.variables) else { return }
                            self.selectionMode.toggle()
                            self.resetSelected()
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
                    
                ScrollView {
                    
                    LazyVStack {
                        
                        Spacer()
                            .frame(height: 3)
                            
                        if vars.isEmpty {
                            
                            VStack {
                                
                                Text("No Variables Set")
                                    .font(Font.system(.title, design: .rounded).weight(.bold))
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 20)
                                
                                Text("No values are currently assigned to a variable.")
                                    .font(Font.system(.body, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Spacer()
                            }
                            .foregroundColor(Color.init(white: 0.6))
                            .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                            .padding(40)
                        }
                        
                        ForEach(vars.sorted(by: { $0.variable.name.uppercased() < $1.variable.name.uppercased() }), id: \.self) { storedVar in

                            Button(action: {
                            }) {
                                HStack {

                                    if selectionMode {
                                        Image(systemName: selectedVars.contains(storedVar) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(Color.init(white: 0.8))
                                            .imageScale(.large)
                                            .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                                            .padding(.horizontal, -5)
                                    }

                                    HStack {
                                        TextDisplay(strings: [storedVar.variable.text], size: 32, colorContext: .theme)
                                        TextDisplay(strings: ["="], size: 24, colorContext: .secondary)
                                    }
                                    .frame(width: 60)

                                    Spacer()

                                    TextDisplay(strings: storedVar.value.strings, size: 24)

                                    if !selectionMode {
                                        Image(systemName: "plus.circle")
                                            .font(.headline.weight(.semibold))
                                            .foregroundColor(Color.init(white: 0.8))
                                            .frame(maxHeight: .infinity)
                                            .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                                            .onTapGesture {
                                                guard proCheckNotice(.variables) else { return }
                                                storedVar.insert()
                                            }
                                    }
                                }
                                .frame(height: 50)
                                .padding(.horizontal, 12)
                                .background(Color.init(white: storedVar == selectedVar ? 0.25 : selectedVars.contains(storedVar) ? 0.25 : 0.15).cornerRadius(20))
                                .padding(.horizontal, 10)
                                .onTapGesture {
                                    guard proCheckNotice(.variables) else { return }
                                    SoundManager.play(haptic: .light)
                                    withAnimation {
                                        if self.selectionMode {
                                            self.selectedVar = nil
                                            if selectedVars.contains(storedVar) {
                                                selectedVars.removeAll(where: { $0 == storedVar })
                                            } else {
                                                self.selectedVars += [storedVar]
                                            }
                                        } else if selectedVar == storedVar {
                                            self.selectedVar = nil
                                        } else {
                                            self.selectedVar = storedVar
                                        }
                                    }
                                }
                                .contextMenu {
                                    if !proCheck() {
                                        Text("")
                                    } else if selectedVars.contains(storedVar) {
                                        StoredVarMultipleContextMenu(storedVars: selectedVars)
                                    } else if !selectionMode {
                                        StoredVarContextMenu(storedValue: storedVar)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        
                        Spacer()
                            .frame(height: 50)
                    }
                }
            }
            .frame(width: geometry.size.width > 650 ? geometry.size.width*0.5 : geometry.size.width)
            .padding(.trailing, geometry.size.width > 650 ? geometry.size.width*0.5 : 0)
            .accentColor(settings.theme.primaryTextColor)
            .overlay(
                VStack {
                    if geometry.size.width > 650 {
                        if let storedVar = selectedVar {
                            MenuSheetView {
                                StoredVarView(storedVar: storedVar)
                            }
                        } else if let storedVar = selectedVars.last {
                            MenuSheetView {
                                StoredVarView(storedVar: storedVar)
                            }
                        } else {
                            MenuSheetView {
                                Text("Select a Variable")
                                    .font(.system(.title, design: .rounded))
                                    .fontWeight(.bold)
                                    .padding(.bottom, 10)
                                    .foregroundColor(Color.init(white: 0.6))
                                    .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                                    .padding(40)
                            }
                        }
                    }
                    else if let storedVar = selectedVar {
                        MenuSheetView {
                            StoredVarView(storedVar: storedVar)
                        } onDismiss: {
                            self.selectedVar = nil
                        }
                    }
                }
                .frame(width: geometry.size.width > 650 ? geometry.size.width*0.5 : geometry.size.width)
                .padding(.leading, geometry.size.width > 650 ? geometry.size.width*0.5 : 0)
            )
            .onAppear {
                self.vars = StoredVar.getAllVariables(type: settings.storedVarDisplayType)
            }
            .onChange(of: settings.storedVarDisplayType) { _ in
                withAnimation {
                    self.vars = StoredVar.getAllVariables(type: settings.storedVarDisplayType)
                    self.resetSelected()
                }
            }
            .onChange(of: StoredVar.refresh) { _ in
                self.vars = StoredVar.getAllVariables(type: settings.storedVarDisplayType)
                self.selectedVars.removeAll()
                self.selectedAll = false
            }
            .onChange(of: self.settings.menuSheetRefresh) { _ in
                self.selectedVar = nil
            }
        }
    }
    
    func selectionOff() {
        self.selectionMode = false
        resetSelected()
    }
    
    func resetSelected() {
        self.selectedVar = nil
        self.selectedVars.removeAll()
        self.selectedAll = false
    }
}
