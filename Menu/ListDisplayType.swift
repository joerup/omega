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
            Picker("", selection: self.$displayType) {
                ForEach(ListDisplayType.allCases) { type in
                    Label(type.rawValue, systemImage: type.icon)
                        .tag(type)
                }
            }
        } label: {
            SmallIconButton(symbol: displayType.icon, color: Color.init(white: displayType == .all ? 0.15 : 0.25), textColor: settings.theme.secondaryTextColor, smallerLarge: true, action: {})
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
//    case measurements = "Measurements"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .all:
            return "square.stack"
        case .numbers:
            return "number"
        case .expressions:
            return "x.squareroot"
//        case .measurements:
//            return "ruler"
        }
    }
}
