//
//  AboutView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 3/11/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI
import StoreKit

struct AboutView: View {
    
    var settings = Settings.settings
    
    @StateObject var storeManager: StoreManager
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    @State private var showWhatsNew: Bool = false
    @State private var showExport: Bool = false
    @State private var showShare = false
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
        
                VStack(spacing: 20) {
                    
                    SettingsGroup("Updates") {
                        
                        SettingsLabel(title: "Version", label: appVersion ?? "Unknown", icon: "app")
                        
                        SettingsButton(title: "News", icon: "newspaper") {
                            self.showWhatsNew.toggle()
                        }
                    }
                    
                    SettingsGroup("Premium") {
                        
                        SettingsLabel(title: "Current Tier", label: settings.pro ? "Omega Pro" : "Standard", icon: "list.bullet")
                    }
                    
                    SettingsGroup("Help us Grow") {
                        
                        SettingsButton(title: "Rate the App", icon: "star") {
                            guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1528068503?action=write-review")
                                else { fatalError("Expected a valid URL") }
                            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
                        }
                        
                        SettingsButton(title: "Share the App", icon: "square.and.arrow.up") {
                            self.showShare.toggle()
                        }
                    }
                    
                    SettingsGroup("Check out our other Apps") {
                        
                        SettingsLink(title: "Planetaria",
                                     url: URL(string: "https://apps.apple.com/is/app/planetaria/id1546887479")!,
                                     icon: "sun.min"
                        )
                        
                        SettingsLink(title: "Bits & Bobs",
                                     url: URL(string: "https://apps.apple.com/us/app/bits-and-bobs/id1554786457")!,
                                     icon: "note.text"
                        )
                    }
                    
                    Spacer()
                        .frame(height: 50)
                }
            }
        }
        .accentColor(color(settings.theme.color1))
        .sheet(isPresented: self.$showShare) {
            ActivityViewController(activityItems: [URL(string: "https://apps.apple.com/us/app/omega-calculator/id1528068503")!])
        }
        .overlay(ZStack {
            if showWhatsNew {
                MenuSheetView {
                    WhatsNew()
                } onDismiss: {
                    showWhatsNew = false
                }
            }
        })
        .overlay(ZStack {
            if showExport {
                MenuSheetView {
                    ExportView()
                } onDismiss: {
                    showExport = false
                }
            }
        })
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
