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
            return orientation == .portrait ? 1/11.5 : 1/9
        } else {
            return orientation == .portrait ? 1/9 : 1/8
        }
    }
    var standardSize: CGFloat {
        return size == .small && orientation == .landscape ? size.smallerSmallSize : size.standardSize
    }
    var horizontalPadding: CGFloat {
        return size == .small && orientation == .landscape ? 5 : 10
    }
    var verticalPadding: CGFloat {
        return size == .small ? 5 : 10
    }
    
    @State private var welcome = false
    @State private var newsUpdate = false
    
    @ViewBuilder var body: some View {
        
        ZStack {
                
            CalculatorInterface(size: size, orientation: orientation, buttonHeight: buttonHeight, standardSize: standardSize, horizontalPadding: horizontalPadding, verticalPadding: verticalPadding)
                
            VStack(spacing: 0) {
                
                HeaderButtonRow(size: size, orientation: orientation)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, 2)
                
                Spacer()
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
        .sheet(isPresented: self.$settings.showMenu) {
            MainMenuView(storeManager: storeManager)
        }
        .sheet(isPresented: self.$welcome) {
            Welcome()
        }
        .sheet(isPresented: self.$settings.showProPopUp) {
            OmegaProSplash(storeManager: storeManager)
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
        // Omega Pro Ad
        else if !UserDefaults.standard.bool(forKey: "seenProAd") && !settings.pro {
            UserDefaults.standard.set(true, forKey: "seenProAd")
            settings.popUp(.cycle)
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
            if Int.random(in: 0...7) == 7 && !settings.pro {
                settings.popUp(.cycle)
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
