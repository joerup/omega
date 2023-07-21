//
//  AlphabetButton.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/1/23.
//  Copyright © 2023 Rupertus. All rights reserved.
//

import SwiftUI

struct AlphabetButton: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Binding var alphabet: Alphabet
    @Binding var uppercase: Bool
    
    var width: CGFloat
    var backgroundColor: Color = .init(white: 0.15)
    var smallerSmall: Bool
    
    var body: some View {
        SmallTextButton(text: text,
                        color: alphabet != .english ? settings.theme.primaryColor : backgroundColor,
                        textColor: alphabet != .english ? .white : settings.theme.primaryTextColor,
                        width: width,
                        smallerSmall: smallerSmall,
                        sound: .click3
        ) {
            switch alphabet {
            case .english:
                alphabet = .greek
            case .greek:
                alphabet = .english
            }
        }
    }
    
    var text: String {
        switch alphabet {
        case .english:
            return uppercase ? "ABC" : "abc"
        case .greek:
            return uppercase ? "ΑΒΓ" : "αβγ"
        }
    }
}

enum Alphabet {
    case english
    case greek
}
