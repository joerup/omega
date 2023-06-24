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
                
                VStack(spacing: 0) {
                    Spacer(minLength: size == .large ? standardSize : 0)
                    TextView(size: size, orientation: orientation, standardSize: standardSize)
                        .frame(maxHeight: min(geometry.size.height*(size == .large ? 0.2 : orientation == .landscape ? 0.3 : 0.22), geometry.size.width*0.5))
                        .padding(.top, orientation == .landscape ? 2 : standardSize + 2)
                        .border(Color.red, width: settings.guidelines ? 1 : 0)
                }
                .overlay(OverlayDismissArea())
                
                VStack(spacing: 0) {
                    
                    DetailButtonRow(size: size, orientation: orientation)
                        .padding(.horizontal, horizontalPadding)
                        .padding(.bottom, size == .small && orientation == .landscape ? 1 : 5)
                        .border(Color.green, width: settings.guidelines ? 1 : 0)
                    
                    ButtonPad(size: size, orientation: orientation, width: geometry.size.width-4, buttonHeight: geometry.size.height*buttonHeight)
                        .padding(.horizontal, 2)
                        .border(Color.blue, width: settings.guidelines ? 1 : 0)
                        .overlay(DetailOverlay().cornerRadius(0.42*0.98*geometry.size.height*buttonHeight).padding(.trailing, orientation == .landscape ? geometry.size.width*(4/11*0.98+0.01) : 0).padding(.bottom, orientation == .landscape ? 0 : geometry.size.height*buttonHeight*0.8+(size == .small ? 5 : 15)))
                }
                .overlay(VStack{ if verticalSizeClass == .regular { CalculatorOverlay() } else {}})
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.init(white: 0.07).edgesIgnoringSafeArea(.all))
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
