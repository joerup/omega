//
//  Placeholder.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 12/23/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation

class Placeholder: Value {
    
    var active: Bool
    var grouping: GroupingType
    var pattern: GroupingPattern
    
    var string: String {
        return active ? "■" : "□"
    }
    
    init(_ active: Bool = false) {
        self.active = active
        self.grouping = .none
        self.pattern = .none
        super.init()
    }
    init(active: Bool = false, grouping: GroupingType = .none, pattern: GroupingPattern = .none) {
        self.active = active
        self.grouping = grouping
        self.pattern = pattern
        super.init()
    }
    
    func activate() {
        self.active = true
    }
    func deactivate() {
        self.active = false
    }
}

class Pointer: Placeholder {
    
    override var string: String {
        return "#|" 
    }
}
