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
    @State private var showUnlock: Bool = false
    
    private var favorites: [Theme] {
        return settings.favoriteThemes.map{ ThemeData.allThemes[$0] }
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                NavigationHeader("Themes")
                
                ScrollView {
                    
                    VStack(spacing: 20) {
                        
                        SettingsGroup {
                            ThemeDescription(theme: settings.theme)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 10)
                        }
                        
                        SettingsGroup {
                            
                            SettingsRow {
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    
                                    HStack {
                                        Text("Favorite Colors")
                                            .font(Font.system(.body, design: .rounded).weight(.bold))
                                        Spacer()
                                    }
                                    .padding(.top, 17)
                                    .padding(.horizontal, 5)
                                    
                                    if favorites.isEmpty {
                                        Text("No favorite colors. Press and hold on an icon to favorite it.")
                                            .font(.caption)
                                            .foregroundColor(Color.init(white: 0.6))
                                            .multilineTextAlignment(.center)
                                            .frame(maxWidth: .infinity)
                                            .padding(.top, 20)
                                            .padding(.bottom, 30)
                                            .padding(.horizontal, 5)
                                    } else {
                                        SettingsRow {
                                            ThemeGrouping(themes: favorites, name: "Favorite Colors", geometry: geometry, preview: $preview, showUnlock: $showUnlock)
                                                .padding(-5)
                                        }
                                    }
                                }
                                .padding(.vertical, -10)
                            }
                        }
                        
                        SettingsGroup(columns: geometry.size.width > 700) {
                            
                            ForEach(ThemeData.themes, id: \.id) { category in
                                
                                SettingsRow {
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        
                                        HStack {
                                            
                                            Text("\(category.name) Series")
                                                .font(Font.system(.body, design: .rounded).weight(.bold))
                                            
                                            Spacer()
                                            
                                            if category.themes[0].locked {
                                                
                                                Button(action: {
                                                    showUnlock.toggle()
                                                }) {
                                                    Text(NSLocalizedString("Unlock", comment: "").uppercased())
                                                        .font(Font.system(.caption, design: .rounded).weight(.bold))
                                                        .lineLimit(0)
                                                        .minimumScaleFactor(0.5)
                                                }
                                                .padding(.horizontal, 10)
                                            }
                                            
                                            Button(action: {
                                                self.showPreview.toggle()
                                                self.preview = ThemePreviewItem(category.themes[0], category: category)
                                            }) {
                                                Text(NSLocalizedString("Preview", comment: "").uppercased())
                                                    .font(Font.system(.caption, design: .rounded).weight(.bold))
                                                    .lineLimit(0)
                                                    .minimumScaleFactor(0.5)
                                            }
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
                        }
                        
                        Button(action: {
                            showUnlock.toggle()
                        }) {
                            Text("Unlock Colors")
                                .font(Font.system(.headline, design: .rounded).weight(.bold))
                                .padding(20)
                        }
                        
                        Spacer()
                            .frame(height: 50)
                    }
                    .padding(.horizontal, 5)
                }
            }
        }
        .sheet(isPresented: self.$showUnlock) {
            OmegaProSplash(storeManager: storeManager)
                .onAppear {
                    settings.proPopUpType = .themes
                }
        }
        .sheet(isPresented: self.$showPreview) {
            ThemePreview(preview: self.$preview)
        }
    }
}
