//
//  OmegaView.swift
//  Calculator
//
//  Created by Joe Rupertus on 4/19/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct OmegaView: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @StateObject var storeManager: StoreManager
    
    var screenSize: CGSize
    
    var orientation: Orientation {
        return screenSize.width > screenSize.height ? .landscape : .portrait
    }
    var size: Size {
        return verticalSizeClass == .compact || horizontalSizeClass == .compact ? .small : .large
    }
    
    var buttonHeight: CGFloat {
        if size == .large {
            return orientation == .portrait ? 1/11.5 : 1/8.5
        } else {
            return orientation == .portrait ? (settings.portraitExpanded ? 1/11 : 1/9.5) : 1/8.3
        }
       
    }
    var standardSize: CGFloat {
        return size == .small && orientation == .landscape ? size.smallerSmallSize : size.standardSize
    }
    var horizontalPadding: CGFloat {
        return orientation == .landscape ? 5 : 10
    }
    var verticalPadding: CGFloat {
        return size == .small ? 5 : 10
    }
    
    @State private var welcome = false
    @State private var newsUpdate = false
    
    @State private var omegaProAd = false
    @State private var themePackAd = false
    
    @ViewBuilder var body: some View {
        
        ZStack {
            
            if settings.showMenu {
                
                MainMenuView(storeManager: storeManager)
                
            } else {
                
                CalculatorInterface(size: size, orientation: orientation, buttonHeight: buttonHeight, standardSize: standardSize, horizontalPadding: horizontalPadding, verticalPadding: verticalPadding)
                    
                VStack(spacing: 0) {
                    
                    HeaderButtonRow(size: size, orientation: orientation)
                        .padding(.horizontal, horizontalPadding)
                    
                    Spacer()
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onChange(of: self.settings.calculatorType) { _ in
            Calculation.current.clear()
            Calculation.current.refresh()
        }
        .onAppear {
            open()
        }
        .sheet(isPresented: self.$welcome) {
            Welcome()
        }
        .sheet(isPresented: self.$newsUpdate) {
            OmegaProAd(storeManager: storeManager)
        }
        .sheet(isPresented: self.$themePackAd) {
            SuperOmegaThemePackView(storeManager: storeManager)
        }
        .sheet(isPresented: self.$omegaProAd) {
            OmegaProAd(storeManager: storeManager)
        }
        .sheet(isPresented: self.$settings.clickProAd) {
            OmegaProAd(storeManager: storeManager, prompted: false)
        }
        .sheet(isPresented: self.$settings.promptProAd) {
            OmegaProAd(storeManager: storeManager, prompted: true)
        }
        .sheet(isPresented: self.$settings.purchaseConfirmation) {
            PurchaseConfirmation()
        }
        .sheet(isPresented: self.$settings.restoreConfirmation) {
            PurchaseConfirmation(restore: true)
        }
    }                                                 
    
    func open() {
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let storedVersion = UserDefaults.standard.string(forKey: "version")

        // Welcome
        if !UserDefaults.standard.bool(forKey: "welcome") {
            UserDefaults.standard.set(true, forKey: "welcome")
            UserDefaults.standard.set(version, forKey: "version")
            self.welcome.toggle()
        }
        // News Update
        else if storedVersion != version {
            if storedVersion?.prefix(3) != version.prefix(3) {
                self.newsUpdate.toggle()
            }
            UserDefaults.standard.set(version, forKey: "version")
        }
        // Random Pop Up
        else {
            // Omega Pro Pop Up
            if Int.random(in: 0...34) == 34 && !settings.pro {
                self.omegaProAd.toggle()
            }
        }
        
        print("Hello. Running Omega Calculator v\(version)")
    }
}

enum CalculatorType: String {
    case calculator = "calculator"
    case graph = "graph"
    case table = "table"
}

enum Orientation {
    case portrait
    case landscape
}

enum Size {
    case small
    case large
    
    var standardSize: CGFloat {
        self == .large ? 60 : 40
    }
    var smallerLargeSize: CGFloat {
        self == .large ? 50 : 40
    }
    var smallerSmallSize: CGFloat {
        self == .large ? 50 : 35
    }
}
