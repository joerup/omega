//
//  CalculatorOverlay.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/13/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct CalculatorOverlay: View {
    
    @ObservedObject var settings = Settings.settings
    
    @State private var recentDisplayType: ListDisplayType = .all
    @State private var savedDisplayType: ListDisplayType = .all
    @State private var storedVarDisplayType: ListDisplayType = .all
    
    @State private var selectedDate: Date = Date()
    @State private var selectedFolder: String? = nil
    
    var body: some View {
        
        ZStack {
            
            if settings.calculatorOverlay != .none {
                
                VStack {
                    
                    Rectangle()
                        .fill(Color.init(white: 0.3))
                        .frame(width: 80, height: 5)
                        .cornerRadius(2)
                        .padding(.top, 5)
                    
                    if settings.calculatorOverlay == .calculations {
                        PastCalcRecentView(displayType: $recentDisplayType, selectedDate: $selectedDate)
                    }
                    else if settings.calculatorOverlay == .saved {
                        PastCalcSavedView(displayType: $savedDisplayType, selectedFolder: $selectedFolder)
                    }
                    else if settings.calculatorOverlay == .variables {
                        StoredVarList(displayType: $storedVarDisplayType)
                    }
                    else if settings.calculatorOverlay == .reference {
                        ReferenceList()
                    }
                    
                    Spacer()
                    
                }
                .edgesIgnoringSafeArea(.bottom)
                .background(Color.init(white: 0.1)
                    .cornerRadius(20)
                    .edgesIgnoringSafeArea(.bottom)
                )
                .gesture(DragGesture(minimumDistance: 30)
                    .onChanged { value in
                        if abs(value.translation.height) > abs(value.translation.width) && value.translation.height > 50 {
                            settings.calculatorOverlay = .none
                        }
                    }
                )
                .transition(.move(edge: .bottom))
                .animation(.default)
            }
        }
    }
}

enum CalculatorOverlayType {
    case none
    case calculations
    case saved
    case variables
    case reference
}

