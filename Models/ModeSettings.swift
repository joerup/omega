//
//  ModeSettings.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/3/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

class ModeSettings: ObservableObject, Equatable {
    
    enum AngleUnit: String {
        case deg = "deg"
        case rad = "rad"
    }
    enum GraphType: String {
        case cartesian = "car"
        case polar = "pol"
    }
    
    var angleUnit: AngleUnit
    var graphType: GraphType
    
    var raw: String {
        var string = ""
        string += "angleUnit:\(angleUnit.rawValue)\n"
        string += "graphType:\(graphType.rawValue)\n"
        return string
    }
    
    init() {
        self.angleUnit = .deg
        self.graphType = .cartesian
    }
    init(angleUnit: AngleUnit = .deg, graphType: GraphType = .cartesian) {
        self.angleUnit = angleUnit
        self.graphType = graphType
    }
    convenience init(raw: String?) {
        self.init()
        guard let raw = raw else { return }
        let settings = raw.split(whereSeparator: \.isNewline).map { (name: $0.split(separator: ":")[0], value: String($0.split(separator: ":")[1]) ) }
        for setting in settings {
            switch setting.name {
            case "angleUnit":
                self.angleUnit = AngleUnit(rawValue: setting.value) ?? .deg
            case "graphType":
                self.graphType = GraphType(rawValue: setting.value) ?? .cartesian
            default:
                ()
            }
        }
    }
    
    static func == (a: ModeSettings, b: ModeSettings) -> Bool {
        return a.angleUnit == b.angleUnit && a.graphType == b.graphType
    }
}
