//
//  PastCalcInsertView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/2/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct PastCalcInsertView: View {
    
    @State private var calculation: PastCalculation
    @State private var substituted: Queue
    
    init(calculation: PastCalculation) {
        self.calculation = calculation
        self.substituted = calculation.result
    }
    
    var body: some View {
        
        PopUpSheet(title: "Insert", confirmText: "Insert", confirmAction: {
            
            // Substitute constants if indicated
            while !substituted.constants.filter({ !$0.systemConstant }).isEmpty && substituted.allVariables.isEmpty {
                substituted = substituted.substituted
            }
            
            // Insert to queue
            Calculation.current.setUpInput()
            Calculation.current.queue.insertToQueue(self.substituted)
            SoundManager.play(sound: .click3, haptic: .medium)
            Settings.settings.popUp = nil
            
        }) {
            
            VStack {
                        
                TextDisplay(strings: calculation.result.strings, size: 30, scrollable: true)
                    .frame(height: 50)
                    .padding(10)
                    .background(Color.init(white: 0.3))
                    .cornerRadius(20)
                    .padding(.top, 10)
                
                Text("Substitute")
                    .font(Font.system(.body, design: .rounded).weight(.semibold))
                    .padding(10)
            
                ScrollView {
                    
                    SubstituteView(queue: calculation.result) { queue in
                        self.substituted = queue
                    }
                    .background(Color.init(white: 0.3))
                    .cornerRadius(20)
                    .animation(nil)
                    
                    Spacer()
                    
                }
            }
        }
    }
}
