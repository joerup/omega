//
//  Number.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 11/18/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation

class Number: Value {
    
    var double: Double
    var string: String
    
    var negative: Bool
    var per: Int = 1
    
    var value: Double {
        return ( negative ? -double : double ) / Double(per)
    }
    
    var integer: Bool {
        return double <= Double(Int.max) && double == Double(Int(double)) && per == 1
    }
    var guaranteedInteger: Bool {
        return self.roundValue().integer && self.double <= 1e6
    }
    
    // MARK: - Input Double
    
    init(_ double: Double, roundPlaces: Int? = nil) {
        
        // MARK: Set the double
        
        // Negative
        if double < 0 {
            self.double = -double
            self.negative = true
        } else {
            self.double = double
            self.negative = false
        }
        
        // MARK: Set the string
        
        // Round the number
        var editedValue: Double {
            var multiplier: Double = pow(10, Double(roundPlaces ?? Settings.settings.roundPlaces))
            var whole = round(double * multiplier)
            while abs(whole) >= 1e12 {
                multiplier /= 10
                whole = round(double * multiplier)
            }
            return whole / multiplier
        }
        
        // Convert the double to a string
        var string = String(editedValue)
        
        // Remove extra zeroes from the beginning
        while String(string.prefix(1)) == "0" && String(string.prefix(2)) != "0." && string != "0" {
            string.removeFirst()
        }
        while String(string.prefix(2)) == "-0" && String(string.prefix(3)) != "-0." && string != "-0" {
            string.remove(at: string.firstIndex(of: "0")!)
        }
        
        // Remove decimal point and decimal zeroes if nothing follows them
        if string.contains(".") {
            
            // Remove the last digit if it is a 0, until it is not a 0
            while string.last == "0" {
                string.removeLast()
            }
            
            // Remove the decimal point if nothing follows it
            if string.last == "." {
                string.removeLast()
            }
        }
        
        // Remove negative from 0
        if string == "-0" {
            string = "0"
        }
        
        // Set the string
        self.string = string
    }
    
    // MARK: - Input String
    
    init(_ string: String, format: Bool = true) {
        
        // MARK: Set the string
        
        // Edit the string
        var editedString = string
        
        if format {
            
            // Remove extra zeroes from the beginning
            while String(editedString.prefix(1)) == "0" && editedString != "0" {
                editedString.removeFirst()
            }
            while String(editedString.prefix(2)) == "-0" && editedString != "-0" {
                editedString.remove(at: string.firstIndex(of: "0")!)
            }
            
            // Add zero in front of decimal
            if editedString.prefix(1) == "." {
                editedString = "0"+editedString
            }
            else if editedString.prefix(2) == "-." {
                editedString.removeFirst()
                editedString = "-0"+editedString
            }
        }
        
        // Set the string
        self.string = editedString
        
        // MARK: Set the double
        
        // Remove invisible markers
        if editedString.first == "#" {
            editedString.removeFirst()
        }
        
        // Set negative
        if editedString.first == "-" {
            editedString.removeFirst()
            self.negative = true
        } else {
            self.negative = false
        }
        
        // Set percent/mille
        if editedString.last == "%" {
            self.per = 100
            editedString.removeLast()
        }
        else if editedString.last == "‰" {
            self.per = 1000
            editedString.removeLast()
        }
        
        // Set repeating
        var repeating = 0
        while editedString.last == " ̅" {
            editedString.removeLast()
            repeating += 1
        }
        if repeating > 0 {
            // Get the repeating digits
            var digits = ""
            for _ in 0..<repeating {
                digits = [editedString.last ?? " "] + digits
                editedString.removeLast()
            }
            // Add the repeating digits
            while editedString.count < 20 {
                editedString += digits
            }
        }
        
        // Directly convert to double
        if let double = Double(editedString) {
            self.double = double
        }
        
        // Other values
        else {
            
            // Constant
            var double: Double {
                switch editedString {
                case "π":
                    return Double.pi
                case "e":
                    return M_E
                default:
                    return Double.nan
                }
            }
            
            // Set the double
            self.double = double
        }
    }
    
    // MARK: - Raw Conversion
    
    init(raw: [String:String]) {
        if let rawDouble = raw["double"], let double = Double(rawDouble) {
            self.double = double
        } else {
            self.double = 0
        }
        if let string = raw["string"] {
            self.string = string
        } else {
            self.string = "0"
        }
        if let rawNegative = raw["negative"], let negative = Bool(rawNegative) {
            self.negative = negative
        } else {
            self.negative = false
        }
        self.per = 1
    }
    
    // MARK: Round
    
    func roundValue(to places: Int? = nil) -> Number {
        var multiplier: Double = pow(10, Double(places ?? Settings.settings.roundPlaces))
        var whole = round(value * multiplier)
        while abs(whole) >= 1e12 {
            multiplier /= 10
            whole = round(value * multiplier)
        }
        return Number(whole / multiplier)
    }
    
    // MARK: Repeat
    
    func repeating() -> Number? {
        
        let string = String(self.value)
        
        guard string.count > 12 else { return nil }
            
        let decimal = string.firstIndex(of: ".") ?? string.startIndex
        let startIndex = string.distance(from: string.startIndex, to: decimal) + 1
        var startPos = 0
        var length = 1
        var position = 0
        var repeatValue = 0
        var numRepeats = 0
        var repeatingSequence = [Int]()
        
        bigboy: while startPos < 5 {
            length = 1
            while length <= 4 {
                // Create the repeating sequence
                var index = startIndex + startPos
                position = 0
                var repeating: Array<Int?> = Array(repeating: nil, count: length)
                while index < string.count {
                    let charIndex = string.index(string.startIndex, offsetBy: index)
                    let char = string[charIndex]
                    repeating[position] = Int(String(char))!
                    position += 1
                    index += 1
                    if position >= length {
                        position = 0
                        break
                    }
                }
                // Check if there is a repetition
                var stillRepeats = true
                while index < string.count {
                    let charIndex = string.index(string.startIndex, offsetBy: index)
                    let char = string[charIndex]
                    if repeating[position] != Int(String(char))! {
                        // See if the last digit was rounded
                        if !(index == string.count-1 && abs(repeating[position]! - Int(String(char))!) <= 3) {
                            stillRepeats = false
                            break
                        }
                    }
                    position += 1
                    index += 1
                    if position >= length {
                        position = 0
                        numRepeats += 1
                    }
                }
                // Set the repeat sequence
                if stillRepeats {
                    for item in repeating {
                        repeatingSequence += [item ?? 0]
                    }
                    // Make sure the repetition is not a 0 or 9 or did not repeat enough
                    if [[0],[9]].contains(repeatingSequence) || numRepeats < 3 {
                        repeatValue = 0
                    }
                    else {
                        repeatValue = length
                    }
                    break bigboy
                }
                length += 1
            }
            startPos += 1
        }
        
        // Create the repeating string
        if repeatValue > 0 {
            let startPosIndex = string.index(string.startIndex, offsetBy: startIndex + startPos)
            var num = String(string.prefix(upTo: startPosIndex))
            for item in repeatingSequence {
                num += String(item)
            }
            for _ in repeatingSequence {
                num += " ̅"
            }
            //print("REPEATING SEQUENCE >>> \(repeatingSequence) >>> pos \(startPos), length \(length), count \(numRepeats)")
            return Number(num)
        }
        
        return nil
    }
}
