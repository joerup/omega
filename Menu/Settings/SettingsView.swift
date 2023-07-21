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
    
    var body: some View {
            
        SettingsGroup {
            SettingsMenuPicker(value: self.$settings.roundPlaces,
                               title: "Rounding Places",
                               displayOptions: ["4","5","6","7","8","9","10","11","12"],
                               offset: 4
            )
            SettingsMenuPicker(value: self.$settings.thousandsSeparators,
                               title: "Thousands Separator",
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
            SettingsMenuPicker(value: self.$settings.minimumTextSize,
                               title: "Minimum Text Size",
                               displayOptions: ["Small", "Medium", "Large"]
            )
        }
    }
}


struct AdvancedSettingsView: View {
    
    @ObservedObject var settings = Settings.settings
    
    var body: some View {
        
        if proCheck() {
            SettingsGroup(description: settings.stayInGroups ? "The text pointer will remain inside powers, radicals, etc. until manually moved outside." : "The text pointer will automatically exit powers, radicals, etc. after something has been completely inputted in them.") {
                SettingsBoolMenuPicker(value: self.$settings.stayInGroups,
                                       title: "Pointer Behavior",
                                       displayOptions: ["Continue Automatically", "Remain with Group"]
                )
            }
        }
        
        SettingsGroup(description: settings.autoParFunction ? "Parentheses will be automatically added after functions, such as trig functions and logarithms." : "Functions may exist without explicit parentheses in their arguments.") {
            SettingsBoolMenuPicker(value: self.$settings.autoParFunction,
                                   title: "Function Arguments",
                                   displayOptions: ["Implicit Grouping", "Explicit Parentheses"]
            )
        }
        
        SettingsGroup(description: settings.implicitMultFirst ? "When the order of operations is ambiguous, implicit multiplication will take precedence over division. ex: 6÷2(3) becomes 6÷(2(3)) -> 1." : "When the order of operations is ambiguous, implicit multiplication will be treated as normal multiplication. ex: 6÷2(3) becomes (6÷2)(3) -> 9.") {
            SettingsBoolMenuPicker(value: self.$settings.implicitMultFirst,
                                   title: "Implicit Multiplication",
                                   displayOptions: ["Prioritized", "Normal Order"],
                                   trueFirst: true
            )
        }
    }
}

