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
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showShare = false
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var size: Size {
        return verticalSizeClass == .compact || horizontalSizeClass == .compact ? .small : .large
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            NavigationView {
                    
                ScrollView {
                    
                    LazyVStack(spacing: 30) {
                        
                        if !proCheck() {
                            SettingsGroup {
                                SettingsButtonContent {
                                    settings.popUp()
                                } content: {
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(settings.theme.primaryColor)
                                            .font(.system(.title2, design: .rounded).weight(.heavy))
                                            .padding(.bottom, 1)
                                        Text("OMEGA PRO")
                                            .font(.system(.title2, design: .rounded).weight(.heavy))
                                            .lineLimit(0)
                                            .minimumScaleFactor(0.5)
                                            .foregroundColor(Color.white)
                                            .padding(.vertical, 10)
                                    }
                                }
                            }
                        }
                        
//                        SettingsGroup {
//                            SettingsNavigationLink(title: "TEST SETTINGS", icon: "xmark", dismiss: dismiss) {
//                                TesterSettingsView()
//                            }
//                        }
                        
                        SettingsGroup {
                            SettingsContentNavigationLink(title: "Themes", dismiss: dismiss) {
                                ThemeView(storeManager: storeManager)
                                    .contentOverlay()
                            } label: {
                                ThemeDescription(theme: settings.theme)
                            }
                        }
                        
                        SettingsView()
                        
                        SettingsGroup {
                            SettingsNavigationLink(title: "Advanced Settings", dismiss: dismiss) {
                                ScrollView {
                                    AdvancedSettingsView()
                                        .padding(.vertical, 10)
                                }
                            }
                        }
                        
                        SettingsGroup {
                            SettingsNavigationLink(title: "Export Calculations", dismiss: dismiss) {
                                ExportView()
                            }
                        }
                        
                        SettingsGroup {
                            SettingsLink(title: "App Website",
                                         url: URL(string: "https://omegacalculator.com")!
                            )
                            SettingsLink(title: "Contact Support",
                                         url: URL(string: "https://omegacalculator.com/support")!
                            )
                            SettingsLink(title: "Privacy Policy",
                                         url: URL(string: "https://omegacalculator.com/privacy")!
                            )
                            SettingsButton(title: "Pro Features") {
                                settings.popUp()
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
                    .padding(.vertical, 10)
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        XButton {
                            dismiss()
                        }
                    }
                }
            }
            .navigationViewStyle(.stack)
            .accentColor(settings.theme.primaryTextColor)
            .sheet(isPresented: self.$settings.showProPopUp) {
                OmegaProSplash(storeManager: storeManager)
            }
            .sheet(isPresented: self.$showShare) {
                ActivityViewController(activityItems: [URL(string: "https://apps.apple.com/us/app/omega-calculator/id1528068503")!])
            }
        }
        .contentOverlay()
    }
}


struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}
