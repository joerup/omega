//
//  ThemeDescription.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/30/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct ThemeDescription: View {
    
    @ObservedObject var settings = Settings.settings
    
    var theme: Theme
    
    var body: some View {
        
        HStack {
            
            ThemeIcon(theme: theme, size: 75, selected: true)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Theme")
                    .font(Font.system(.headline, design: .rounded).weight(.bold))
                    .foregroundColor(Color.init(white: 0.7))
                Text(theme.name)
                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 3)
                ThemeCircles(theme: theme)
                    .padding(.horizontal, 2)
                    .padding(.vertical, 5)
            }
            .padding(.leading, 10)
            
            Spacer()
        }
        .padding(.vertical, 15)
    }
}
