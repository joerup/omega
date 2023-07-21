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
    var hasColumns: Bool = false
    
    @Binding var preview: ThemePreviewItem?
    @Binding var showUnlock: Theme?
    
    var size: CGFloat {
        return hasColumns ? 65 : 70
    }
    var columns: Int {
        return Int((hasColumns ? 0.5 : 1) * geometry.size.width/(size*1.25))
    }
    
    var body: some View {
        
        ScrollView {
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns)) {
                
                ForEach(self.themes, id: \.id) { theme in
                    
                    Button(action: { }) {
                        VStack {
                            ThemeIcon(theme: theme, locked: theme.locked, selected: settings.theme.id == theme.id)
                                .cornerRadius(20)
                                .padding(.horizontal, 5)
                                .overlay(alignment: .bottomTrailing) {
                                    if settings.theme.id == theme.id {
                                        ZStack {
                                            Image(systemName: "circle.fill")
                                                .foregroundColor(theme.secondaryColor.opacity(0.9))
                                                .imageScale(.large)
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.white)
                                                .imageScale(.small)
                                        }
                                        .shadow(radius: 5)
                                        .padding(.bottom, -5)
                                    }
                                }

                            Text(theme.name)
                                .font(Font.system(.footnote, design: .rounded).weight(.bold))
                                .lineLimit(0)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.white)
                            
                            ThemeCircles(theme: theme)
                                .padding(.bottom, 10)
                                .padding(.top, -5)
                        }
                        .onTapGesture {
                            if !theme.locked {
                                theme.setTheme()
                            } else {
                                showUnlock = theme
                            }
                        }
                        .onLongPressGesture {
                            if !theme.locked {
                                theme.favorite()
                                settings.notification = theme.isFavorite ? .favorite : .unfavorite
                            } else {
                                showUnlock = theme
                            }
                        }
                    }
                    .id(theme.id)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 5)
        }
    }
}
