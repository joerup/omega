//
//  UnitConversionView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 4/22/23.
//  Copyright © 2023 Rupertus. All rights reserved.
//

import SwiftUI

struct UnitConversionView: View {
    
    @ObservedObject var settings = Settings.settings
    
    var calculation: PastCalculation
    
    var size: Size {
        return UIDevice.current.userInterfaceIdiom == .phone ? .small : .large
    }
    
    var body: some View {
            
        VStack {
            
            ForEach(calculation.otherUnits, id: \.id) { result in
                
                HStack {
                    
                    SmallIconButton(symbol: "arrowshape.turn.up.forward", color: Color.init(white: 0.25), smallerLarge: true, sound: .click3) {
                        calculation.replaceResult(with: result)
                        Calculation.get(calculation.uuid).refresh(result: result)
                    }
                    Spacer()
                    
                    TextDisplay(strings: ["="]+result.strings, size: 30, scrollable: true)
                }
                .padding(.vertical, 5)
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

