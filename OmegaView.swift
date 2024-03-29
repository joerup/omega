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
        return verticalSizeClass == .compact || (horizontalSizeClass == .compact) ? .small : .large
    }
    
    var buttonHeight: CGFloat {
        if size == .large {
            return orientation == .portrait ? 1/11.5 : 1/8.5
        } else {
            return orientation == .portrait ? 1/8.9 : 1/8
        }
    }
    var standardSize: CGFloat {
        return size == .small && orientation == .landscape ? size.smallerSmallSize : size.standardSize
    }
    var horizontalPadding: CGFloat {
        return size == .small && orientation == .landscape ? 5 : (screenSize.width > 1000 && orientation == .portrait || screenSize.width > 1250) ? 15 : 10
    }
    var verticalPadding: CGFloat {
        return size == .small ? 5 : 10
    }
    
    @ViewBuilder var body: some View {
        
        ZStack {
                
            CalculatorInterface(size: size, orientation: orientation, buttonHeight: buttonHeight, standardSize: standardSize, horizontalPadding: horizontalPadding, verticalPadding: verticalPadding)
                
            VStack(spacing: 0) {
                
                HeaderButtonRow(size: size, orientation: orientation)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, 5)
                
                Spacer()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onChange(of: self.settings.calculatorType) { _ in
            Calculation.current.clear()
            Calculation.current.refresh()
        }
        .sheet(isPresented: self.$settings.showMenu) {
            MainMenuView(storeManager: storeManager)
        }
        .sheet(isPresented: self.$settings.showProPopUp) {
            OmegaProSplash(storeManager: storeManager)
        }
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
        self == .large ? 50 : 40
    }
    var smallerLargeSize: CGFloat {
        self == .large ? 50 : 40
    }
    var smallerSmallSize: CGFloat {
        self == .large ? 50 : 35
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
