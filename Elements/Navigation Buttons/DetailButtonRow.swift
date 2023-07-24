//
//  DetailButtonRow.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/12/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailButtonRow: View {
    
    @ObservedObject var settings = Settings.settings
    
    var calculation = Calculation.current
    
    var pastCalculation: PastCalculation? {
        return PastCalculation.get(calculation.id)
    }
    
    var size: Size
    var orientation: Orientation
    
    var body: some View {
            
        HStack(spacing: 0) {
            
            HStack(spacing: 0) {
                
                HStack {
                    
                    if orientation == .landscape || size == .large {
                        SmallTextButton(text: "MAT",
                                        color: settings.buttonDisplayMode == .basic || settings.buttonDisplayMode == .funcs ? settings.theme.secondaryColor : Color.init(white: 0.15),
                                        textColor: settings.buttonDisplayMode == .basic || settings.buttonDisplayMode == .funcs ? Color.white : settings.theme.secondaryTextColor,
                                        width: size == .small ? 55 : 70,
                                        smallerSmall: orientation == .landscape,
                                        sound: .click3
                        ) {
                            settings.buttonDisplayMode = .basic
                            settings.buttonUppercase = false
                            settings.detailOverlay = .none
                        }
                    } else {
                        SmallTextButton(text: "MAT",
                                        color: settings.buttonDisplayMode == .funcs ? settings.theme.secondaryColor : Color.init(white: 0.15),
                                        textColor: settings.buttonDisplayMode == .funcs ? Color.white : settings.theme.secondaryTextColor,
                                        width: size == .small ? 55 : 70,
                                        smallerSmall: orientation == .landscape,
                                        sound: .click3
                        ) {
                            settings.buttonDisplayMode = settings.buttonDisplayMode == .funcs ? .basic : .funcs
                            settings.buttonUppercase = false
                            settings.detailOverlay = .none
                        }
                    }
                    
                    SmallTextButton(text: "VAR",
                                    color: settings.buttonDisplayMode == .vars ? settings.theme.secondaryColor : Color.init(white: 0.15),
                                    textColor: settings.buttonDisplayMode == .vars ? Color.white : settings.theme.secondaryTextColor,
                                    width: size == .small ? 55 : 70,
                                    smallerSmall: orientation == .landscape,
                                    sound: .click3,
                                    locked: true
                    ) {
                        guard proCheckNotice([.functions, .variables].randomElement()!) else { return }
                        settings.buttonDisplayMode = settings.buttonDisplayMode == .vars ? .basic : .vars
                        settings.buttonUppercase = false
                        settings.detailOverlay = .none
                    }
                    
                }
                
                if orientation == .landscape || size == .large {
                    if settings.buttonDisplayMode == .basic || settings.buttonDisplayMode == .funcs {
                        HStack {
                            matButtons
                        }
                        .padding(.leading, 20)
                    }
                    else if settings.buttonDisplayMode == .vars {
                        HStack {
                            varButtons
                        }
                        .padding(.leading, 20)
                    }
                }
            }
            
            Spacer(minLength: 0)
            
            HStack {
                if orientation == .portrait && size == .small {
                    if settings.buttonDisplayMode == .funcs {
                        matButtons
                    }
                    else if settings.buttonDisplayMode == .vars {
                        varButtons
                    }
                }
            }
            
            if settings.buttonDisplayMode == .basic || size == .large || orientation == .landscape {
                
                HStack {
                    
                    if calculation.queue.editing {
                        
                        SmallIconButton(symbol: "chevron.backward", textColor: Color.init(white: 0.7), smallerSmall: orientation == .landscape, sound: .click2, locked: true) {
                            guard proCheckNotice(.misc) else { return }
                            Calculation.current.setUpInput()
                            Calculation.current.queue.backward()
                        }
                        
                        SmallIconButton(symbol: "chevron.forward", textColor: Color.init(white: 0.7), smallerSmall: orientation == .landscape, sound: .click1, locked: false) {
                            Calculation.current.setUpInput()
                            Calculation.current.queue.forward()
                        }
                    }
                    
                    if calculation.completed {
                        
                        SmallIconButton(symbol: "doc.on.clipboard\(pastCalculation?.copied ?? false ? ".fill" : "")", textColor: settings.theme.primaryTextColor, smallerSmall: orientation == .landscape) {
                            pastCalculation?.copy()
                        }
                        SmallIconButton(symbol: "folder\(pastCalculation?.saved ?? false ? ".fill" : "")", textColor: settings.theme.primaryTextColor, smallerSmall: orientation == .landscape, locked: settings.featureVersionIdentifier > 0) {
                            guard proCheckNotice(.save, maxFreeVersion: 0) else { return }
                            pastCalculation?.save()
                        }
                        SmallIconButton(symbol: "character.textbox", textColor: settings.theme.primaryTextColor, smallerSmall: orientation == .landscape, locked: true) {
                            guard proCheckNotice(.variables) else { return }
                            pastCalculation?.store()
                        }
                    }
                    
                    if calculation.completed {
                        
                        SmallIconButton(symbol: "ellipsis", color: Color.init(white: settings.detailOverlay == .result ? 0.3 : 0.15), smallerSmall: orientation == .landscape, locked: true) {
                            guard proCheckNotice(.misc) else { return }
                            settings.detailOverlay = settings.detailOverlay == .result ? .none : .result
                        }
                        .onAppear {
                            if !calculation.queue.allVariables.isEmpty || !calculation.queue.otherUnits().isEmpty {
                                settings.detailOverlay = .result
                            }
                        }
                    }
                }
            }
        }
        .frame(height: size == .large ? 45 : orientation == .landscape ? 35 : 40)
        .animation(.default, value: Calculation.current.completed)
        .animation(.default, value: settings.buttonDisplayMode)
    }
    
    @ViewBuilder
    var matButtons: some View {
        SmallTextButton(text: "2nd",
                        color: settings.buttonUppercase ? settings.theme.secondaryColor : Color.init(white: 0.15),
                        textColor: settings.buttonUppercase ? Color.white : settings.theme.secondaryTextColor,
                        width: size == .small ? 50 : 65,
                        smallerSmall: orientation == .landscape,
                        sound: .click3
        ) {
            settings.buttonUppercase.toggle()
            settings.detailOverlay = .none
        }
    }
    
    @ViewBuilder
    var varButtons: some View {
        AlphabetButton(alphabet: $settings.selectedAlphabet,
                       uppercase: $settings.buttonUppercase,
                       width: size == .small ? 50 : 65,
                       smallerSmall: orientation == .landscape
        )
        SmallIconButton(symbol: settings.buttonUppercase ? "capslock.fill" : "capslock",
                        color: settings.buttonUppercase ? settings.theme.secondaryColor : Color.init(white: 0.15),
                        textColor: .white,
                        smallerSmall: orientation == .landscape,
                        sound: .click3
        ) {
            settings.buttonUppercase.toggle()
            settings.detailOverlay = .none
        }
    }
}
