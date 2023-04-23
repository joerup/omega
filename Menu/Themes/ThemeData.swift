//
//  ThemeData.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/8/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class ThemeData {
    
    static var allThemes: [Theme] {
        var themes: [Theme] = []
        ThemeData.themes.forEach { themes += $0.themes }
        return themes
    }
    
    static func categoryID(for name: String) -> Int {
        switch name {
        case "The Land":
            return 0
        case "The Sea":
            return 1
        case "The Sky":
            return 2
        case "Animals":
            return 3
        case "Food":
            return 4
        case "Festive":
            return 5
        case "Gemstones":
            return 6
        default:
            return -1
        }
    }
    
    static let themes = [
        
        ThemeCategory(id: 0, name: "Basic", themes: [
            
                Theme(id: 0,
                      name: "Classic Blue",
                      category: "Basic",
                      color1: [040,130,240], // Light Blue
                      color2: [230,120,020], // Orange
                      color3: [030,080,180] // Dark Blue
                ),
            
                Theme(id: 1,
                      name: "Classic Pink",
                      category: "Basic",
                      color1: [245,135,208], // Light Pink
                      color2: [255,144,070], // Orange
                      color3: [229,037,210] // Hot Pink
                ),
                
                Theme(id: 2,
                      name: "Light",
                      category: "Basic",
                      color1: [200,200,200], // White
                      color2: [100,100,100], // Dark Gray
                      color3: [150,150,150] // Gray
                ),
                
                Theme(id: 3,
                      name: "Dark",
                      category: "Basic",
                      color1: [055,055,055], // Dark Gray
                      color2: [032,032,032], // Black
                      color3: [073,073,073] // Gray
                ),
            ]
        ),
        
        ThemeCategory(id: 1, name: "Colorful", themes: [
        
                Theme(id: 4,
                      name: "Warm",
                      category: "Colorful",
                      color1: [244,061,063], // Pinkish Red
                      color2: [232,094,024], // Orange
                      color3: [156,014,010] // Dark Red
                ),
                
                Theme(id: 5,
                      name: "Cool",
                      category: "Colorful",
                      color1: [180,230,240], // Light Blue
                      color2: [200,020,200], // Magenta
                      color3: [000,180,200] // Light Blue
                ),
                
                Theme(id: 6,
                      name: "Life",
                      category: "Colorful",
                      color1: [075,200,102], // Bright Green
                      color2: [040,177,190], // Blue
                      color3: [015,115,050] // Dark Green
                ),
                
                Theme(id: 7,
                      name: "Pastel",
                      category: "Colorful",
                      color1: [200,225,176], // Light Green
                      color2: [176,176,225], // Light Blue
                      color3: [225,200,176] // Light Orange
                ),
            ]
        ),
        
        ThemeCategory(id: 2, name: "The Land", themes: [
            
                Theme(id: 8,
                      name: "Grassy",
                      category: "The Land",
                      color1: [065,233,087], // Lime Green
                      color2: [240,210,087], // Yellow
                      color3: [034,132,047] // Dark Green
                ),
                
                Theme(id: 9,
                      name: "Mountain",
                      category: "The Land",
                      color1: [201,169,218], // Light Purple
                      color2: [101,141,159], // Dark Teal
                      color3: [095,058,115] // Dark Purple
                ),
                
                Theme(id: 10,
                      name: "Desert",
                      category: "The Land",
                      color1: [210,176,147], // Tan
                      color2: [135,155,142], // Dull Green
                      color3: [196,124,083] // Brown Orange
                ),
                
                Theme(id: 11,
                      name: "Floral",
                      category: "The Land",
                      color1: [184,043,216], // Purple
                      color2: [218,236,056], // Yellow Green
                      color3: [132,032,213] // Dark Purple
                ),
            ]
        ),
        
        ThemeCategory(id: 3, name: "The Sea", themes: [
                
                Theme(id: 12,
                      name: "Aquatic",
                      category: "The Sea",
                      color1: [115,215,235], // Light Blue
                      color2: [242,065,011], // Scarlet
                      color3: [025,143,166] // Teal
                ),
                
                Theme(id: 13,
                      name: "Scuba",
                      category: "The Sea",
                      color1: [000,030,150], // Blue
                      color2: [000,090,030], // Dark Green
                      color3: [000,025,100] // Dark Blue
                ),
                
                Theme(id: 14,
                      name: "Sailboat",
                      category: "The Sea",
                      color1: [224,055,055], // Red
                      color2: [209,171,145], // Beige
                      color3: [002,191,212] // Light Blue
                ),
                
                Theme(id: 15,
                      name: "Coral",
                      category: "The Sea",
                      color1: [053,138,159], // Blue-Gray
                      color2: [144,083,205], // Purple
                      color3: [053,074,159] // Indigo
                ),
            ]
        ),
        
        ThemeCategory(id: 4, name: "The Sky", themes: [
        
                Theme(id: 16,
                      name: "Galaxy",
                      category: "The Sky",
                      color1: [150,010,200], // Purple
                      color2: [231,020,243], // Magenta
                      color3: [000,002,154] // Blue
                ),
                
                Theme(id: 17,
                      name: "Sunset",
                      category: "The Sky",
                      color1: [252,031,090], // Pinkish Red
                      color2: [236,075,236], // Magenta
                      color3: [252,141,031] // Orangey Yellow
                ),
                
                Theme(id: 18,
                      name: "Moonlight",
                      category: "The Sky",
                      color1: [212,212,212], // White
                      color2: [000,027,100], // Dark Blue
                      color3: [000,014,065] // Darker Blue
                ),
                
                Theme(id: 19,
                      name: "Alien",
                      category: "The Sky",
                      color1: [089,239,169], // Light Green
                      color2: [074,183,205], // Light Blue
                      color3: [184,136,202] // Light Purple
                ),
            ]
        ),
        
        ThemeCategory(id: 5, name: "Animals", themes: [
        
                Theme(id: 20,
                      name: "Caterpillar",
                      category: "Animals",
                      color1: [000,207,242], // Aqua
                      color2: [157,212,040], // Yellow Green
                      color3: [020,135,170] // Dark Aqua
                ),
                
                Theme(id: 21,
                      name: "Turtle",
                      category: "Animals",
                      color1: [142,179,152], // Dull Green
                      color2: [210,239,218], // Very Light Green
                      color3: [004,081,032] // Dark Green
                ),
                
                Theme(id: 22,
                      name: "Unicorn",
                      category: "Animals",
                      color1: [253,091,145], // Pink
                      color2: [054,010,118], // Indigo
                      color3: [195,188,205] // White
                ),
                
                Theme(id: 23,
                      name: "Robin",
                      category: "Animals",
                      color1: [060,208,225], // Light Blue
                      color2: [234,061,002], // Scarlet
                      color3: [004,135,087] // Teal
                ),
            ]
        ),
        
        ThemeCategory(id: 6, name: "Food", themes: [
            
                Theme(id: 24,
                      name: "Watermelon",
                      category: "Food",
                      color1: [228,051,090], // Red Violet
                      color2: [104,223,024], // Lime Green
                      color3: [023,170,006] // Dark Green
                ),
                
                Theme(id: 25,
                      name: "Cookie",
                      category: "Food",
                      color1: [201,149,047], // Dough
                      color2: [125,090,014], // Brown
                      color3: [043,031,016] // Chocolate
                ),
                
                Theme(id: 26,
                      name: "Pineapple",
                      category: "Food",
                      color1: [200,168,000], // Yellow
                      color2: [115,056,002], // Brown
                      color3: [010,141,016] // Green
                ),
                
                Theme(id: 27,
                      name: "Jelly",
                      category: "Food",
                      color1: [210,043,144], // Rose
                      color2: [112,016,106], // Fuschia
                      color3: [038,016,112] // Dark Blue
                ),
            ]
        ),
        
        ThemeCategory(id: 7, name: "Festive", themes: [

                Theme(id: 28,
                      name: "Hearts",
                      category: "Festive",
                      color1: [214,020,191], // Pink
                      color2: [148,023,169], // Purple
                      color3: [201,014,092] // Red
                ),
                
                Theme(id: 29,
                      name: "Fireworks",
                      category: "Festive",
                      color1: [210,210,210], // White
                      color2: [200,000,000], // Red
                      color3: [000,000,186] // Blue
                ),
                
                Theme(id: 30,
                      name: "Pumpkin",
                      category: "Festive",
                      color1: [249,133,044], // Orange
                      color2: [145,057,025], // Chestnut
                      color3: [225,060,000] // Scarlet
                ),
                
                Theme(id: 31,
                      name: "Holiday",
                      category: "Festive",
                      color1: [157,000,000], // Red
                      color2: [210,210,210], // White
                      color3: [005,142,005] // Dark Green
                ),
            ]
        ),
        
        ThemeCategory(id: 8, name: "Gemstones", themes: [

                Theme(id: 32,
                      name: "Gold",
                      category: "Gemstones",
                      color1: [240,200,000],
                      color2: [255,220,100],
                      color3: [200,150,000]
                ),
                
                Theme(id: 33,
                      name: "Ruby",
                      category: "Gemstones",
                      color1: [220,055,090],
                      color2: [155,017,030],
                      color3: [198,031,095]
                ),
                
                Theme(id: 34,
                      name: "Amethyst",
                      category: "Gemstones",
                      color1: [165,031,226],
                      color2: [182,160,206],
                      color3: [180,124,255]
                ),
                
                Theme(id: 35,
                      name: "Emerald",
                      category: "Gemstones",
                      color1: [000,210,155],
                      color2: [150,235,200],
                      color3: [018,121,091]
                ),
            ]
        )
    ]
}
