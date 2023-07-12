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
            
            HStack {
                
                if orientation == .landscape || size == .large {
                    SmallTextButton(text: "MAT",
                                    color: settings.buttonDisplayMode == .basic || settings.buttonDisplayMode == .funcs ? color(settings.theme.color3) : Color.init(white: 0.15),
                                    textColor: settings.buttonDisplayMode == .basic || settings.buttonDisplayMode == .funcs ? Color.white : color(settings.theme.color3, edit: true),
                                    width: size == .small ? 55 : 70,
                                    smallerSmall: orientation == .landscape,
                                    sound: .click3
                    ) {
                        settings.buttonDisplayMode = .basic
                        settings.buttonUppercase = false
                        settings.detailOverlay = .none
                    }
                }
                else {
                    SmallTextButton(text: "MAT",
                                    color: settings.buttonDisplayMode == .funcs ? color(settings.theme.color3) : Color.init(white: 0.15),
                                    textColor: settings.buttonDisplayMode == .funcs ? Color.white : color(settings.theme.color3, edit: true),
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
                                color: settings.buttonDisplayMode == .vars ? color(settings.theme.color3) : Color.init(white: 0.15),
                                textColor: settings.buttonDisplayMode == .vars ? Color.white : color(settings.theme.color3, edit: true),
                                width: size == .small ? 55 : 70,
                                smallerSmall: orientation == .landscape,
                                sound: .click3,
                                locked: true
                ) {
                    guard proCheckNotice(.variables) else { return }
                    settings.buttonDisplayMode = settings.buttonDisplayMode == .vars ? .basic : .vars
                    settings.buttonUppercase = false
                    settings.detailOverlay = .none
                }
                
//                SmallTextButton(text: "UNIT",
//                                color: settings.buttonDisplayMode == .units ? color(settings.theme.color3) : Color.init(white: 0.15),
//                                textColor: settings.buttonDisplayMode == .units ? Color.white : color(settings.theme.color3, edit: true),
//                                width: size == .small ? 50 : 65,
//                                smallerSmall: orientation == .landscape,
//                                sound: .click3
//                ) {
//                    guard proCheck() else {
//                        settings.popUp(.misc)
//                        return
//                    }
//                    settings.buttonDisplayMode = settings.buttonDisplayMode == .units ? .basic : .units
//                    settings.buttonUppercase = false
//                    settings.detailOverlay = .none
//                }
            }
            
            HStack {
                if orientation == .landscape || size == .large {
                    if settings.buttonDisplayMode == .basic {
                        matButtons
                    }
                    else if settings.buttonDisplayMode == .vars {
                        varButtons
                    }
                }
            }
            .padding(.leading, 20)
            
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
                        
                        SmallIconButton(symbol: "chevron.forward", textColor: Color.init(white: 0.7), smallerSmall: orientation == .landscape, sound: .click1, locked: !((Calculation.current.queue.queue2.first as? Parentheses)?.type == .hidden)) {
                            guard proCheckNotice(.misc) else { return }
                            Calculation.current.setUpInput()
                            Calculation.current.queue.forward()
                        }
                    }
                    
                    if calculation.completed {
                        
                        SmallIconButton(symbol: "doc.on.clipboard\(pastCalculation?.copied ?? false ? ".fill" : "")", textColor: color(settings.theme.color1, edit: true), smallerSmall: orientation == .landscape) {
                            pastCalculation?.copy()
                        }
                        SmallIconButton(symbol: "folder\(pastCalculation?.saved ?? false ? ".fill" : "")", textColor: color(settings.theme.color1, edit: true), smallerSmall: orientation == .landscape, locked: settings.featureVersionIdentifier > 0) {
                            guard proCheckNotice(.misc, maxFreeVersion: 0) else { return }
                            pastCalculation?.save()
                        }
                        SmallIconButton(symbol: "character.textbox", textColor: color(settings.theme.color1, edit: true), smallerSmall: orientation == .landscape, locked: true) {
                            guard proCheckNotice(.variables) else { return }
                            pastCalculation?.store()
                        }
                    }
                    
                    if calculation.completed {
                        
                        SmallIconButton(symbol: "ellipsis", color: Color.init(white: settings.detailOverlay == .result ? 0.3 : 0.15), smallerSmall: orientation == .landscape, locked: true) {
                            guard proCheckNotice(.results) else { return }
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
                        color: settings.buttonUppercase ? color(settings.theme.color1) : Color.init(white: 0.15),
                        textColor: settings.buttonUppercase ? Color.white : color(settings.theme.color1, edit: true),
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
                        color: settings.buttonUppercase ? color(settings.theme.color1) : Color.init(white: 0.15),
                        textColor: .white,
                        smallerSmall: orientation == .landscape,
                        sound: .click3
        ) {
            settings.buttonUppercase.toggle()
            settings.detailOverlay = .none
        }
    }
}
