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
            
            HStack {
                Spacer(minLength: 0)
                
                SubstituteView(queue: queue, onChange: { queue in
                    self.pluggedResult = queue
                    let result = queue.simplify()
                    self.editedResult = queue.items != result.items ? result : nil
                })
                .frame(maxWidth: 400)
            }
            
            if !queue.allVariables.isEmpty, let editedResult = editedResult {
                
                HStack {
                    
                    Spacer(minLength: 0)
                
                    TextDisplay(strings: ["="]+editedResult.strings, size: 24, scrollable: true, animations: true)
                    
                    Menu {
                        Button {
                            Calculation.current.setUpInput()
                            Calculation.current.queue.insertToQueue(currentResult)
                            SoundManager.play(sound: .click3, haptic: .medium)
                        } label: {
                            Label("Insert", systemImage: "plus.circle")
                        }
                        Button {
                            UIPasteboard.general.string = currentResult.exportString()
                            Settings.settings.clipboard = currentResult.items
                            Settings.settings.notification = .copy
                        } label: {
                            Label("Copy", systemImage: "doc.on.clipboard")
                        }
                    } label: {
                        Image(systemName: "chevron.forward.circle")
                            .foregroundColor(color(settings.theme.color1))
                    }
                    .padding(.trailing, 10).padding(.leading, -10)
                }
                .padding(.bottom, 15)
                .padding(.horizontal, 10)
            }
        }
    }
}
