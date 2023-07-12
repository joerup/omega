//
//  SubstituteView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 4/16/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct SubstituteView: View {
    
    @ObservedObject var settings = Settings.settings

    var queue: Queue
    
    var letters: [Letter] {
        return self.queue.allLetters.filter { !$0.systemConstant }
    }
    
    @State private var values: [String:Queue] = [:]
    
    var onChange: (Queue) -> Void
    
    var size: Size {
        return UIDevice.current.userInterfaceIdiom == .phone ? .small : .large
    }
    
    var body: some View {
        
        VStack {
            
            ForEach(self.letters.indices, id: \.self) { v in
                
                let variable = self.letters[v]
                
                HStack {
                    
                    TextDisplay(strings: [variable.text], size: size == .small ? 24 : 35, color: color(settings.theme.color1, edit: true))
                        .frame(width: size == .small ? 28 : 35)
                    
                    HStack {
                        
                        Text(NSLocalizedString(variable.typeString, comment: "").uppercased())
                            .font(Font.system(.caption, design: .rounded))
                            .foregroundColor(Color.init(white: 0.6))
                            .lineLimit(0)
                            .minimumScaleFactor(0.3)
                            .padding(.leading, 2)
                        
                        Spacer()
                        
                        if variable.type == .constant {
                            TextDisplay(strings: variable.value!.strings, size: size == .small ? 20 : 25, color: Color.init(white: variable.value!.variables.isEmpty && variable.value!.bounds.isEmpty ? 0.8 : 1), scrollable: true)
                        }
                        else if variable.type == .bound || variable.type == .dummy {
                            TextDisplay(strings: [], size: size == .small ? 20 : 25, color: Color.init(white: 0.6), scrollable: true)
                        }
                        else if variable.storedValue {
                            TextInput(queue: variable.value!, placeholder: [variable.text], defaultValue: variable.value!, size: size == .small ? 20 : 25, scrollable: true, onChange: { value in
                                self.values[variable.name] = value
                            })
                        } else {
                            TextInput(queue: values[variable.name], placeholder: [variable.text], size: size == .small ? 20 : 25, scrollable: true, onChange: { value in
                                self.values[variable.name] = value
                            })
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: size == .small ? 24 : 35)
                    .padding(10)
                    .background(Color.init(white: variable.type == .variable ? 0.27 : 0.23).cornerRadius(20))
                }
                .frame(height: 20+(size == .small ? 28 : 35))
            }
        }
        .padding(10)
        .onChange(of: values) { values in
            onChange(substituteValues(values))
        }
    }
    
    func substituteValues(_ values: [String:Queue]) -> Queue {
        
        var queue = self.queue
        
        for letter in self.letters {
            if let letterValue = values[letter.name], !letterValue.empty {
                queue = queue.substitute(letter, with: Expression(letterValue.final))
            }
        }
        
        return queue
    }
}



