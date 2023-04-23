//
//  Modifier.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 12/19/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation

class Modifier: NonValue {
    
    var modifier: ModifierType
    
    init(_ modifier: ModifierType) {
        self.modifier = modifier
    }
    
    init(raw: [String:String]) {
        if let rawType = raw["type"], let type = ModifierType(rawValue: rawType) {
            self.modifier = type
        } else {
            self.modifier = .pcent
        }
    }
}

enum ModifierType: String {
    case pcent = "%"
    case pmil = "‰"
    case fac = "!"
    case dfac = "!!"
}
