//
//  OmegaCalculatorApp.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/22/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI
import StoreKit

@main
struct OmegaCalculatorApp: App {
    
    @ObservedObject var settings = Settings.settings
    @StateObject var storeManager = StoreManager()
    
    @Environment(\.scenePhase) var scenePhase
    
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    
    let productIDs = ["com.rupertusapps.OmegaCalc.PRO"]
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                OmegaView(storeManager: storeManager, screenSize: geometry.size)
            }
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            .preferredColorScheme(.dark)
            .onAppear {
                openApp()
            }
            .onChange(of: scenePhase) { phase in
                refreshApp(phase: phase)
            }
        }
        .commands {
            KeyboardCommands()
        }
    }
    
    func openApp() {
        
        // Get store products from App Store Connect
        self.storeManager.getProducts(productIDs: productIDs)
        
        // Add store manager
        SKPaymentQueue.default().add(storeManager)
        
        // Set to dark mode
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        scene?.windows.first?.overrideUserInterfaceStyle = .dark
        
        // Set the default settings if not set
        Settings.defaultSettings()
        
        // Set scroll view behavior
        UIScrollView.appearance().bounces = false
        
        // Convert old calculations
        PersistenceController.shared.convertOldCalculations()
        
        // Remove expired calculations
        PersistenceController.shared.removeExpiredCalculations()
        
        // Add calculation folders
        PersistenceController.shared.addCalculationFolders()
        
        // Set up the queue
        Calculation.current.refresh()
        
        // New version updates
        if UserDefaults.standard.string(forKey: "version") != version {
            UserDefaults.standard.set(version, forKey: "version")
        }
        
        // Change to the correct icon
        Theme.setAppIcon()

        // Run pro ad
        runProAd()
        
        print("Hello. Running Omega Calculator v\(version)")
    }
    
    func refreshApp(phase: ScenePhase) {
        
        // Save
        PersistenceController.shared.save()
            
        // Reset overlay selections
        settings.recentDisplayType = .all
        settings.savedDisplayType = .all
        settings.storedVarDisplayType = .all
        settings.selectedDate = .now
        settings.selectedFolder = nil
        
        // Change to the correct icon
        Theme.setAppIcon()
            
        // Run pro ad
        if phase == .active {
            runProAd()
        }
        
        print("Refreshing...")
    }
    
    func runProAd() {
        guard !settings.pro, !settings.showProPopUp, UserDefaults.standard.integer(forKey: "lastShownProAd") != Date.now.dateNumber else { return }
        if Int.random(in: 0...5) == 5 {
            settings.popUp()
            UserDefaults.standard.setValue(Date.now.dateNumber, forKey: "lastShownProAd")
        }
    }
}

extension Date {
    
    var dateNumber: Int {
        // Define the reference date as January 1, 1970
        let referenceDate = Calendar.current.startOfDay(for: Date(timeIntervalSince1970: 0))
        
        // Get the current date's start of day
        let currentDate = Calendar.current.startOfDay(for: self)
        
        // Calculate the number of days between the reference date and the current date
        let days = Calendar.current.dateComponents([.day], from: referenceDate, to: currentDate).day!
        
        return days
    }
}
