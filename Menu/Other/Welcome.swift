//
//  WelcomeNews.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/10/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

struct Welcome: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var scale: Double = 1.0
    
    var body: some View {
        
        VStack {
        
            Text("Welcome to")
                .font(Font.system(.title3, design: .rounded).weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.white)
                .opacity(0.8)
                .padding(.top, 10)
            
            Spacer()
                .frame(maxHeight: 10)
            
            VStack {
                Text("OMEGA CALCULATOR")
                    .font(.system(size: 80, weight: .heavy, design: .rounded))
                    .lineLimit(2)
                    .minimumScaleFactor(0.1)
                    .multilineTextAlignment(.center)
                    .opacity(0)
                    .overlay(
                        LinearGradient(colors: [color(settings.theme.color1, edit: true).lighter(by: 0.3), color(settings.theme.color1, edit: true).darker(by: 0.3)], startPoint: .leading, endPoint: .trailing)
                            .mask(
                                Text("OMEGA CALCULATOR")
                                    .font(.system(size: 80, weight: .heavy, design: .rounded))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.1)
                                    .multilineTextAlignment(.center)
                            )
                    )
            }
                
            Spacer()
            
            if verticalSizeClass == .regular {
                Image("Omega_\(self.settings.theme.name.replacingOccurrences(of:" ",with:"_"))")
                    .resizable()
                    .frame(width: verticalSizeClass == .regular ? 200 : 125, height: verticalSizeClass == .regular ? 200 : 125)
                    .cornerRadius((verticalSizeClass == .regular ? 200 : 125)/5)
                    .padding(10)
            }
            
            Spacer()
            
            Text("Let's get started.")
                .font(Font.system(.title, design: .rounded).weight(.bold))
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                self.settings.showMenu = false
            }) {
                Text("Start")
                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                    .foregroundColor(Color.white)
                    .shadow(color: .init(white: 0.5), radius: 10)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(RadialGradient(colors: [color(settings.theme.color1).lighter(by: 0.1), color(settings.theme.color1).darker(by: 0.2)], center: .center, startRadius: 0, endRadius: 300))
                    .cornerRadius(20)
            }
            .frame(maxWidth: 500)
            .scaleEffect(scale)
            .padding(10)
            .onAppear {
                withAnimation(Animation.linear(duration: 3.0).repeatForever()) {
                    scale = 1.1
                }
            }
        }
        .padding()
    }
}
