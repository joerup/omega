//
//  FunctionRoots.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/21/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {
    
    // MARK: Function Roots
    
    static func functionRoots(_ function: Queue) -> [Value] {
        
        var roots: [Value] = []
        
        guard function.variables.count == 1, let variable = function.allVariables.first else { return [] }
        
        // Use Newton's Method to aproximate the roots of the function
        
        var x: Value = Number(Double.random(in: -10...10))
        
        var i = 0
        while i < 10 {
            
            let y = Expression(function.items).plugIn(x, to: variable)
            let dy = evaluateDerivative(Expression(function.simplify()), withRespectTo: variable, location: x)
            
            x = x - y/dy
            
            i += 1
        }
        
        if Expression(function.items).plugIn(x, to: variable) == Number(0) {
            roots += [x]
        }
        
        return roots
    }
    
}
