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
    
    var size: Size
    var orientation: Orientation
    
    var primary: Bool = true
    
    var body: some View {
        
        VStack {
            
            if proCheck() {
                
                if orientation == .landscape {
                    
                    if primary {
                        HStack(spacing: 10) {
                            CalculationVisuals(width: geometry.size.width-8, height: geometry.size.height, ignoreIfEmpty: false)
                        }
                        .padding(.trailing, 3)
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.init(white: 0.15))
                            ScrollView {
                                VStack(spacing: 0) {
                                    if let pastCalculation = pastCalculation, !pastCalculation.extraResults.isEmpty {
                                        ExtraResultView(calculation: pastCalculation)
                                            .id(Calculation.current.update)
                                    }
                                    if !calculation.queue.allLetters.filter{ !$0.systemConstant }.isEmpty {
                                        VariablePlugView(queue: calculation.queue)
                                            .id(Calculation.current.update)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 2)
                        .padding(.bottom, 5)
                    }
                    
                } else {
                    
                    let height = min(geometry.size.width*0.6, geometry.size.height*0.7)
                    
                    HStack(spacing: 10) {
                        CalculationVisuals(width: geometry.size.width-10, height: height, ignoreIfEmpty: true)
                            .padding(.bottom, 2)
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.init(white: 0.15))
                        ScrollView {
                            VStack(spacing: 0) {
                                if let pastCalculation = pastCalculation {
                                    
                                    if !pastCalculation.extraResults.isEmpty {
                                        ExtraResultView(calculation: pastCalculation)
                                            .id(Calculation.current.update)
                                    }
                                    if !pastCalculation.result.otherUnits().isEmpty {
                                        UnitConversionView(calculation: pastCalculation)
                                            .id(Calculation.current.update)
                                    }
                                }
                                
                                if !calculation.queue.allLetters.filter{ !$0.systemConstant }.isEmpty {
                                    VariablePlugView(queue: calculation.queue)
                                        .id(Calculation.current.update)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 2)
                    .padding(.bottom, 5)
                }
            }
        }
        .padding(2)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func dateString(_ date: Date?, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        dateFormatter.doesRelativeDateFormatting = true

        return dateFormatter.string(from: date ?? Date())
    }
}
