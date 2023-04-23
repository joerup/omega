//
//  CalculatorInterface.swift
//  Calculator
//
//  Created by Joe Rupertus on 4/20/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct CalculatorInterface: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var size: Size
    var orientation: Orientation
    
    var buttonHeight: CGFloat
    var standardSize: CGFloat
    var horizontalPadding: CGFloat
    var verticalPadding: CGFloat
    
    @State private var fullOverlay: Bool = false
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                TextView(size: size, orientation: orientation, standardSize: standardSize)
                    .padding(.top, orientation == .landscape ? 0 : standardSize)
                    .border(Color.red, width: settings.guidelines ? 1 : 0)
                    .overlay(OverlayDismissArea())
                
                VStack(spacing: 0) {
                    
                    DetailButtonRow(size: size, orientation: orientation)
                        .padding(.horizontal, horizontalPadding)
                        .padding(.bottom, size == .large ? (orientation == .portrait ? 12.5 : 7.5) : orientation == .portrait ? 10 : 5)
                        .border(Color.green, width: settings.guidelines ? 1 : 0)
                    
                    ButtonPad(size: size, orientation: orientation, width: geometry.size.width-4, buttonHeight: geometry.size.height*buttonHeight)
                        .padding(.top, 2).padding(.horizontal, 2)
                        .background(Color.init(white: 0.1).cornerRadius(20).edgesIgnoringSafeArea(.bottom))
                        .border(Color.blue, width: settings.guidelines ? 1 : 0)
                        .overlay(DetailOverlay().padding(.trailing, orientation == .landscape ? geometry.size.width*2/5 : 0).padding(.bottom, orientation == .landscape ? 0 : geometry.size.height*buttonHeight+5))
                }
                .overlay(VStack{ if verticalSizeClass == .regular { CalculatorOverlay() } else {}})
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .overlay(VStack{ if verticalSizeClass == .compact { CalculatorOverlay().padding(.top, standardSize+7) } else {}})
            .keypadShift()
            .contentOverlay()
            .accentColor(color(self.settings.theme.color1))
            .ignoresSafeArea(.keyboard)
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
