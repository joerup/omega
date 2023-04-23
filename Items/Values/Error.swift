//
//  Error.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 11/14/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation

class Error: Value {
    
    var message: String
    
    init(_ message: String = "") {
        self.message = message
    }
}
