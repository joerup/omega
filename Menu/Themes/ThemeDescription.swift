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
            
            ThemeIcon(theme: theme, selected: true)
                .frame(maxHeight: 60)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Current Theme")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(Color.init(white: 0.8))
                Text(theme.name)
                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 1)
            }
            .padding(.leading, 5)
            
            Spacer()
        }
        .padding(.vertical, 5)
        .padding(.horizontal, -5)
    }
}
