//
//  Theme.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/7/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class Theme: ObservableObject, Codable {
    
    var id: Int
    var name: String
    
    var category: String
    var categoryID: Int
    
    var color1: [CGFloat]
    var color2: [CGFloat]
    var color3: [CGFloat]
    
    var isFavorite: Bool {
        return Settings.settings.favoriteThemes.contains(self.id)
    }
    
    var locked: Bool {
        return !proCheck() && !UserDefaults.standard.bool(forKey: "com.rupertusapps.OmegaCalc.ThemeSet\(ThemeData.categoryID(for: self.category))") && !["Basic","Colorful"].contains(self.category)
    }
    
    init(id: Int, name: String, category: String, color1: [CGFloat], color2: [CGFloat], color3: [CGFloat]) {
        self.id = id
        self.name = name
        self.category = category
        self.categoryID = id%4
        self.color1 = color1
        self.color2 = color2
        self.color3 = color3
    }
    
    func setTheme() {
        
        guard !locked else { return }
        
        Settings.settings.themeID = self.id
        
        let impactMed = UIImpactFeedbackGenerator(style: .light)
        impactMed.impactOccurred()
        
        if UIApplication.shared.supportsAlternateIcons {
            UIApplication.shared.setAlternateIconName(self.name) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("App Icon changed to \(self.name)")
                }
            }
        }
    }
    
    func favorite() {
        if let index = Settings.settings.favoriteThemes.firstIndex(of: self.id) {
            Settings.settings.favoriteThemes.remove(at: index)
        } else {
            Settings.settings.favoriteThemes.append(self.id)
        }
    }
}

class ThemeCategory {
    
    var id: Int
    var name: String
    
    var themes: [Theme]
    
    init(id: Int, name: String, themes: [Theme]) {
        self.id = id
        self.name = name
        self.themes = themes
    }
}

func color(_ rgb: [CGFloat], opacity: Double = 1, edit: Bool = false) -> Color {
    
    guard rgb.count == 3 else {
        return Color.black
    }
    
    var red = Double(rgb[0])
    var green = Double(rgb[1])
    var blue = Double(rgb[2])
    
    if edit {
        if red < 100 && green < 100 && blue < 100 {
            if red == green && green == blue {
                red += 100
                green += 100
                blue += 100
            }
            else {
                red += 75
                green += 75
                blue += 75
            }
        }
    }
    
    let color = Color.init(red: red/255, green: green/255, blue: blue/255, opacity: opacity)
    
    return color
}

extension Color {

    func lighter(by percentage: CGFloat = 0.5) -> Color {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 0.5) -> Color {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 0.5) -> Color {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return Color(UIColor(red: red + percentage*(1-red),
                           green: green + percentage*(1-green),
                           blue: blue + percentage*(1-blue),
                           alpha: alpha))
        } else {
            return self
        }
    }
}
