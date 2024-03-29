//
//  ThemeData.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/8/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation  

class ThemeData {
    
    static var allThemes: [Theme] {
        var themes: [Theme] = []
        ThemeData.themes.forEach({ themes += $0.themes })
        return themes.sorted(by: { $0.id < $1.id })
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
                      name: "Classic",
                      category: "Basic",
                      color1: [40,130,240],
                      color2: [230,119,20],
                      color3: [47,69,188]
                ),
            
                Theme(id: 1,
                      name: "Special",
                      category: "Basic",
                      color1: [245,131,204],
                      color2: [254,141,79],
                      color3: [229,33,169]
                ),
                
                Theme(id: 2,
                      name: "Light",
                      category: "Basic",
                      color1: [170,178,177],
                      color2: [96,98,110],
                      color3: [131,140,142]
                ),
                
                Theme(id: 3,
                      name: "Dark",
                      category: "Basic",
                      color1: [80,80,80],
                      color2: [53,55,55],
                      color3: [132,136,136]
                ),
            ]
        ),
        
        ThemeCategory(id: 1, name: "Monochrome", themes: [
            
                Theme(id: 36,
                      name: "System",
                      category: "Monochrome",
                      color1: [80,80,80],
                      color2: [271,142,0],
                      color3: [132,136,136]
                ),
                
                Theme(id: 37,
                      name: "Electric",
                      category: "Monochrome",
                      color1: [80,80,80],
                      color2: [0,119,243],
                      color3: [131,136,136]
                ),
                
                Theme(id: 38,
                      name: "Boost",
                      category: "Monochrome",
                      color1: [80,80,80],
                      color2: [0,201,18],
                      color3: [131,136,136]
                ),
                
                Theme(id: 39,
                      name: "Neon",
                      category: "Monochrome",
                      color1: [80,80,80],
                      color2: [255,57,125],
                      color3: [131,136,136]
                ),
            ]
        ),
        
        ThemeCategory(id: 2, name: "Elements", themes: [
        
                Theme(id: 4,
                      name: "Fire",
                      category: "Colorful",
                      color1: [243,32,44],
                      color2: [237,121,20],
                      color3: [185,42,67]
                ),
                
                Theme(id: 5,
                      name: "Water",
                      category: "Colorful",
                      color1: [61,200,235],
                      color2: [206,86,216],
                      color3: [71,135,201]
                ),
                
                Theme(id: 6,
                      name: "Earth",
                      category: "Colorful",
                      color1: [74,200,101],
                      color2: [37,178,175],
                      color3: [14,115,59]
                ),
                
                Theme(id: 7,
                      name: "Air",
                      category: "Colorful",
                      color1: [146,195,160],
                      color2: [152,151,215],
                      color3: [181,150,138]
                ),
            ]
        ),
        
        ThemeCategory(id: 3, name: "Gemstones", themes: [

                Theme(id: 32,
                      name: "Gold",
                      category: "Gemstones",
                      color1: [242,181,-17],
                      color2: [162,133,106],
                      color3: [220,143,11]
                ),
                
                Theme(id: 33,
                      name: "Ruby",
                      category: "Gemstones",
                      color1: [235,50,96],
                      color2: [139,37,83],
                      color3: [186,33,103]
                ),
                
                Theme(id: 34,
                      name: "Amethyst",
                      category: "Gemstones",
                      color1: [165,31,226],
                      color2: [182,160,206],
                      color3: [180,124,254]
                ),
                
                Theme(id: 35,
                      name: "Emerald",
                      category: "Gemstones",
                      color1: [17,196,139],
                      color2: [2,123,110],
                      color3: [29,111,83]
                ),
            ]
        ),
        
        ThemeCategory(id: 4, name: "The Land", themes: [
            
                Theme(id: 8,
                      name: "Grassy",
                      category: "The Land",
                      color1: [95,193,44],
                      color2: [177,201,27],
                      color3: [57,132,43]
                ),
                
                Theme(id: 9,
                      name: "Mountain",
                      category: "The Land",
                      color1: [184,160,207],
                      color2: [101,131,159],
                      color3: [97,68,130]
                ),
                
                Theme(id: 10,
                      name: "Desert",
                      category: "The Land",
                      color1: [212,172,136],
                      color2: [135,155,142],
                      color3: [196,124,83]
                ),
                
                Theme(id: 11,
                      name: "Floral",
                      category: "The Land",
                      color1: [174,56,218],
                      color2: [149,185,46],
                      color3: [123,71,196]
                ),
            ]
        ),
        
        ThemeCategory(id: 5, name: "The Sea", themes: [
                
                Theme(id: 12,
                      name: "Aquatic",
                      category: "The Sea",
                      color1: [103,194,229],
                      color2: [242,65,10],
                      color3: [43,124,139]
                ),
                
                Theme(id: 13,
                      name: "Scuba",
                      category: "The Sea",
                      color1: [38,68,217],
                      color2: [0,117,65],
                      color3: [49,43,144]
                ),
                
                Theme(id: 14,
                      name: "Sailboat",
                      category: "The Sea",
                      color1: [223,59,97],
                      color2: [191,157,154],
                      color3: [0,163,212]
                ),
                
                Theme(id: 15,
                      name: "Coral",
                      category: "The Sea",
                      color1: [0,164,170],
                      color2: [117,92,211],
                      color3: [83,63,190]
                ),
            ]
        ),
        
        ThemeCategory(id: 6, name: "The Sky", themes: [
        
                Theme(id: 16,
                      name: "Galaxy",
                      category: "The Sky",
                      color1: [132,15,200],
                      color2: [204,47,236],
                      color3: [55,44,157]
                ),
                
                Theme(id: 17,
                      name: "Sunset",
                      category: "The Sky",
                      color1: [236,43,79],
                      color2: [232,95,148],
                      color3: [238,129,84]
                ),
                
                Theme(id: 18,
                      name: "Moonlight",
                      category: "The Sky",
                      color1: [24,99,133],
                      color2: [194,175,164],
                      color3: [29,59,97]
                ),
                
                Theme(id: 19,
                      name: "Alien",
                      category: "The Sky",
                      color1: [1,209,135],
                      color2: [121,170,192],
                      color3: [176,124,186]
                ),
            ]
        ),
        
        ThemeCategory(id: 7, name: "Animals", themes: [
        
                Theme(id: 20,
                      name: "Caterpillar",
                      category: "Animals",
                      color1: [29,198,242],
                      color2: [150,219,35],
                      color3: [31,121,172]
                ),
                
                Theme(id: 21,
                      name: "Turtle",
                      category: "Animals",
                      color1: [130,184,151],
                      color2: [90,116,143],
                      color3: [69,105,87]
                ),
                
                Theme(id: 22,
                      name: "Unicorn",
                      category: "Animals",
                      color1: [225,121,143],
                      color2: [109,43,100],
                      color3: [192,158,160]
                ),
                
                Theme(id: 23,
                      name: "Robin",
                      category: "Animals",
                      color1: [56,194,219],
                      color2: [253,82,110],
                      color3: [4,133,110]
                ),
            ]
        ),
        
        ThemeCategory(id: 8, name: "Food", themes: [
            
                Theme(id: 24,
                      name: "Watermelon",
                      category: "Food",
                      color1: [218,52,90],
                      color2: [118,191,43],
                      color3: [40,136,31]
                ),
                
                Theme(id: 25,
                      name: "Cookie",
                      category: "Food",
                      color1: [201,136,48],
                      color2: [121,90,56],
                      color3: [80,57,53]
                ),
                
                Theme(id: 26,
                      name: "Pineapple",
                      category: "Food",
                      color1: [224,173,-34],
                      color2: [141,99,4],
                      color3: [-22,143,98]
                ),
                
                Theme(id: 27,
                      name: "Jelly",
                      category: "Food",
                      color1: [210,43,144],
                      color2: [111,15,105],
                      color3: [61,49,129]
                ),
            ]
        ),
        
        ThemeCategory(id: 9, name: "Festive", themes: [

                Theme(id: 28,
                      name: "Hearts",
                      category: "Festive",
                      color1: [243,80,165],
                      color2: [160,59,178],
                      color3: [198,46,88]
                ),
                
                Theme(id: 29,
                      name: "Fireworks",
                      category: "Festive",
                      color1: [159,170,207],
                      color2: [224,54,67],
                      color3: [64,82,184]
                ),
                
                Theme(id: 30,
                      name: "Pumpkin",
                      category: "Festive",
                      color1: [248,136,34],
                      color2: [150,69,32],
                      color3: [226,91,25]
                ),
                
                Theme(id: 31,
                      name: "Holiday",
                      category: "Festive",
                      color1: [174,34,38],
                      color2: [177,141,96],
                      color3: [36,127,35]
                ),
            ]
        ),
    ]
}
