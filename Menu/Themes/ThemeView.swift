//
//  ThemeView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/25/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct ThemeView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ObservedObject var settings = Settings.settings
    
    @StateObject var storeManager: StoreManager
    
    @State private var showPreview: Bool = false
    @State private var preview: ThemePreviewItem? = nil
    @State private var showUnlock: Theme? = nil
    
    private var favorites: [Theme] {
        return settings.favoriteThemes.map { ThemeData.allThemes[$0] }
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                ScrollView {
                    
                    VStack(spacing: 20) {
                        
                        SettingsGroup {
                            ThemeDescription(theme: settings.theme)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                        }
                        
                        SettingsGroup {
                            
                            SettingsRow {
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    
                                    HStack {
                                        Text("Favorites")
                                            .font(Font.system(.body, design: .rounded).weight(.bold))
                                        Spacer()
                                    }
                                    .padding(.top, 17)
                                    .padding(.horizontal, 5)
                                    
                                    if favorites.isEmpty {
                                        Text("Press and hold on a theme to favorite it.")
                                            .font(.caption)
                                            .foregroundColor(Color.init(white: 0.6))
                                            .multilineTextAlignment(.center)
                                            .dynamicTypeSize(..<DynamicTypeSize.xxxLarge)
                                            .frame(maxWidth: .infinity)
                                            .padding(.top, 20)
                                            .padding(.bottom, 30)
                                            .padding(.horizontal, 5)
                                    } else {
                                        ThemeGrouping(themes: favorites, name: "Favorite Colors", geometry: geometry, preview: $preview, showUnlock: $showUnlock)
                                            .padding(.vertical, 5)
                                    }
                                }
                                .padding(.vertical, -10)
                            }
                            .padding(.horizontal, -5)
                        }
                        
                        SettingsGroup(columns: geometry.size.width > 700) {
                            
                            ForEach(ThemeData.themes, id: \.id) { category in
                                
                                SettingsRow {
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        
                                        AStack {
                                            
                                            Text("\(category.name)")
                                                .font(Font.system(.body, design: .rounded).weight(.bold))
                                                .lineLimit(0)
                                            
                                            Spacer()
                                            
                                            HStack {
                                                
                                                if category.themes[0].locked {
                                                    
                                                    Button(action: {
                                                        showUnlock = category.themes[0]
                                                        settings.setPreviewThemes(without: category.themes[0])
                                                    }) {
                                                        Text(NSLocalizedString("Unlock", comment: "").uppercased())
                                                            .font(Font.system(.caption, design: .rounded).weight(.bold))
                                                            .lineLimit(0)
                                                            .minimumScaleFactor(0.5)
                                                            .foregroundColor(.white.opacity(0.8))
                                                    }
                                                    .padding(.leading, 10)
                                                }
                                                
                                                Button(action: {
                                                    self.showPreview.toggle()
                                                    self.preview = ThemePreviewItem(category.themes[0], category: category)
                                                }) {
                                                    Text(NSLocalizedString("Preview", comment: "").uppercased())
                                                        .font(Font.system(.caption, design: .rounded).weight(.bold))
                                                        .lineLimit(0)
                                                        .minimumScaleFactor(0.5)
                                                        .foregroundColor(.white.opacity(0.8))
                                                }
                                                .padding(.leading, 10)
                                            }
                                            .dynamicTypeSize(..<DynamicTypeSize.accessibility1)
                                        }
                                        .padding(.top, 17)
                                        .padding(.horizontal, 5)
                                        .padding(.bottom, 5)
                                        
                                        ThemeGrouping(category: category, themes: category.themes, geometry: geometry, hasColumns: geometry.size.width > 700, preview: $preview, showUnlock: $showUnlock)
                                            .padding(.bottom, 3)
                                    }
                                    .padding(.vertical, -10)
                                }
                            }
                            .padding(.horizontal, -5)
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
        }
        .sheet(item: self.$showUnlock) { theme in
            OmegaProSplash(storeManager: storeManager)
                .onAppear {
                    settings.proPopUpType = .themes
                    settings.previewTheme1 = theme
                }
        }
        .sheet(isPresented: self.$showPreview) {
            ThemePreview(preview: self.$preview)
        }
    }
}
