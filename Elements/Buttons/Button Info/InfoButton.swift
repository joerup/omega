//
//  InfoButton.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 9/30/20.
//  Copyright © 2020 Rupertus. All rights reserved.
//

import Foundation

class InfoButtonCategory: Identifiable {
    
    var id: Int
    var name: String
    var desc: String
    
    var buttons: [InfoButton]
    
    init(id: Int, name: String, desc: String, buttons: [InfoButton]) {
        self.id = id
        self.name = name
        self.desc = desc
        self.buttons = buttons
    }
}

class InfoButton: Identifiable {
    
    var id: Int
    
    var button: InputButton
    
    var name: String
    var fullName: String
    
    var category: String
    var cluster: Bool
    
    var description: String?
    var sample: [String]
    var formula: [String]
    var formulaDesc: [String]
    var domain: [String]
    var range: [String]
    var constValue: String?
    
    var syntax: [[String]]
    var example: [String]
    var exampleQuestions: [[String]]
    var exampleAnswers: [[String]]
    
    init(id: Int,
         name: String,
         fullName: String,
         category: String,
         description: String? = nil,
         sample: [String]? = nil,
         formula: [String] = [],
         formulaDesc: [String] = [],
         domain: [String] = [],
         range: [String] = [],
         constValue: String? = nil,
         syntax: [[String]],
         example: [String],
         exampleQuestions: [[String]],
         exampleAnswers: [[String]]) {
        self.id = id
        self.button = InputButton(name)
        self.name = name
        self.fullName = fullName
        self.category = category
        self.cluster = false
        self.description = description
        self.sample = sample ?? example
        self.formula = formula
        self.formulaDesc = formulaDesc
        self.domain = domain
        self.range = range
        self.constValue = constValue
        self.syntax = syntax
        self.example = example
        self.exampleQuestions = exampleQuestions
        self.exampleAnswers = exampleAnswers
    }
    
    func insert() {
        Calculation.current.setUpInput()
        Calculation.current.queue.button(button, pressType: .tap)
    }
}

class InfoButtonCluster: InfoButton {
    
    var buttons: [InfoButton]
    var clusterName: String
    
    init(name: String, buttons: [InfoButton]) {
        
        self.clusterName = name
        self.buttons = buttons
        
        super.init(id: buttons[0].id, name: buttons[0].name, fullName: buttons[0].fullName, category: buttons[0].category, description: buttons[0].description, formula: buttons[0].formula, syntax: buttons[0].syntax, example: buttons[0].example, exampleQuestions: buttons[0].exampleQuestions, exampleAnswers: buttons[0].exampleAnswers)
        
        self.cluster = true
    }
}
