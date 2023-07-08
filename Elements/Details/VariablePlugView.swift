//
//  VariablePlugView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/2/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct VariablePlugView: View {
    
    @ObservedObject var settings = Settings.settings
    
    var queue: Queue
    
    @State private var pluggedResult: Queue? = nil
    @State private var editedResult: Queue? = nil
    
    var main: Bool = false
    
    var currentResult: Queue {
        return editedResult ?? pluggedResult ?? queue
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            SubstituteView(queue: queue, onChange: { queue in
                self.pluggedResult = queue
                let result = queue.simplify()
                self.editedResult = queue.items != result.items ? result : nil
            })
            
            if !queue.allVariables.isEmpty {
                
                HStack {
                    
                    if let editedResult = editedResult {
                        
                        if !queue.allVariables.isEmpty {
                            
                            SmallIconButton(symbol: "plus.circle", color: Color.init(white: main ? 0.2 : 0.25), textColor: color(settings.theme.color1, edit: true), smallerLarge: true) {
                                Calculation.current.setUpInput()
                                Calculation.current.queue.insertToQueue(currentResult)
                                SoundManager.play(sound: .click3, haptic: .medium)
                            }
                            
                            SmallIconButton(symbol: "doc.on.clipboard\(Settings.settings.clipboard == currentResult.items ? ".fill" : "")", color: Color.init(white: main ? 0.2 : 0.25), textColor: color(settings.theme.color1, edit: true), smallerLarge: true) {
                                UIPasteboard.general.string = currentResult.exportString()
                                Settings.settings.clipboard = currentResult.items
                                Settings.settings.notification = .copy
                            }
                        }
                        
                        Spacer()
                    
                        TextDisplay(strings: ["="]+editedResult.strings, size: 24, scrollable: true, animations: true)
                        
                    }
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 10)
            }
        }
    }
}
