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
            
            VStack {
                Spacer(minLength: 0)
                ThemeIcon(theme: theme, selected: true)
                    .frame(maxHeight: 60)
                    .cornerRadius(15)
                Spacer(minLength: 0)
            }
            
            VStack(alignment: .leading) {
                Text("Current Theme")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundColor(Color.init(white: 0.8))
                Text(theme.name)
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 5)

            Spacer(minLength: 0)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, -5)
    }
}
