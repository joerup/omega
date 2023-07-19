//
//  ThemeIcon.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/6/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct ThemeIcon: View {
    
    var theme: Theme = Settings.settings.theme
    var locked: Bool = false
    var selected: Bool = false
    
    var body: some View {
        Image("Omega_\(theme.name.replacingOccurrences(of: " ", with: "_"))")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(20)
            .opacity(locked ? 0.3 : 1)
    }
}


struct ThemeCircles: View {
    
    var theme: Theme
    
    var body: some View {
        
        HStack {
            Circle()
                .fill(color(theme.color1))
                .frame(width: 10, height: 10)
            Circle()
                .fill(color(theme.color2))
                .frame(width: 10, height: 10)
            Circle()
                .fill(color(theme.color3))
                .frame(width: 10, height: 10)
        }
        .shadow(color: Color.init(white: 0.4), radius: 20)
    }
}
