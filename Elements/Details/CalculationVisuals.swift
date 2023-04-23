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
    
    var buttons: Bool = false
    
    var body: some View {
        
        Group {
            
            // Graph and Table
            if calculation.queue.allVariables.count == 1, let variable = calculation.queue.allVariables.first {

                let line = Line(equation: calculation.queue, color: settings.theme.color1)

                if buttons {
                    CalculationVisualButton(symbol: "perspective", textColor: color(settings.theme.color2)) {
                        GraphView([line], horizontalAxis: variable, verticalAxis: Letter("f(\(variable.name)"), gridStyle: variable.name != "θ" ? .cartesian : .polar)
                    }
                    CalculationVisualButton(symbol: "tablecells", textColor: color(settings.theme.color2)) {
                        TableMenuView(equation: calculation.queue, horizontalAxis: variable, verticalAxis: Letter("f(\(variable.name)"), centerValue: 0)
                    }
                } else {
                    CalculationVisualSquare(text: "Graph", width: width, height: height) {
                        GraphView([line], horizontalAxis: variable, verticalAxis: Letter("f(\(variable.name)"), gridLines: false, gridStyle: variable.name != "θ" ? .cartesian : .polar, interactive: false, popUpGraph: true, precision: 100)
                    }

                    CalculationVisualSquare(text: "Table", width: width, height: height) {
                        TableView(equation: calculation.queue, horizontalAxis: variable, verticalAxis: Letter("f(\(variable.name)"), lowerBound: -5, upperBound: 5, increment: 1, fullTable: false, popUpTable: true, fontSize: width/15.5)
                            .padding(.horizontal, -10)
                    }
                }
            }

            // Unit Circle
            if calculation.queue.items.count == 2, let function = calculation.queue.items[0] as? Function, Function.baseTrig.contains(function.function), let angle = calculation.queue.items[1].simplify() as? Number {

                if buttons {
                    CalculationVisualButton(symbol: "perspective", textColor: color(settings.theme.color2)) {
                        UnitCircleView(function: function, angle: angle, unit: calculation.queue.modes.angleUnit)
                    }
                } else {
                    CalculationVisualSquare(text: "Unit Circle", width: width, height: height) {
                        UnitCircleView(function: function, angle: angle, unit: calculation.queue.modes.angleUnit, gridLines: false, interactive: false, popUpGraph: true)
                    }
                }
            }

            // Derivative
            if calculation.queue.items.count == 5, let function = calculation.queue.items[0] as? Function, function.function == .valDeriv, let power = calculation.queue.items[1].simplify() as? Number, power.value == 1, let variable = calculation.queue.items[2].simplify() as? Letter, let expression = calculation.queue.items[3] as? Expression, let value = calculation.queue.items[4].simplify() as? Number, calculation.result.items.count == 1, let derivative = calculation.result.items[0].simplify() as? Number {

                let equation = Queue(expression.value, modes: calculation.queue.modes).substituted

                let line = Line(equation: equation, color: settings.theme.color1)
                let tangentLine = Line(equation: Queue([derivative, Operation(.mlt), Expression([variable, Operation(.sub), value]), Operation(.add), Expression(equation.items).plugIn(value, to: variable)], modes: calculation.queue.modes), color: settings.theme.color2)

                if buttons {
                    CalculationVisualButton(symbol: "perspective", textColor: color(settings.theme.color2)) {
                        GraphView([line, tangentLine], horizontalAxis: variable, verticalAxis: Letter("f(\(variable.text)"))
                    }
                } else {
                    CalculationVisualSquare(text: "Derivative", width: width, height: height) {
                        GraphView([line, tangentLine], horizontalAxis: variable, verticalAxis: Letter("f(\(variable.text)"), gridLines: false, interactive: false, popUpGraph: true, precision: 100)
                    }
                }
            }

            // Integral
            if calculation.queue.items.count == 5, let function = calculation.queue.items[0] as? Function, function.function == .definteg, let lowerBound = calculation.queue.items[1].simplify() as? Number, let upperBound = calculation.queue.items[2].simplify() as? Number, lowerBound.value < upperBound.value, let expression = calculation.queue.items[3] as? Expression, let variable = calculation.queue.items[4].simplify() as? Letter, calculation.result.items[0].simplify() is Number {

                let equation = Queue(expression.value, modes: calculation.queue.modes).substituted

                let line = Line(equation: equation, color: settings.theme.color1)
                let area = LineShape(equation: equation, location: .center, domain: lowerBound.value...upperBound.value, color: settings.theme.color2, opacity: 0.5)

                if buttons {
                    CalculationVisualButton(symbol: "perspective", textColor: color(settings.theme.color2)) {
                        GraphView([line, area], horizontalAxis: variable, verticalAxis: Letter("f(\(variable.text)"))
                    }
                } else {
                    CalculationVisualSquare(text: "Integral", width: width, height: height) {
                        GraphView([line, area], horizontalAxis: variable, verticalAxis: Letter("f(\(variable.text)"), gridLines: false, interactive: false, popUpGraph: true, precision: 100)
                    }
                }
            }
        }
        .animation(nil)
        .id(Calculation.current.update)
    }
}

struct CalculationVisualSquare<Content: View>: View {
    
    var text: String
    var width: CGFloat
    var height: CGFloat
    
    var content: () -> Content
    
    var body: some View {
        
        ZStack {
            content()
                .background(Color.init(white: 0.2))
                .cornerRadius(20)
                .padding(1)
                .background(Color.init(white: 0.25))
                .cornerRadius(20)
                .padding(width*0.05)
        }
        .frame(width: width, height: height)
        .background(Color.init(white: 0.2))
        .cornerRadius(20)
        .proLock()
    }
}

struct CalculationVisualButton<Content: View>: View {
    
    var symbol: String
    var textColor: Color
    
    var content: () -> Content
    
    @State private var showView: Bool = false
    
    var body: some View {
        
        SmallIconButton(symbol: symbol, textColor: textColor, action: {
            self.showView.toggle()
        })
        .fullScreenCover(isPresented: self.$showView) {
            ZStack {
                content()
                MenuXOverlay(presentBool: $showView)
            }
        }
        .proLock()
    }
}

