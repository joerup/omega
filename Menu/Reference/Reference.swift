//
//  Reference.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 9/30/20.
//  Copyright © 2020 Rupertus. All rights reserved.
//

import Foundation
import Combine
import UIKit

class Reference {
    
    // MARK: Buttons
    
    static var buttons = [
        
        InfoButtonCategory(
            id: 0,
            name: "Operations",
            desc: "These basic operations are the essential parts of a calculator.",
            buttons: [
                
                InfoButton(
                    id: 0,
                    name: "+",
                    fullName: "Addition",
                    category: "Operations",
                    syntax: [
                        ["a","+","b"]
                    ],
                    example: ["a","+","b"],
                    exampleQuestions: [
                        ["2","+","3"],
                        ["13.1","+","6.12","+","3.2"]
                    ],
                    exampleAnswers: [
                        ["5"],
                        ["22.42"]
                    ]
                ),
                
                InfoButton(
                    id: 1,
                    name: "-",
                    fullName: "Subtraction",
                    category: "Operations",
                    syntax: [
                        ["a","-","b"]
                    ],
                    example: ["a","-","b"],
                    exampleQuestions: [
                        ["14","-","3"],
                        ["6.23","-","26.95","-","3.1"]
                    ],
                    exampleAnswers: [
                        ["11"],
                        ["-23.82"]
                    ]
                ),
                
                InfoButton(
                    id: 2,
                    name: "×",
                    fullName: "Multiplication",
                    category: "Operations",
                    syntax: [
                        ["a","×","b"]
                    ],
                    example: ["a","×","b"],
                    exampleQuestions: [
                        ["4","×","-12"],
                        ["9.1","×","7.23","×","-4"]
                    ],
                    exampleAnswers: [
                        ["-48"],
                        ["-263.172"]
                    ]
                ),
                
                InfoButton(
                    id: 3,
                    name: "÷",
                    fullName: "Division",
                    category: "Operations",
                    syntax: [
                        ["a","÷","b"]
                    ],
                    example: ["a","÷","b"],
                    exampleQuestions: [
                        ["364","÷","14"],
                        ["618.075","÷","-67","÷","7.5"]
                    ],
                    exampleAnswers: [
                        ["26"],
                        ["-1.23"]
                    ]
                ),
                
                InfoButton(
                    id: 4,
                    name: "%",
                    fullName: "Percent",
                    category: "Operations",
                    syntax: [
                        ["a","%"]
                    ],
                    example: ["a","%"],
                    exampleQuestions: [
                        ["37","%","×","364"],
                        ["10","+","25","%"]
                    ],
                    exampleAnswers: [
                        ["133.2"],
                        ["12.5"]
                    ]
                ),
                
                InfoButton(
                    id: 5,
                    name: "/",
                    fullName: "Fraction",
                    category: "Operations",
                    syntax: [
                        ["a","/","b"]
                    ],
                    example: ["a","/","b"],
                    exampleQuestions: [
                        ["4","/","7"],
                        ["1","/","2","+","3","/","4"]
                    ],
                    exampleAnswers: [
                        ["0.57142857"],
                        ["1.25"]
                    ]
                ),
                
                InfoButton(
                    id: 6,
                    name: "| |",
                    fullName: "Absolute Value",
                    category: "Operations",
                    description: "The distance a number is from zero",
                    syntax: [
                        ["| |","a"],
                        ["a","| |"]
                    ],
                    example: ["| |","a"],
                    exampleQuestions: [
                        ["| |","-4"],
                        ["| |","3","×","6","-","26"]
                    ],
                    exampleAnswers: [
                        ["4"],
                        ["8"]
                    ]
                ),
                
                InfoButton(
                    id: 7,
                    name: "mod",
                    fullName: "Modulo",
                    category: "Operations",
                    description: "The remainder of the division of two numbers",
                    syntax: [
                        ["a","mod","b"]
                    ],
                    example: ["a","mod","b"],
                    exampleQuestions: [
                        ["8","mod","3"],
                        ["634","mod","41"]
                    ],
                    exampleAnswers: [
                        ["2"],
                        ["19"]
                    ]
                ),
                
            ]
        ),
        
        InfoButtonCategory(
            id: 1,
            name: "Exponents & Roots",
            desc: "Exponents and roots are quintessential parts of math, giving you much more power.",
            buttons: [
                
                InfoButton(
                    id: 0,
                    name: "^2",
                    fullName: "Square",
                    category: "Exponents & Roots",
                    syntax: [
                        ["a","^2"]
                    ],
                    example: ["a","^","2"],
                    exampleQuestions: [
                        ["17","^","2"],
                        ["(","-4.78",")","^","2"]
                    ],
                    exampleAnswers: [
                        ["289"],
                        ["22.8484"]
                    ]
                ),
                
                InfoButton(
                    id: 1,
                    name: "^3",
                    fullName: "Cube",
                    category: "Exponents & Roots",
                    syntax: [
                        ["a","^3"]
                    ],
                    example: ["a","^","3"],
                    exampleQuestions: [
                        ["6","^","3"],
                        ["(","-1.54","-","2.1",")","^","3"]
                    ],
                    exampleAnswers: [
                        ["216"],
                        ["-48.228544"]
                    ]
                ),
                
                InfoButton(
                    id: 2,
                    name: "^",
                    fullName: "Exponent",
                    category: "Exponents & Roots",
                    syntax: [
                        ["a","^","b"]
                    ],
                    example: ["a","^","b"],
                    exampleQuestions: [
                        ["4","^","10"],
                        ["(","2","+","3",")","^","2","+","3"]
                    ],
                    exampleAnswers: [
                        ["1048576"],
                        ["3125"]
                    ]
                ),
                
                InfoButton(
                    id: 3,
                    name: "EXP",
                    fullName: "Exponential Notation",
                    category: "Exponents & Roots",
                    syntax: [
                        ["a","EXP","b"]
                    ],
                    example: ["a","E","b"],
                    exampleQuestions: [
                        ["2.4","E","3"],
                        ["6.45×10","^","-4"]
                    ],
                    exampleAnswers: [
                        ["2400"],
                        ["0.000645"]
                    ]
                ),
                
                InfoButton(
                    id: 4,
                    name: "^-1",
                    fullName: "Inverse",
                    category: "Exponents & Roots",
                    sample: ["x","^","-1"],
                    formula: ["1","/","x"],
                    syntax: [
                        ["a","^-1"]
                    ],
                    example: ["a","^","-1"],
                    exampleQuestions: [
                        ["4","^","-1"],
                        ["0.001","^","-1"]
                    ],
                    exampleAnswers: [
                        ["0.25"],
                        ["1000"]
                    ]
                ),
                
                InfoButton(
                    id: 5,
                    name: "√",
                    fullName: "Square Root",
                    category: "Exponents & Roots",
                    syntax: [
                        ["√","a"],
                        ["a","√"]
                    ],
                    example: ["#2","√","a"],
                    exampleQuestions: [
                        ["#2","√","1156"],
                        ["#2","√","#(","3.2","×","20","#)"]
                    ],
                    exampleAnswers: [
                        ["34"],
                        ["8"]
                    ]
                ),
                
                InfoButton(
                    id: 6,
                    name: "3√",
                    fullName: "Cube Root",
                    category: "Exponents & Roots",
                    syntax: [
                        ["³√","a"],
                        ["a","³√"]
                    ],
                    example: ["3","√","a"],
                    exampleQuestions: [
                        ["3","√","343"],
                        ["3","√","#(","-2120","-","624","#)"]
                    ],
                    exampleAnswers: [
                        ["7"],
                        ["-14"]
                    ]
                ),
                
                InfoButton(
                    id: 7,
                    name: "n√",
                    fullName: "n Root",
                    category: "Exponents & Roots",
                    syntax: [
                        ["ⁿ√","b","a"],
                        ["a","ⁿ√","b"]
                    ],
                    example: ["b","√","a"],
                    exampleQuestions: [
                        ["10","√","1024"],
                        ["4","√","#(","3.40","-","8.2","#)"]
                    ],
                    exampleAnswers: [
                        ["2"],
                        ["Error"]
                    ]
                ),
                
            ]
        ),
        
        InfoButtonCategory(
            id: 2,
            name: "Logarithms",
            desc: "Logarithms are used to calculate what power of a base a certain number is equal to. This section also includes exponent bases.",
            buttons: [
                
                InfoButton(
                    id: 0,
                    name: "log",
                    fullName: "Base 10 Logarithm",
                    category: "Logarithms",
                    description: "The power of 10 equal to the given number",
                    formula: ["x","⇔","10","^","x","=","a"],
                    syntax: [
                        ["log","a"],
                        ["a","log"]
                    ],
                    example: ["log","#10","a"],
                    exampleQuestions: [
                        ["log","#10","10000"],
                        ["log","#10","31.622777"]
                    ],
                    exampleAnswers: [
                        ["4"],
                        ["1.5"]
                    ]
                ),
                
                InfoButton(
                    id: 1,
                    name: "ln",
                    fullName: "Natural Logarithm",
                    category: "Logarithms",
                    description: "The power of e equal to the given number",
                    formula: ["x","⇔","e","^","x","=","a"],
                    syntax: [
                        ["ln","a"],
                        ["a","ln"]
                    ],
                    example: ["ln","a"],
                    exampleQuestions: [
                        ["ln","162754.79"],
                        ["ln","100"]
                    ],
                    exampleAnswers: [
                        ["12"],
                        ["4.6051702"]
                    ]
                ),
                
                InfoButton(
                    id: 2,
                    name: "log2",
                    fullName: "Base 2 Logarithm",
                    category: "Logarithms",
                    description: "The power of 2 equal to the given number",
                    formula: ["x","⇔","2","^","x","=","a"],
                    syntax: [
                        ["log₂","a"],
                        ["a","log₂"]
                    ],
                    example: ["log","2","a"],
                    exampleQuestions: [
                        ["log","2","65536"],
                        ["log","2","34"]
                    ],
                    exampleAnswers: [
                        ["16"],
                        ["5.0874628"]
                    ]
                ),
                
                InfoButton(
                    id: 3,
                    name: "logn",
                    fullName: "Base n Logarithm",
                    category: "Logarithms",
                    description: "The power of any base equal to the given number",
                    formula: ["x","⇔","b","^","x","=","a"],
                    syntax: [
                        ["logₙ","b","a"],
                        ["a","logₙ","b"]
                    ],
                    example: ["log","b","a"],
                    exampleQuestions: [
                        ["log","4","16777216"],
                        ["log","13","169"]
                    ],
                    exampleAnswers: [
                        ["12"],
                        ["2"]
                    ]
                ),
                
                InfoButton(
                    id: 4,
                    name: "10^",
                    fullName: "Base 10 Power",
                    category: "Logarithms",
                    syntax: [
                        ["10^","a"],
                        ["a","10^"]
                    ],
                    example: ["10","^","a"],
                    exampleQuestions: [
                        ["10","^","9"],
                        ["10","^","-2"],
                    ],
                    exampleAnswers: [
                        ["1000000000"],
                        ["0.01"]
                    ]
                ),
                
                InfoButton(
                    id: 5,
                    name: "e^",
                    fullName: "Base e Power",
                    category: "Logarithms",
                    syntax: [
                        ["e^","a"],
                        ["a","e^"]
                    ],
                    example: ["e","^","a"],
                    exampleQuestions: [
                        ["e","^","2.54"],
                        ["e","^","-6.4"],
                    ],
                    exampleAnswers: [
                        ["12.679671"],
                        ["0.00166156"]
                    ]
                ),
                
                InfoButton(
                    id: 6,
                    name: "2^",
                    fullName: "Base 2 Power",
                    category: "Logarithms",
                    syntax: [
                        ["2^","a"],
                        ["a","2^"]
                    ],
                    example: ["2","^","a"],
                    exampleQuestions: [
                        ["2","^","13"],
                        ["2","^","#2","√","2"],
                    ],
                    exampleAnswers: [
                        ["8192"],
                        ["2.6651441"]
                    ]
                ),
                
                InfoButton(
                    id: 7,
                    name: "n^",
                    fullName: "Base n Power",
                    category: "Logarithms",
                    syntax: [
                        ["n^","b","a"],
                        ["a","n^","b"]
                    ],
                    example: ["b","^","a"],
                    exampleQuestions: [
                        ["4","^","19"],
                        ["(","8","-","2",")","^","#(","4","^","2","#)"],
                    ],
                    exampleAnswers: [
                        ["2.7487791×10","^","11"],
                        ["2.8211099","E","12"]
                    ]
                ),
                
            ]
        ),
        
        InfoButtonCategory(
            id: 3,
            name: "Trigonometry",
            desc: "Trigonometry deals with the relationships between angles in a triangle. There are many variations of trig functions listed.",
            buttons: [
                
                InfoButton(
                    id: 0,
                    name: "sin",
                    fullName: "Sine",
                    category: "Trigonometry",
                    sample: ["sin","θ"],
                    formula: ["y","/","r"],
                    formulaDesc: ["y = opposite","r = hypotenuse"],
                    domain: ["(","-∞",",","∞",")"],
                    range: ["[","-1",",","1","]"],
                    syntax: [
                        ["sin","a"],
                        ["a","sin"]
                    ],
                    example: ["sin","a"],
                    exampleQuestions: [
                        ["sin","90"],
                        ["sin","(","2π","/","3",")"]
                    ],
                    exampleAnswers: [
                        ["1"],
                        ["0.8660254"]
                    ]
                ),
                
                InfoButton(
                    id: 1,
                    name: "cos",
                    fullName: "Cosine",
                    category: "Trigonometry",
                    sample: ["cos","θ"],
                    formula: ["x","/","r"],
                    formulaDesc: ["x = adjacent","r = hypotenuse"],
                    domain: ["(","-∞",",","∞",")"],
                    range: ["[","-1",",","1","]"],
                    syntax: [
                        ["cos","a"],
                        ["a","cos"]
                    ],
                    example: ["cos","a"],
                    exampleQuestions: [
                        ["cos","90"],
                        ["cos","(","2π","/","3",")"]
                    ],
                    exampleAnswers: [
                        ["0"],
                        ["-0.5"]
                    ]
                ),
                
                InfoButton(
                    id: 2,
                    name: "tan",
                    fullName: "Tangent",
                    category: "Trigonometry",
                    sample: ["tan","θ"],
                    formula: ["y","/","x"],
                    formulaDesc: ["y = opposite","x = adjacent"],
                    domain: ["(","-∞",",","∞",")"],
                    range: ["(","-∞",",","∞",")"],
                    syntax: [
                        ["tan","a"],
                        ["a","tan"]
                    ],
                    example: ["tan","a"],
                    exampleQuestions: [
                        ["tan","90"],
                        ["tan","(","2π","/","3",")"]
                    ],
                    exampleAnswers: [
                        ["∞"],
                        ["-1.7320508"]
                    ]
                ),
                
                InfoButton(
                    id: 3,
                    name: "sin⁻¹",
                    fullName: "Inverse Sine",
                    category: "Trigonometry",
                    description: "The angle whose sin is the given value",
                    domain: ["[","-1",",","1","]"],
                    range: ["[","#(","#-1","*","π","#)","/","2",",","π","/","2","]"],
                    syntax: [
                        ["sin⁻¹","a"],
                        ["a","sin⁻¹"]
                    ],
                    example: ["sin⁻¹","(","a",")"],
                    exampleQuestions: [
                        ["sin⁻¹","(","0",")"],
                        ["sin⁻¹","(","#(","#2","√","3","#)","/","2",")"]
                    ],
                    exampleAnswers: [
                        ["0"],
                        ["60"]
                    ]
                ),
                
                InfoButton(
                    id: 4,
                    name: "cos⁻¹",
                    fullName: "Inverse Cosine",
                    category: "Trigonometry",
                    description: "The angle whose cos is the given value",
                    domain: ["[","-1",",","1","]"],
                    range: ["[","0",",","π","]"],
                    syntax: [
                        ["cos⁻¹","a"],
                        ["a","cos⁻¹"]
                    ],
                    example: ["cos⁻¹","(","a",")"],
                    exampleQuestions: [
                        ["cos⁻¹","(","0",")"],
                        ["cos⁻¹","(","#(","#2","√","3","#)","/","2",")"]
                    ],
                    exampleAnswers: [
                        ["90"],
                        ["30"]
                    ]
                ),
                
                InfoButton(
                    id: 5,
                    name: "tan⁻¹",
                    fullName: "Inverse Tangent",
                    category: "Trigonometry",
                    description: "The angle whose tan is the given value",
                    domain: ["(","-∞",",","∞",")"],
                    range: ["(","#(","#-1","*","π","#)","/","2",",","π","/","2",")"],
                    syntax: [
                        ["tan⁻¹","a"],
                        ["a","tan⁻¹"]
                    ],
                    example: ["tan⁻¹","(","a",")"],
                    exampleQuestions: [
                        ["tan⁻¹","(","0",")"],
                        ["tan⁻¹","(","#(","#2","√","3","#)","/","2",")"]
                    ],
                    exampleAnswers: [
                        ["0"],
                        ["40.893395"]
                    ]
                ),
                
                InfoButtonCluster(
                    name: "Reciprocal Functions",
                    buttons: [
                        InfoButton(
                            id: 6,
                            name: "cot",
                            fullName: "Cotangent",
                            category: "Trigonometry",
                            sample: ["cot","θ"],
                            formula: ["x","/","y"],
                            formulaDesc: ["x = adjacent","y = opposite"],
                            domain: ["(","-∞",",","∞",")"],
                            range: ["(","-∞",",","∞",")"],
                            syntax: [
                                ["cot","a"],
                                ["a","cot"]
                            ],
                            example: ["cot","a"],
                            exampleQuestions: [
                                ["cot","90"],
                                ["cot","(","2π","/","3",")"]
                            ],
                            exampleAnswers: [
                                ["0"],
                                ["-0.57735027"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 7,
                            name: "sec",
                            fullName: "Secant",
                            category: "Trigonometry",
                            sample: ["sec","θ"],
                            formula: ["r","/","x"],
                            formulaDesc: ["r = hypotenuse","x = adjacent"],
                            domain: ["(","-∞",",","∞",")"],
                            range: ["(","-∞",",","-1","]","∪","[","1",",","∞",")"],
                            syntax: [
                                ["sec","a"],
                                ["a","sec"]
                            ],
                            example: ["sec","a"],
                            exampleQuestions: [
                                ["sec","90"],
                                ["sec","(","2π","/","3",")"]
                            ],
                            exampleAnswers: [
                                ["∞"],
                                ["-2"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 8,
                            name: "csc",
                            fullName: "Cosecant",
                            category: "Trigonometry",
                            sample: ["csc","θ"],
                            formula: ["r","/","y"],
                            formulaDesc: ["r = hypotenuse","y = opposite"],
                            domain: ["(","-∞",",","∞",")"],
                            range: ["(","-∞",",","-1","]","∪","[","1",",","∞",")"],
                            syntax: [
                                ["csc","a"],
                                ["a","csc"]
                            ],
                            example: ["csc","a"],
                            exampleQuestions: [
                                ["csc","90"],
                                ["csc","(","2π","/","3",")"]
                            ],
                            exampleAnswers: [
                                ["1"],
                                ["1.1547005"]
                            ]
                        ),
                        InfoButton(
                            id: 9,
                            name: "cot⁻¹",
                            fullName: "Inverse Cotangent",
                            category: "Trigonometry",
                            description: "The angle whose cot is the given value",
                            domain: ["(","-∞",",","∞",")"],
                            range: ["(","0",",","π",")"],
                            syntax: [
                                ["cot⁻¹","a"],
                                ["a","cot⁻¹"]
                            ],
                            example: ["cot⁻¹","(","a",")"],
                            exampleQuestions: [
                                ["cot⁻¹","(","0",")"],
                                ["cot⁻¹","(","(","2","*","#2","√","3",")","/","3",")"]
                            ],
                            exampleAnswers: [
                                ["90"],
                                ["40.893395"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 10,
                            name: "sec⁻¹",
                            fullName: "Inverse Secant",
                            category: "Trigonometry",
                            description: "The angle whose sec is the given value",
                            domain: ["(","-∞",",","-1","]","∪","[","1",",","∞",")"],
                            range: ["[","0",",","π","/","2",")","∪","(","π","/","2",",","π","]"],
                            syntax: [
                                ["sec⁻¹","a"],
                                ["a","sec⁻¹"]
                            ],
                            example: ["sec⁻¹","(","a",")"],
                            exampleQuestions: [
                                ["sec⁻¹","(","0",")"],
                                ["cot⁻¹","(","(","2","*","#2","√","3",")","/","3",")"]
                            ],
                            exampleAnswers: [
                                ["Error"],
                                ["30"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 11,
                            name: "csc⁻¹",
                            fullName: "Inverse Cosecant",
                            category: "Trigonometry",
                            description: "The angle whose csc is the given value",
                            domain: ["(","-∞",",","-1","]","∪","[","1",",","∞",")"],
                            range: ["[","#(","#-1","*","-π","/","2","#)",",","0",")","∪","(","0",",","π","/","2","]"],
                            syntax: [
                                ["csc⁻¹","a"],
                                ["a","csc⁻¹"]
                            ],
                            example: ["csc⁻¹","(","a",")"],
                            exampleQuestions: [
                                ["csc⁻¹","(","0",")"],
                                ["cot⁻¹","(","(","2","*","#2","√","3",")","/","3",")"]
                            ],
                            exampleAnswers: [
                                ["Error"],
                                ["60"]
                            ]
                        ),
                    ]
                ),
                
                InfoButtonCluster(
                    name: "Hyperbolic Functions",
                    buttons: [
                        InfoButton(
                            id: 12,
                            name: "sinh",
                            fullName: "Hyperbolic Sine",
                            category: "Trigonometry",
                            sample: ["sinh","α"],
                            formula: ["(","e","^","α","-","e","^","-α",")","/","2"],
                            formulaDesc: ["α = 2× the hyperbolic angle"],
                            domain: ["(","-∞",",","∞",")"],
                            range: ["(","-∞",",","∞",")"],
                            syntax: [
                                ["sinh","a"],
                                ["a","sinh"]
                            ],
                            example: ["sinh","a"],
                            exampleQuestions: [
                                ["sinh","90"],
                                ["sinh","(","2π","/","3",")"]
                            ],
                            exampleAnswers: [
                                ["2.3012989"],
                                ["3.9986913"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 13,
                            name: "cosh",
                            fullName: "Hyperbolic Cosine",
                            category: "Trigonometry",
                            sample: ["cosh","α"],
                            formula: ["(","e","^","α","+","e","^","-α",")","/","2"],
                            formulaDesc: ["α = 2× the hyperbolic angle"],
                            domain: ["(","-∞",",","∞",")"],
                            range: ["[","1",",","∞",")"],
                            syntax: [
                                ["cosh","a"],
                                ["a","cosh"]
                            ],
                            example: ["cosh","a"],
                            exampleQuestions: [
                                ["cosh","90"],
                                ["cosh","(","2π","/","3",")"]
                            ],
                            exampleAnswers: [
                                ["2.5091785"],
                                ["4.1218361"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 14,
                            name: "tanh",
                            fullName: "Hyperbolic Tangent",
                            category: "Trigonometry",
                            sample: ["tanh","α"],
                            formula: ["(","e","^","α","-","e","^","-α",")","/","(","e","^","α","+","e","^","-α",")"],
                            formulaDesc: ["α = 2× the hyperbolic angle"],
                            domain: ["(","-∞",",","∞",")"],
                            range: ["(","-1",",","1",")"],
                            syntax: [
                                ["tanh","a"],
                                ["a","tanh"]
                            ],
                            example: ["tanh","a"],
                            exampleQuestions: [
                                ["tanh","90"],
                                ["tanh","(","2π","/","3",")"]
                            ],
                            exampleAnswers: [
                                ["0.91715234"],
                                ["0.97012382"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 15,
                            name: "coth",
                            fullName: "Hyperbolic Cotangent",
                            category: "Trigonometry",
                            sample: ["coth","α"],
                            formula: ["(","e","^","α","+","e","^","-α",")","/","(","e","^","α","-","e","^","-α",")"],
                            formulaDesc: ["α = 2× the hyperbolic angle"],
                            domain: ["(","-∞",",","0",")","∪","(","0",",","∞",")"],
                            range: ["(","-∞",",","-1",")","∪","(","1",",","∞",")"],
                            syntax: [
                                ["coth","a"],
                                ["a","coth"]
                            ],
                            example: ["coth","a"],
                            exampleQuestions: [
                                ["coth","90"],
                                ["coth","(","2π","/","3",")"]
                            ],
                            exampleAnswers: [
                                ["1.0903314"],
                                ["1.0307963"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 16,
                            name: "sech",
                            fullName: "Hyperbolic Secant",
                            category: "Trigonometry",
                            sample: ["sech","α"],
                            formula: ["2","/","(","e","^","α","+","e","^","-α",")"],
                            formulaDesc: ["α = 2× the hyperbolic angle"],
                            domain: ["(","-∞",",","∞",")"],
                            range: ["(","0",",","1","]"],
                            syntax: [
                                ["sech","a"],
                                ["a","sech"]
                            ],
                            example: ["sech","a"],
                            exampleQuestions: [
                                ["sech","90"],
                                ["sech","(","2π","/","3",")"]
                            ],
                            exampleAnswers: [
                                ["0.39853682"],
                                ["0.24261033"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 17,
                            name: "csch",
                            fullName: "Hyperbolic Cosecant",
                            category: "Trigonometry",
                            sample: ["csch","α"],
                            formula: ["2","/","(","e","^","α","-","e","^","-α",")"],
                            formulaDesc: ["α = 2× the hyperbolic angle"],
                            domain: ["(","-∞",",","0",")","∪","(","0",",","∞",")"],
                            range: ["(","-∞",",","0",")","∪","(","0",",","∞",")"],
                            syntax: [
                                ["csch","a"],
                                ["a","csch"]
                            ],
                            example: ["csch","a"],
                            exampleQuestions: [
                                ["csch","90"],
                                ["csch","(","2π","/","3",")"]
                            ],
                            exampleAnswers: [
                                ["0.43453721"],
                                ["0.25008182"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 18,
                            name: "sinh⁻¹",
                            fullName: "Inverse Hyperbolic Sine",
                            category: "Trigonometry",
                            description: "The angle whose sinh is the given value",
                            domain: ["(","-∞",",","∞",")"],
                            range: ["(","-∞",",","∞",")"],
                            syntax: [
                                ["sinh⁻¹","a"],
                                ["a","sinh⁻¹"]
                            ],
                            example: ["sinh⁻¹","(","a",")"],
                            exampleQuestions: [
                                ["sinh⁻¹","(","0",")"],
                                ["sinh⁻¹","(","20",")"]
                            ],
                            exampleAnswers: [
                                ["0"],
                                ["211.393"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 19,
                            name: "cosh⁻¹",
                            fullName: "Inverse Hyperbolic Cosine",
                            category: "Trigonometry",
                            description: "The angle whose cosh is the given value",
                            domain: ["[","1",",","∞",")"],
                            range: ["[","0",",","∞",")"],
                            syntax: [
                                ["cosh⁻¹","a"],
                                ["a","cosh⁻¹"]
                            ],
                            example: ["cosh⁻¹","(","a",")"],
                            exampleQuestions: [
                                ["cosh⁻¹","(","0",")"],
                                ["cosh⁻¹","(","20",")"]
                            ],
                            exampleAnswers: [
                                ["Error"],
                                ["211.32138"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 20,
                            name: "tanh⁻¹",
                            fullName: "Inverse Hyperbolic Tangent",
                            category: "Trigonometry",
                            description: "The angle whose tanh is the given value",
                            domain: ["(","-1",",","1",")"],
                            range: ["(","-∞",",","∞",")"],
                            syntax: [
                                ["tanh⁻¹","a"],
                                ["a","tanh⁻¹"]
                            ],
                            example: ["tanh⁻¹","(","a",")"],
                            exampleQuestions: [
                                ["tanh⁻¹","(","0",")"],
                                ["tanh⁻¹","(","20",")"]
                            ],
                            exampleAnswers: [
                                ["0"],
                                ["Error"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 21,
                            name: "coth⁻¹",
                            fullName: "Inverse Hyperbolic Cotangent",
                            category: "Trigonometry",
                            description: "The angle whose coth is the given value",
                            domain: ["(","-∞",",","-1",")","∪","(","1",",","∞",")"],
                            range: ["(","-∞",",","0",")","∪","(","0",",","∞",")"],
                            syntax: [
                                ["coth⁻¹","a"],
                                ["a","coth⁻¹"]
                            ],
                            example: ["coth⁻¹","(","a",")"],
                            exampleQuestions: [
                                ["coth⁻¹","(","0",")"],
                                ["coth⁻¹","(","20",")"]
                            ],
                            exampleAnswers: [
                                ["Error"],
                                ["2.8671799"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 22,
                            name: "sech⁻¹",
                            fullName: "Inverse Hyperbolic Secant",
                            category: "Trigonometry",
                            description: "The angle whose sech is the given value",
                            domain: ["(","0",",","1","]"],
                            range: ["[","0",",","∞",")"],
                            syntax: [
                                ["sech⁻¹","a"],
                                ["a","sech⁻¹"]
                            ],
                            example: ["sech⁻¹","(","a",")"],
                            exampleQuestions: [
                                ["sech⁻¹","(","0",")"],
                                ["sech⁻¹","(","20",")"]
                            ],
                            exampleAnswers: [
                                ["∞"],
                                ["Error"]
                            ]
                        ),
                        
                        InfoButton(
                            id: 23,
                            name: "csch⁻¹",
                            fullName: "Inverse Hyperbolic Cosecant",
                            category: "Trigonometry",
                            description: "The angle whose csch is the given value",
                            domain: ["(","-∞",",","0",")","∪","(","0",",","∞",")"],
                            range: ["(","-∞",",","0",")","∪","(","0",",","∞",")"],
                            syntax: [
                                ["csch⁻¹","a"],
                                ["a","csch⁻¹"]
                            ],
                            example: ["csch⁻¹","(","a",")"],
                            exampleQuestions: [
                                ["csch⁻¹","(","0",")"],
                                ["csch⁻¹","(","20",")"]
                            ],
                            exampleAnswers: [
                                ["∞"],
                                ["2.8635967"]
                            ]
                        )
                    ]
                )
            ]
        ),
        
        InfoButtonCategory(
            id: 4,
            name: "Calculus",
            desc: "",
            buttons: [
                
                InfoButton(
                    id: 0,
                    name: "∑",
                    fullName: "Summation Notation",
                    category: "Calculus",
                    description: "The sum of all integers between two bounds",
                    sample: ["∑","x","a","b","(","f","(","x",")",")"],
                    formula: ["f","(","a",")","+","f","(","a","+","1",")","+","...","+","f","(","b",")"],
                    formulaDesc: ["a = lower bound","b = upper bound","f(x) = function"],
                    syntax: [
                        ["∑","x","a","b","c"]
                    ],
                    example: ["∑","x","a","b","(","c",")"],
                    exampleQuestions: [
                        [""],
                        [""]
                    ],
                    exampleAnswers: [
                        [""],
                        [""]
                    ]
                ),
                
                InfoButton(
                    id: 1,
                    name: "∏",
                    fullName: "Product Notation",
                    category: "Calculus",
                    description: "The product of all integers between two bounds",
                    sample: ["∏","x","a","b","(","f","(","x",")",")"],
                    formula: ["f","(","a",")","×","f","(","a","+","1",")","×","...","×","f","(","b",")"],
                    formulaDesc: ["a = lower bound","b = upper bound","f(x) = function"],
                    syntax: [
                        ["∏","x","a","b","c"]
                    ],
                    example: ["∏","x","a","b","(","c",")"],
                    exampleQuestions: [
                        [""],
                        [""]
                    ],
                    exampleAnswers: [
                        [""],
                        [""]
                    ]
                ),
                
                InfoButton(
                    id: 2,
                    name: "dx",
                    fullName: "Derivative",
                    category: "Calculus",
                    description: "The instantaneous rate of change of a function at a point; slope of the tangent line",
                    sample: ["d/d|","#1","x","n","(","f","(","x",")",")"],
                    syntax: [
                        ["dx|","x","a","b"]
                    ],
                    example: ["d/d|","#1","x","a","(","b",")"],
                    exampleQuestions: [
                        [""],
                        [""]
                    ],
                    exampleAnswers: [
                        [""],
                        [""]
                    ]
                ),
                
                InfoButton(
                    id: 3,
                    name: "∫",
                    fullName: "Integral",
                    category: "Calculus",
                    description: "The area under the function curve between two bounds",
                    sample: ["∫d","a","b","(","f","'","(","x",")",")","x"],
                    formula: ["f","(","b",")","-","f","(","a",")"],
                    formulaDesc: [""],
                    syntax: [
                        ["∫ₐᵇ","a","b","c","x"]
                    ],
                    example: ["∫d","a","b","(","c",")","x"],
                    exampleQuestions: [
                        [""],
                        [""]
                    ],
                    exampleAnswers: [
                        [""],
                        [""]
                    ]
                ),
            ]
        ),
        
        InfoButtonCategory(
            id: 5,
            name: "Probability",
            desc: "These tools for probability can be used to calculate statistical information or the chance of something happening.",
            buttons: [
                
                InfoButton(
                    id: 0,
                    name: "!",
                    fullName: "Factorial",
                    category: "Probability",
                    description: "The product of all integers from the given number to 1",
                    sample: ["n","!"],
                    formula: ["n","×","(","n","-","1",")","...","3","×","2","×","1"],
                    syntax: [
                        ["a","!"]
                    ],
                    example: ["a","!"],
                    exampleQuestions: [
                        ["4","!"],
                        ["4","!"]
                    ],
                    exampleAnswers: [
                        ["4","×","3","×","2","×","1"],
                        ["24"]
                    ]
                ),
                
                InfoButton(
                    id: 1,
                    name: "!!",
                    fullName: "Double Factorial",
                    category: "Probability",
                    description: "The product of all even or odd (depending on the number) integers from the given number to 1",
                    sample: ["n","!!"],
                    formula: ["n","×","(","n","-","2",")","...","4","×","2"],
                    syntax: [
                        ["a","!!"]
                    ],
                    example: ["a","!!"],
                    exampleQuestions: [
                        ["8","!!"],
                        ["8","!!"]
                    ],
                    exampleAnswers: [
                        ["8","×","6","×","4","×","2"],
                        ["384"]
                    ]
                ),
                
                InfoButton(
                    id: 2,
                    name: "nPr",
                    fullName: "Permutations",
                    category: "Probability",
                    description: "The number of possible ordered arrangements of a set",
                    sample: ["n","nPr","r"],
                    formula: ["#(","n","!","#)","/","#(","(","n","-","r",")","!","#)"],
                    formulaDesc: ["n = total number of objects","r = number of objects chosen"],
                    syntax: [
                        ["a","nPr","b"]
                    ],
                    example: ["a","nPr","b"],
                    exampleQuestions: [
                        ["7","nPr","4"],
                        ["7","nPr","4"]
                        
                    ],
                    exampleAnswers: [
                        ["#(","7","!","#)","/","#(","(","7","-","4",")","!","#)"],
                        ["840"]
                    ]
                ),
                
                InfoButton(
                    id: 3,
                    name: "nCr",
                    fullName: "Combinations",
                    category: "Probability",
                    description: "The number of possible combinations of a set",
                    sample: ["n","nCr","r"],
                    formula: ["#(","n","!","#)","/","#(","(","n","-","r",")","!","*","r","!","#)"],
                    formulaDesc: ["n = total number of objects","r = number of objects chosen"],
                    syntax: [
                        ["a","nCr","b"]
                    ],
                    example: ["a","nCr","b"],
                    exampleQuestions: [
                        ["7","nCr","4"],
                        ["7","nCr","4"]
                    ],
                    exampleAnswers: [
                        ["#(","7","!","#)","/","#(","(","7","-","4",")","!","×","4","!","#)"],
                        ["35"]
                    ]
                ),
                
                InfoButton(
                    id: 4,
                    name: "rand",
                    fullName: "Random Number",
                    category: "Probability",
                    range: ["[","0",",","1",")"],
                    syntax: [
                        ["rand"]
                    ],
                    example: ["rand"],
                    exampleQuestions: [
                        ["rand"],
                        ["rand","×","37"]
                    ],
                    exampleAnswers: [
                        ["0.3617841993"],
                        ["29.90217216"]
                    ]
                ),
            ]
        ),
        
        InfoButtonCategory(
            id: 6,
            name: "Miscellaneous",
            desc: "Miscellaneous constants and functions.",
            buttons: [
                
                InfoButton(
                    id: 0,
                    name: "x",
                    fullName: "Variable",
                    category: "Miscellaneous",
                    description: "Represents a variable value",
                    syntax: [
                        ["x"]
                    ],
                    example: ["x"],
                    exampleQuestions: [
                        ["3","*","x","+","4","*","x"],
                        ["(","8","*","a",")","^","2"]
                    ],
                    exampleAnswers: [
                        ["7","*","x"],
                        ["64","*","a","^","2"]
                    ]
                ),
                
                InfoButton(
                    id: 1,
                    name: "π",
                    fullName: "Pi",
                    category: "Miscellaneous",
                    description: "Ratio of a circle's circumference to diameter",
                    constValue: "3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679",
                    syntax: [
                        ["π"]
                    ],
                    example: ["π"],
                    exampleQuestions: [
                        ["2","×","π"],
                        ["8","*","π","+","3","*","π"]
                    ],
                    exampleAnswers: [
                        ["6.2831853"],
                        ["34.557519"]
                    ]
                ),
                
                InfoButton(
                    id: 2,
                    name: "e",
                    fullName: "e",
                    category: "Miscellaneous",
                    description: "Base of the exponential function equal to its own derivative",
//                    sample: ["e"],
//                    formula: ["lim","n->∞","(","1","+","1","/","n",")","^","n"],
                    sample: ["d/d","#1","x","e","^","x"],
                    formula: ["e","^","x"],
                    constValue: "2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274",
                    syntax: [
                        ["e"]
                    ],
                    example: ["e"],
                    exampleQuestions: [
                        ["4","×","e"],
                        ["e","^","4.5"]
                    ],
                    exampleAnswers: [
                        ["10.873127"],
                        ["90.017131"]
                    ]
                ),
                
                InfoButton(
                    id: 3,
                    name: "i",
                    fullName: "i",
                    category: "Miscellaneous",
                    description: "Imaginary number; the square root of negative one",
                    sample: ["i"],
                    formula: ["#2","√","-1"],
                    syntax: [
                        ["i"]
                    ],
                    example: ["i"],
                    exampleQuestions: [
                        ["i","^","2"],
                        ["6","*","i","+","7","*","i"]
                    ],
                    exampleAnswers: [
                        ["-1"],
                        ["13","*","i"]
                    ]
                ),
                
                InfoButton(
                    id: 4,
                    name: "vinc",
                    fullName: "Repeating Decimal",
                    category: "Miscellaneous",
                    description: "Adds a repeating symbol to a decimal place",
                    syntax: [
                        ["a.b"," ̅"]
                    ],
                    example: ["a.b ̅"],
                    exampleQuestions: [
                        ["2.1 ̅"],
                        ["3.045 ̅ ̅"]
                    ],
                    exampleAnswers: [
                        ["2.1111111111"],
                        ["3.0454545454"]
                    ]
                ),
                
                InfoButton(
                    id: 5,
                    name: "‰",
                    fullName: "Permille",
                    category: "Miscellaneous",
                    description: "Like a percent, but based on 1000 instead of 100",
                    syntax: [
                        ["a","‰"]
                    ],
                    example: ["a","‰"],
                    exampleQuestions: [
                        ["1","‰"],
                        ["50","+","50","‰"]
                    ],
                    exampleAnswers: [
                        ["0.001"],
                        ["52.5"]
                    ]
                ),
                
                InfoButton(
                    id: 6,
                    name: "round",
                    fullName: "Round",
                    category: "Miscellaneous",
                    description: "Rounds to the nearest integer",
                    syntax: [
                        ["round","a"],
                        ["a","round"]
                    ],
                    example: ["round","(","a",")"],
                    exampleQuestions: [
                        ["round","(","35.638475",")"],
                        ["round","(","-6","×","8.1",")"]
                    ],
                    exampleAnswers: [
                        ["36"],
                        ["-49"]
                    ]
                ),
                
                InfoButton(
                    id: 7,
                    name: "floor",
                    fullName: "Floor",
                    category: "Miscellaneous",
                    description: "Rounds a number down",
                    syntax: [
                        ["floor","a"],
                        ["a","floor"]
                    ],
                    example: ["floor","(","a",")"],
                    exampleQuestions: [
                        ["floor","(","35.638475",")"],
                        ["floor","(","-6","×","8.1",")"]
                    ],
                    exampleAnswers: [
                        ["35"],
                        ["-49"]
                    ]
                ),
                
                InfoButton(
                    id: 8,
                    name: "ceil",
                    fullName: "Ceiling",
                    category: "Miscellaneous",
                    description: "Rounds a number up",
                    syntax: [
                        ["ceil","a"],
                        ["a","ceil"]
                    ],
                    example: ["ceil","(","a",")"],
                    exampleQuestions: [
                        ["ceil","(","35.638475",")"],
                        ["ceil","(","-6","×","8.1",")"]
                    ],
                    exampleAnswers: [
                        ["36"],
                        ["-48"]
                    ]
                ),
                
            ]
        )
    ]
    
    // MARK: Constants
    
    static var constants = [
        
        InfoConstant(
            name: "Pi",
            symbol: "π",
            value: ["3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679"]
        ),
        
        InfoConstant(
            name: "Euler's Number",
            symbol: "e",
            value: ["2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274"]
        ),
        
        InfoConstant(
            name: "Golden Ratio",
            symbol: "Φ",
            value: ["1.618033988749894848204586834365638"]
        ),
        
        InfoConstant(
            name: "Acceleration due to Gravity on Earth's surface",
            symbol: "g",
            value: ["9.80665"],
            unit: ["m","/","#(","s","^","2","#)"]
        ),
        
        InfoConstant(
            name: "Universal Gravitational constant",
            symbol: "G",
            value: ["6.67408","E","-11"],
            unit: ["#(","N","*","m","^","2","#)","/","#(","kg","^","2","#)"]
        ),
        
        InfoConstant(
            name: "Speed of Light",
            symbol: "c",
            value: ["2.99792458","E","8"],
            unit: ["m","/","s"]
        ),
        
        InfoConstant(
            name: "Avogadro's Number",
            symbol: "N¬A",
            value: ["6.02214076","E","23"],
            unit: [" ","/","mol"]
        ),
        
        InfoConstantCluster(
            name: "Planck's Constant",
            symbol: "h",
            constants: [
                InfoConstant(
                    value: ["6.62607015","E","-34"],
                    unit: ["J","s"]
                ),
                InfoConstant(
                    value: ["4.135667696","E","-15"],
                    unit: ["eV","s"]
                )
            ]
        ),
        
        InfoConstantCluster(
            name: "Planck's Constant × c",
            symbol: "hc",
            constants: [
                InfoConstant(
                    value: ["1.98644586","E","-25"],
                    unit: ["J","m"]
                ),
                InfoConstant(
                    value: ["1.23984198","E","3"],
                    unit: ["eV","nm"]
                )
            ]
        ),
        
        InfoConstantCluster(
            name: "Reduced Planck Constant",
            symbol: "ħ",
            constants: [
                InfoConstant(
                    value: ["1.054571817","E","-34"],
                    unit: ["J","s"]
                ),
                InfoConstant(
                    value: ["6.582119569","E","-16"],
                    unit: ["eV","s"]
                )
            ]
        ),
        
        InfoConstant(
            name: "Faraday Constant",
            symbol: "F",
            value: ["9.648533212","E","4"],
            unit: ["C","/","mol"]
        ),
        
        InfoConstantCluster(
            name: "Ideal Gas Constant",
            symbol: "R",
            constants: [
                InfoConstant(
                    value: ["8.31446261815324"],
                    unit: ["J","/","#(","mol","*","K","#)"]
                ),
                InfoConstant(
                    value: ["8.31446261815324"],
                    unit: ["#(","L","*","kPa","#)","/","#(","mol","*","K","#)"]
                ),
                InfoConstant(
                    value: ["0.082057366080960"],
                    unit: ["#(","L","*","atm","#)","/","#(","mol","*","K","#)"]
                ),
                InfoConstant(
                    value: ["62.36367"],
                    unit: ["#(","L","*","torr","#)","/","#(","mol","*","K","#)"]
                )
            ]
        ),
        
        InfoConstant(
            name: "Boltzmann Constant",
            symbol: "k¬B",
            value: ["1.380649","E","-23"],
            unit: ["J","/","K"]
        ),
        
        InfoConstant(
            name: "Planck Length",
            symbol: "l¬P",
            value: ["1.616255","E","-35"],
            unit: ["m"]
        ),
        
        InfoConstant(
            name: "Vacuum Electric Permittivity",
            symbol: "ε¬0",
            value: ["8.8541878128","E","-12"],
            unit: ["#(","C","^","2","#)","/","#(","N","*","m","^","2","#)"]
        ),
        
        InfoConstantCluster(
            name: "Vacuum Magnetic Permeability",
            symbol: "μ¬0",
            constants: [
                InfoConstant(
                    value: ["1.25663706212","E","-6"],
                    unit: ["N","/","#(","A","^","2","#)"]
                ),
                InfoConstant(
                    value: ["","4","*","π","E","-7"],
                    unit: ["N","/","#(","A","^","2","#)"]
                )
            ]
        ),
        
        InfoConstantCluster(
            name: "Proton Mass",
            symbol: "m¬p",
            constants: [
                InfoConstant(
                    value: ["1.67262192370","E","-27"],
                    unit: ["kg"]
                ),
                InfoConstant(
                    value: ["1.00727646677"],
                    unit: ["u"]
                ),
                InfoConstant(
                    value: ["938.272013"],
                    unit: ["MeV","/","#(","c","^","2","#)"]
                )
            ]
        ),
        
        InfoConstantCluster(
            name: "Neutron Mass",
            symbol: "m¬n",
            constants: [
                InfoConstant(
                    value: ["1.67492749805","E","-27"],
                    unit: ["kg"]
                ),
                InfoConstant(
                    value: ["1.00866491597"],
                    unit: ["u"]
                ),
                InfoConstant(
                    value: ["939.565346"],
                    unit: ["MeV","/","#(","c","^","2","#)"]
                )
            ]
        ),
        
        InfoConstantCluster(
            name: "Electron Mass",
            symbol: "m¬e",
            constants: [
                InfoConstant(
                    value: ["9.1093837015","E","-31"],
                    unit: ["kg"]
                ),
                InfoConstant(
                    value: ["5.4857990943","E","-4"],
                    unit: ["u"]
                ),
                InfoConstant(
                    value: ["0.510998910"],
                    unit: ["MeV","/","#(","c","^","2","#)"]
                )
            ]
        ),
        
        InfoConstantCluster(
            name: "Deuteron Mass",
            symbol: "m¬d",
            constants: [
                InfoConstant(
                    value: ["3.34358320","E","-27"],
                    unit: ["kg"]
                ),
                InfoConstant(
                    value: ["2.013553212724"],
                    unit: ["u"]
                )
            ]
        ),
        
        InfoConstantCluster(
            name: "Rydberg Constant",
            symbol: "R¬H",
            constants: [
                InfoConstant(
                    value: ["1.0973731568539","E","7"],
                    unit: [" ","/","m"]
                ),
                InfoConstant(
                    value: ["2.1798741","E","-18"],
                    unit: ["J"]
                )
            ]
        ),
        
        InfoConstant(
            name: "Electron Volt",
            symbol: "eV",
            value: ["1.602176634","E","-19"],
            unit: ["J"]
        ),
        
        InfoConstant(
            name: "Elementary Charge",
            symbol: "e",
            value: ["1.602176634","E","-19"],
            unit: ["C"]
        ),
        
        InfoConstant(
            name: "Coulomb Constant",
            symbol: "k",
            value: ["8.9875517923","E","9"],
            unit: ["#(","N","*","m","^","2","#)","/","#(","C","^","2","#)"]
        ),
        
        InfoConstantCluster(
            name: "Atomic Mass Unit",
            symbol: "u",
            constants: [
                InfoConstant(
                    value: ["1.660538783","E","-27"],
                    unit: ["kg"]
                ),
                InfoConstant(
                    value: ["931.494028"],
                    unit: ["MeV","/","#(","c","^","2","#)"]
                )
            ]
        ),
        
        InfoConstantCluster(
            name: "Atmosphere Pressure",
            symbol: "atm",
            constants: [
                InfoConstant(
                    value: ["101325"],
                    unit: ["Pa"]
                ),
                InfoConstant(
                    value: ["101.325"],
                    unit: ["kPa"]
                ),
                InfoConstant(
                    value: ["760"],
                    unit: ["torr"]
                )
            ]
        ),
        
        InfoConstant(
            name: "Earth Mass",
            symbol: "m¬E",
            value: ["5.9722","E","24"],
            unit: ["kg"]
        ),
        
        InfoConstant(
            name: "Solar Mass",
            symbol: "m¬☉",
            value: ["1.98847","E","30"],
            unit: ["kg"]
        ),
        
        InfoConstant(
            name: "Lunar Mass",
            symbol: "m¬L",
            value: ["7.34767309","E","22"],
            unit: ["kg"]
        ),
        
        InfoConstant(
            name: "Jupiter Mass",
            symbol: "m¬J",
            value: ["1.89813","E","27"],
            unit: ["kg"]
        ),
        
        InfoConstantCluster(
            name: "Earth Radius",
            symbol: "r¬E",
            constants: [
                InfoConstant(
                    value: ["6.3781","E","6"],
                    unit: ["m"]
                ),
                InfoConstant(
                    value: ["6378.1"],
                    unit: ["km"]
                )
            ]
        ),
        
        InfoConstantCluster(
            name: "Solar Radius",
            symbol: "r¬☉",
            constants: [
                InfoConstant(
                    value: ["6.957","E","8"],
                    unit: ["m"]
                ),
                InfoConstant(
                    value: ["6.957","E","5"],
                    unit: ["km"]
                )
            ]
        ),
        
        InfoConstantCluster(
            name: "Astronomical Unit",
            symbol: "AU",
            constants: [
                InfoConstant(
                    value: ["1.495978707","E","11"],
                    unit: ["m"]
                ),
                InfoConstant(
                    value: ["1.495978707","E","8"],
                    unit: ["km"]
                ),
            ]
        ),
        
        InfoConstantCluster(
            name: "Lunar Distance",
            symbol: "LD",
            constants: [
                InfoConstant(
                    value: ["3.84399","E","8"],
                    unit: ["m"]
                ),
                InfoConstant(
                    value: ["3.84399","E","5"],
                    unit: ["km"]
                ),
            ]
        ),
        
        InfoConstant(
            name: "Bohr Magneton",
            symbol: "μ¬B",
            value: ["9.27400915","E","-24"],
            unit: ["J","/","T"]
        ),
        
        InfoConstant(
            name: "Nuclear Magneton",
            symbol: "μ¬n",
            value: ["5.05078324","E","-27"],
            unit: ["J","/","T"]
        ),
        
        InfoConstant(
            name: "Bohr Radius",
            symbol: "a¬0",
            value: ["5.2917720859","E","-11"],
            unit: ["m"]
        ),
        
        InfoConstant(
            name: "Compton Wavelength",
            symbol: "λ¬C",
            value: ["2.4263102175","E","-12"],
            unit: ["m"]
        ),
        
        InfoConstant(
            name: "Euler–Mascheroni Constant",
            symbol: "γ",
            value: ["0.5772156649"]
        ),
        
        InfoConstant(
            name: "Meissel–Mertens Constant",
            symbol: "M¬1",
            value: ["0.2614972128"]
        ),
        
        InfoConstant(
            name: "Bernstein's Constant",
            symbol: "β",
            value: ["0.2801694990"]
        ),
        
        InfoConstant(
            name: "Gauss–Kuzmin–Wirsing Constant",
            symbol: "λ",
            value: ["0.3036630028"]
        ),
        
        InfoConstant(
            name: "Hafner–Sarnak–McCurley Constant",
            symbol: "σ",
            value: ["0.3532363718"]
        ),
        
        InfoConstant(
            name: "Omega Constant",
            symbol: "Ω",
            value: ["0.5671432904"]
        ),
        
        InfoConstant(
            name: "Golomb–Dickman Constant",
            symbol: "λ",
            value: ["0.6243299885"]
        ),
        
        InfoConstant(
            name: "Twin Prime Constant",
            symbol: "C¬2",
            value: ["0.6601618158"]
        ),
        
        InfoConstant(
            name: "Laplace Limit",
            symbol: "",
            value: ["0.6627434193"]
        ),
        
        InfoConstant(
            name: "Cahen's Constant",
            symbol: "",
            value: ["0.6434105462"]
        ),
        
        InfoConstant(
            name: "Embree–Trefethen Constant",
            symbol: "B*",
            value: ["0.70258"]
        ),
        
        InfoConstant(
            name: "Landau–Ramanujan Constant",
            symbol: "K",
            value: ["0.7642236535"]
        ),
        
        InfoConstant(
            name: "Brun's Constant for twin primes",
            symbol: "B¬2",
            value: ["1.9021605831"]
        ),
        
        InfoConstant(
            name: "Brun's Constant for prime quadruplets",
            symbol: "B¬4",
            value: ["0.87058838"]
        ),
        
        InfoConstant(
            name: "Catalan's Constant",
            symbol: "K",
            value: ["0.9159655941"]
        ),
        
        InfoConstant(
            name: "Viswanath's Constant",
            symbol: "K",
            value: ["1.13198824"]
        ),
        
        InfoConstant(
            name: "Apéry's Constant",
            symbol: "ζ(3)",
            value: ["1.2020569031"]
        ),
        
        InfoConstant(
            name: "Conway's Constant",
            symbol: "λ",
            value: ["1.3035772690"]
        ),
        
        InfoConstant(
            name: "Mills' Constant",
            symbol: "θ",
            value: ["1.3063778838"]
        ),
        
        InfoConstant(
            name: "Plastic Constant",
            symbol: "ρ",
            value: ["1.3247179572"]
        ),
        
        InfoConstant(
            name: "Ramanujan–Soldner Constant",
            symbol: "μ",
            value: ["1.4513692348"]
        ),
        
        InfoConstant(
            name: "Backhouse's Constant",
            symbol: "",
            value: ["1.4560749485"]
        ),
        
        InfoConstant(
            name: "Porter's Constant",
            symbol: "",
            value: ["1.4670780794"]
        ),
        
        InfoConstant(
            name: "Lieb's Square Ice Constant",
            symbol: "",
            value: ["1.5396007178"]
        ),
        
        InfoConstant(
            name: "Erdős–Borwein Constant",
            symbol: "E¬B",
            value: ["1.6066951524"]
        ),
        
        InfoConstant(
            name: "Niven's Constant",
            symbol: "",
            value: ["1.7052111401"]
        ),
        
        InfoConstant(
            name: "Universal Parabolic Constant",
            symbol: "P¬2",
            value: ["2.2955871493"]
        ),
        
        InfoConstant(
            name: "Feigenbaum Constant",
            symbol: "α",
            value: ["2.5029078750"]
        ),
        
        InfoConstant(
            name: "Sierpiński's Constant",
            symbol: "K",
            value: ["2.5849817595"]
        ),
        
        InfoConstant(
            name: "Khinchin's Constant",
            symbol: "",
            value: ["2.6854520010"]
        ),
        
        InfoConstant(
            name: "Fransén–Robinson Constant",
            symbol: "F",
            value: ["2.8077702420"]
        ),
        
        InfoConstant(
            name: "Lévy's Constant",
            symbol: "",
            value: ["3.2758229187"]
        ),
        
        InfoConstant(
            name: "Reciprocal Fibonacci Constant",
            symbol: "ψ",
            value: ["3.3598856662"]
        ),
        
        InfoConstant(
            name: "Feigenbaum Constant",
            symbol: "δ",
            value: ["4.6692016091"]
        )
        
        // dont let them use this minus −
    ]
}
