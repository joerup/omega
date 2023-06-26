//
//  HeaderButtonRow.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 5/25/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct HeaderButtonRow: View {
    
    @ObservedObject var settings = Settings.settings
    
    var size: Size
    var orientation: Orientation
    
    var body: some View {
        
        HStack {
            
            SmallIconButton(symbol: "gearshape.fill", color: Color.init(white: 0.15), smallerSmall: orientation == .landscape, action: {
                withAnimation {
                    self.settings.showMenu = true
                }
            })
            
            if orientation != .landscape || size == .large {
                HeaderButtonScrollView(size: size, orientation: orientation)
            }
            
            SmallIconButton(symbol: "clock.arrow.circlepath", color: Color.init(white: self.settings.calculatorOverlay == .calculations ? 0.3 : 0.15), smallerSmall: orientation == .landscape, action: {
                self.settings.calculatorOverlay = self.settings.calculatorOverlay == .calculations ? .none : .calculations
            })
            
            SmallIconButton(symbol: "folder", color: Color.init(white: self.settings.calculatorOverlay == .saved ? 0.3 : 0.15), smallerSmall: orientation == .landscape, action: {
                self.settings.calculatorOverlay = self.settings.calculatorOverlay == .saved ? .none : .saved
            })
            
            if proCheck() {
                
                SmallIconButton(symbol: "character.textbox", color: Color.init(white: self.settings.calculatorOverlay == .variables ? 0.3 : 0.15), smallerSmall: orientation == .landscape, action: {
                    self.settings.calculatorOverlay = self.settings.calculatorOverlay == .variables ? .none : .variables
                })
            } else {
                
                SmallTextButton(text: "PRO", color: Color.init(white: 0.15), textColor: color(settings.theme.color1, edit: true), width: size == .small ? 55 : 75, smallerSmall: orientation == .landscape, action: {
                    settings.popUp(.list)
                })
            }
            
            if orientation == .landscape && size == .small {
                HeaderButtonScrollView(size: size, orientation: orientation)
            }
        }
    }
}

struct HeaderButtonScrollView: View {
    
    @ObservedObject var settings = Settings.settings
    
    @ObservedObject var calculation = Calculation.current
    
    var size: Size
    var orientation: Orientation
    
    var body: some View {
    
        HStack {
                    
            SmallTextButton(text: self.settings.modes.angleUnit.rawValue.uppercased(), color: Color.init(white: 0.15), textColor: Color.init(white: 0.7), width: size == .small ? 55 : 75, smallerSmall: orientation == .landscape, sound: .click3) {
                
                self.settings.modes.angleUnit = settings.modes.angleUnit == .rad ? .deg : .rad
                Calculation.current.setModes(to: self.settings.modes)
                
                // Refresh
                UserDefaults.standard.set(self.settings.modes.raw, forKey: "modes")
                Calculation.current.refresh()
            }
            .id(calculation.update)
            
            Spacer()
        }
        .border(Color.orange, width: self.settings.guidelines ? 1 : 0)
    }
    
    func containsTrigFunction(_ queue: Queue? = nil) -> Bool {
        let queue = queue ?? Calculation.current.queue
        return queue.items.contains(where: { Function.trig.contains((($0 as? Function)?.function ?? .abs)) || ($0 is Expression && containsTrigFunction(($0 as! Expression).queue)) })
    }
}
