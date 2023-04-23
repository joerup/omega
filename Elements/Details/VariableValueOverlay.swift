//
//  VariableValueOverlay.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/17/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct VariableValueOverlay: View {
    
    @ObservedObject var settings = Settings.settings
    
    var calculation = Calculation.current
    
    var size: Size {
        return UIDevice.current.userInterfaceIdiom == .phone ? .small : .large
    }
    
    var body: some View {
        
        GeometryReader { geometry in
                    
            VStack {
                
                VStack {
                    
                    ForEach(calculation.queue.allLetters.indices, id: \.self) { v in

                        let variable = calculation.queue.allLetters[v]

                        HStack {

                            TextDisplay(strings: [variable.text], size: size == .small ? 25 : 25, color: color(settings.theme.color1))
                                .frame(width: size == .small ? 25 : 35)

                            HStack {
                                
                                Text(variable.typeString.uppercased())
                                    .font(.caption)
                                    .foregroundColor(Color.init(white: 0.6))
                                    .padding(.leading, 2)

                                Spacer()

                                if variable.type == .bound || variable.type == .dummy {
                                    TextDisplay(strings: [], size: size == .small ? 18 : 25, color: Color.init(white: 0.6), scrollable: true)
                                } else {
                                    TextInput(queue: calculation.queue.allLetters[v].value, placeholder: [variable.text], size: size == .small ? 18 : 25, scrollable: true, onChange: { value in
                                        if value.empty {
                                            calculation.queue.matchLetters(to: Letter(variable.name))
                                        } else {
                                            calculation.queue.matchLetters(to: Letter(variable.name, type: .constant, value: value))
                                        }
                                    })
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: size == .small ? 25 : 35)
                            .padding(10)
                            .background(Color.init(white: variable.type == .variable ? 0.27 : 0.23).cornerRadius(20))
                        }
                        .frame(height: 20+(size == .small ? 25 : 35))
                    }
                }
                .padding(10)
                .background(Color.init(white: 0.2))
                .cornerRadius(20)

                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.top, 5)
        }
    }
}
