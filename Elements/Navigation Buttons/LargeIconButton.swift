//
//  LargeIconButton.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 5/24/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct LargeIconButton: View {
    
    var text: String
    var image: String
    var width: CGFloat = .infinity
    var height: CGFloat = 50
    var proOnly: Bool = false
    
    var action: () -> Void
    
    var body: some View {
        
        Button(action: {
            guard !proOnly || proCheckNotice() else { return }
            SoundManager.play(sound: .click3, haptic: .light)
            action()
        }) {
            VStack(spacing: 0) {
                Image(systemName: image)
                    .font(.system(size: height*0.35, weight: .bold))
                    .frame(height: height*0.35)
                    .foregroundColor(color(Settings.settings.theme.color1, edit: true))
                    .padding(.vertical, height*0.05)
                Text(LocalizedStringKey(text))
                    .font(Font.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundColor(.init(white: 0.8))
                    .frame(maxHeight: .infinity)
            }
            .padding(10)
            .frame(maxWidth: width, maxHeight: height)
            .background(Color.init(white: 0.2))
            .overlay(Color.init(white: 0.2).opacity(!proOnly || proCheck() ? 0 : 0.8))
            .cornerRadius(20)
        }
    }
}
