//
//  Connectors.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/9/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {
    
    // MARK: - Connector
    // Connectors link values that appear adjacent to each other in the queue with no other operation between them
    
    static func connect(input1: Value, input2: Value) -> Value {
        
        var product = Value()
        
        let value1 = setValue(input1)
        let value2 = setValue(input2)
        
        // ERROR
        guard !(value1 is Error), !(value2 is Error) else { return Error() }
        
        // FUNCTION appears before value - Plug in to dummies
        if let function = input1 as? Letter, function.type == .constant, function.storedValue, input2 is Expression {
            
            // Set variables
            if function.value!.allVariables.count == 1, let letter = function.value!.allVariables.first {
                
                // Set variables to dummies
                function.value!.allVariables.filter{ $0.name == letter.name }.forEach{ $0.type = .dummy }
                
            }
            
            // Dummies already set
            if function.value!.allDummies.count == 1, let letter = function.value!.allDummies.first {
                
                // Plug it in and evaluate
                product = value1.plugIn(value2, to: letter)
                
            } else {
                
                // Multiply them
                product = value1 * value2
            }
        }

        // OTHER - Multiply the values
        else {
            
            // Multiply them
            product = value1 * value2
        }
        
        return product
    }
}
