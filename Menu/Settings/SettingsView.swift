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
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
    
        GeometryReader { geometry in
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    SettingsGroup("Buttons") {
                        SettingsToggle(toggle: self.$settings.portraitExpanded,
                                       title: "Expanded Portrait Mode"
                                    )
                        SettingsIconPicker(value: self.$settings.buttonCornerRadius,
                                       title: "Button Shape",
                                       displayOptions: ["circle","app"],
                                       offset: 4
                                    )
                        SettingsToggle(toggle: self.$settings.soundEffects,
                                       title: "Sound Effects"
                                    )
                        if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
                            SettingsToggle(toggle: self.$settings.hapticFeedback,
                                           title: "Haptic Feedback"
                                        )
                        }
                    }
                    
                    SettingsGroup("Text") {
                        SettingsIconPicker(value: self.$settings.textWeight,
                                       title: "Font Weight",
                                       displayOptions: ["l.square","m.square","b.square"],
                                       alternateOptions: ["1.square","2.square","3.square"]
                                    )
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
                    
                    SettingsGroup("Display") {
                        SettingsIconPicker(value: self.$settings.roundPlaces,
                                       title: "Rounding Places",
                                       desc: LocalizedStringKey("Numbers with more than \(settings.roundPlaces) decimal places will be displayed rounded. They retain their true value internally."),
                                       displayOptions: ["6.circle","7.circle","8.circle","9.circle","10.circle","11.circle","12.circle"],
                                       offset: 6
                                    )
                        SettingsMenuPicker(value: self.$settings.thousandsSeparators,
                                           title: "Thousands Separators",
                                           displayOptions: ["None", "Commas", "Spaces"]
                                    )
                        SettingsBoolPicker(value: self.$settings.commaDecimal,
                                           title: "Decimal Point",
                                           displayOptions: [".",","],
                                           font: Font.custom("HelveticaNeue", size: 30)
                        )
                        SettingsBoolPicker(value: self.$settings.displayX10,
                                           title: "Exponential Notation",
                                           displayOptions: ["E","×10^"]
                                    )
                        SettingsToggle(toggle: self.$settings.degreeSymbol,
                                       title: "Degrees Symbol"
                                    )
                    }
                    
                    SettingsGroup("Input") {
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
                    }
                    
                    SettingsGroup("Evaluation") {
                        SettingsBoolMenuPicker(value: self.$settings.implicitMultFirst,
                                               title: "Implicit Multiplication",
                                               displayOptions: ["Separate", "Normal"],
                                               displayDescriptions: ["When the order of operations is ambiguous, implicit multiplication will take precedence over division. ex: 6÷2(3) becomes 6÷(2(3)) -> 1.", "When the order of operations is ambiguous, implicit multiplication will be treated as normal multiplication. ex: 6÷2(3) becomes (6÷2)(3) -> 9."],
                                               trueFirst: true
                                    )
                    }
                    
                    SettingsGroup("Language") {
                        SettingsRow {
                            Button(action: {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            }) {
                                HStack {
                                    SettingsText(title: "Language")
                                    Spacer()
                                    let locale: Locale = .current
                                    let string = locale.localizedString(forLanguageCode: Locale.current.languageCode ?? "") ?? ""
                                    Text(string.prefix(1).uppercased() + string.dropFirst())
                                }
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(height: 50)
                }
            }
        }
        .accentColor(color(settings.theme.color1))
    }
}


