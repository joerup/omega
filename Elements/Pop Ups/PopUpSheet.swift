//
//  PopUpSheet.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/29/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct PopUpSheet<Content: View>: View {
    
    @ObservedObject var settings = Settings.settings
    
    var title: String
    var fullScreen: Bool = false
    
    var showCancel: Bool = true
    var confirmText: String = "Confirm"
    var confirmAction: () -> Void = {}
    
    var content: () -> Content
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            if !fullScreen {
                Text(LocalizedStringKey(title))
                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                    .fontWeight(.bold)
                    .padding(10)
            }
            
            content()
            
            HStack {
                
                if showCancel {
                    Button(action: {
                        withAnimation {
                            settings.popUp = nil
                        }
                        SoundManager.play(haptic: .light)
                    }) {
                        Text("Cancel")
                            .font(Font.system(.title2, design: .rounded).weight(.bold))
                            .foregroundColor(Color.white)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .padding(.vertical, 20)
                            .frame(width: 125)
                            .background(Color.init(white: 0.25))
                            .cornerRadius(20)
                    }
                }
                
                Button(action: {
                    withAnimation {
                        confirmAction()
                    }
                    SoundManager.play(haptic: .light)
                }) {
                    Text(LocalizedStringKey(confirmText))
                        .font(Font.system(.title2, design: .rounded).weight(.bold))
                        .foregroundColor(Color.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .padding(.vertical, 20)
                        .frame(width: 125)
                        .background(settings.theme.primaryColor)
                        .cornerRadius(20)
                }
            }
            .padding(5)
            .padding(.bottom, fullScreen ? 20 : 0)
            .dynamicTypeSize(..<DynamicTypeSize.xxxLarge)
        }
        .frame(maxWidth: fullScreen ? .infinity : 500, maxHeight: fullScreen ? .infinity : 500)
    }
}
