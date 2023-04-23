//
//  Parentheses.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 11/20/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation

class Parentheses: NonValue {
    
    var grouping: InputGrouping
    
    var type: GroupingType
    var pattern: GroupingPattern
    
    var open: Bool {
        return grouping == .open
    }
    var close: Bool {
        return grouping == .close
    }
    
    var visible: Bool {
        return type.visible
    }
    var invisible: Bool {
        return type.invisible
    }
    
    var display: String {
        switch grouping {
        case .open:
            return invisible ? "#(" : "("
        case .close:
            return invisible ? "#)" : "\\)"
        }
    }
    
    init(_ grouping: InputGrouping, _ type: GroupingType = .parentheses, _ pattern: GroupingPattern = .none) {
        self.grouping = grouping
        self.type = type
        self.pattern = pattern
    }
}


