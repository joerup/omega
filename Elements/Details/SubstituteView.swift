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
    
    @State private var updateValues: Bool = false
    
    var onChange: (Queue) -> Void
    
    var size: Size {
        return UIDevice.current.userInterfaceIdiom == .phone ? .small : .large
    }
    
    var body: some View {
        
        VStack {
            
            ForEach(self.letters.indices, id: \.self) { v in
                
                let variable = self.letters[v]
                
                HStack {
                    
                    TextDisplay(strings: [variable.text], size: size == .small ? 24 : 35, colorContext: .theme)
                        .frame(width: size == .small ? 28 : 35)
                    
                    HStack {
                        
                        Text(string(for: variable).uppercased())
                            .font(Font.system(.caption, design: .rounded))
                            .foregroundColor(Color.init(white: 0.6))
                            .lineLimit(0)
                            .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                            .minimumScaleFactor(0.3)
                            .padding(.leading, 2)
                        
                        Spacer()
                        
                        if variable.type == .constant {
                            TextDisplay(strings: variable.value!.strings, size: size == .small ? 20 : 25, colorContext: .secondary, scrollable: true)
                        }
                        else if variable.type == .bound || variable.type == .dummy {
                            TextDisplay(strings: [], size: size == .small ? 20 : 25, colorContext: .secondary, scrollable: true)
                        }
                        else if variable.storedValue {
                            TextInput(queue: variable.value!, placeholder: [variable.text], defaultValue: variable.value!, size: size == .small ? 20 : 25, scrollable: true, onChange: { value in
                                self.values[variable.name] = value
                                self.updateValues.toggle()
                            })
                        } else {
                            TextInput(queue: values[variable.name], placeholder: [variable.text], size: size == .small ? 20 : 25, scrollable: true, onChange: { value in
                                self.values[variable.name] = value
                                self.updateValues.toggle()
                            })
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: size == .small ? 24 : 35)
                    .padding(10)
                    .background(Color.init(white: 0.23).cornerRadius(20))
                }
                .frame(height: 20+(size == .small ? 28 : 35))
            }
        }
        .padding(10)
        .onChange(of: updateValues) { _ in
            onChange(substituteValues(values))
        }
    }
    
    private func string(for variable: Letter) -> String {
        let string = variable.typeString
        if string == "Unknown" {
            return values[variable.name] != nil && !values[variable.name]!.empty ? "Plug-In" : "Unknown"
        }
        return string
    }
    
    private func substituteValues(_ values: [String:Queue]) -> Queue {
        
        var queue = self.queue
        
        for letter in self.letters {
            if let letterValue = values[letter.name], !letterValue.empty {
                queue = queue.substitute(letter, with: Expression(letterValue.final))
            }
        }
        
        return queue
    }
}



