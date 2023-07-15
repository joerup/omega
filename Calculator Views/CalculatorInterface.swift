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
    
    @State private var test: String = ""
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    Spacer(minLength: size == .large ? size.smallerLargeSize : 0)
                    TextView(size: size, orientation: orientation, standardSize: standardSize)
                        .frame(maxHeight: min(size == .large ? max(geometry.size.height*0.2, 190) : geometry.size.height*(orientation == .landscape ? 0.3 : 0.22), geometry.size.width*0.5))
                        .padding(.top, orientation == .landscape ? 2 : standardSize + 2)
                        .border(Color.red, width: settings.guidelines ? 1 : 0)
                        .ignoresSafeArea(.keyboard)
                }
                .overlay(OverlayDismissArea())
                
                VStack(spacing: 0) {
                    
                    DetailButtonRow(size: size, orientation: orientation)
                        .padding(.horizontal, horizontalPadding)
                        .padding(.bottom, size == .large && orientation == .landscape ? 2 : (size == .small && orientation == .portrait ? 2 : 0))
                        .padding(.top, size == .small && orientation == .landscape ? 0 : 5)
                        .border(Color.green, width: settings.guidelines ? 1 : 0)
                    
                    ButtonPad(size: size, orientation: orientation, width: geometry.size.width-4, buttonHeight: geometry.size.height*buttonHeight)
                        .padding(.horizontal, 2)
                        .border(Color.blue, width: settings.guidelines ? 1 : 0)
                }
                .keypadShift()
                .overlay(VStack{ if verticalSizeClass == .regular { CalculatorOverlay() } else {}})
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .overlay(VStack{ if verticalSizeClass == .compact { CalculatorOverlay().padding(.top, standardSize+7) } else {}})
            .contentOverlay()
            .background(Color.init(white: 0.07).edgesIgnoringSafeArea(.all))
            .accentColor(color(self.settings.theme.color1))
            .ignoresSafeArea(.keyboard)
            .onChange(of: geometry.size) { _ in
                Calculation.current.refresh()
            }
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
