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
    
    @Binding var preview: ThemePreviewItem?
    
    var body: some View {
        
        HStack {
            
            ThemeIcon(theme: theme, size: 75, selected: true)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(theme.name)
                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                Text("\(theme.category) Series")
                    .font(Font.system(.headline, design: .rounded).weight(.bold))
                    .foregroundColor(Color.init(white: 0.7))
                    .padding(.vertical, 3)
                ThemeCircles(theme: theme)
                    .padding(.horizontal, 2)
                    .padding(.vertical, 5)
            }
            .padding(.leading, 10)
            
            Spacer()
            
            VStack {
                Button(action: {
                    theme.favorite()
                }) {
                    Image(systemName: "star\(theme.isFavorite ? ".fill" : "")")
                        .imageScale(.large)
                        .foregroundColor(theme.isFavorite ? color(theme.color1) : Color.init(white: 0.6))
                }
                Spacer()
                Button(action: {
                    self.preview = ThemePreviewItem(theme, name: "Current Color")
                }) {
                    Image(systemName: "rectangle.on.rectangle")
                        .foregroundColor(Color.init(white: 0.6))
                }
                .padding(.bottom, 2)
            }
            
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 15)
    }
}
