//
//  ProFeatureDisplay.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/15/23.
//  Copyright © 2023 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

enum ProFeatureDisplay: String, Identifiable, CaseIterable {
    
    case themes
    case functions
    case variables
    case calculus
    case save
    case misc
    
    var id: String {
        return self.rawValue
    }
    
    static func random() -> ProFeatureDisplay {
        if Double.random(in: 0..<1) > 0.5 {
            return .themes
        } else if Double.random(in: 0..<1) > 0.5 {
            return .functions
        } else if Double.random(in: 0..<1) > 0.5 {
            return .variables
        } else if Double.random(in: 0..<1) > 0.5 {
            return .misc
        } else if Double.random(in: 0..<1) > 0.5 {
            return .save
        } else {
            return .calculus
        }
    }
    
    static func randomArray(startingWith: ProFeatureDisplay? = nil) -> [ProFeatureDisplay] {
        let start = startingWith ?? random()
        var array: [ProFeatureDisplay] = [start]
        while array.count < allCases.count {
            if let element = allCases.filter({ !array.contains($0) && $0.previewAmount != (array.last?.previewAmount ?? 0) }).randomElement() {
                array.append(element)
            }
        }
        return array
    }
    
    var text: String? {
        switch self {
        case .themes:
            return "Customize your calculator."
        case .functions:
            return "A whole new world of capabilities."
        case .variables:
            return "Variables: store or plug in."
        case .calculus:
            return "Advanced operations made simple."
        case .save:
            return "Save and export calculations."
        case .misc:
            return "Convenient tools and features."
        }
    }
    
    var description: String {
        switch self {
        case .themes:
            return "Access to over 30 themes. With so many colorful options, there's a look for everyone."
        case .functions:
            return "Functions. Graphs. Tables. Take your calculator to the next level for the ultimate experience."
        case .variables:
            return "Store values as variables and recall them later. Or directly plug in values for quick results."
        case .calculus:
            return "Summation & Products. Derivatives & Integrals. More power to meet your needs."
        case .save:
            return "Save your calculations. Organize them into folders. Export them into spreadsheets."
        case .misc:
            return "Edit the input line with an interactive pointer. Get equivalent forms & visuals of results."
        }
    }
    
    var summary: [String] {
        switch self {
        case .themes:
            return ["Themes"]
        case .functions:
            return ["Functions","Graphs","Tables"]
        case .variables:
            return ["Variables"]
        case .calculus:
            return ["Summation","Calculus"]
        case .save:
            return ["Saving","Exporting"]
        case .misc:
            return ["Pointer"]
        }
    }
    
    func previews(theme1: Theme, theme2: Theme, theme3: Theme) -> some View {
        return ProFeatureDisplay.previews(type: self, theme1: theme1, theme2: theme2, theme3: theme3)
    }
    
    static func summaryDisplay(theme: Theme) -> some View {
        tripleCalculatorDisplay(
            left: .variableButtonsText(text: Queue()),
            center: .shapes,
            right: .graph(elements: [Line(equation: expression5, modes: .init(angleUnit: .rad), color: theme.primaryTextColor)]),
            theme: theme
        )
    }
    
    @ViewBuilder
    static func previews(type: ProFeatureDisplay, theme1: Theme, theme2: Theme, theme3: Theme) -> some View {
        switch type {
        case .themes:
            tripleCalculatorDisplay(
                left: .theme(theme2),
                center: .theme(theme1),
                right: .theme(theme3),
                theme: theme1
            )
        case .functions:
            tripleCalculatorDisplay(
                left: .table(function: expression1),
                center: .buttonsText(text: expression1),
                right: .graph(elements: [Line(equation: expression1, color: theme1.primaryTextColor)]),
                theme: theme1
            )
        case .variables:
            doubleCalculatorDisplay(
                left: .variableButtonsText(text: expression2),
                right: .variablePlug(expression: plugInExp, variables: plugInVars, values: plugInVals, result: plugInResult),
                theme: theme1
            )
        case .calculus:
            tripleCalculatorDisplay(
                left: .buttonsText(text: expression4),
                center: .graph(elements: [Line(equation: function3, modes: .init(angleUnit: .rad), color: theme1.primaryTextColor), LineShape(equation: function3, location: .center, domain: 0...3*Double.pi, color: theme1.primaryTextColor, opacity: 0.5)]),
                right: .buttonsText(text: expression3),
                theme: theme1,
                modes: .init(angleUnit: .rad)
            )
        case .save:
            doubleCalculatorDisplay(
                left: .pastCalculations(inputs: inputList, outputs: expressionList),
                right: .popUp(text: "Export"),
                theme: theme1
            )
        case .misc:
            doubleCalculatorDisplay(
                left: .buttonsAnimatedText(textSequence: animatedExpressions, delay: 0.2),
                right: .extraResults(result: result2, function: function2, angle: angle2, extraResults: extraResult2),
                theme: theme1,
                modes: .init(angleUnit: .deg)
            )
        }
    }
    
