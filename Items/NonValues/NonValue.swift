//
//  NonValue.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 12/19/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation

class NonValue: Item {
    
    var empty: Bool {
        return !( self is Operation || self is Function || self is Modifier || self is Parentheses )
    }
    
    // these non values may come before fake parentheses
    var beforeFakePar: Bool {
        if let operation = self as? Operation {
            return ((Settings.settings.displayX10 ? []:[.exp])+[.mod]).contains(operation.operation)
        } else if let function = self as? Function {
            return !function.parentheses && !function.autoHiddenPar && function.function != .abs
        }
        return false
    }
    // these non values may come after fake parentheses
    var afterFakePar: Bool {
        if let operation = self as? Operation {
            return [.pow,.exp,.mod].contains(operation.operation)
        }
        return false
    }
}
