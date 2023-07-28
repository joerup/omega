//
//  Letter.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/10/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

class Letter: Value {
    
    var name: String
    var type: LetterType
    var value: Queue?
    
    var storedValue: Bool {
        return !(value?.empty ?? true)
    }
    
    var typeString: String {
        switch type {
        case .variable:
            return "Unknown"
        case .constant:
            return (value != nil && !(value!.allVariables.isEmpty && value!.allBounds.isEmpty && value!.allDummies.isEmpty)) ? "Function" : "Constant"
        case .bound:
            return "Bound"
        case .dummy:
            return "Dummy"
        }
    }
    
    var systemConstant: Bool {
        if type == .constant, let queue = value, queue.items.count == 1, let number = queue.items.first as? Number {
            if name == "π" && number.value == .pi || name == "e" && number.value == M_E {
                return true
            }
        }
        return false
    }
        
    enum LetterType: String {
        // variables - hold no value
        case variable = "v"
        // constants - hold a permanent value
        case constant = "c"
        // bound - explicit letter where values are plugged in
        case bound = "b"
        // dummy - implicit letter where values are plugged in
        case dummy = "d"
    }
    
    init(_ name: String, type: LetterType = .variable) {
        
        self.name = name
        
        if type != .variable {
            self.value = nil
            self.type = type
        } else if let storedVar = StoredVar.getVariable(name) {
            self.value = storedVar.value
            self.type = .constant
        } else if Letter.constants.contains(where: { $0.name == name }) {
            switch name {
            case "π":
                self.value = Queue([Number(Double.pi)])
            case "e":
                self.value = Queue([Number(M_E)])
            default:
                self.value = Queue()
            }
            self.type = .constant
        } else {
            self.value = nil
            self.type = .variable
        }
    }
    
    init(_ name: String, type: LetterType = .variable, value: Queue?, resetStored: Bool = false) {
        
        self.name = name
        
        self.type = type
        if value?.empty ?? true {
            if resetStored, let storedVar = StoredVar.getVariable(name) {
                self.value = storedVar.value
                self.type = .constant
            } else if resetStored, Letter.constants.contains(where: { $0.name == name }) {
                switch name {
                case "π":
                    self.value = Queue([Number(Double.pi)])
                case "e":
                    self.value = Queue([Number(M_E)])
                default:
                    self.value = Queue()
                }
                self.type = .constant
            } else {
                self.value = nil
            }
        } else {
            self.value = value
        }
    }
    
    init(_ name: String) {
        
        self.name = name
        self.type = .variable
        self.value = nil
    }
    
    init(_ name: String, constant: Queue) {
        
        self.name = name
        
        self.type = .constant
        self.value = constant
    }
    
    init(raw: [String:String], resetStored: Bool = false) {
        if let name = raw["name"] {
            self.name = name
        } else {
            self.name = ""
        }
        if let rawType = raw["type"], let type = LetterType(rawValue: rawType) {
            self.type = type
        } else {
            self.type = .variable
        }
        if let rawValue = raw["value"], let value = Item.convertRawStringArray(rawValue, resetStored: resetStored) {
            self.value = value
        } else {
            self.value = nil
        }
    }
    
    func set(_ value: Queue?) {
        self.value = value
        self.type = value == nil || value!.empty ? .variable : .constant
    }
}
