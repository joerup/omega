//
//  PastCalcRecentView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/19/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI
import CoreData

struct PastCalcRecentView: View {

    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var settings = Settings.settings
    @ObservedObject var current = Calculation.current
    
    @State private var calculations: [PastCalculation] = []
    @State private var count: Int = 50
    
    @State private var selectionMode = false
    @State private var selectedCalculation: PastCalculation? = nil
    @State private var selectedCalculations: [PastCalculation] = []
    @State private var selectedAll = false

    @State private var editCalendar = false
    
    var prevDate: Date {
        return settings.selectedDate.advanced(by: -86400)
    }
    var nextDate: Date {
        return settings.selectedDate.advanced(by: 86400)
    }
    var minDate: Date {
        return Date().advanced(by: -PastCalculation.expirationLength)
    }
    
    var size: Size {
        return verticalSizeClass == .compact || horizontalSizeClass == .compact ? .small : .large
    }
    
    var body: some View {

        GeometryReader { geometry in

            VStack(spacing: 0) {
                
                ZStack {
                    
                    HStack {
                        
                        if !selectionMode {
                            
                            ListDisplayTypePicker(displayType: $settings.recentDisplayType)
                            
                            HStack {
                                    
                                SmallIconButton(symbol: "calendar", color: Color.init(white: editCalendar ? 0.3 : 0.2), textColor: settings.theme.secondaryTextColor, smallerLarge: true) {
                                    withAnimation {
                                        self.editCalendar.toggle()
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    if prevDate >= minDate {
                                        withAnimation {
                                            settings.selectedDate = prevDate
                                        }
                                        SoundManager.play(haptic: .light)
                                    }
                                }) {
                                    Image(systemName: "chevron.backward")
                                        .font(.body.bold())
                                        .foregroundColor(prevDate >= minDate ? settings.theme.secondaryTextColor : Color.init(white: 0.25))
                                        .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                                        .padding(.horizontal, 5)
                                }
                                
                                Text(dateString(settings.selectedDate))
                                    .font(Font.system(.headline, design: .rounded).weight(.semibold))
                                    .foregroundColor(.white)
                                    .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                                    .lineLimit(0)
                                    .minimumScaleFactor(0.5)
                                    .padding(5)
                                
                                Button(action: {
                                    if nextDate <= Date() {
                                        withAnimation {
                                            settings.selectedDate = nextDate
                                        }
                                        SoundManager.play(haptic: .light)
                                    }
                                }) {
                                    Image(systemName: "chevron.forward")
                                        .font(.body.bold())
                                        .foregroundColor(nextDate <= Date() ? settings.theme.secondaryTextColor : Color.init(white: 0.25))
                                        .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                                        .padding(.horizontal, 5)
                                }
                                
                                Spacer()
                                
                                SmallIconButton(symbol: "house", color: Color.init(white: Calendar.current.isDate(settings.selectedDate, inSameDayAs: Date()) ? 0.3 : 0.2), textColor: settings.theme.secondaryTextColor, smallerLarge: true) {
                                    withAnimation {
                                        settings.selectedDate = .now
                                    }
                                }
                            }
                            .frame(maxHeight: size == .large ? 50 : 40)
                            .background(Color.init(white: 0.15))
                            .cornerRadius(25)
                        }
                        else {

                            HStack {
                                
                                SmallIconButton(symbol: "checkmark.circle\(selectedCalculations.isEmpty ? "" : ".fill")", color: Color.init(white: self.selectedAll ? 0.4 : 0.2), smallerLarge: true, action: {
                                    withAnimation {
                                        if !selectedCalculations.isEmpty {
                                            self.resetSelected()
                                        } else {
                                            self.selectedAll = true
                                            self.selectedCalculations = getAllCalculations(limit: false).reversed()
                                        }
                                    }
                                })
                                
                                Text("\(String(selectedCalculations.count))")
                                    .font(Font.system(.headline, design: .rounded).weight(.semibold))
                                    .lineLimit(0)
                                    .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                                    .foregroundColor(Color.init(white: 0.8))
                                    .padding(.horizontal, 5)
                                
                                Spacer()

                                if !selectedCalculations.isEmpty {

                                    SmallIconButton(symbol: "folder\(!selectedCalculations.isEmpty && selectedCalculations.contains(where: { $0.saved }) ? ".fill" : "")", color: Color.init(white: 0.25), textColor: settings.theme.secondaryTextColor, smallerLarge: true, locked: settings.featureVersionIdentifier > 0, action: {
                                        PastCalculation.saveSelected(selectedCalculations)
                                    })

                                    SmallIconButton(symbol: "square.and.arrow.up", color: Color.init(white: 0.25), textColor: settings.theme.secondaryTextColor, smallerLarge: true, locked: true, action: {
                                        PastCalculation.exportSelected(selectedCalculations)
                                    })

                                    SmallIconButton(symbol: "trash", color: Color.init(white: 0.25), textColor: settings.theme.secondaryTextColor, smallerLarge: true, action: {
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
                            withAnimation {
                                self.editCalendar = false
                                self.selectionMode.toggle()
                                self.resetSelected()
                            }
                        }
                    }
                    .animation(.default, value: settings.selectedDate)
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
                
                if editCalendar {
                    
                    DatePicker("Date", selection: self.$settings.selectedDate, in: Date().addingTimeInterval(-PastCalculation.expirationLength)...Date(), displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .onChange(of: settings.selectedDate) { _ in
                            withAnimation {
                                self.editCalendar = false
                            }
                            SoundManager.play(haptic: .medium)
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 3)
                        .padding(.bottom, 15)
                        .accentColor(settings.theme.secondaryTextColor)
                        .background(Color.init(white: 0.15))
                        .cornerRadius(20)
                        .padding(.horizontal, 10)
                        .padding(.top, 3)
                        .padding(.bottom, 5)
                        .animation(.default, value: settings.selectedDate)
                }

                if self.calculations.isEmpty && !self.editCalendar {
                    
                    VStack {
                        
                        Text("No Calculations")
                            .font(Font.system(.title, design: .rounded).weight(.bold))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)
                        
                        Text("No calculations were performed on the selected day.")
                            .font(Font.system(.body, design: .rounded))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                    .foregroundColor(Color.init(white: 0.6))
                    .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                    .padding(40)
                }
                
                ScrollView {
                    
                    LazyVStack {
                        
                        Spacer()
                            .frame(height: 3)

                        ForEach(self.calculations.indices, id: \.self) { c in
                            
                            let calculation = self.calculations[c]
                                
                            Button(action: {
                            }) {
                                HStack {
                                    
                                    if self.selectionMode {
                                        Image(systemName: selectedCalculations.contains(calculation) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(Color.init(white: 0.8))
                                            .imageScale(.large)
                                            .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                                            .padding(.horizontal, -5)
                                    }

                                    VStack {
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(settings.theme.primaryColor)
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(50/4)
                                            Image(systemName: calculation.listType.icon)
                                                .foregroundColor(.init(white: calculation.saved ? 1 : 0.1))
                                                .opacity(calculation.saved ? 1 : 0.6)
                                                .font(.system(size: 50/2, weight: .black))
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
                                                    .foregroundColor(settings.theme.secondaryTextColor)
                                                    .frame(height: 36)
                                            } else {
                                                TextDisplay(strings: calculation.queue.strings, modes: calculation.modes, size: 24, colorContext: .secondary, equals: !calculation.result.error)
                                                    .frame(height: 36)
                                            }
                                            
                                            TextDisplay(strings: calculation.result.strings, modes: calculation.modes, size: 36)
                                                .frame(height: 45)
                                            
                                        } else {
                                            
                                            if let name = calculation.name, !name.isEmpty {
                                                Text(name)
                                                    .font(.system(size: 24, design: .rounded))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(settings.theme.secondaryTextColor)
                                                    .frame(height: 36)
                                            }
                                            
                                            TextDisplay(strings: calculation.queue.strings, modes: calculation.modes, size: 36)
                                                .frame(height: calculation.name?.isEmpty ?? true ? 81 : 45)
                                            
                                        }
                                    }
                                    .border(Color.yellow, width: settings.guidelines ? 1 : 0)
                                    
                                    if !self.selectionMode {
                                        Image(systemName: "plus.circle")
                                            .font(.headline.weight(.semibold))
                                            .foregroundColor(Color.init(white: 0.8))
                                            .frame(maxHeight: .infinity)
                                            .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                                            .onTapGesture {
                                                calculation.insert()
                                            }
                                    }
                                }
                                .frame(minHeight: 90)
                                .padding(.horizontal, 7)
                                .padding(5)
                                .background(Color.init(white: calculation == selectedCalculation ? 0.25 : selectedCalculations.contains(calculation) ? 0.25 : 0.15).cornerRadius(20))
                                .padding(.horizontal, 10)
                                .onTapGesture {
                                    SoundManager.play(haptic: .light)
                                    withAnimation {
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
                                }
                                .contextMenu {
                                    if selectedCalculations.contains(calculation) {
                                        PastCalculationMultipleContextMenu(calculations: selectedCalculations)
                                    } else if !selectionMode {
                                        PastCalculationContextMenu(calculation: calculation)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .id(!calculation.isFault ? calculation.uuid : UUID())
                        }
                        .id(self.current.update)
                        
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
                }
                .id(settings.selectedDate)
            }
            .frame(width: geometry.size.width > 650 ? geometry.size.width*0.5 : geometry.size.width)
            .padding(.trailing, geometry.size.width > 650 ? geometry.size.width*0.5 : 0)
            .accentColor(settings.theme.primaryTextColor)
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
                                    .font(.system(.title, design: .rounded))
                                    .fontWeight(.bold)
                                    .padding(.bottom, 10)
                                    .foregroundColor(Color.init(white: 0.6))
                                    .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
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
            )
            .onAppear {
                // Set the calculations
                self.calculations = []
                self.calculations = getAllCalculations()
            }
            .onChange(of: settings.recentDisplayType) { _ in
                withAnimation {
                    self.count = 50
                    self.calculations = []
                    self.calculations = getAllCalculations()
                    self.resetSelected()
                }
            }
            .onChange(of: settings.selectedDate) { _ in
                withAnimation {
                    self.count = 50
                    self.calculations = []
                    self.calculations = getAllCalculations()
                    self.resetSelected()
                }
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

        // Limit the date
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: settings.selectedDate)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date =< %@", argumentArray: [startDate!, endDate!])

        // Fetch the calculations
        do {
            calculations = try managedObjectContext.fetch(fetchRequest)
        }
        catch {
            fatalError("Failed to get calculations")
        }
        
        // Filter the type
        if settings.recentDisplayType != .all {
            calculations = calculations.filter { $0.listType == settings.recentDisplayType }
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
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date ?? Date())
    }

    func dateString(_ date: Date?) -> String {
        
        if let date = date {
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.doesRelativeDateFormatting = true
            
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
}