    var previewAmount: Int {
        switch self {
        case .themes, .functions, .calculus:
            return 3
        case .variables, .misc, .save:
            return 2
        }
    }
    
    
    private static let expression1 = Queue([Number(1),Operation(.fra),Number(2),Operation(.con),Letter("x"),Operation(.pow),Number(4),Operation(.sub),Number(2),Operation(.con),Letter("x"),Operation(.pow),Number(3)])
    private static let expression2 = Queue([Letter("a"),Operation(.add),Letter("b"),Operation(.add),Letter("c"),Operation(.add),Pointer()])
    private static let expression3 = Queue([Function(.definteg),Number(0),Number("π"),Expression([Function(.sin),Letter("x")], grouping: .hidden),Letter("x")])
    private static let function3 = Queue([Expression([Number(7),Operation(.con),Function(.sin),Expression([Number(1),Operation(.fra),Number(3),Operation(.con),Letter("x")])])], modes: .init(angleUnit: .rad))
    private static let expression4 = Queue([Function(.valDeriv),Number("#1"),Letter("z"),Expression([Number(4),Operation(.fra),Number(3),Operation(.con),Letter("z"),Operation(.pow),Number(3),Operation(.add),Letter("z")]),Number("e")])
    private static let expression5 = Queue([Function(.sinh),Letter("x")])
    
    private static let animatedExpressions = [Queue([Pointer()]),Queue([Number(2),Pointer()]),Queue([Number(2),Operation(.add),Pointer()]),Queue([Number(2),Operation(.add),Number("3", format: false),Pointer()]),Queue([Number(2),Operation(.add),Number("3.", format: false),Pointer()]),Queue([Number(2),Operation(.add),Number("3.0", format: false),Pointer()]),Queue([Number(2),Operation(.add),Number(3.01),Pointer()]),Queue([Number(2),Operation(.add),Number("3.0", format: false),Pointer(),Number("1", format: false)]),Queue([Number(2),Operation(.add),Number("3.", format: false),Pointer(),Number("01", format: false)]),Queue([Number(2),Operation(.add),Number("3", format: false),Pointer(),Number(".01", format: false)]),Queue([Number(2),Operation(.add),Pointer(),Number(3.01)]),Queue([Number(2),Pointer(),Operation(.add),Number(3.01)]),Queue([Number(2),Operation(.mlt),Pointer(),Operation(.add),Number(3.01)]),Queue([Number(2),Operation(.mlt),Number(6),Pointer(),Operation(.add),Number(3.01)])
    ]
    
    private static let inputList = [Queue([Number(253.1),Operation(.mlt),Number(87)]), Queue([Number(35),Operation(.pow),Number(2)])]
    private static let expressionList = [Queue([Number(22019.7)]), Queue([Number(1225)]), Queue([Number(2),Operation(.con),Letter("x"),Operation(.add),Number(1)])]
    
    private static let result2 = Queue([Number(0.86602540)])
    private static let function2 = Function(.cos); private static let angle2 = Number(30)
    private static let extraResult2 = [Queue([Expression([Number("#2"),Operation(.rad),Number(3)], grouping: .hidden),Operation(.fra),Number(2)])]
    private static let input3 = Queue([Number(30),Operation(.mlt),Number("π"),Operation(.fra),Number(180)])
    private static let result3 = Queue([Number("π"),Operation(.fra),Number(6)])
    
