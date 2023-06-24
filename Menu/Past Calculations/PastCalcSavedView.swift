//
//  PastCalcSavedView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/8/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI
import CoreData

struct PastCalcSavedView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var settings = Settings.settings
    @ObservedObject var current = Calculation.current

    @Binding var displayType: ListDisplayType
    @Binding var selectedFolder: String?
    
    @State private var calculations: [PastCalculation] = []
    @State private var count: Int = 50
    
    @State private var selectionMode = false
    @State private var selectedCalculation: PastCalculation? = nil
    @State private var selectedCalculations: [PastCalculation] = []
    @State private var selectedAll = false
    
    @State private var searchMode = false
    @State private var searchText: String = ""

    @State private var editFolder = false
    @State private var newFolderText: String = ""
    
    var size: Size {
        return verticalSizeClass == .compact || horizontalSizeClass == .compact ? .small : .large
    }

    var body: some View {

        GeometryReader { geometry in

            VStack(spacing: 0) {

                ZStack {
                    
                    HStack {
                        
                        if !selectionMode {
                            
                            ListDisplayTypePicker(displayType: $displayType)
                                
                            Button(action: {
                                self.editFolder.toggle()
                                SoundManager.play(sound: .click3, haptic: .medium)
                            }) {
                                HStack {
                                    
                                    SmallIconButton(symbol: "folder\(selectedFolder != nil ? ".fill" : "")", color: Color.init(white: 0.2), textColor: color(settings.theme.color2, edit: true), smallerLarge: true) {
                                        self.editFolder.toggle()
                                    }

                                    if let selectedFolder = selectedFolder {
                                        Text(selectedFolder)
                                            .font(Font.system(.headline, design: .rounded).weight(.semibold))
                                            .foregroundColor(color(settings.theme.color2, edit: true))
                                            .padding(.horizontal, 5)
                                            .padding(.vertical, 10)
                                    } else {
                                        Text("All Saved")
                                            .font(Font.system(.headline, design: .rounded).weight(.semibold))
                                            .foregroundColor(Color.init(white: 0.6))
                                            .padding(.horizontal, 5)
                                            .padding(.vertical, 10)
                                    }

                                    Spacer()

                                    Image(systemName: editFolder ? "chevron.up" : "chevron.down")
                                        .imageScale(.small)
                                        .foregroundColor(Color.init(white: 0.6))
                                        .animation(.default)
                                        .padding(.horizontal, 5)
                                }
                                .frame(maxHeight: size == .large ? 50 : 40)
                            }
                            .padding(.trailing, 10)
                            .frame(maxHeight: size == .large ? 50 : 40)
                            .background(Color.init(white: 0.15))
                            .cornerRadius(25)
                            
                        } else {
                            
                            HStack {
                                
                                SmallIconButton(symbol: "checkmark.circle\(selectedCalculations.isEmpty ? "" : ".fill")", color: Color.init(white: self.selectedAll ? 0.4 : 0.2), smallerLarge: true, action: {
                                    if !selectedCalculations.isEmpty {
                                        self.resetSelected()
                                    } else {
                                        self.selectedAll = true
                                        self.selectedCalculations = getAllCalculations(limit: false).reversed()
                                    }
                                })
                                
                                Text("\(String(selectedCalculations.count)) selected")
                                    .font(Font.system(.headline, design: .rounded).weight(.semibold))
                                    .lineLimit(0)
                                    .foregroundColor(Color.init(white: 0.8))
                                    .padding(.horizontal, 5)
                                
                                Spacer()

                                if !selectedCalculations.isEmpty {

                                    SmallIconButton(symbol: "folder\(!selectedCalculations.isEmpty && selectedCalculations.contains(where: { $0.saved }) ? ".fill" : "")", color: Color.init(white: 0.25), textColor: color(settings.theme.color2, edit: true), smallerLarge: true, action: {
                                        PastCalculation.saveSelected(selectedCalculations)
                                    })

                                    SmallIconButton(symbol: "arrow.up.doc", color: Color.init(white: 0.25), textColor: color(settings.theme.color2, edit: true), smallerLarge: true, proOnly: true, action: {
                                        PastCalculation.exportSelected(selectedCalculations)
                                    })

                                    SmallIconButton(symbol: "trash", color: Color.init(white: 0.25), textColor: color(settings.theme.color2, edit: true), smallerLarge: true, action: {
                                        PastCalculation.deleteSelected(selectedCalculations)
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
                            self.editFolder = false
                            self.selectionMode.toggle()
                            self.resetSelected()
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
                
                if editFolder {
                    
                    VStack(spacing: 0) {

                        ScrollView {

                            VStack {

                                Button(action: {
                                    self.selectedFolder = nil
                                    self.editFolder = false
                                    SoundManager.play(sound: .click3, haptic: .medium)
                                }) {
                                    HStack {
                                        Text("All Saved")
                                            .font(Font.system(.headline, design: .rounded).weight(.semibold))
                                            .foregroundColor(Color.init(white: 0.7))
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(Color.init(white: selectedFolder == nil ? 0.25 : 0.15))
                                    .cornerRadius(10)
                                }
                                .padding(.top, 10)
                                
                                if proCheck() {
                                    
                                    ForEach(settings.folders, id: \.self) { folder in

                                        HStack {
                                            Button(action: {
                                                self.selectedFolder = folder
                                                self.editFolder = false
                                                SoundManager.play(sound: .click3, haptic: .medium)
                                            }) {
                                                Text(folder)
                                                    .font(Font.system(.headline, design: .rounded).weight(.semibold))
                                                    .foregroundColor(.white)
                                                Spacer()
                                            }
                                            Menu {
                                                Button(action: {
                                                    self.settings.warning = Warning(
                                                        headline: "Delete",
                                                        message: "Are you sure you want to delete the \(folder) folder? This action cannot be undone. Note that this will only delete the folder itself, not the calculations inside it.",
                                                        continueString: "Delete",
                                                        continueAction: {
                                                            self.settings.folders.removeAll(where: { $0 == folder })
                                                            PastCalculation.getCalculations(folder: folder).forEach{ $0.confirmSave(to: "") }
                                                            if selectedFolder == folder {
                                                                selectedFolder = nil
                                                            }
                                                        }
                                                    )
                                                }) {
                                                    Image(systemName: "trash")
                                                    Text("Delete")
                                                }
                                            } label: {
                                                Image(systemName: "ellipsis.circle")
                                                    .foregroundColor(Color.init(white: 0.7))
                                            }
                                        }
                                        .padding(10)
                                        .background(Color.init(white: selectedFolder == folder ? 0.25 : 0.15))
                                        .cornerRadius(10)
                                    }
                                    
                                    TextField(NSLocalizedString("New Folder", comment: ""), text: self.$newFolderText, onCommit: {
                                        while self.newFolderText.last == " " {
                                            self.newFolderText.removeLast()
                                        }
                                        while self.newFolderText.first == " " {
                                            self.newFolderText.removeFirst()
                                        }
                                        if !self.newFolderText.isEmpty && !settings.folders.contains(newFolderText) {
                                            self.selectedFolder = newFolderText
                                            self.settings.folders.insert(newFolderText, at: 0)
                                        }
                                        self.newFolderText.removeAll()
                                        self.editFolder = false
                                        SoundManager.play(haptic: .light)
                                    })
                                    .font(Font.system(.headline, design: .rounded).weight(.semibold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.init(white: 0.15))
                                    .cornerRadius(10)
                                    
                                } else {
                                    Button(action: {
                                        guard proCheckNotice() else { return }
                                    }) {
                                        HStack {
                                            Text("New Folder")
                                                .font(Font.system(.headline, design: .rounded).weight(.semibold))
                                                .foregroundColor(Color.init(white: 0.6))
                                            Spacer()
                                            Image(systemName: "lock.fill")
                                                .foregroundColor(color(settings.theme.color1))
                                        }
                                        .padding(10)
                                        .background(Color.init(white: 0.15))
                                        .cornerRadius(10)
                                    }
                                }

                                Spacer().frame(height: 10)
                            }
                        }
                        .frame(minHeight: 150)
                        .frame(maxHeight: 225)
                    }
                    .padding(.horizontal, 10)
                    .background(Color.init(white: 0.1))
                    .cornerRadius(20)
                    .padding(.horizontal, 10)
                    .padding(.top, 3)
                    .padding(.bottom, 5)
                }

                if self.calculations.isEmpty && !self.editFolder {

                    VStack {

                        Text("No Calculations")
                            .font(Font.system(.title, design: .rounded).weight(.bold))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)

                        if selectedFolder != nil {
                            Text("This folder is empty.")
                                .font(Font.system(.body, design: .rounded))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Text("Saved calculations will appear here and will not expire.")
                                .font(Font.system(.body, design: .rounded))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Spacer()
                    }
                    .foregroundColor(Color.init(white: 0.6))
                    .padding(40)
                }

                ScrollView {

                    LazyVStack {

                        Spacer()
                            .frame(height: 3)

                        ForEach(self.calculations, id: \.id) { calculation in

                            Button(action: {
                            }) {
                                HStack {

                                    if self.selectionMode {
                                        Image(systemName: selectedCalculations.contains(calculation) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(Color.init(white: 0.8))
                                            .imageScale(.large)
                                            .padding(.horizontal, -5)
                                    }

                                    VStack {
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(color(self.settings.theme.color1, edit: true))
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(50/4)
                                            Image(systemName: calculation.listType.icon)
                                                .foregroundColor(.init(white: calculation.saved ? 1 : 0.1))
                                                .opacity(calculation.saved ? 1 : 0.6)
                                                .font(.system(size: 50/2, weight: .black))
                                                .animation(nil)
                                        }
                                        .padding(.horizontal, 5)
                                        .padding(.top, 5)

                                        Text(timestamp(calculation.date))
                                            .foregroundColor(Color.init(white: 0.7))
                                            .font(.caption)
                                            .frame(width: 60)
                                            .minimumScaleFactor(0.1)
                                            .lineLimit(0)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 0) {

                                        if calculation.showResult {

                                            if let name = calculation.name, !name.isEmpty {
                                                Text(name)
                                                    .font(.system(size: 24, design: .rounded))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(color(settings.theme.color1))
                                                    .frame(height: 36)
                                            } else {
                                                TextDisplay(strings: calculation.queue.strings, modes: calculation.modes, size: 24, opacity: 0.7, equals: !calculation.result.error)
                                                    .frame(height: 36)
                                            }

                                            TextDisplay(strings: calculation.result.strings, modes: calculation.modes, size: 36)
                                                .frame(height: 45)

                                        } else {

                                            if let name = calculation.name, !name.isEmpty {
                                                Text(name)
                                                    .font(.system(size: 24, design: .rounded))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(color(settings.theme.color1))
                                                    .frame(height: 36)
                                            }

                                            TextDisplay(strings: calculation.queue.strings, modes: calculation.modes, size: 36)
                                                .frame(height: calculation.name?.isEmpty ?? true ? 81 : 45)

                                        }
                                    }
                                    .border(Color.yellow, width: settings.guidelines ? 1 : 0)

                                    if !self.selectionMode {
                                        Image(systemName: "plus.circle")
                                            .foregroundColor(Color.init(white: 0.8))
                                            .imageScale(.large)
                                            .frame(maxHeight: .infinity)
                                            .onTapGesture {
                                                calculation.insert()
                                            }
                                    }
                                }
                                .frame(minHeight: 90)
                                .padding(.horizontal, 7)
                                .padding(5)
                                .background(Color.init(white: calculation == selectedCalculation ? 0.25 : selectedCalculations.contains(calculation) ? 0.25 : 0.15).cornerRadius(20))
                                .animation(nil)
                                .padding(.horizontal, 10)
                                .onTapGesture {
                                    SoundManager.play(haptic: .light)
                                    if self.selectionMode {
                                        self.selectedCalculation = nil
                                        if selectedCalculations.contains(calculation) {
                                            selectedCalculations.removeAll(where: { $0 == calculation })
                                        } else {
                                            self.selectedCalculations += [calculation]
                                        }
                                    } else if selectedCalculation == calculation {
                                        self.selectedCalculation = nil
                                    } else {
                                        self.selectedCalculation = calculation
                                    }
                                }
                                .contextMenu {
                                    if selectedCalculations.contains(calculation) {
                                        PastCalculationMultipleContextMenu(calculations: selectedCalculations)
                                    } else if !selectionMode {
                                        PastCalculationContextMenu(calculation: calculation)
                                    }
                                }
                            }
                            .id(!calculation.isFault ? calculation.uuid : UUID())
                        }
                        .id(self.current.update)
                        
                        if !settings.pro && !calculations.isEmpty {
                            Text("\(PastObject.savedAmount()) of maximum \(PastObject.savedLimit) calculations saved")
                                .font(.footnote)
                                .foregroundColor(Color.init(white: 0.6))
                                .padding(10)
                                .animation(nil)
                        }
                        
                        Spacer()
                            .frame(height: 50)

                        if self.calculations.count >= self.count {
                            Spacer()
                                .onAppear {
                                    self.count += 25
                                    self.calculations = getAllCalculations()
                                }
                        }
                    }
                    .animation(nil)
                }
                .id(self.selectedFolder)
            }
            .frame(width: geometry.size.width > 650 ? geometry.size.width*0.5 : geometry.size.width)
            .padding(.trailing, geometry.size.width > 650 ? geometry.size.width*0.5 : 0)
            .accentColor(color(self.settings.theme.color1, edit: true))
            .simultaneousGesture(DragGesture(minimumDistance: 30)
                .onChanged { value in
                    if abs(value.translation.height) > abs(value.translation.width) && value.translation.height > 50 {
                        settings.calculatorOverlay = .none
                    }
                }
            )
            .overlay(
                VStack {
                    if geometry.size.width > 650 {
                        if let calculation = selectedCalculation {
                            MenuSheetView {
                                PastCalculationView(calculation: calculation)
                            }
                        } else if let calculation = selectedCalculations.last {
                            MenuSheetView {
                                PastCalculationView(calculation: calculation)
                            }
                        } else {
                            MenuSheetView {
                                Text("Select a Calculation")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 10)
                                    .foregroundColor(Color.init(white: 0.6))
                                    .padding(40)
                            }
                        }
                    }
                    else if let calculation = selectedCalculation {
                        MenuSheetView {
                            PastCalculationView(calculation: calculation)
                        } onDismiss: {
                            self.selectedCalculation = nil
                        }
                    }
                }
                .frame(width: geometry.size.width > 650 ? geometry.size.width*0.5 : geometry.size.width)
                .padding(.leading, geometry.size.width > 650 ? geometry.size.width*0.5 : 0)
                .highPriorityGesture(DragGesture(minimumDistance: 30)
                    .onChanged { value in
                        if abs(value.translation.height) > abs(value.translation.width) && value.translation.height > 50 {
                            self.selectedCalculation = nil
                        }
                    }
                )
            )
            .onAppear {
                self.calculations = []
                self.calculations = getAllCalculations()
            }
            .onChange(of: displayType) { _ in
                self.count = 50
                self.calculations = []
                self.calculations = getAllCalculations()
                self.resetSelected()
            }
            .onChange(of: selectedFolder) { _ in
                self.count = 50
                self.calculations = []
                self.calculations = getAllCalculations()
                self.resetSelected()
            }
            .onChange(of: PastCalculation.refresh) { _ in
                self.calculations = getAllCalculations()
                self.selectedCalculations.removeAll()
                self.selectedAll = false
            }
            .onChange(of: self.settings.menuSheetRefresh) { _ in
                self.selectedCalculation = nil
            }
        }
    }

    func getAllCalculations(limit: Bool = true) -> [PastCalculation] {

        var calculations: [PastCalculation] = []

        // Create the fetch request
        let fetchRequest = NSFetchRequest<PastCalculation>(entityName: "PastCalculation")

        // Order by most recent
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        // Limit only to the number of offsets
        if limit {
            fetchRequest.fetchLimit = self.count
        }

        // Limit the folder
        if let selectedFolder = selectedFolder {
            fetchRequest.predicate = NSPredicate(format: "folder == %@", selectedFolder)
        } else {
            fetchRequest.predicate = NSPredicate(format: "folder != NULL")
        }

        // Fetch the calculations
        do {
            calculations = try managedObjectContext.fetch(fetchRequest)
        }
        catch {
            fatalError("Failed to get calculations")
        }
        
        // Filter the type
        if displayType != .all {
            calculations = calculations.filter { $0.listType == displayType }
        }

        return calculations
    }

    func selectionOff() {
        self.selectionMode = false
        resetSelected()
    }

    func resetSelected() {
        self.selectedCalculation = nil
        self.selectedCalculations.removeAll()
        self.selectedAll = false
    }
    
    func timestamp(_ date: Date?) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none

        if dateFormatter.string(from: date ?? Date()) == dateFormatter.string(from: Date()) {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: date ?? Date())
        } else {
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            return dateFormatter.string(from: date ?? Date())
        }
    }
}
