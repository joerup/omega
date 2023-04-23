//
//  Trigonometry.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/7/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

extension Value {

    // MARK: - Trigonometry
    
    static func trig(_ function: FunctionType, angle: Value, unit: ModeSettings.AngleUnit) -> Value {

        var result = Value()
        
        let angle = setValue(angle, keepExp: false)
        
        // ERROR
        guard !(angle is Error) else { return Error() }

        // NUMBER - Direct trig function
        if let angle = angle as? Number {

            // Set the angle and switch radians <=> degrees
            let angle = unit == .rad ? angle.value : angle.value*Double.pi/180
            
            // Find the function value
            var value: Double = .infinity
            switch function {
            case .sin:
                value = sin(angle)
            case .cos:
                value = cos(angle)
            case .tan:
                value = tan(angle)
            case .cot:
                value = 1/tan(angle)
            case .sec:
                value = 1/cos(angle)
            case .csc:
                value = 1/sin(angle)
            case .sinh:
                value = sinh(angle)
            case .cosh:
                value = cosh(angle)
            case .tanh:
                value = tanh(angle)
            case .coth:
                value = 1/tanh(angle)
            case .sech:
                value = 1/cosh(angle)
            case .csch:
                value = 1/sinh(angle)
            default:
                value = .infinity
            }

            // Account for errors - send result to infinity or 0
            if abs(value) > 1e+12 { value = .infinity }
            if abs(value) < 1e-12 { value = 0 }

            // Set the result
            result = number(value)
        }
        
        // DO NOT SIMPLIFY - Create a function expression
        else if !(angle is Expression) && Function.parenthesesFunctions.contains(function) {
            result = Expression([Function(function), Expression([angle])])
        } else {
            result = Expression([Function(function), angle])
        }

        return result
    }
    
    // MARK: - Trig Power Functions
    
    static func trig(_ function: FunctionType, power: Value, angle: Value, unit: ModeSettings.AngleUnit) -> Value {

        var result = Value()
        
        let power = setValue(power, keepExp: false)
        let angle = setValue(angle, keepExp: false)
        
        // ERROR
        guard !(power is Error), !(angle is Error) else { return Error() }
        
        // Set up the power function
        result = trig(FunctionType.init(rawValue: String(function.rawValue.dropLast()))!, angle: angle, unit: unit) ^ power
        
        return result
    }
    
    // MARK: - Inverse Trig Functions
    
    static func trig(_ function: FunctionType, value: Value, unit: ModeSettings.AngleUnit) -> Value {

        var result = Value()
        
        let value = setValue(value, keepExp: false)
        
        // ERROR
        guard !(value is Error) else { return Error() }

        // NUMBER - Direct inverse trig function
        if let value = value as? Number {
            
            // Set the value
            let value = value.value

            // Find the angle
            var angle: Double = .infinity
            switch function {
            case .sin⁻¹:
                angle = asin(value)
            case .cos⁻¹:
                angle = acos(value)
            case .tan⁻¹:
                angle = atan(value)
            case .cot⁻¹:
                angle = atan(1/value)
            case .sec⁻¹:
                angle = acos(1/value)
            case .csc⁻¹:
                angle = asin(1/value)
            case .sinh⁻¹:
                angle = asinh(value)
            case .cosh⁻¹:
                angle = acosh(value)
            case .tanh⁻¹:
                angle = atanh(value)
            case .coth⁻¹:
                angle = atanh(1/value)
            case .sech⁻¹:
                angle = acosh(1/value)
            case .csch⁻¹:
                angle = asinh(1/value)
            default:
                angle = .infinity
            }

            // Switch radians <=> degrees for inverse function result angles
            angle = unit == .rad ? angle : angle*180/Double.pi

            // Set the result
            result = number(angle)
        }
        
        // DO NOT SIMPLIFY - Create a function expression
        else if !(value is Expression) && Function.parenthesesFunctions.contains(function) {
            result = Expression([Function(function), Expression([value])])
        } else {
            result = Expression([Function(function), value])
        }

        return result
    }
}
