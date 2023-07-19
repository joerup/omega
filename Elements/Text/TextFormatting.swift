//
//  TextFormatting.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/23/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

// Data structure that formats text elements
class TextFormatting {
    
    @ObservedObject var settings = Settings.settings
    
    var elements: [TextElement]
    
    var modeSettings: ModeSettings? = nil
    var modes: ModeSettings {
        return modeSettings ?? settings.modes
    }
    var theme: Theme? = nil
    
    init(elements: [TextElement]) {
        self.elements = elements
    }
    
    // Format the elements
    func formatElements() {
        
        guard !Settings.settings.noElements else { return }
        
        var index = 0
        while index < elements.count {
            
            let element = elements[index]
            let prev = index-1 >= 0 ? elements[index-1] : nil
            let prev2 = index-2 >= 0 ? elements[index-2] : nil
            let prev3 = index-3 >= 0 ? elements[index-3] : nil
            let next = index+1 < elements.count ? elements[index+1] : nil
            let next2 = index+2 < elements.count ? elements[index+2] : nil
            
            element.color = .general
            
            // MARK: Numbers
            if Double(element.text) != nil {
                var string = element.display

                // Decimal point
                if settings.commaDecimal {
                    string = string.replacingOccurrences(of: ".", with: ",")
                }
                // Thousands separators
                if settings.thousandsSeparators != 0 {
                    var strIndex = string.distance(from: string.startIndex, to: string.lastIndex(of: settings.commaDecimal ? "," : ".") ?? string.endIndex) as Int - 3
                    while strIndex > (string.first == "-" ? 1 : 0) {
                        string.insert(settings.thousandsSeparators == 2 ? " " : settings.commaDecimal ? "." : ",", at: string.index(string.startIndex, offsetBy: strIndex))
                        strIndex -= 3
                    }
                }
                element.display = string
                element.color = .prominent
            }
            
            // MARK: Negatives
            else if element.text == "#-1" {
                element.display = "-"
                element.rightPad -= element.size*0.1
                element.color = .prominent
            }
            
            // MARK: Variables
            else if element.text.first == "»" || element.text.first == "¶" {
                
                element.display = String(element.text.dropFirst())
                if prev?.text == "*" && prev2?.text != "#-1" || prev?.text == "#(" && prev2?.text == "*" && prev3?.text != "#-1" {
                    element.leftPad -= element.size*0.075
                } 
                element.color = .prominent
                
                // Subscript
                if element.display.count == 2, let sub = element.display.last {
                    element.display = String(element.display.dropLast())
                    let subElement = TextElement(String(sub), copy: elements[index])
                    subElement.multiply(0.5)
                    subElement.midline -= element.size*0.35
                    subElement.leftPad -= element.size*0.2
                    elements.insert(subElement, at: index+1)
                }
            }
            
            // MARK: Units
            else if element.text.first == "_" {
                element.display = String(element.text.dropFirst())
                element.color = .general
                element.multiply(0.8)
                element.verticalOffset -= element.size*0.1
            }
            
            // MARK: Parentheses
            else if element.text == "(" {
                
                let index1 = nextIndex(start: index, parentheses: 1)
                
                element.rightPad -= element.size*0.1
                elements[index1].leftPad -= element.size*0.1
                
                element.leftPad -= element.size*0.05
                elements[index1].rightPad -= element.size*0.05
                
                if elements[index1].text == "\\)" {
                    elements[index1].display = ")"
                    elements[index1].color = .gray2
                }
                
                let height = getTotalHeight(elements[index...index1].map{$0})
                let ratio = (height.top-height.bottom)/element.size
                
                element.aspectRatio *= ratio
                elements[index1].aspectRatio *= ratio
                
                element.midline += (height.top+height.bottom)/2
                elements[index1].midline += (height.top+height.bottom)/2
                
                element.verticalOffset += element.size*0.078
                elements[index1].verticalOffset += element.size*0.078
                
                index = index1
            }
            
            // MARK: Invisible Parentheses
            else if element.text == "#(" || element.text == "#)" {
                element.size = 0
            }
            
            // MARK: Placeholders
            else if element.text == "□" || element.text == "■" {
                element.display = "■"
                element.color = element.text == "■" ? .theme : .gray3
            }
            
            // MARK: Pointers
            else if element.text == "#|" {
                element.display = "|"
                element.color = .theme
            
                element.leftPad -= element.width * (prev != nil ? 0.8 : 0.5)
                element.rightPad -= element.width * (next != nil ? 0.8 : 0.5)
                element.verticalOffset += element.size*0.078
            }
 
            // MARK: Other Invisible Items
            else if element.text.contains("#") {
                element.display = element.text.replacingOccurrences(of: "#", with: "")
                element.color = .invisible
                if element.text != "#2" {
                    element.size = 0
                }
            }
            
            // MARK: Infinity
            else if element.text == "∞" {
                element.multiply(1.1)
                element.midline -= element.size*0.075
            }
            
            // MARK: Errors
            else if element.text == "ERROR" {
                element.color = .gray2
                element.multiply(0.8)
            }
            
            // MARK: Repeating Decimals
            else if element.text.contains(" ̅") {
                
                var count = 0
                while element.text.last == " ̅" {
                    element.text.removeLast()
                    element.display.removeLast()
                    count += 1
                }
                
                let index1 = nextIndex(start: index-1)
                
                let width = TextElement(String(element.display.suffix(count)), copy: element).width
                let vinculum = Vinculum(width: width, thickness: strokeSize(element.size))
                vinculum.leftPad -= width + element.size/10
                vinculum.rightPad += element.size/10
                vinculum.midline += element.size*0.375 + strokeSize(element.size)
                elements.insert(vinculum, at: index+1)
                
                index = index1+1
            }
            
            // MARK: Operations
            else if ["+","-","×","÷"].contains(element.text) {
                if let prev, prev.text != "#|" {
                    element.leftPad -= element.size*0.15
                }
                if let next, next.text != "#|" {
                    element.rightPad -= element.size*0.15
                }
                element.color = .gray1
            }
            
            // MARK: Connectors
            else if element.text == "*" {
                element.leftPad -= element.size*0.06
                element.rightPad -= element.size*0.06
                element.size = 0
            }
            
            // MARK: Percent
            else if element.text == "%" || element.text == "‰" {
                element.leftPad -= element.size*0.2
            }
            
            // MARK: Exponents
            else if element.text == "^" {
                
                let index1 = nextIndex(start: index)
                let lastV = lastVisible(start: index)
                
                for e in elements[index+1...index1] {
                    e.multiply(0.5)
                    e.midline += elements[lastV].height/2 - element.height/4
                }
                
                elements[index+1].leftPad -= element.size*0.1
                elements[index1].rightPad += element.size*0.07
                
                element.size = 0
                
                index = index1
            }
            
            // MARK: Radicals
            else if element.text == "√" {
                
                let index1 = prevIndex(start: index)
                let index2 = nextIndex(start: index)
                
                for e in elements[index1..<index] {
                    e.multiply(0.42)
                    e.midline += element.size*0.37
                }
                
                let radical = Radical(size: element.size)
                radical.leftPad -= element.size*0.3
                radical.rightPad -= element.size*0.27
                radical.color = .general
                elements[index] = radical
                
                let radicandHeight = getTotalHeight(elements[index+1...index2].map{$0})
                let radicandWidth = getTotalWidth(elements[index+1...index2].map{$0})
                
                elements[index1].leftPad += elements[index].size*0.05
                elements[index2].rightPad += elements[index].size*0.1
                
                let vinculum = Vinculum(width: radicandWidth, thickness: strokeSize(element.size))
                vinculum.rightPad -= radicandWidth
                vinculum.midline += radicandHeight.top + strokeSize(element.size)/2
                vinculum.color = .general
                elements.insert(vinculum, at: index+1)
                
                elements[index].aspectRatio *= (vinculum.topPosition-radicandHeight.bottom)/element.size
                elements[index].midline += (vinculum.topPosition+radicandHeight.bottom)/2
                
                for e in elements[index1..<index] {
                    e.midline += element.midline - element.height*0.08
                }
                
                index = index2+1
            }
            
            // MARK: Exponential Symbol
            else if element.text == "E" {
                
                if settings.displayX10 {
                    
                    let index1 = nextIndex(start: index)
                    
                    for e in elements[index+1...index1] {
                        e.multiply(0.5)
                        e.midline += element.size*0.25
                    }
                    
                    element.display = "×10"
                    
                    element.leftPad -= element.size*0.2
                    elements[index+1].leftPad -= element.size*0.1
                    elements[index1].rightPad += next?.text == "*" ? element.size*0.1 : 0
                    
                    index = index1
                    
                } else {
                    
                    element.multiply(0.8)
                    element.midline -= element.size*0.075
                    element.leftPad -= element.size*0.15
                    element.rightPad -= element.size*0.15
                }
            }
            
            // MARK: Fractions
            else if element.text == "/" {

                let index1 = prevIndex(start: index)
                let index2 = nextIndex(start: index)

                for e in elements[index1...index2] {
                    e.multiply(0.7)
                }
                
                let numeratorHeight = getTotalHeight(elements[index1..<index].map{$0})
                let denominatorHeight = getTotalHeight(elements[index+1...index2].map{$0})
                
                for e in elements[index1..<index] {
                    e.midline -= numeratorHeight.bottom - element.size*0.1
                }
                for e in elements[index...index2] {
                    e.midline -= denominatorHeight.top + element.size*0.1
                }
                
                let numeratorWidth = getTotalWidth(elements[index1..<index].map{$0})
                let denominatorWidth = getTotalWidth(elements[index+1...index2].map{$0})
                
                if numeratorWidth >= denominatorWidth {
                    
                    let vinculum = Vinculum(width: numeratorWidth, thickness: strokeSize(element.size))
                    elements.insert(vinculum, at: index)
                    
                    elements[index-1].rightPad -= numeratorWidth
                    elements[index+1].leftPad -= (numeratorWidth + denominatorWidth)/2
                    elements[index2+1].rightPad += (numeratorWidth - denominatorWidth)/2 + element.size*0.15
                    elements[index1].leftPad += element.size*0.15
                    
                } else {
                    
                    let vinculum = Vinculum(width: denominatorWidth, thickness: strokeSize(element.size))
                    elements.insert(vinculum, at: index)
                    
                    elements[index+1].leftPad -= denominatorWidth
                    elements[index-1].rightPad -= (numeratorWidth + denominatorWidth)/2
                    elements[index1].leftPad += (denominatorWidth - numeratorWidth)/2 + element.size*0.15
                    elements[index2+1].rightPad += element.size*0.15
                }
                
                element.size = 0
                
                index = index2+1
            }
            
            else if element.text == "//" {
                
                let index1 = prevIndex(start: index)
                let index2 = nextIndex(start: index)

                for e in elements[index1...index2] {
                    e.multiply(0.95)
                }
                element.display = "/"
                element.midline += element.size*0.05
                
                for e in elements[index1..<index] {
                    e.midline += element.size*0.05
                }
                
                element.leftPad -= element.size*0.05
                element.rightPad -= element.size*0.2
                
                index = index2+1
            }
            
            // MARK: Logarithms
            else if element.text == "log" {
                
                let index1 = nextIndex(start: index)
                
                if next2?.text == "#e" {
                    element.display = "ln"
                }
                for e in elements[index+1...index1] {
                    e.multiply(0.5)
                    e.midline -= element.size*0.35
                }
                
                if !(next2?.text.contains("#") ?? false) {
                    elements[index+1].leftPad -= element.size*0.125
                    elements[index1].rightPad -= element.size*0.125
                } else {
                    elements[index+1].leftPad -= element.size*0.1
                }
                
                index = index1
            }
            
            // MARK: Regular Trig Functions
            else if Function.regTrig.contains(where: { element.text == $0.rawValue }) {
                
                let index1 = nextIndex(start: index)
                
                elements[index+1].leftPad -= element.size*0.125

                if modes.angleUnit == .deg {
                    if elements[index1].text == "#)", index1+1 <= elements.count {
                        elements.insert(TextElement("º", copy: element), at: index1+1)
                        elements[index1].leftPad -= element.size*0.2
                        elements[index1].queueIndex = elements[index1-1].queueIndex
                    }
                    else if elements[index1].text.contains(")"), index1+1 <= elements.count {
                        elements.insert(TextElement("º", copy: element), at: index1+1)
                        elements[index1+1].leftPad -= element.size*0.2
                        elements[index1+1].queueIndex = elements[index1].queueIndex
                    }
                }
                
                index = index1
            }
            
            // MARK: Inverse Trig Functions
            else if Function.invTrig.contains(where: { element.text == $0.rawValue }) {
                
                element.display = String(element.text.dropLast(2))
                
                if settings.arcInverseTrig {
                    element.display = "arc"+element.display
                } else {
                    elements.insert(TextElement("-1", copy: element), at: index+1)
                    elements[index+1].multiply(0.5)
                    elements[index+1].midline += element.topPosition - element.size/4
                    elements[index+1].rightPad -= element.size*0.05
                }
                
                let index1 = nextIndex(start: index)
                
                if index+1 < elements.count {
                    elements[index+1].leftPad -= element.size*0.15
                }
                
                index = index1
            }

            // MARK: Power Trig Functions
            else if Function.powTrig.contains(where: { element.text == $0.rawValue }) {
                
                let index1 = nextIndex(start: index)
                let index2 = nextIndex(start: index1)
                
                for e in elements[index+1...index1] {
                    e.multiply(0.5)
                    e.midline += element.topPosition - element.size/4
                }
                
                elements[index+1].leftPad -= element.size*0.1
                elements[index1].rightPad -= element.size*0.07
                
                element.display.removeLast()
                
                index = index2
            }
            
            // MARK: Number Functions
            else if Function.numberFunctions.contains(where: { element.text == $0.rawValue }) {
                
                element.display = element.text.lowercased()
                
                element.multiply(0.95)
                element.rightPad -= element.size*0.1
            }
            
            // MARK: Absolute Value
            else if element.text == "abs" {
                
                let index1 = nextIndex(start: index)
                
                element.display = "|"
                elements.insert(TextElement("|", copy: element), at: index1+1)
                
                if prev?.text == "*" || prev?.text == "#(" && prev2?.text == "*" {
                    element.leftPad -= element.size*0.15
                }
                element.rightPad -= element.size*0.1
                elements[index1+1].leftPad -= element.size*0.1
                elements[index1+1].queueIndex = elements[index1].queueIndex
                
                let height = getTotalHeight(elements[index...index1].map{$0})
                let ratio = (height.top-height.bottom)/element.size
                
                element.aspectRatio *= ratio
                elements[index1+1].aspectRatio *= ratio
                
                element.midline += (height.top+height.bottom)/2
                elements[index1+1].midline += (height.top+height.bottom)/2
                
                element.verticalOffset += element.size*0.078
                elements[index1+1].verticalOffset += element.size*0.078
                
                index = index1+1
            }
            
            // MARK: Factorial
            else if element.text == "!" || element.text == "!!" {
                element.leftPad -= element.size*0.2
            }
            
            // MARK: Permutations & Combinations
            else if element.text == "nPr" || element.text == "nCr" {
                
                element.display.removeFirst()
                element.display.removeLast()
                
                let index1 = prevIndex(start: index)
                let index2 = nextIndex(start: index)
                
                for e in elements[index1..<index]+elements[index+1...index2] {
                    e.multiply(0.5)
                    e.midline -= element.size*0.25
                }
                
                elements[index1].leftPad += element.size*0.1
                elements[index-1].rightPad -= element.size*0.1
                elements[index+1].leftPad -= element.size*0.1
                elements[index2].rightPad += element.size*0.1
                
                index = index2
            }
            
            // MARK: Summation/Products
            else if element.text == "∑" || element.text == "∏" {
                
                let index1 = nextIndex(start: index)
                elements.insert(TextElement("=", copy: elements[index1+1]), at: index1+1)
                let index2 = nextIndex(start: index1+1)
                let index3 = nextIndex(start: index2)
                
                for e in elements[index+1...index2]+elements[index2+1...index3] {
                    e.multiply(0.35)
                }
                
                element.verticalOffset += element.size*0.078
                
                let lowerHeight = getTotalHeight(elements[index+1...index2].map{$0})
                let upperHeight = getTotalHeight(elements[index2+1...index3].map{$0})
                
                for e in elements[index+1...index2] {
                    e.midline -= element.size/2 + lowerHeight.top - element.size*0.05
                }
                for e in elements[index2+1...index3] {
                    e.midline += element.size/2 - upperHeight.bottom
                }
                
                let lowerWidth = getTotalWidth(elements[index+1...index2].map{$0})
                let upperWidth = getTotalWidth(elements[index2+1...index3].map{$0})
                
                elements[index+1].leftPad -= (lowerWidth+element.width)/2 + element.size*0.1
                elements[index2+1].leftPad -= (lowerWidth+upperWidth)/2
                if lowerWidth >= upperWidth {
                    elements[index3].rightPad += (lowerWidth-upperWidth)/2
                }
                if lowerWidth >= element.width {
                    element.leftPad += (lowerWidth-element.width)/2
                }
                
                elements[index3+1].leftPad -= element.size*0.1
                
                index = index3
            }
            
            // MARK: Limits
            else if element.text == "lim" {
                
                let index1 = nextIndex(start: index)
                elements.insert(TextElement("->", copy: elements[index1+1]), at: index1+1)
                let index2 = nextIndex(start: index1+1)
                
                for e in elements[index+1...index2] {
                    e.multiply(0.35)
                }
                
                let lowerHeight = getTotalHeight(elements[index+1...index2].map{$0})
                
                for e in elements[index+1...index2] {
                    e.midline -= element.size/2 + lowerHeight.top - element.size*0.175
                }
                
                let lowerWidth = getTotalWidth(elements[index+1...index2].map{$0})
                
                element.midline += element.size*0.125
                elements[index+1].leftPad -= (lowerWidth+element.width)/2 + element.size*0.1
                if element.width > lowerWidth {
                    elements[index2].rightPad += (element.width-lowerWidth)/2
                } else {
                    element.leftPad += (lowerWidth-element.width)/2
                }
                
                index = index2
            }
            
            // MARK: Derviatives
            else if element.text == "d/d" || element.text == "d/d|" {
                
                let index1 = nextIndex(start: index)
                let index2 = nextIndex(start: index1) + 1
                elements.insert(TextElement("d", copy: elements[index1+1]), at: index1+1)
                elements[index1+1].size = element.size
                elements[index1+1].color = element.color
                for element in elements[index+1...index1].reversed() {
                    elements.insert(TextElement(element.text, copy: element), at: index2+1)
                }
                let index3 = nextIndex(start: index2)
                let index4 = nextIndex(start: index3)
                
                element.display = "d"
                
                elements[index+1].leftPad -= element.size*0.2
                elements[index1+2].leftPad -= element.size*0.2
                elements[index2+1].leftPad -= element.size*0.2
                
                for e in elements[index+1...index1]+elements[index2+1...index3] {
                    e.multiply(0.5)
                    e.midline += element.size*0.25
                }
                for e in elements[index...index3] {
                    e.multiply(0.7)
                }
                
                let numeratorHeight = getTotalHeight(elements[index...index1].map{$0})
                let denominatorHeight = getTotalHeight(elements[index1+1...index3].map{$0})
                
                for e in elements[index...index1] {
                    e.midline -= numeratorHeight.bottom - element.size*0.1
                }
                for e in elements[index1+1...index3] {
                    e.midline -= denominatorHeight.top + element.size*0.1
                }

                let numeratorWidth = getTotalWidth(elements[index...index1].map{$0})
                let denominatorWidth = getTotalWidth(elements[index1+1...index3].map{$0})
                
                let vinculum = Vinculum(width: denominatorWidth, thickness: element.size*0.1)
                elements.insert(vinculum, at: index1+1)

                elements[index1+2].leftPad -= denominatorWidth + element.size*0.05
                elements[index1].rightPad -= (numeratorWidth + denominatorWidth)/2
                elements[index].leftPad += (denominatorWidth - numeratorWidth)/2 + element.size*0.2
                
                if element.text == "d/d|" {
                    
                    var varIndex: Int {
                        if index2 < elements.count, elements[index2].text == "d", index2+1 < elements.count {
                            return index2+1
                        } else if index2 < elements.count, elements[index2].text == "#|", index2-1 < elements.count {
                            return index2-1
                        } else if index2 < elements.count {
                            return index2
                        }
                        return index1
                    }
                    
                    elements.insert(TextElement("=", copy: elements[index4+2]), at: index4+2)
                    elements.insert(TextElement(elements[varIndex].display, copy: elements[index4+2]), at: index4+2)
                    elements[index4+2].color = elements[varIndex].color
                    elements[index4+2].queueIndex = elements[varIndex].queueIndex
                    
                    elements.insert(TextElement("|", copy: elements[index4+3]), at: index4+2)
                    elements[index4+2].verticalOffset += elements[index4+2].size*0.078
                    elements[index4+2].leftPad -= elements[index4+2].width*0.5
                    elements[index4+2].rightPad -= elements[index4+2].width*0.3
                    elements[index4+2].aspectRatio *= 1.2
                    
                    let index5 = nextIndex(start: index4+4)

                    for e in elements[index4+3...index5] {
                        e.multiply(0.4)
                        e.midline -= element.size*0.5
                    }
                    
                    index = index5
                    
                } else {
                    
                    index = index4+1
                }
            }
            
            // MARK: Indefinite Integrals
            else if element.text == "∫" {
                
                let index1 = nextIndex(start: index)
                let index2 = nextIndex(start: index1)
                
                elements.insert(TextElement("d", copy: elements[index1+2 < elements.count ? index1+2 : index2]), at: index1+1)
                elements[index1+1].color = element.color
                
                let integrandHeight = getTotalHeight(elements[index+1...index1].map{$0})
                
                elements[index+1].leftPad -= element.size*0.2
                elements[index1+1].leftPad -= element.size*0.1
                elements[index1+1].rightPad -= element.size*0.15
                
                element.verticalOffset += element.size*0.1
                element.leftPad -= element.size*0.1
                element.aspectRatio *= (integrandHeight.top-integrandHeight.bottom)/element.size
                element.size *= 1.25
                element.midline += (integrandHeight.top+integrandHeight.bottom)/2 + element.size*0.02
                
                index = index2+1
            }
            
            // MARK: Definite Integrals
            else if element.text == "∫d" {
                
                let index1 = nextIndex(start: index)
                let index2 = nextIndex(start: index1)
                let index3 = nextIndex(start: index2)
                let index4 = nextIndex(start: index3)
                
                elements.insert(TextElement("d", copy: elements[index3+2 < elements.count ? index3+2 : index4]), at: index3+1)
                elements[index3+1].color = element.color
                
                let integrandHeight = getTotalHeight(elements[index2+1...index3].map{$0})
                
                for e in elements[index+1...index1] {
                    e.multiply(0.4)
                    e.midline += integrandHeight.bottom
                }
                for e in elements[index1+1...index2] {
                    e.multiply(0.4)
                    e.midline += integrandHeight.top
                }
                
                let lowerWidth = getTotalWidth(elements[index+1...index1].map{$0})
                let upperWidth = getTotalWidth(elements[index1+1...index2].map{$0})
                
                elements[index+1].leftPad -= element.size*0.3
                elements[index1+1].leftPad -= lowerWidth - element.size*0.2
                elements[index2].rightPad -= element.size*0.1
                if lowerWidth >= upperWidth {
                    elements[index2].rightPad += lowerWidth-upperWidth
                }
                
                elements[index3+1].leftPad -= element.size*0.1
                elements[index3+1].rightPad -= element.size*0.15
                
                element.display = "∫"
                element.aspectRatio *= 1.4
                element.verticalOffset += element.size*0.078
                element.leftPad -= element.size*0.1
                element.aspectRatio *= (integrandHeight.top-integrandHeight.bottom)/element.size
                element.midline += (integrandHeight.top+integrandHeight.bottom)/2
                
                index = index4+1
            }
            
            index += 1
        }
    }
    
