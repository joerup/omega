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

class Theme {
    
    var id: Int
    var name: String
    
    var category: String
    
    var color1: Color
    var color2: Color
    var color3: Color
    
    var primaryColor: Color {
        switch id {
        case 36, 37, 38, 39: return color2
        default: return color1
        }
    }
    var primaryTextColor: Color {
        return primaryColor.lighter(by: 0.3)
    }
    var secondaryColor: Color {
        switch id {
        default: return color3
        }
    }
    var secondaryTextColor: Color {
        return secondaryColor.lighter(by: 0.3)
    }
    
    var isFavorite: Bool {
        return Settings.settings.favoriteThemes.contains(self.id)
    }
    
    // NOTE: Premium themes used to be unlocked via purchase of individual sets. Now they are only included in Omega Pro, but anyone who purchased them pre-2.0.2, when this model changed, will keep access. The Basic series is always available for everyone. The Colorful series was previously available for everyone, so anyone who downloaded pre-2.1.1 will have it, but anyone after will not.
    
    // Conditions for a theme to be LOCKED
    var locked: Bool {
        // no Pro
        !proCheck()
        // not in Basic category
        && category != "Basic"
        // not unlocked via individual purchase
        && !UserDefaults.standard.bool(forKey: "com.rupertusapps.OmegaCalc.ThemeSet\(ThemeData.categoryID(for: category))")
        // not in Colorful category (if feature version id 0)
        && !(category == "Colorful" && Settings.settings.featureVersionIdentifier == 0)
    }
    
    init(id: Int, name: String, category: String, color1: [CGFloat], color2: [CGFloat], color3: [CGFloat]) {
        self.id = id
        self.name = name
        self.category = category
        self.color1 = Color(rgb: color1)
        self.color2 = Color(rgb: color2)
        self.color3 = Color(rgb: color3)
    }
    
    func setTheme() {
        
        guard !locked else { return }
        
        Settings.settings.themeID = self.id
        Calculation.current.refresh()
        
        let impactMed = UIImpactFeedbackGenerator(style: .light)
        impactMed.impactOccurred()
        
        Theme.setAppIcon(theme: self)
    }
    
    func favorite() {
        if let index = Settings.settings.favoriteThemes.firstIndex(of: self.id) {
            Settings.settings.favoriteThemes.remove(at: index)
        } else {
            Settings.settings.favoriteThemes.append(self.id)
        }
    }
    
    static func setAppIcon(theme: Theme? = nil) {
        let theme = theme ?? Settings.settings.theme
        if UIApplication.shared.supportsAlternateIcons, theme.id != 0 || UIApplication.shared.alternateIconName != nil, UIApplication.shared.alternateIconName != theme.name {
            UIApplication.shared.setAlternateIconName(theme.name) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Theme set to \(theme.name)")
                }
            }
        }
    }
}

extension Theme: Identifiable { }

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


extension Color {
    init(rgb: [CGFloat]) {
        guard rgb.count == 3 else {
            self.init(.black)
            return
        }
        self.init(red: Double(rgb[0])/255, green: Double(rgb[1])/255, blue: Double(rgb[2])/255)
    }

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

    func greyed(by darkenPercentage: Double) -> Color {
        let originalColor = UIColor(self)
        
        guard let colorComponents = originalColor.cgColor.components, colorComponents.count >= 3 else {
            return self
        }
        
        let red = colorComponents[0]
        let green = colorComponents[1]
        let blue = colorComponents[2]
        let alpha = colorComponents[3]
        
        let darkenedRed = max(red - CGFloat(darkenPercentage), 0)
        let darkenedGreen = max(green - CGFloat(darkenPercentage), 0)
        let darkenedBlue = max(blue - CGFloat(darkenPercentage), 0)
        
        return Color(red: Double(darkenedRed), green: Double(darkenedGreen), blue: Double(darkenedBlue), opacity: Double(alpha))
    }

}
