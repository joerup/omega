//
//  Limits.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {
    
    // MARK: - Limits
    
    static func limit(as variable: Letter, approaches limit: Value, of value: Value) -> Value {
        
        var result = Value()
        
        let limit = setValue(limit, keepExp: false, keepInf: true)
        let value = setValue(value)
        
        // ERROR
        guard !(limit is Error), !(value is Error) else { return Error() }
        
        // NUMBERS only - Approach number
        if let limit = limit as? Number {
            
            let difference = pow(10,round(log10(limit.value))-14)
            
            // Approach the left and right
            let leftApproach = Number(limit.value - difference)
            let rightApproach = Number(limit.value + difference)
            
            // Substitute the values
            let leftSubstitution = value.plugIn(leftApproach, to: variable)
            let rightSubstitution = value.plugIn(rightApproach, to: variable)
            
            // Set the average
            result = (leftSubstitution+rightSubstitution) / Number(2)
        }
        
        // OTHER - Plug it right in
        else {
            
            // Replace the variables in the value with the bound
            result = value.plugIn(limit, to: variable)
        }
        
        return result
    }
}
