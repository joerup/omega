//
//  Operation.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 11/14/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation

class Operation: NonValue {
    
    var operation: OperationType
    
    init(_ operation: OperationType) {
        self.operation = operation
    }
    
    init(raw: [String:String]) {
        if let rawType = raw["type"], let type = OperationType(rawValue: rawType) {
            self.operation = type
        } else {
            self.operation = .add
        }
    }
    
    static let primary = ["+","-","×","÷","mod"]
    
    var isPrimary: Bool {
        return Operation.primary.contains(operation.rawValue)
    }
}

enum OperationType: String {
    case add = "+"
    case sub = "-"
    case mlt = "×"
    case div = "÷"
    case con = "*"
    case fra = "/"
    case pow = "^"
    case rad = "√"
    case exp = "E"
    case nPr = "nPr"
    case nCr = "nCr"
    case mod = "mod"
}
