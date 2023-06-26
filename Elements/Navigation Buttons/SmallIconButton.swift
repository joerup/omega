//
//  SmallIconButton.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/15/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct SmallIconButton: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
        
    var symbol: String
    var color: Color = Color.init(white: 0.15)
    var textColor: Color = Color.white
    var smallerLarge: Bool = false
    var smallerSmall: Bool = false
    var scale: CGFloat = 1.0
    var sound: SoundManager.Sound? = nil
    var proOnly: Bool = false
    
    var action: () -> Void
    
    var size: Size {
        return verticalSizeClass == .compact || horizontalSizeClass == .compact ? .small : .large
    }
    
    var body: some View {
        
        Button(action: {
            guard !proOnly || proCheckNotice(.misc) else { return }
            SoundManager.play(sound: sound, haptic: .light)
            action()
        }) {
            ZStack {
                Rectangle()
                    .fill(color)
                    .frame(width: size == .large ? (smallerLarge ? size.smallerLargeSize : size.standardSize) : (smallerSmall ? 35 : 40), height: size == .large ? (smallerLarge ? size.smallerLargeSize : size.standardSize) : (smallerSmall ? 35 : 40))
                    .cornerRadius(100)
                Image(systemName: symbol)
                    .font(.system(size: size == .large ? (smallerLarge ? 21 : 24) : (smallerSmall ? 15 : 18), weight: .bold))
                    .foregroundColor(textColor)
            }
            .overlay(Color.init(white: 0.2).cornerRadius(100).opacity(!proOnly || proCheck() ? 0 : 0.8))
        }
        .buttonStyle(CalculatorButtonStyle())
        .scaleEffect(scale)
    }
}
