//
//  PurchaseConfirmation.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/9/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct PurchaseConfirmation: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var restore: Bool = false
    
    var body: some View {
        
        VStack {
            
            Text(restore ? "Restore Complete" : "Purchase Complete")
                .font(Font.system(.largeTitle, design: .rounded).weight(.bold))
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Spacer()
            
            Text("😊")
                .font(.system(size: 100))
                .padding()
            
            Spacer()
            
            Text("Thank you for supporting Omega Calculator.")
                .font(Font.system(.title, design: .rounded).weight(.bold))
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
            
            Text("Your support helps us keep Omega Calculator free of ads and free of charge for everyone. And you're helping us create future app updates that we know you will love. We hope you enjoy your purchase.")
                .font(Font.system(.body, design: .rounded))
                .foregroundColor(Color.init(white: 0.75))
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Continue")
                    .font(Font.system(.title3, design: .rounded).weight(.bold))
                    .foregroundColor(Color.white)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(20)
            }
            .padding()
        }
        .padding()
    }
}
