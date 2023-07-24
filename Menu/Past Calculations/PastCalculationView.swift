//
//  PastCalculationView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/19/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct PastCalculationView: View {

    @ObservedObject var settings = Settings.settings

    @ObservedObject var calculation: PastCalculation

    @State private var name = ""
    @State private var note = ""

    var body: some View {

        GeometryReader { geometry in
                
            ScrollView {
                
                VStack {
                    
                    // Name & Icon

                    HStack(spacing: 0) {

                        ZStack {
                            Rectangle()
                                .foregroundColor(settings.theme.primaryColor)
                                .frame(width: 85, height: 85)
                                .cornerRadius(85/4)
                            Image(systemName: calculation.listType.icon)
                                .foregroundColor(.init(white: calculation.saved ? 1 : 0.1))
                                .opacity(calculation.saved ? 1 : 0.6)
                                .font(.system(size: 85/2, weight: .black))
                        }
                        .padding(.top, -3)
                        
                        Spacer()

                        VStack(alignment: .leading, spacing: 2) {
                            
                            ZStack(alignment: .leading) {
                                Text("Calculation")
                                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                                    .lineLimit(0).opacity(0)
                                Text(self.name)
                                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                                    .lineLimit(0).opacity(0)
                            }
                            .padding(.trailing, 15)
                            .overlay {
                                TextField(NSLocalizedString("Calculation", comment: ""), text: self.$name, onCommit: {
                                    while self.name.last == " " {
                                        self.name.removeLast()
                                    }
                                    while self.name.first == " " {
                                        self.name.removeFirst()
                                    }
                                    if self.name == "" {
                                        self.name = ""
                                    }
                                    calculation.rename(to: name)
                                })
                                .font(Font.system(.title2, design: .rounded).weight(.bold))
                                .foregroundColor(settings.theme.primaryTextColor)
                            }
                            .padding(.top, -3)
                            .padding(.trailing, 30)

                            HStack(spacing: 5) {
                                
                                Text(self.dateString(self.calculation.date ?? Date(), dateStyle: .medium, timeStyle: .none))
                                    .font(Font.system(.subheadline, design: .rounded))
                                    .foregroundColor(Color.init(white: 0.6))
                                
                                Text("•")
                                    .font(Font.system(.subheadline, design: .rounded))
                                    .foregroundColor(Color.init(white: 0.8))
                                
                                Text(self.dateString(self.calculation.date ?? Date(), dateStyle: .none, timeStyle: .short))
                                    .font(Font.system(.subheadline, design: .rounded))
                                    .foregroundColor(Color.init(white: 0.6))
                                
                                Spacer()
                            }
                            .padding(.leading, 0.5)
                            .padding(.bottom, 2)
                            
                            if self.calculation.saved, let folder = calculation.folder {
                                
                                Button(action: {
                                    calculation.save()
                                }) {
                                    HStack(spacing: 5) {
                                        Image(systemName: "folder")
                                            .imageScale(.small)
                                            .foregroundColor(settings.theme.primaryTextColor)
                                        if folder.isEmpty {
                                            Text("Saved")
                                                .font(Font.system(.subheadline, design: .rounded))
                                                .foregroundColor(Color.init(white: 0.7))
                                        } else {
                                            Text(folder)
                                                .font(Font.system(.subheadline, design: .rounded))
                                                .foregroundColor(Color.init(white: 0.7))
                                        }
                                    }
                                }
                            } else {
                                
                                HStack(spacing: 5) {
                                    Image(systemName: "clock.arrow.circlepath")
                                        .imageScale(.small)
                                        .foregroundColor(settings.theme.primaryTextColor)
                                    Text("Recent")
                                        .font(Font.system(.subheadline, design: .rounded))
                                        .foregroundColor(Color.init(white: 0.5))
                                }
                            }
                        }
                        .padding(.leading, 6)
                        .dynamicTypeSize(..<DynamicTypeSize.accessibility1)
                        
                        Spacer()
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 1)
                    
                    // Display

                    VStack {
                        
                        if calculation.showResult {
                            
                            TextDisplay(strings: calculation.queue.strings, modes: calculation.modes, size: 35, colorContext: .secondary, equals: !calculation.result.error, scrollable: true)
                            
                            TextDisplay(strings: calculation.result.strings, modes: calculation.modes, size: 55, scrollable: true)
                            
                        } else {
                            
                            TextDisplay(strings: calculation.queue.strings, modes: calculation.modes, size: 55, scrollable: true)
                            
                        }
                    }
                    .padding(.vertical, 20)
                    .background(Color.init(white: 0.2))
                    .cornerRadius(20)
                    
                    // Buttons
                    
                    if geometry.size.width > 500 {
                        HStack {
                            buttonRow1
                            buttonRow2
                        }
                    } else {
                        HStack {
                            buttonRow1
                        }
                        HStack {
                            buttonRow2
                        }
                    }
                    
                    if proCheck(), !calculation.isFault {
                        
                        // Extra Results
                            
                        if !calculation.extraResults.isEmpty {
                            ExtraResultView(calculation: calculation, results: calculation.extraResults)
                                .background(Color.init(white: 0.2))
                                .cornerRadius(20)
                                .id(Calculation.current.update)
                        }
                        
                        // Substitute
                        
                        if !calculation.queue.allLetters.filter{ !$0.systemConstant }.isEmpty {
                            VariablePlugView(queue: calculation.queue)
                                .background(Color.init(white: 0.2))
                                .cornerRadius(20)
                                .id(Calculation.current.update)
                        }
                        
                        // Squares
                        
                        HStack(spacing: 10) {
                            CalculationVisuals(calculation: calculation.newCalculation(), width: geometry.size.width-20, height: geometry.size.width*0.6-20, lightBackground: true)
                        }
                        .id(Calculation.current.update)
                        
                    }
                    
                    // Note
                    
                    // COMING IN iOS 16
                    
                    Spacer()
                        .frame(height: 60)
                }
                .padding(10)
                .id(calculation)
            }
            .accentColor(settings.theme.primaryTextColor)
            .onAppear {
                self.name = self.calculation.name ?? ""
            }
            .onChange(of: self.calculation) { calculation in
                self.name = calculation.name ?? ""
            }
        }
    }
    
    @ViewBuilder
    private var buttonRow1: some View {
        LargeIconButton(text: "Insert", image: "plus.circle") {
            calculation.insert()
        }
        LargeIconButton(text: "Edit", image: "pencil") {
            calculation.edit()
        }
        LargeIconButton(text: "Copy", image: "doc.on.clipboard\(calculation.copied ? ".fill" : "")") {
            calculation.copy()
        }
    }
    @ViewBuilder
    private var buttonRow2: some View {
        LargeIconButton(text: "Save", image: "folder\(calculation.saved ? ".fill" : "")", locked: settings.featureVersionIdentifier > 0) {
            guard proCheckNotice(.save, maxFreeVersion: 0) else { return }
            calculation.save()
        }
        LargeIconButton(text: "Assign", image: "character.textbox", locked: true) {
            guard proCheckNotice(.variables) else { return }
            calculation.store()
        }
        LargeIconButton(text: "Delete", image: "trash") {
            calculation.delete()
        }
    }

    func dateString(_ date: Date?, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.doesRelativeDateFormatting = true

        return dateFormatter.string(from: date ?? Date())
    }
}
