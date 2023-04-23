//
//  Expression.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 11/14/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation

class Expression: Value {
    
    var queue: Queue
    var value: [Item] {
        return queue.items
    }
    
    var grouping: GroupingType
    var pattern: GroupingPattern
    
    var parentheses: Bool {
        return grouping.visible
    }
    var canEnter: Bool {
        return !(value.count == 1 && value.first is Number && (value.first as! Number).string.contains("#"))
    }
    
    var singleGroup: Bool {
        return smallGroup && !value.contains(where: { ($0 as? Number)?.negative ?? false }) && !value.contains(where: { ($0 as? Number)?.string.contains(" ̅") ?? false })
    }
    var smallGroup: Bool {
        return !queue.final.withoutExpressions().contains(where: { $0 is NonValue })
    }
    var mediumGroup: Bool {
        let value = queue.final.withoutExpressions()
        return !value.contains(where: { $0 is Function }) && !value.contains(where: { ($0 as? Operation)?.isPrimary ?? false }) && !((self.value.contains(where: { ($0 as? Expression)?.parentheses ?? false }) || self.value.contains(where: { $0 is Parentheses && ($0 as! Parentheses).visible })) && value.contains(where: { ($0 as? Operation)?.operation == .con }))
    }
    var bigGroup: Bool {
        return !queue.final.withoutExpressions().contains(where: { ($0 as? Operation)?.isPrimary ?? false })
    }
    
    override init() {
        self.queue = Queue([])
        self.grouping = .parentheses
        self.pattern = .none
    }
    init(_ queue: Queue, grouping: GroupingType = .parentheses, pattern: GroupingPattern = .none) {
        self.queue = queue
        self.grouping = grouping
        self.pattern = pattern
    }
    init(_ value: [Item], modes: ModeSettings = Settings.settings.modes, grouping: GroupingType = .parentheses, pattern: GroupingPattern = .none) {
        self.queue = Queue(value, modes: modes)
        self.grouping = grouping
        self.pattern = pattern
    }
    init(_ value: Item, modes: ModeSettings = Settings.settings.modes, grouping: GroupingType = .parentheses, pattern: GroupingPattern = .none) {
        self.queue = Queue([value], modes: modes)
        self.grouping = grouping
        self.pattern = pattern
    }
    init(_ value: Double, grouping: GroupingType = .parentheses, pattern: GroupingPattern = .none) {
        self.queue = Queue([Number(value)])
        self.grouping = grouping
        self.pattern = pattern
    }
    
    init(raw: [String:String]) {
        if let rawValue = raw["value"], let value = Item.convertRawStringArray(rawValue) {
            self.queue = value
        } else {
            self.queue = Queue([])
        }
        if let rawGrouping = raw["type"], let grouping = GroupingType(rawValue: rawGrouping) {
            self.grouping = grouping
        } else if let rawParentheses = raw["parentheses"], let parentheses = Bool(rawParentheses) {
            self.grouping = parentheses ? .parentheses : .hidden
        } else {
            self.grouping = .parentheses
        }
        if let rawPattern = raw["pattern"], let pattern = GroupingPattern(rawValue: rawPattern) {
            self.pattern = pattern
        } else {
            self.pattern = .none
        }
    }
    
    func smallEnoughLast(for nonValue: NonValue?) -> Bool {
        guard let nonValue = nonValue else { return true }
        if let function = nonValue as? Function {
            return function.autoHiddenPar ? bigGroup : mediumGroup
        } else {
            return smallGroup
        }
    }
    func smallEnoughNext(for nonValue: NonValue?) -> Bool {
        guard let nonValue = nonValue else { return true }
        if (nonValue as? Operation)?.operation == .pow {
            return singleGroup
        } else {
            return smallGroup
        }
    }
}

enum GroupingType: String {
    
    case parentheses = "p"
    case hidden = "h"
    case temporary = "t"
    case bound = "b"
    case none = "n"
    
    var visible: Bool {
        return self == .parentheses
    }
    var invisible: Bool {
        return self == .hidden || self == .temporary || self == .bound
    }
}

enum GroupingPattern: String {
    
    case none = "N"
    case stuckLeft = "L"
    case stuckRight = "R"
    
    var stuck: Bool {
        return self == .stuckLeft || self == .stuckRight
    }
}
