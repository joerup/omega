//
//  FunctionAnalysisView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/21/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

struct FunctionAnalysisView: View {
    
    var queue: Queue
    
    var roots: [Value]
    var extrema: [Value]
    
    var body: some View {
        
        if let variable = queue.variables.first {
            
            VStack {
                
                ForEach(roots.indices, id: \.self) { r in
                    
                    let root = roots[r]
                    
                    HStack {
                        
                        Text("Root")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.init(white: 0.7))
                            .padding(.leading, 5)
                        
                        TextDisplay(strings: [variable.text, "="] + Queue([root]).strings, size: 22, scrollable: true)
                    }
                }
                
                ForEach(extrema.indices, id: \.self) { e in
                    
                    let extremum = extrema[e]
                    
                    let second = Value.evaluateDerivative(Expression(queue.items), order: Number(2), withRespectTo: variable, location: extremum)
                    
                    HStack {
                        
                        Text(second is Number && (second as! Number).negative ? "Maximum" : "Minimum")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.init(white: 0.7))
                            .padding(.leading, 5)
                        
                        TextDisplay(strings: [variable.text, "="] + Queue([extremum]).strings, size: 22, scrollable: true)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(10)
        }
    }
}
