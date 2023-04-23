//
//  Unit.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/10/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation

class Unit: Value {

    var symbol: String
    var name: String
    var type: MeasurementType
    var relativeValue: Double

    var string: String {
        return "_"+symbol
    }

    init(symbol: String) {
        self.symbol = symbol
        if symbol.first == "_" {
            self.symbol.removeFirst()
        }
        let unitData = Unit.unitData[self.symbol]
        self.name = unitData?.name ?? ""
        self.type = unitData?.type ?? .none
        self.relativeValue = unitData?.relativeValue ?? 0
    }
    
    init(raw: [String:String], resetStored: Bool = false) {
        if let symbol = raw["symbol"] {
            self.symbol = symbol
        } else {
            self.symbol = ""
        }
        let unitData = Unit.unitData[self.symbol]
        self.name = unitData?.name ?? ""
        self.type = unitData?.type ?? .none
        self.relativeValue = unitData?.relativeValue ?? 0
    }
    
    var otherUnits: [Unit] {
        return Unit.allUnits(of: type)
    }
    
    static func allUnits(of type: MeasurementType) -> [Unit] {
        return unitData.keys.filter { unitData[$0]?.type == type }.map { Unit(symbol: $0) }
    }
    
    func convert(to unit: Unit) -> [Item] {
        guard self.type == unit.type else { return [] }
        return [Number(unit.relativeValue / self.relativeValue), Operation(.con), unit]
    }
    
    static var unitData: [String: (name: String, type: MeasurementType, relativeValue: Double)] = [
        
        // Time
        "s": (name: "seconds", type: .time, relativeValue: 1),
        "min": (name: "minutes", type: .time, relativeValue: 1/60),
        "hr": (name: "hours", type: .time, relativeValue: 1/3600),
        "day": (name: "days", type: .time, relativeValue: 1/86400),
        "yr": (name: "seconds", type: .time, relativeValue: 1/3.1536E+7),
            
        // Length
        "m": (name: "meters", type: .length, relativeValue: 1),
        "km": (name: "kilometers", type: .length, relativeValue: 1/1000),
        "cm": (name: "centimeters", type: .length, relativeValue: 100),
        "mm": (name: "millimeters", type: .length, relativeValue: 1000),
        "ft": (name: "feet", type: .length, relativeValue: 3.28084),
        "in": (name: "inches", type: .length, relativeValue: 39.3701),
        "yd": (name: "yards", type: .length, relativeValue: 1.09361),
        "mi": (name: "miles", type: .length, relativeValue: 1/1609.34),
            
        // Mass
        "kg": (name: "kilograms", type: .mass, relativeValue: 1),
        "g": (name: "grams", type: .mass, relativeValue: 1000),
        "lb": (name: "pounds", type: .mass, relativeValue: 2.20462),
    ]
    
    enum MeasurementType: String {
        case time
        case length
        case mass
        case current
        case temperature
        case amount
        case none
        
        var string: String {
            return self.rawValue
        }
    }
}

