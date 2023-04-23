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
    
    @State private var preview: ThemePreviewItem? = nil
    @State private var showUnlock: Bool = false
    @State private var promptUnlock: Bool = false
    
    private var favorites: [Theme] {
        return settings.favoriteThemes.map{ ThemeData.allThemes[$0] }
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    SettingsGroup("Current Color") {
                        
                        SettingsRow {
                            ThemeDescription(theme: settings.theme, preview: self.$preview)
                        }
                    }
                    
                    SettingsGroup("Favorite Colors") {
                        
                        if favorites.isEmpty {
                            
                            Text("No favorite colors. Press and hold on an icon to favorite it.")
                                .font(Font.system(.caption, design: .rounded))
                                .foregroundColor(Color.init(white: 0.6))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(30)
                            
                        } else {
                            
                            SettingsRow {
                                ThemeGrouping(themes: favorites, name: "Favorite Colors", geometry: geometry, preview: self.$preview, showUnlock: self.$showUnlock)
                                    .padding(.vertical, 5)
                            }
                        }
                    }
                    
                    SettingsGroup("All Colors", columns: geometry.size.width > 700) {
                        
                        ForEach(ThemeData.themes, id: \.id) { category in
                            
                            SettingsRow {
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    
                                    HStack {
                                        
                                        Text("\(category.name) Series")
                                            .font(Font.system(.body, design: .rounded).weight(.bold))
                                            .animation(nil)
                                        
                                        Spacer()
                                        
                                        if category.themes[0].locked {
                                            
                                            Button(action: {
                                                self.showUnlock.toggle()
                                            }) {
                                                Text(NSLocalizedString("Unlock", comment: "").uppercased())
                                                    .font(Font.system(.caption, design: .rounded).weight(.bold))
                                                    .lineLimit(0)
                                                    .minimumScaleFactor(0.5)
                                            }
                                            .padding(.horizontal, 10)
                                            .animation(nil)
                                        }
                                        
                                        Button(action: {
                                            self.preview = ThemePreviewItem(category.themes[0], category: category)
                                        }) {
                                            Text(NSLocalizedString("Preview", comment: "").uppercased())
                                                .font(Font.system(.caption, design: .rounded).weight(.bold))
                                                .lineLimit(0)
                                                .minimumScaleFactor(0.5)
                                        }
                                        .animation(nil)
                                    }
                                    .padding(.top, 17)
                                    .padding(.horizontal, 5)
                                    .padding(.bottom, 5)
                                    
                                    ThemeGrouping(category: category, themes: category.themes, geometry: geometry, preview: self.$preview, showUnlock: self.$promptUnlock)
                                        .padding(.bottom, 3)
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        self.showUnlock.toggle()
                    }) {
                        Text("Unlock Colors")
                            .font(Font.system(.headline, design: .rounded).weight(.bold))
                            .padding(20)
                    }
                    
                    Spacer()
                        .frame(height: 50)
                }
            }
            .padding(.top, 1)
        }
        .overlay(ZStack {
            if preview != nil {
                MenuSheetView {
                    ThemePreview(preview: self.$preview, showUnlock: self.$showUnlock)
                } onDismiss: {
                    self.preview = nil
                }
            }
        })
        .sheet(isPresented: self.$showUnlock) {
            OmegaProAd(storeManager: self.storeManager)
        }
        .sheet(isPresented: self.$promptUnlock) {
            OmegaProAd(storeManager: self.storeManager, prompted: true)
        }
    }
}
