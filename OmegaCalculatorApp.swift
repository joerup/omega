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
            .onAppear(perform: {
                // Get store products from App Store Connect
                self.storeManager.getProducts(productIDs: productIDs)
                // Add store manager
                SKPaymentQueue.default().add(storeManager)
                // Set the default settings if not set
                defaultSettings()
                // Set the theme to dark
                InterfaceManager.shared.setMode(darkMode: true, system: false)
                // Set scroll view behavior
                UIScrollView.appearance().bounces = false
                // Convert old calculations
                PersistenceController.shared.convertOldCalculations()
                // Remove expired calculations
                PersistenceController.shared.removeExpiredCalculations()
                // Set up the queue
                Calculation.current.refresh()
            })
        }
        .onChange(of: scenePhase) { _ in
            PersistenceController.shared.save()
        }
        .commands {
            KeyboardCommands()
        }
    }
}

class InterfaceManager {
    static let shared = InterfaceManager()

    private init () {}

    func setMode(darkMode: Bool, system: Bool) {
    
        guard !system else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
            return
        }
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = darkMode ? .dark : .light
    }

}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
