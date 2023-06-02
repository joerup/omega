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
            SettingsBoolPicker(value: self.$settings.displayX10,
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
                           title: "Animations"
            )
            SettingsSlider(value: self.$settings.shrink,
                           title: "Maximum Shrink",
                           desc: settings.shrink == 0 ? LocalizedStringKey("The text will not shrink before scrolling.") : settings.shrink == 1 ? LocalizedStringKey("The text will continue to shrink as much as it needs to fit the screen.") : LocalizedStringKey("The text will shrink by up to \(Int(settings.shrink*100))% of its original size before scrolling."),
                           min: 0.0,
                           max: 1.0,
                           step: 0.05,
                           percent: true
            )
        }
        
        SettingsGroup {
            if proCheck() {
                SettingsBoolMenuPicker(value: self.$settings.stayInGroups,
                                       title: "Pointer Behavior",
                                       displayOptions: ["Continue Automatically", "Remain with Group"],
                                       displayDescriptions: ["The text pointer will automatically exit powers, radicals, etc. after something has been completely inputted in them.", "The text pointer will remain inside powers, radicals, etc. until manually moved outside."]
                )
            }
            SettingsBoolMenuPicker(value: self.$settings.autoParFunction,
                                   title: "Function Arguments",
                                   displayOptions: ["Implicit", "Explicit"],
                                   displayDescriptions: ["Functions may exist without explicit parentheses in their arguments.", "Parentheses will be automatically added after functions, such as trig functions and logarithms."]
            )
            SettingsBoolMenuPicker(value: self.$settings.implicitMultFirst,
                                   title: "Implicit Multiplication",
                                   displayOptions: ["Separate", "Normal"],
                                   displayDescriptions: ["When the order of operations is ambiguous, implicit multiplication will take precedence over division. ex: 6÷2(3) becomes 6÷(2(3)) -> 1.", "When the order of operations is ambiguous, implicit multiplication will be treated as normal multiplication. ex: 6÷2(3) becomes (6÷2)(3) -> 9."],
                                   trueFirst: true
            )
        }
    }
}


