//
//  SettingsRowType.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/22/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct SettingsLabel: View {
    
    @ObservedObject var settings = Settings.settings
    
    var title: String
    var label: String
    var icon: String? = nil
    var desc: String? = nil
    
    var body: some View {
        SettingsRow(desc: desc) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .imageScale(.small)
                        .foregroundColor(color(self.settings.theme.color1, edit: true))
                        .padding(.trailing, 5)
                }
                SettingsText(title: title)
                Spacer()
                Text(LocalizedStringKey(label))
                    .font(Font.system(.body, design: .rounded))
                    .foregroundColor(Color.init(white: 0.85))
            }
        }
    }
}

struct SettingsToggle: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Binding var toggle: Bool
    var title: String
    var desc: String? = nil
    
    var body: some View {
        SettingsRow(desc: desc) {
            Toggle(isOn: self.$toggle) {
                SettingsText(title: title)
            }
            .toggleStyle(SwitchToggleStyle(tint: color(self.settings.theme.color1)))
        }
    }
}

struct SettingsMenuPicker: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Binding var value: Int
    var title: String
    var desc: String? = nil
    var displayOptions: [String]
    
    var body: some View {
        SettingsRow(desc: desc) {
            HStack {
                SettingsText(title: title)
                Spacer()
                Picker("", selection: self.$value) {
                    ForEach(self.displayOptions.indices, id: \.self) { index in
                        Text(LocalizedStringKey(self.displayOptions[index]))
                            .tag(index)
                    }
                }
                .pickerStyle(.menu)
                .padding(.trailing, -10)
            }
        }
        .onChange(of: self.value, perform: { _ in
            let impactMed = UIImpactFeedbackGenerator(style: .light)
            impactMed.impactOccurred()
        })
    }
}

struct SettingsBoolPicker: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Binding var value: Bool
    var title: String
    var displayOptions: [String]
    var font: Font = .body
    var trueFirst = false
    
    var body: some View {
        SettingsRow {
            HStack {
                SettingsText(title: title)
                Spacer()
                Picker(title, selection: self.$value) {
                    Text(self.displayOptions[0])
                        .tag(trueFirst)
                    Text(self.displayOptions[1])
                        .tag(!trueFirst)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 150)
            }
        }
        .onChange(of: self.value, perform: { _ in
            let impactMed = UIImpactFeedbackGenerator(style: .light)
            impactMed.impactOccurred()
        })
    }
}

struct SettingsBoolMenuPicker: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Binding var value: Bool
    var title: String
    var displayOptions: [String]
    var displayDescriptions: [String] = []
    var trueFirst = false
    
    var body: some View {
        SettingsRow(desc: displayDescriptions.isEmpty ? nil : displayDescriptions[trueFirst ? (value ? 0 : 1) : (value ? 1 : 0)]) {
            HStack {
                SettingsText(title: title)
                Spacer()
                Picker("", selection: self.$value) {
                    Text(LocalizedStringKey(self.displayOptions[0]))
                        .tag(trueFirst)
                    Text(LocalizedStringKey(self.displayOptions[1]))
                        .tag(!trueFirst)
                }
                .pickerStyle(.menu)
                .padding(.trailing, -10)
            }
        }
        .onChange(of: self.value, perform: { _ in
            let impactMed = UIImpactFeedbackGenerator(style: .light)
            impactMed.impactOccurred()
        })
    }
}

struct SettingsIconPicker: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Binding var value: Int
    var title: String
    var desc: LocalizedStringKey? = nil
    var displayOptions: [String]
    var alternateOptions: [String] = []
    var offset: Int = 0
    var increment: Int = 1
    
    var body: some View {
        SettingsRow(desc: desc) {
            HStack {
                SettingsText(title: title)
                Spacer()
                let language = Locale.current.languageCode
                let options = (language == "en" || alternateOptions.isEmpty) ? displayOptions : alternateOptions
                ForEach(options.indices, id: \.self) { index in
                    Button {
                        self.value = index*increment + offset
                    } label: {
                        Image(systemName: "\(options[index])\(self.value == index*increment + offset ? ".fill" : "")")
                            .imageScale(.large)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, -1)
                }
            }
        }
        .onChange(of: self.value, perform: { _ in
            let impactMed = UIImpactFeedbackGenerator(style: .light)
            impactMed.impactOccurred()
        })
    }
}

struct SettingsSlider: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Binding var value: Double
    var title: String
    var desc: LocalizedStringKey? = nil
    var min: Double
    var max: Double
    var step: Double
    var percent: Bool = false
    
    var body: some View {
        SettingsRow(desc: desc) {
            HStack {
                SettingsText(title: title)
                Spacer()
                Slider(value: self.$value, in: min...max, step: step)
                    .frame(maxWidth: 200)
                if self.percent {
                    Text("\(String(Int(round(self.value*100))))%")
                } else {
                    Text(String(self.value))
                }
            }
        }
    }
}

struct SettingsLink: View {
    
    @ObservedObject var settings = Settings.settings
    
    var title: String
    var url: URL
    var icon: String? = nil
    
    var body: some View {
        SettingsRow {
            Link(destination: url) {
                HStack {
                    if let icon = icon {
                        Image(systemName: icon)
                            .imageScale(.small)
                            .foregroundColor(color(self.settings.theme.color1, edit: true))
                            .padding(.trailing, 5)
                    }
                    SettingsText(title: title)
                    Spacer()
                    Image(systemName: "arrow.forward")
                        .imageScale(.small)
                        .foregroundColor(Color.init(white: 0.4))
                        .padding(.trailing, 5)
                }
            }
        }
    }
}

struct SettingsButton: View {
    
    @ObservedObject var settings = Settings.settings
    
    var title: String
    var icon: String? = nil
    
    var action: () -> Void
    
    var body: some View {
        SettingsRow {
            Button(action: action) {
                HStack {
                    if let icon = icon {
                        Image(systemName: icon)
                            .imageScale(.small)
                            .foregroundColor(color(self.settings.theme.color1, edit: true))
                            .padding(.trailing, 5)
                    }
                    SettingsText(title: title)
                    Spacer()
                    Image(systemName: "arrow.forward")
                        .imageScale(.small)
                        .foregroundColor(Color.init(white: 0.4))
                        .padding(.trailing, 5)
                }
            }
        }
    }
}
