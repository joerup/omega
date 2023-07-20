//
//  CalculationVisuals.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 4/21/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct CalculationVisuals: View {
    
    @ObservedObject var settings = Settings.settings
    
    @ObservedObject var calculation: Calculation = Calculation.current
    
    var width: CGFloat = 10
    var height: CGFloat = 10
    
    var lightBackground: Bool = false
    var ignoreIfEmpty: Bool = true
    
    var body: some View {
        
        Group {
            
            // Graph and Table
            if calculation.queue.allVariables.count == 1, let variable = calculation.queue.allVariables.first {

                let line = Line(equation: calculation.queue, color: settings.theme.color1)

                CalculationVisualSquare(text: "Graph", width: height, height: height) {
                    GraphView([line], horizontalAxis: variable, verticalAxis: Letter("f(\(variable.name)"), gridStyle: variable.name != "θ" ? .cartesian : .polar, interactive: false, popUpGraph: true, lightBackground: lightBackground, precision: 500)
                }
                CalculationVisualSquare(text: "Table", width: width-10-height, height: height) {
                    TableView(equation: calculation.queue, horizontalAxis: variable, verticalAxis: Letter("f(\(variable.name)"), lowerBound: .constant(height > 400 ? -10 : -7), upperBound: .constant(height > 400 ? 10 : 7), centerValue: .constant(0), increment: .constant(1), fullTable: false, popUpTable: true, lightBackground: lightBackground, fontSize: height > 400 ? height/(21*1.2) : height/(15*1.2))
                }
            }

            // Unit Circle
            else if calculation.queue.items.count == 2, let function = calculation.queue.items[0] as? Function, Function.baseTrig.contains(function.function), let angle = calculation.queue.items[1].simplify() as? Number {

                CalculationVisualSquare(text: "Unit Circle", width: width, height: height) {
                    UnitCircleView(function: function, angle: angle, unit: calculation.queue.modes.angleUnit, gridLines: false, interactive: false, popUpGraph: true, lightBackground: lightBackground)
                }
            }

            // Derivative
            else if calculation.queue.items.count == 5, let function = calculation.queue.items[0] as? Function, function.function == .valDeriv, let power = calculation.queue.items[1].simplify() as? Number, power.value == 1, let variable = calculation.queue.items[2].simplify() as? Letter, let expression = calculation.queue.items[3] as? Expression, let value = calculation.queue.items[4].simplify() as? Number, calculation.result.items.count == 1, let derivative = calculation.result.items[0].simplify() as? Number {

                let equation = Queue(expression.value, modes: calculation.queue.modes).substituted

                let line = Line(equation: equation, color: settings.theme.color1)
                let tangentLine = Line(equation: Queue([derivative, Operation(.mlt), Expression([variable, Operation(.sub), value]), Operation(.add), Expression(equation.items).plugIn(value, to: variable)], modes: calculation.queue.modes), color: settings.theme.color2)

                CalculationVisualSquare(text: "Derivative", width: width, height: height) {
                    GraphView([line, tangentLine], horizontalAxis: variable, verticalAxis: Letter("f(\(variable.text)"), interactive: false, popUpGraph: true, lightBackground: lightBackground, precision: 500)
                }
            }

            // Integral
            else if calculation.queue.items.count == 5, let function = calculation.queue.items[0] as? Function, function.function == .definteg, let lowerBound = calculation.queue.items[1].simplify() as? Number, let upperBound = calculation.queue.items[2].simplify() as? Number, lowerBound.value < upperBound.value, let expression = calculation.queue.items[3] as? Expression, let variable = calculation.queue.items[4].simplify() as? Letter, calculation.result.items[0].simplify() is Number {

                let equation = Queue(expression.value, modes: calculation.queue.modes).substituted

                let line = Line(equation: equation, color: settings.theme.color1)
                let area = LineShape(equation: equation, location: .center, domain: lowerBound.value...upperBound.value, color: settings.theme.color1, opacity: 0.5)

                CalculationVisualSquare(text: "Integral", width: width, height: height) {
                    GraphView([line, area], horizontalAxis: variable, verticalAxis: Letter("f(\(variable.text)"), interactive: false, popUpGraph: true, lightBackground: lightBackground, precision: 500)
                }
            }
            
            else if !ignoreIfEmpty {
                CalculationVisualSquare(text: "None", width: width, height: height) {
                    ZStack {
                        Color.init(white: 0.125).cornerRadius(20)
                        Text("No Preview")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .id(Calculation.current.update)
    }
}

struct CalculationVisualSquare<Content: View>: View {
    
    var text: String
    var width: CGFloat
    var height: CGFloat
    
    var content: () -> Content
    
    var body: some View {
        
        content()
            .background(Color.init(white: 0.12))
            .frame(width: width, height: height)
            .cornerRadius(20)
    }
}

