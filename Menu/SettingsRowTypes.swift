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
                        .foregroundColor(settings.theme.primaryTextColor)
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
            .toggleStyle(SwitchToggleStyle(tint: settings.theme.primaryTextColor))
        }
    }
}

struct SettingsMenuPicker: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Binding var value: Int
    var title: String
    var desc: String? = nil
    var displayOptions: [String]
    var offset: Int = 0
    
    var body: some View {
        SettingsRow(desc: desc) {
            AStack {
                SettingsText(title: title)
                Spacer()
                Picker("", selection: self.$value) {
                    ForEach(self.displayOptions.indices, id: \.self) { index in
                        Text(LocalizedStringKey(self.displayOptions[index]))
                            .tag(index + offset)
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
            AStack {
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
            AStack {
                SettingsText(title: title)
                Spacer(minLength: 0)
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
                            .foregroundColor(settings.theme.primaryTextColor)
                            .padding(.trailing, 5)
                    }
                    SettingsText(title: title)
                    Spacer()
                    Image(systemName: "arrow.forward")
                        .imageScale(.small)
                        .foregroundColor(Color.init(white: 0.4))
                }
            }
            .padding(.vertical, 5)
        }
    }
}

struct SettingsNavigationLink<Content: View>: View {
    
    @ObservedObject var settings = Settings.settings
    
    var title: String
    var icon: String? = nil
    var dismiss: DismissAction
    
    @ViewBuilder var destination: () -> Content
    
    var body: some View {
        SettingsRow {
            NavigationLink {
                destination()
                    .navigationTitle(title)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            XButton {
                                dismiss()
                            }
                        }
                    }
            } label: {
                HStack {
                    if let icon = icon {
                        Image(systemName: icon)
                            .foregroundColor(settings.theme.primaryTextColor)
                            .padding([.trailing, .bottom], 5)
                    }
                    SettingsText(title: title)
                    Spacer()
                    Image(systemName: "arrow.forward")
                        .imageScale(.small)
                        .foregroundColor(Color.init(white: 0.4))
                }
            }
            .padding(.vertical, 5)
        }
    }
}

struct SettingsContentNavigationLink<Content: View, RowContent: View>: View {
    
    @ObservedObject var settings = Settings.settings
    
    var title: String
    var dismiss: DismissAction
    
    @ViewBuilder var destination: () -> Content
    var label: () -> RowContent
    
    var body: some View {
        SettingsRow {
            NavigationLink {
                destination()
                    .navigationTitle(title)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            XButton {
                                dismiss()
                            }
                        }
                    }
            } label: {
                ZStack(alignment: .trailing) {
                    label()
                    Image(systemName: "arrow.forward")
                        .imageScale(.small)
                        .foregroundColor(Color.init(white: 0.4))
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
                            .foregroundColor(settings.theme.primaryTextColor)
                            .padding([.trailing, .bottom], 5)
                    }
                    SettingsText(title: title)
                    Spacer()
                    Image(systemName: "arrow.forward")
                        .imageScale(.small)
                        .foregroundColor(Color.init(white: 0.4))
                }
            }
            .padding(.vertical, 5)
        }
    }
}

struct SettingsButtonContent<Content: View>: View {
    
    var action: () -> Void
    var content: () -> Content
    
    var body: some View {
        SettingsRow {
            Button(action: action) {
                HStack {
                    content()
                    Spacer()
                    Image(systemName: "arrow.forward")
                        .imageScale(.small)
                        .foregroundColor(Color.init(white: 0.4))
                }
            }
        }
    }
}

struct AStack<Content: View>: View {
    
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ViewBuilder
    var content: () -> Content
    
    var body: some View {
        if sizeCategory >= .accessibilityMedium && horizontalSizeClass == .compact {
            HStack {
                VStack(alignment: .leading, content: content)
                Spacer()
            }
        } else {
            HStack(content: content)
        }
    }
}

struct HScrollStack<Content: View>: View {
                            
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ViewBuilder
    var content: () -> Content
    
    var body: some View {
        if sizeCategory >= .accessibilityMedium && horizontalSizeClass == .compact {
            ScrollView(.horizontal) {
                HStack(content: content)
            }
        } else {
            HStack(content: content)
        }
    }
}
