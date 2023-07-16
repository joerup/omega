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
    
    @State private var offset: CGFloat = 0
    @GestureState private var gestureOffset: CGFloat = 0
    
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
                    
                    Spacer()
                    
                }
                .edgesIgnoringSafeArea(.bottom)
                .background(Color.init(white: 0.1)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .edgesIgnoringSafeArea(.bottom)
                )
                .offset(y: offset + gestureOffset)
                .highPriorityGesture(DragGesture()
                    .updating($gestureOffset) { value, gestureOffset, _ in
                        if value.translation.height > 0 {
                            gestureOffset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > 0 {
                            offset = value.translation.height
                        }
                        withAnimation {
                            offset = 0
                        }
                        SoundManager.play(haptic: .medium)
                        if abs(value.translation.height) > abs(value.translation.width) && value.translation.height > 50 {
                            withAnimation {
                                settings.calculatorOverlay = .none
                            }
                        }
                    }
                )
                .transition(.move(edge: .bottom))
                .keypadShift()
            }
        }
    }
}

enum CalculatorOverlayType {
    case none
    case calculations
    case saved
    case variables
}

