//
//  InfoConstant.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/27/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation

class InfoConstant {
    
    var id = UUID()
    var name: String
    var symbol: String
    var value: [String]
    var unit: [String]
    
    init(name: String, symbol: String, value: [String], unit: [String] = []) {
        self.name = name
        self.symbol = symbol
        self.value = value
        self.unit = unit
    }
    
    init(value: [String], unit: [String] = []) {
        self.name = ""
        self.symbol = ""
        self.value = value
        self.unit = unit
    }
}

class InfoConstantCluster: InfoConstant {
    
    var constants: [InfoConstant]
    
    init(name: String, symbol: String, constants: [InfoConstant]) {
        
        self.constants = constants
        
        super.init(name: name, symbol: symbol, value: constants[0].value, unit: constants[0].unit)
    }
}