    private static let plugInExp = Queue([Expression([Letter("G"),Operation(.con),Letter("M"),Operation(.con),Letter("m")], grouping: .hidden),Operation(.fra),Expression([Letter("r"),Operation(.pow),Number(2)], grouping: .hidden)])
    private static let plugInVars = [Letter("G"),Letter("M"),Letter("m"),Letter("r")]
    private static let plugInVals = [Queue([Number(6.67),Operation(.exp),Number(-11)]), Queue([Number(2),Operation(.exp),Number(30)]), Queue([Number(5.97),Operation(.exp),Number(24)]), Queue([Number(1.5),Operation(.exp),Number(11)])]
    private static let plugInResult = Queue([Number(3.53955),Operation(.exp),Number(22)])
    
    
    static func doubleCalculatorDisplay(left: ModelDisplayType, right: ModelDisplayType, theme: Theme, modes: ModeSettings? = nil) -> some View {
        GeometryReader { geometry in
            HStack(spacing: 20) {
                CalculatorModel(left, orientation: .portrait, maxWidth: geometry.size.width*0.36, maxHeight: geometry.size.height*0.8, theme: theme, modes: modes)
                CalculatorModel(right, orientation: .portrait, maxWidth: geometry.size.width*0.36, maxHeight: geometry.size.height*0.8, theme: theme, modes: modes)
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
        }
        .transition(.opacity)
        .disabled(true)
    }
    
    static func tripleCalculatorDisplay(left: ModelDisplayType, center: ModelDisplayType, right: ModelDisplayType, theme: Theme, modes: ModeSettings? = nil) -> some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0) {
                    CalculatorModel(left, orientation: .portrait, maxWidth: geometry.size.width*0.36, maxHeight: geometry.size.height*0.8, theme: theme, modes: modes)
                        .scaleEffect(0.9)
                    CalculatorModel(center, orientation: .portrait, maxWidth: geometry.size.width*0.36, maxHeight: geometry.size.height*0.8, sideInsets: -0.15, theme: theme, modes: modes)
                        .zIndex(1)
                    CalculatorModel(right, orientation: .portrait, maxWidth: geometry.size.width*0.36, maxHeight: geometry.size.height*0.8, theme: theme, modes: modes)
                        .scaleEffect(0.9)
                }
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
        }
        .transition(.opacity)
        .disabled(true)
    }
    
    static func quintupleCalculatorDisplay(one: ModelDisplayType, two: ModelDisplayType, three: ModelDisplayType, four: ModelDisplayType, five: ModelDisplayType, theme: Theme, modes: ModeSettings? = nil) -> some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0) {
                    CalculatorModel(one, orientation: .portrait, maxWidth: geometry.size.width*0.22, maxHeight: geometry.size.height*0.8, sideInsets: -0.15, theme: theme, modes: modes)
                        .scaleEffect(0.8)
                    CalculatorModel(two, orientation: .portrait, maxWidth: geometry.size.width*0.22, maxHeight: geometry.size.height*0.8, theme: theme, modes: modes)
                        .scaleEffect(0.9)
                        .zIndex(1)
                    CalculatorModel(three, orientation: .portrait, maxWidth: geometry.size.width*0.22, maxHeight: geometry.size.height*0.8, sideInsets: -0.15, theme: theme, modes: modes)
                        .zIndex(2)
                    CalculatorModel(four, orientation: .portrait, maxWidth: geometry.size.width*0.22, maxHeight: geometry.size.height*0.8, theme: theme, modes: modes)
                        .scaleEffect(0.9)
                        .zIndex(1)
                    CalculatorModel(five, orientation: .portrait, maxWidth: geometry.size.width*0.22, maxHeight: geometry.size.height*0.8, sideInsets: -0.15, theme: theme, modes: modes)
                        .scaleEffect(0.8)
                }
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
        }
        .transition(.opacity)
        .disabled(true)
    }
}
