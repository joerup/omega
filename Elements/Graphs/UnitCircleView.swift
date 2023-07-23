//
//  UnitCircleView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/8/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct UnitCircleView: View {
    
    @ObservedObject var settings = Settings.settings
    
    var function: Function
    var angle: Number
    var unit: ModeSettings.AngleUnit
    
    var x: CGFloat
    var y: CGFloat
    
    var color: Color
    
    var gridLines: Bool
    var interactive: Bool
    var popUpGraph: Bool
    var lightBackground: Bool
    
    init(function: Function, angle: Number, unit: ModeSettings.AngleUnit, color: Color? = nil, gridLines: Bool = true, interactive: Bool = true, popUpGraph: Bool = false, lightBackground: Bool = false) {
        self.function = function
        self.angle = angle
        self.unit = unit
        self.x = (Value.trig(.cos, angle: angle, unit: unit) as? Number)?.value ?? 0
        self.y = (Value.trig(.sin, angle: angle, unit: unit) as? Number)?.value ?? 0
        self.color = color ?? Settings.settings.theme.primaryTextColor
        self.gridLines = gridLines
        self.interactive = interactive
        self.popUpGraph = popUpGraph
        self.lightBackground = lightBackground
    }
    
    var body: some View {
        GraphView(circle()+triangle()+angles()+text(), width: 2.5, gridLines: gridLines, interactive: interactive, popUpGraph: popUpGraph, lightBackground: lightBackground)
    }
    
    func circle() -> [Guideline] {
        
        return [Guideline(radius: 1, color: .gray)]
    }
    
    func angles() -> [GraphAngle] {
        
        let theta = GraphAngle(center: CGPoint(x: 0, y: 0), startAngle: 0, endAngle: angle.value, unit: unit, string: angle.string + (unit == .deg ? "º" : ""))
        let right = GraphAngle(center: CGPoint(x: x, y: 0), startAngle: x > 0 ? 180 : 0, endAngle: y > 0 ? 90 : 270, maxSize: min(abs(x), abs(y))/3, unit: .deg)
        
        return [theta,right]
    }
    
    func triangle() -> [Guideline] {
        
        let hypotenuse = Guideline(start: CGPoint(x: 0, y: 0), end: CGPoint(x: x, y: y), color: color)
        let cos = Guideline(start: CGPoint(x: 0, y: 0), end: CGPoint(x: x, y: 0), color: color)
        let sin = Guideline(start: CGPoint(x: x, y: 0), end: CGPoint(x: x, y: y), color: color)
        
        return [hypotenuse,cos,sin]
    }
    
    func text() -> [GraphText] {
        
//        let xText = GraphText(position: CGPoint(x: x*0.5, y: y>=0 ? -0.08 : 0.08), text: "x", color: .white)
//        let yText = GraphText(position: CGPoint(x: x>=0 ? x+0.08 : x-0.08, y: y*0.5), text: "y", color: .white)
//        let rText = GraphText(position: CGPoint(x: x*0.4, y: y*0.6), text: "r", color: .white)
//        let valueText = GraphText(position: CGPoint(x: x*0.5, y: y*0.5), text: "\(function.text) \(angle.string)º")
        
        return []
    }
}
