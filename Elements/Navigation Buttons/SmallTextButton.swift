//
//  SmallTextButton.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/15/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct SmallTextButton: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var text: String
    var color: Color = Color.init(white: 0.1)
    var textColor: Color = Color.white
    var width: CGFloat? = nil
    var circle: Bool = false
    var scale: CGFloat = 1.0
    var fontScale: CGFloat = 1.0
    var smallerLarge: Bool = false
    var smallerSmall: Bool = false
    var sound: SoundManager.Sound? = nil
    var proOnly: Bool = false
    
    var action: () -> Void
    
    var size: Size {
        return verticalSizeClass == .compact || horizontalSizeClass == .compact ? .small : .large
    }
    var height: CGFloat {
        return smallerLarge ? size.smallerLargeSize : smallerSmall && size == .small ? size.smallerSmallSize : size.standardSize
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
                    .frame(width: circle ? height : width ?? (size == .large ? (smallerLarge ? 90 : 110) : (smallerSmall ? 60 : 75)), height: height)
                Text(LocalizedStringKey(text))
                    .font(.system(size: fontScale*(size == .large ? 18 : 13), design: .rounded).weight(.semibold))
                    .foregroundColor(textColor.lighter(by: 0.4))
                    .lineLimit(0)
                    .minimumScaleFactor(0.3)
                    .frame(maxWidth: circle ? height : width)
            }
            .overlay(Color.init(white: 0.2).opacity(!proOnly || proCheck() ? 0 : 0.8))
            .cornerRadius(100)
        }
        .buttonStyle(CalculatorButtonStyle())
        .scaleEffect(scale)
    }
}
