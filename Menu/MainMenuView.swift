//
//  MainMenuView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/4/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct MainMenuView: View {
    
    @ObservedObject var settings = Settings.settings
    
    @StateObject var storeManager: StoreManager
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showThemes: Bool = false
    @State private var showTesterView: Bool = false
    @State private var showExport: Bool = false
    @State private var showShare = false
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var size: Size {
        return verticalSizeClass == .compact || horizontalSizeClass == .compact ? .small : .large
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                NavigationHeader("Settings")
                
                ScrollView {
                    
                    LazyVStack(spacing: 30) {
                        
                        if !proCheck() {
                            SettingsGroup {
                                SettingsButtonContent {
                                    settings.popUp(.list)
                                } content: {
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(color(settings.theme.color1))
                                            .padding(.trailing, 5)
                                        VStack(alignment: .leading) {
                                            Text("OMEGA PRO")
                                                .font(.system(.title2, design: .rounded).weight(.heavy))
                                                .lineLimit(0)
                                                .minimumScaleFactor(0.5)
                                                .foregroundColor(Color.white)
                                            Text("Take your calculator to the next level.")
                                                .font(.system(.callout, design: .rounded).weight(.medium))
                                                .lineLimit(0)
                                                .minimumScaleFactor(0.5)
                                                .foregroundColor(Color.init(white: 0.7))
                                        }
                                        .padding(.vertical, 10)
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                        
                        SettingsGroup {
                            SettingsButton(title: "TEST SETTINGS", icon: "xmark") {
                                self.showTesterView.toggle()
                            }
                        }
                        
                        SettingsGroup {
                            SettingsButtonContent {
                                self.showThemes.toggle()
                            } content: {
                                ThemeDescription(theme: settings.theme)
                            }
                        }
                        
                        SettingsGroup {
                            SettingsButton(title: "Export Calculations", icon: "square.and.arrow.up") {
                                guard proCheckNotice(.misc) else { return }
                                self.showExport.toggle()
                            }
                        }
                        
                        SettingsView()
                        
                        SettingsGroup {
                            SettingsLink(title: "Website",
                                         url: URL(string: "https://omegacalculator.com")!
                            )
                            SettingsLink(title: "Support",
                                         url: URL(string: "https://omegacalculator.com/support")!
                            )
                            SettingsLink(title: "Privacy Policy",
                                         url: URL(string: "https://omegacalculator.com/privacy")!
                            )
                            SettingsButton(title: "Pro Features") {
                                settings.popUp(.list)
                            }
                        }
                        
                        SettingsGroup {
                            SettingsButton(title: "Rate the App") {
                                guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1528068503?action=write-review")
                                    else { fatalError("Expected a valid URL") }
                                UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
                            }
                            SettingsButton(title: "Share the App") {
                                self.showShare.toggle()
                            }
                        }
                        
                        VStack(spacing: 5) {
                            Text("Omega Calculator")
                                .font(.footnote)
                                .foregroundColor(Color.init(white: 0.5))
                            HStack(spacing: 3) {
                                Text("Version")
                                    .font(.footnote)
                                    .foregroundColor(Color.init(white: 0.5))
                                Text(appVersion ?? "")
                                    .font(.footnote)
                                    .foregroundColor(Color.init(white: 0.5))
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 20)
                    }
                    .animation(nil)
                    .padding(5)
                }
                .animation(nil)
                .accentColor(color(self.settings.theme.color1, edit: true))
            }
            .accentColor(color(settings.theme.color1))
            .sheet(isPresented: self.$settings.showProPopUp) {
                OmegaProSplash(storeManager: storeManager)
            }
            .sheet(isPresented: self.$showThemes) {
                ThemeView(storeManager: storeManager)
                    .contentOverlay()
            }
            .sheet(isPresented: self.$showExport) {
                ExportView()
                    .contentOverlay()
            }
            .sheet(isPresented: self.$showTesterView) {
                TesterSettingsView()
            }
            .sheet(isPresented: self.$showShare) {
                ActivityViewController(activityItems: [URL(string: "https://apps.apple.com/us/app/omega-calculator/id1528068503")!])
            }
            .sheet(isPresented: self.$settings.purchaseConfirmation) {
                PurchaseConfirmation()
            }
            .sheet(isPresented: self.$settings.restoreConfirmation) {
                PurchaseConfirmation(restore: true)
            }
        }
        .contentOverlay()
    }
}


struct NavigationHeader: View {
    
    var text: String
    
    @Environment(\.presentationMode) var presentationMode
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        
        ZStack {
            Text(text)
                .font(Font.system(.headline, design: .rounded).weight(.bold))
            HStack {
                Spacer()
                XButton {
                    withAnimation {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .padding(10)
    }
}
