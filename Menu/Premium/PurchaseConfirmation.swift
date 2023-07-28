//
//  PurchaseConfirmation.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/9/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct PurchaseConfirmation: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.presentationMode) var presentationMode
    
    var restore: Bool = false
    
    var body: some View {
        
        VStack {
            
            Text(restore ? "Restore Complete" : "Purchase Complete")
                .font(Font.system(.largeTitle, design: .rounded).weight(.bold))
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .shadow(radius: 10)
                .padding(.top, 20)
            
            Spacer()
            
            ProFeatureDisplay.tripleCalculatorDisplay(
                left: .smiley(settings.previewTheme2),
                center: .smiley(settings.previewTheme1),
                right: .smiley(settings.previewTheme3),
                theme: settings.previewTheme1
            )
            .frame(maxWidth: 500)
            .shadow(radius: 10)
            
            Spacer()
            
            Text("Thank you for supporting Omega Calculator.")
                .font(Font.system(.title, design: .rounded).weight(.bold))
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .shadow(radius: 10)
            
            Text("Your support helps us keep Omega Calculator free of ads and free of charge for everyone. And you're helping us create future app updates that we know you will love. We hope you enjoy your purchase.")
                .font(Font.system(.body, design: .rounded))
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .shadow(radius: 10)
                .padding()
            
            Button(action: {
                settings.showProPopUp = false
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Continue")
                    .font(Font.system(.title3, design: .rounded).weight(.bold))
                    .foregroundColor(Color.white)
                    .shadow(color: .init(white: 0.4), radius: 15)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(RadialGradient(gradient: Gradient(colors: [.white, .black]), center: .center, startRadius: 1, endRadius: 400).overlay(settings.previewTheme1.primaryColor.opacity(0.6)))
                    .cornerRadius(20)
            }
            .padding()
            .frame(maxWidth: 500)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(colors: [.init(white: 0.3), .init(white: 0.2)], startPoint: .top, endPoint: .bottom)
                .overlay(settings.previewTheme1.primaryColor.opacity(0.6))
                .edgesIgnoringSafeArea(.all)
        )
    }
}
