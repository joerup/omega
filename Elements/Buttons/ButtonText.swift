//
//  ButtonText.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/24/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct ButtonText: View {
    
    @ObservedObject var settings = Settings.settings
    
    var button: InputButton
    var fontSize: CGFloat
    
    var name: String {
        switch button.name {
        case "clear":
            return "C"
        case "backspace":
            return "←"
        case "enter":
            return "="
        case "nothing":
            return ""
        case "vinc":
            return "‾"
        case ".":
            return settings.commaDecimal ? "," : "."
        case _ where button.name.first == "_":
            return String(button.name.dropFirst())
        case _ where Function.invTrig.contains(where: { button.name == $0.rawValue }):
            return settings.arcInverseTrig ? "arc"+String(button.name.dropLast(2)) : button.name
        default:
            return button.name
        }
    }
    
    var elements: [TextElement]? {
        guard !Settings.settings.noButtonElements else { return nil }
        var strings: [String]? {
            switch button.name {
            case "*":
                return ["■"]
            case "/":
                return ["■","/","■"]
            case "*/":
                return ["■","*","■","/","■"]
            case "+/-":
                return ["+","//","-"]
            case "abs":
                return ["abs","■"]
            case "√":
                return ["#2","√","■"]
            case "3√":
                return ["3","√","■"]
            case "n√":
                return ["■","√","■"]
            case "log2":
                return ["log","2",""]
            case "logn":
                return ["log","■",""]
            case "10^":
                return ["10","^","■"]
            case "e^":
                return ["»e","^","■"]
            case "2^":
                return ["2","^","■"]
            case "n^":
                return ["■","^","■"]
            case "dx":
                return ["d/d","#1","■",""]
            case "dx2":
                return ["d/d","2","■",""]
            case "dxn":
                return ["d/d","■","■",""]
            case "∫":
                return ["∫d","■","■",""]
            default:
                return nil
            }
        }
        if let strings = strings {
            var elements = TextElement.setElements(strings, size: fontSize)
            if [].contains(button.name) {
                elements.removeLast()
            }
            else if ["∫"].contains(button.name) {
                elements.removeLast(2)
            }
            return elements
        }
        return nil
    }
    
    var offset: CGSize {
        if Operation.primary.contains(button.name) || ["enter","(",")","∑","∏"].contains(button.name) {
            return CGSize(width: 0, height: fontSize*0.125)
        }
        if button.name == "*/" {
            return CGSize(width: -fontSize*0.075, height: 0)
        }
        return .zero
    }
    
    var relativeSize: CGFloat {
        if name.count <= 3 {
            return 1.0
        } else if name.count == 4 {
            return 0.95
        } else if name.count == 5 {
            return 0.9
        } else if name.count == 6 {
            return 0.85
        } else if name.count >= 7 {
            return 0.8
        }
        return 1.0
    }
    
    var body: some View {
        
        if let elements = elements {
            TextSequence(textElements: elements, colorContext: .none)
                .offset(offset)
        } else {
            Text(name)
                .font(.system(size: fontSize*relativeSize, weight: .medium, design: .rounded))
                .baselineOffset(offset.height)
                .offset(x: offset.width)
        }
    }
    
    
    func keyboardShortcut(_ button: String) -> KeyEquivalent {
        
        if button.count == 1 {
            return KeyEquivalent.init(Character(button))
        }
        
        return KeyEquivalent.init(" ")
    }
}