    // Get the total width
    func getTotalWidth(_ elements: [TextElement]) -> CGFloat {
        
        var width: CGFloat = 0
        
        // Add all of the width and padding together
        for element in elements {
            width += element.width + element.leftPad + element.rightPad + element.size*0.2
        }
        
        return width
    }
    
    // Get the total height
    func getTotalHeight(_ elements: [TextElement]) -> (bottom: CGFloat, top: CGFloat) {
        
        // Get the maximum top position and bottom position
        let top = elements.max(by: { $0.topPosition < $1.topPosition })?.topPosition ?? 0
        let bottom = elements.min(by: { $0.bottomPosition < $1.bottomPosition })?.bottomPosition ?? 0
        
        return (bottom: bottom, top: top)
    }
    
    // Get the next index
    func nextIndex(start: Int, parentheses: Int = 0) -> Int {
        
        var index = start + 1
        var parentheses = parentheses
        
        // Find the next close par
        while index < elements.count {
            let item = elements[index]
            if item.text == "(" || item.text == "#(" { parentheses += 1 }
            if item.text == ")" || item.text == "#)" || item.text == "\\)" { parentheses -= 1 }
            if parentheses == 0 && item.text != "#-1" && item.text != "#|" || index+1 == elements.count { break }
            index += 1
        }
        
        guard index < elements.count else { return start }
        
        // Format the entire selection
        let formatted = TextFormatting(elements: elements[start+1...index].map{$0})
        formatted.modeSettings = modes
        formatted.formatElements()
        elements.replaceSubrange(start+1...index, with: formatted.elements)
        
        // Adjust the index
        return start + formatted.elements.count
    }
    
    // Get the previous index
    func prevIndex(start: Int) -> Int {
        
        var index = start - 1
        var parentheses = 0
        
        // Find the prev open par
        while index >= 0 {
            let item = elements[index]
            let prev = index-1 >= 0 ? elements[index-1] : nil
            if item.text == ")" || item.text == "#)" || item.text == "\\)" { parentheses += 1 }
            if item.text == "(" || item.text == "#(" { parentheses -= 1 }
            if parentheses == 0 && !(prev?.text == "#-1" && item.text == "■") && item.text != "#|" { break }
            index -= 1
        }
        
        return index
    }
    
    // Get the last visible
    func lastVisible(start: Int) -> Int {
        return elements[0..<start].map{$0}.lastIndex(where: { $0.size > 0 }) ?? start
    }
    
    // Stroke size
    func strokeSize(_ size: CGFloat) -> CGFloat {
        return size * 0.1
    }
}
