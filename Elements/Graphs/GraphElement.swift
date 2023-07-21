//
//  GraphElement.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/3/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

class GraphElement {
    
    var color: Color
    
    init(color: Color = .white) {
        self.color = color
    }
}

class Line: GraphElement {
    
    var equation: Queue
    var modes: ModeSettings
    var domain: ClosedRange<Double>
    var points: [Double: Double]
    
    init(equation: Queue, modes: ModeSettings = Settings.settings.modes, domain: ClosedRange<Double> = -Double.infinity...Double.infinity, color: Color = .white) {
        self.equation = equation
        self.modes = modes
        self.domain = domain
        self.points = [:]
        super.init(color: color)
    }
    
    static func == (lhs: Line, rhs: Line) -> Bool {
        return lhs.equation == rhs.equation
    }
}

class LineShape: Line {
    
    var location: VerticalAlignment
    var opacity: CGFloat
    
    init(equation: Queue, location: VerticalAlignment = .center, domain: ClosedRange<Double> = -Double.infinity...Double.infinity, color: Color = .white, opacity: CGFloat = 1) {
        self.location = location
        self.opacity = opacity
        super.init(equation: equation, domain: domain, color: color)
    }
    
    static func == (lhs: LineShape, rhs: LineShape) -> Bool {
        return lhs.equation == rhs.equation && lhs.location == rhs.location
    }
}

class Guideline: GraphElement {
    
    var start: CGPoint
    var end: CGPoint
    var circle: Bool
    
    init(start: CGPoint, end: CGPoint, color: Color = .white) {
        self.start = start
        self.end = end
        self.circle = false
        super.init(color: color)
    }
    
    init(center: CGPoint = CGPoint(x: 0, y: 0), radius: CGFloat, color: Color = .white) {
        self.start = CGPoint(x: center.x + radius, y: center.y)
        self.end = center
        self.circle = true
        super.init(color: color)
    }
}

class GraphAngle: GraphElement {
    
    var center: CGPoint
    var startAngle: Double
    var endAngle: Double
    var maxSize: Double?
    var unit: ModeSettings.AngleUnit
    var string: String?
    
    var start: Angle {
        return unit == .deg ? Angle(degrees: startAngle) : Angle(radians: startAngle)
    }
    var end: Angle {
        return unit == .deg ? Angle(degrees: endAngle) : Angle(radians: endAngle)
    }
    
    init(center: CGPoint, startAngle: Double, endAngle: Double, maxSize: Double? = nil, unit: ModeSettings.AngleUnit, string: String? = nil, color: Color = .white) {
        self.center = center
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.maxSize = maxSize
        self.unit = unit
        self.string = string
        super.init(color: color)
    }
}

class GraphText: GraphElement {
    
    var position: CGPoint
    var text: String
    var size: CGFloat
    var rotation: Angle
    
    init(position: CGPoint, text: String, size: CGFloat = 0.1, rotation: Angle = .zero, color: Color = .white) {
        self.position = position
        self.text = text
        self.size = size
        self.rotation = rotation
        super.init(color: color)
    }
}
