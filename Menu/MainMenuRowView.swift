//
//  MainMenuRowView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/6/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct MainMenuRowView: View {
    
    @ObservedObject var settings = Settings.settings
    
    var type: MenuType
    @Binding var selected: MenuType?
    
    var themeCircles: Bool = false
    var size = UIFont.preferredFont(forTextStyle: .headline).pointSize*3
    
    var body: some View {
        
        Button(action: {
            self.selected = type
        }) {
            
            HStack {
                    
                Image(systemName: self.type.icon)
                    .font(.headline.bold())
                    .frame(minWidth: size, minHeight: size)
                    .foregroundColor(selected == type ? .white : color(settings.theme.color1, edit: true))
                    .background(selected == type ? color(settings.theme.color1, edit: true) : Color.init(white: 0.2))
                    .cornerRadius(size/2)
                
                Text(LocalizedStringKey(self.type.text))
                    .foregroundColor(Color.init(white: 0.9))
                    .font(Font.system(.headline, design: .rounded).weight(.bold))
                    .minimumScaleFactor(0.4)
                    .multilineTextAlignment(.leading)
                    .padding(4)
                
                Spacer()
                
                if themeCircles {
                    ThemeCircles(theme: settings.theme)
                        .padding(.horizontal)
                }
                
                Image(systemName: "chevron.forward")
                    .imageScale(.small)
                    .foregroundColor(Color.init(white: 0.6))
                    .padding(.trailing, 20)
            }
            .background(Color.init(white: selected == type ? 0.2 : 0.1))
            .cornerRadius(size/2)
            .padding(.horizontal, 5)
            .padding(.top, 5)
        }
    }
}
