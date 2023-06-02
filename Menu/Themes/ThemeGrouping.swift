//
//  ThemeGrouping.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/30/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct ThemeGrouping: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ObservedObject var settings = Settings.settings
    
    var category: ThemeCategory? = nil
    var themes: [Theme]
    var name: String? = nil
    
    var geometry: GeometryProxy
    
    @Binding var preview: ThemePreviewItem?
    @Binding var showUnlock: Bool
    
    var columns: Int {
        let maxColumns = Int(geometry.size.width/90)
        return themes.count >= maxColumns ? maxColumns : themes.count
    }
    
    var body: some View {
        
        ScrollView {
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns)) {
                
                ForEach(self.themes, id: \.id) { theme in
                    
                    Button(action: {
                        if !theme.locked {
                            theme.setTheme()
                        } else {
                            self.showUnlock.toggle()
                        }
                    }) {
                        VStack {

                            ThemeIcon(theme: theme, size: 70, locked: theme.locked, selected: self.settings.theme.name == theme.name)

                            Text(theme.name)
                                .font(Font.system(.footnote, design: .rounded).weight(.bold))
                                .lineLimit(0)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(Color.init(white: 0.7))
                                .frame(width: 70, height: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
                                .padding(.bottom, 5)
                        }
                    }
                    .contextMenu {
                        
                        if !theme.locked {
                        
                            Button(action: {
                                theme.setTheme()
                            }) {
                                Image(systemName: "arrow.up.right.circle")
                                Text("Set Color")
                            }
                            
                            Button(action: {
                                theme.favorite()
                            }) {
                                Image(systemName: "star\(theme.isFavorite ? ".fill" : "")")
                                Text(theme.isFavorite ? "Unfavorite" : "Favorite")
                            }
                        }
                        else {
                            
                            Button(action: {
                                self.showUnlock.toggle()
                            }) {
                                Image(systemName: "lock.open")
                                Text("Unlock")
                            }
                        }
                        
                        Button(action: {
                            self.preview = ThemePreviewItem(theme, category: category, name: name)
                        }) {
                            Image(systemName: "rectangle.on.rectangle")
                            Text("Preview")
                        }
                    }
                    .id(theme.id)
                    .animation(nil)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 5)
        }
        .animation(nil)
    }
}
