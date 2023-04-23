//
//  ResultOverlay.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/13/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct ResultOverlay: View {
    
    @ObservedObject var settings = Settings.settings
    
    @ObservedObject var calculation = Calculation.current
    
    var geometry: GeometryProxy
    
    var pastCalculation: PastCalculation? {
        return PastCalculation.get(calculation.id)
    }
    
    var horizontalSizeClass: UserInterfaceSizeClass {
        return geometry.size.width > geometry.size.height ? .regular : .compact
    }
    
    @State private var name: String = ""
    
    var body: some View {
        
        VStack {
            
            if let pastCalculation = pastCalculation {
                
                HStack {
                    
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
                        pastCalculation.rename(to: name)
                    })
                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                    .foregroundColor(color(self.settings.theme.color1, edit: true))
                    .onAppear {
                        self.name = pastCalculation.name ?? ""
                    }
                    
                    Spacer()

                    HStack(spacing: 5) {
                        
                        Text(self.dateString(pastCalculation.date ?? Date(), dateStyle: .medium, timeStyle: .none))
                            .font(Font.system(.subheadline, design: .rounded))
                            .foregroundColor(Color.init(white: 0.6))
                        
                        Text("•")
                            .font(Font.system(.subheadline, design: .rounded))
                            .foregroundColor(Color.init(white: 0.8))
                        
                        Text(self.dateString(pastCalculation.date ?? Date(), dateStyle: .none, timeStyle: .short))
                            .font(Font.system(.subheadline, design: .rounded))
                            .foregroundColor(Color.init(white: 0.6))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 7)
                .padding(.bottom, 9)
            }
            
            if proCheck() {
                
                if let pastCalculation = pastCalculation {
                    
                    if !pastCalculation.extraResults.isEmpty {
                        ExtraResultView(calculation: pastCalculation)
                            .background(Color.init(white: 0.2))
                            .cornerRadius(20)
                            .id(Calculation.current.update)
                            .proLock()
                    }
                    if !pastCalculation.result.otherUnits().isEmpty {
                        UnitConversionView(calculation: pastCalculation)
                            .background(Color.init(white: 0.2))
                            .cornerRadius(20)
                            .id(Calculation.current.update)
                            .proLock()
                    }
                }
                
                if !calculation.queue.allLetters.filter{ !$0.systemConstant }.isEmpty {
                    VariablePlugView(queue: calculation.queue)
                        .background(Color.init(white: 0.2))
                        .cornerRadius(20)
                        .id(Calculation.current.update)
                        .proLock()
                }
                
                if horizontalSizeClass == .compact {
                    LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())]) {
                        CalculationVisuals(width: geometry.size.width/2-15, height: geometry.size.width/2-15)
                    }
                }
                else {
                    LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]) {
                        CalculationVisuals(width: geometry.size.width/3-15, height: geometry.size.width/3-15)
                    }
                }
                
//                FunctionAnalysisView(queue: calculation.queue)
//                    .background(Color.init(white: 0.2))
//                    .cornerRadius(20)
//                    .padding(.horizontal, 7.5)
//                    .animation(nil)
            }
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.top, 5)
    }
    
    func dateString(_ date: Date?, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.doesRelativeDateFormatting = true

        return dateFormatter.string(from: date ?? Date())
    }
}
