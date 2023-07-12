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
                                .foregroundColor(color(self.settings.theme.color1, edit: true))
                                .frame(width: 85, height: 85)
                                .cornerRadius(85/4)
                            Image(systemName: calculation.listType.icon)
                                .foregroundColor(.init(white: calculation.saved ? 1 : 0.1))
                                .opacity(calculation.saved ? 1 : 0.6)
                                .font(.system(size: 85/2, weight: .black))
                        }
                        .padding(.top, -3)
                        
                        Spacer()

                        VStack(alignment: .leading, spacing: 0) {

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
                            .foregroundColor(color(self.settings.theme.color1, edit: true))
                            .padding(.top, -3)

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
                                            .foregroundColor(color(settings.theme.color1))
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
                                        .foregroundColor(color(settings.theme.color1))
                                    Text("Recent")
                                        .font(Font.system(.subheadline, design: .rounded))
                                        .foregroundColor(Color.init(white: 0.5))
                                }
                            }
                        }
                        .padding(.leading, 6)
                        
                        Spacer()
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 1)
                    
                    // Display

                    VStack {
                        
                        if calculation.showResult {
                            
                            TextDisplay(strings: calculation.queue.strings, modes: calculation.modes, size: 35, opacity: 0.7, equals: !calculation.result.error, scrollable: true)
                            
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
                                .proLock()
                        }
                        
                        // Substitute
                        
                        if !calculation.queue.allLetters.filter{ !$0.systemConstant }.isEmpty {
                            VariablePlugView(queue: calculation.queue)
                                .background(Color.init(white: 0.2))
                                .cornerRadius(20)
                                .id(Calculation.current.update)
                                .proLock()
                        }
                        
                        // Squares
                        
                        HStack(spacing: 10) {
                            CalculationVisuals(calculation: calculation.newCalculation(), width: geometry.size.width-20, height: geometry.size.width*0.6-20, lightBackground: true)
                        }
                        .id(Calculation.current.update)
                        
                        // Analysis
                        
    //                    let roots = Value.functionRoots(calculation.queue)
    //                    let extrema = Value.functionRoots( Queue([Value.derivative(Expression(calculation.queue.items), withRespectTo: calculation.queue.variables.first ?? Variable("x"))]) )
    //
    //                    if !roots.isEmpty, !extrema.isEmpty {
    //
    //                        FunctionAnalysisView(queue: calculation.queue, roots: roots, extrema: extrema)
    //                            .background(Color.init(white: 0.2))
    //                            .cornerRadius(20)
    //                    }
                    }
                    
                    // Note
                    
                    // COMING IN iOS 16
                    
                    Spacer()
                        .frame(height: 60)
                }
                .padding(10)
                .id(calculation)
            }
            .accentColor(color(self.settings.theme.color1, edit: true))
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
        LargeIconButton(text: "Save", image: "folder\(calculation.saved ? ".fill" : "")") {
            calculation.save()
        }
        LargeIconButton(text: "Assign", image: "character.textbox") {
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
