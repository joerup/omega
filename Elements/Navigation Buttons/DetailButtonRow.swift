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
                
                if orientation == .landscape {
                    SmallTextButton(text: "2ND",
                                    color: settings.buttonDisplayMode == .second ? color(settings.theme.color3) : Color.init(white: 0.15),
                                    textColor: settings.buttonDisplayMode == .second ? Color.white : color(settings.theme.color3, edit: true),
                                    width: size == .large ? 100 : 60,
                                    smallerSmall: orientation == .landscape,
                                    sound: .click3
                    ) {
                        settings.buttonDisplayMode = settings.buttonDisplayMode == .second ? .first : .second
                        settings.detailOverlay = .none
                    }
                }
                
                SmallTextButton(text: "MAT",
                                color: settings.buttonDisplayMode == .math ? color(settings.theme.color3) : Color.init(white: 0.15),
                                textColor: settings.buttonDisplayMode == .math ? Color.white : color(settings.theme.color3, edit: true),
                                width: size == .large ? 100 : 60,
                                smallerSmall: orientation == .landscape,
                                sound: .click3
                ) {
                    settings.buttonDisplayMode = settings.buttonDisplayMode == .math ? .first : .math
                    settings.detailOverlay = .none
                }
                
                SmallTextButton(text: "ABC",
                                color: settings.buttonDisplayMode == .alpha ? color(settings.theme.color3) : Color.init(white: 0.15),
                                textColor: settings.buttonDisplayMode == .alpha ? Color.white : color(settings.theme.color3, edit: true),
                                width: size == .large ? 100 : 60,
                                smallerSmall: orientation == .landscape,
                                sound: .click3
                ) {
                    settings.buttonDisplayMode = settings.buttonDisplayMode == .alpha ? .first : .alpha
                    settings.detailOverlay = .none
                }
            }
            
            Spacer()
                
            HStack {
                
                if calculation.queue.editing {
                    
                    SmallIconButton(symbol: "chevron.backward", textColor: Color.init(white: 0.7), smallerSmall: orientation == .landscape, sound: .click2, proOnly: true) {
                        Calculation.current.setUpInput()
                        Calculation.current.queue.backward()
                    }
                    
                    SmallIconButton(symbol: "chevron.forward", textColor: Color.init(white: 0.7), smallerSmall: orientation == .landscape, sound: .click1, proOnly: !((Calculation.current.queue.queue2.first as? Parentheses)?.type == .hidden)) {
                        Calculation.current.setUpInput()
                        Calculation.current.queue.forward()
                    }
                }
                
                if calculation.completed {
                    
                    SmallIconButton(symbol: "doc.on.clipboard\(pastCalculation?.copied ?? false ? ".fill" : "")", textColor: color(settings.theme.color1, edit: true), smallerSmall: orientation == .landscape) {
                        pastCalculation?.copy()
                    }
                    SmallIconButton(symbol: "folder\(pastCalculation?.saved ?? false ? ".fill" : "")", textColor: color(settings.theme.color1, edit: true), smallerSmall: orientation == .landscape) {
                        pastCalculation?.save()
                    }
                    if proCheck() {
                        SmallIconButton(symbol: "character.textbox", textColor: color(settings.theme.color1, edit: true), smallerSmall: orientation == .landscape, proOnly: true) {
                            pastCalculation?.store()
                        }
                    }
                }
                
                if calculation.completed {
                    
                    SmallIconButton(symbol: "ellipsis", color: Color.init(white: settings.detailOverlay == .result ? 0.3 : 0.2), smallerSmall: orientation == .landscape) {
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
        .frame(height: size == .large ? 65 : orientation == .landscape ? 35 : 40)
        .animation(.default)
        .transition(.move(edge: .trailing))
    }
}
