//
//  ListDisplayType.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/4/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct ListDisplayTypePicker: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Binding var displayType: ListDisplayType
    
    var body: some View {
        
        Menu {
            ForEach(ListDisplayType.allCases) { type in
                Button(action: {
                    SoundManager.play(sound: .click3, haptic: .medium)
                    self.displayType = type
                }) {
                    Image(systemName: type.icon)
                    Text(LocalizedStringKey(type.rawValue))
                }
            }
        } label: {
            SmallIconButton(symbol: displayType.icon, color: Color.init(white: displayType == .all ? 0.15 : 0.25), textColor: color(settings.theme.color3, edit: true), smallerLarge: true, action: {})
        }
        .simultaneousGesture(TapGesture().onEnded {
            SoundManager.play(sound: .click3, haptic: .light)
        })
    }
}

enum ListDisplayType: String, Identifiable, CaseIterable {
    
    case all = "All Types"
    case numbers = "Numbers"
    case expressions = "Expressions"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .all:
            return "square.stack"
        case .numbers:
            return "number"
        case .expressions:
            return "x.squareroot"
        }
    }
}
