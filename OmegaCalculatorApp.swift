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
    
    @StateObject var storeManager = StoreManager()
    
    @Environment(\.scenePhase) var scenePhase
    
    let productIDs = [
        "com.rupertusapps.OmegaCalc.PRO"
    ]
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                OmegaView(storeManager: storeManager, screenSize: geometry.size)
            }
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            .preferredColorScheme(.dark)
            .onAppear {
                // Get store products from App Store Connect
                self.storeManager.getProducts(productIDs: productIDs)
                // Add store manager
                SKPaymentQueue.default().add(storeManager)
                // Set to dark mode
                let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                scene?.windows.first?.overrideUserInterfaceStyle = .dark
                // Set the default settings if not set
                defaultSettings()
                // Set scroll view behavior
                UIScrollView.appearance().bounces = false
                // Convert old calculations
                PersistenceController.shared.convertOldCalculations()
                // Remove expired calculations
                PersistenceController.shared.removeExpiredCalculations()
                // Set up the queue
                Calculation.current.refresh()
            }
        }
        .onChange(of: scenePhase) { _ in
            PersistenceController.shared.save()
        }
        .commands {
            KeyboardCommands()
        }
    }
}

