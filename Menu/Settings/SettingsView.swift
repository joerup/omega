//
//  SettingsView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/6/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI
import CoreAudio
import CoreHaptics

struct SettingsView: View {
    
    @ObservedObject var settings = Settings.settings
    
    @ViewBuilder
    var body: some View {
            
        SettingsGroup {
            SettingsIconPicker(value: self.$settings.roundPlaces,
                               title: "Rounding Places",
                               displayOptions: ["6.circle","7.circle","8.circle","9.circle","10.circle","11.circle","12.circle"],
                               offset: 6
            )
            SettingsMenuPicker(value: self.$settings.thousandsSeparators,
                               title: "Thousands Separators",
                               displayOptions: ["None", settings.commaDecimal ? "Period" : "Comma", "Space"]
            )
            SettingsBoolMenuPicker(value: self.$settings.commaDecimal,
                                   title: "Decimal Point",
                                   displayOptions: ["Period","Comma"]
            )
            SettingsBoolMenuPicker(value: self.$settings.displayX10,
                               title: "Exponential Notation",
                               displayOptions: ["E","×10^"]
            )
        }
        
        SettingsGroup {
            SettingsToggle(toggle: self.$settings.soundEffects,
                           title: "Sound Effects"
            )
            if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
                SettingsToggle(toggle: self.$settings.hapticFeedback,
                               title: "Haptic Feedback"
                )
            }
            SettingsToggle(toggle: self.$settings.textAnimations,
                           title: "Text Animations"
            )
            SettingsIconPicker(value: self.$settings.minimumTextSize,
                               title: "Minimum Text Size",
                               displayOptions: ["s.circle", "m.circle", "l.circle"],
                               alternateOptions: ["1.circle", "2.circle", "3.circle"]
            )
        }
        
        SettingsGroup {
            if proCheck() {
                SettingsBoolMenuPicker(value: self.$settings.stayInGroups,
                                       title: "Pointer Behavior",
                                       displayOptions: ["Continue Automatically", "Remain with Group"]
                )
            }
            SettingsBoolMenuPicker(value: self.$settings.autoParFunction,
                                   title: "Function Arguments",
                                   displayOptions: ["Implicit Grouping", "Explicit Parentheses"]
            )
            SettingsBoolMenuPicker(value: self.$settings.implicitMultFirst,
                                   title: "Implicit Multiplication",
                                   displayOptions: ["Prioritized", "Normal Order"],
                                   trueFirst: true
            )
        }
    }
}


