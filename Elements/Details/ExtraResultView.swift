//
//  ExtraResultView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/5/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct ExtraResultView: View {
    
    @ObservedObject var calculation: PastCalculation
    var results: [Queue]? = nil
    var extraResults: [Queue] {
        return results ?? calculation.extraResults
    }
    
    var body: some View {
            
        VStack {
            
            ForEach(extraResults, id: \.id) { result in
                
                HStack {
                    
                    SmallIconButton(symbol: "arrowshape.turn.up.forward", color: Color.init(white: 0.25), smallerLarge: true, sound: .click3) {
                        calculation.replaceResult(with: result)
                        Calculation.get(calculation.uuid).refresh(result: result)
                    }
                    Spacer()
                    
                    TextDisplay(strings: ["="]+result.strings, size: 30, color: .white, scrollable: true)
                }
                .padding(.vertical, 5)
            }
        }
        .padding(10)
    }
}
