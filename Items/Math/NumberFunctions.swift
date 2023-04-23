//
//  NumberFunctions.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {
    
    // MARK: - Miscellaneous Functions
    
    static func numberFunction(_ function: FunctionType, _ input: Value) -> Value {

        var result = Value()
        
        let input = setValue(input, keepExp: false)
        
        // ERROR
        guard !(input is Error) else { return Error() }
        
        // NUMBER - Direct function
        if let input = input as? Number {

            // Set the value
            let input = input.value
            
            // Perform the function
            var value: Double {
                switch function {
                case .rand:
                    return input.isInfinite ? .nan : input == 0 ? 0 : input > 0 ? Double.random(in: 0..<input) : -Double.random(in: 0..<(-input))
                case .randint:
                    return input.isInfinite ? .nan : Int(input) == 0 ? 0 : input > 0 ? Double(Int.random(in: 0..<Int(input))) : -Double(Int.random(in: 0..<(-Int(input))))
                case .round:
                    return round(input)
                case .floor:
                    return floor(input)
                case .ceil:
                    return ceil(input)
                default:
                    return input
                }
            }

            // Set the result
            result = number(value)
        }
        
        // EXPRESSION - default values
        else if let input = input as? Expression, input.queue.empty {
            
            // Set the default value
            var value: Double? {
                switch function {
                case .rand:
                    return Double.random(in: 0..<1)
                case .randint:
                    return Double(Int.random(in: 0..<10))
                default:
                    return nil
                }
            }
            
            if let value = value {
                result = number(value)
            } else {
                result = Error("Invalid syntax")
            }
        }
        
        // DO NOT SIMPLIFY - Create a function expression
        else if !(input is Expression) {
            result = Expression([Function(function), Expression([input])])
        } else {
            result = Expression([Function(function), input])
        }

        return result
    }
}
