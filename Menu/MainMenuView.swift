//
//  MainMenuView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/4/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct MainMenuView: View {
    
    @ObservedObject var settings = Settings.settings
    
    @StateObject var storeManager: StoreManager
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var sidebar: Bool = true
    
    @State private var recentDisplayType: ListDisplayType = .all
    @State private var savedDisplayType: ListDisplayType = .all
    @State private var storedVarDisplayType: ListDisplayType = .all
    
    @State private var selectedDate: Date = Date()
    @State private var selectedFolder: String? = nil
    
    @State private var welcome: Bool = false
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var size: Size {
        return verticalSizeClass == .compact || horizontalSizeClass == .compact ? .small : .large
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                ScrollView {
                    
                    Button(action: {
                        self.welcome.toggle()
                    }) {
                        VStack {
                            Text("OMEGA CALCULATOR")
                                .font(.system(size: size.smallerLargeSize*0.9, weight: .heavy, design: .rounded))
                                .lineLimit(0)
                                .overlay(
                                    RadialGradient(colors: [color(settings.theme.color1, edit: true).lighter(by: 0.3).opacity(0.9), color(settings.theme.color1, edit: true).darker(by: 0.3).opacity(0.9)], center: .center, startRadius: 0, endRadius: 300)
                                        .mask(
                                            Text("OMEGA CALCULATOR")
                                                .font(.system(size: size.smallerLargeSize*0.9, weight: .heavy, design: .rounded))
                                                .lineLimit(0)
                                        )
                                )
                                .minimumScaleFactor(0.1)
                                .animation(.default)
                            if proCheck() {
                                Text("PRO")
                                    .font(Font.system(.title2, design: .rounded).weight(.heavy))
                                    .lineLimit(0)
                                    .overlay(
                                        RadialGradient(colors: [color(settings.theme.color2, edit: true).lighter(by: 0.3).opacity(0.9), color(settings.theme.color2, edit: true).darker(by: 0.3).opacity(0.9)], center: .center, startRadius: 0, endRadius: 300)
                                            .mask(
                                                Text("PRO")
                                                    .font(Font.system(.title2, design: .rounded).weight(.heavy))
                                                    .lineLimit(0)
                                            )
                                    )
                                    .minimumScaleFactor(0.1)
                                    .animation(.default)
                            }
                        }
                        .padding(20)
                        .padding(.top, 30)
                        .padding(.bottom, proCheck() ? 20 : 30)
                        .frame(maxWidth: .infinity)
                        .background(Color.init(white: 0.1))
                        .cornerRadius(20)
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                    .overlay(ZStack {
                        if horizontalSizeClass == .compact || !sidebar {
                            XButtonOverlay {
                                settings.showMenu = false
                            }
                        }
                    })
                    .animation(.default)
                    
                    LazyVStack(spacing: 15) {
                        
                        if !proCheck() {
                            Button(action: {
                                self.settings.menuType = .pro
                            }) {
                                VStack {
                                    Text("Upgrade to")
                                        .font(Font.system(.body, design: .rounded).weight(.heavy))
                                        .lineLimit(0)
                                        .minimumScaleFactor(0.5)
                                        .foregroundColor(Color.white)
                                        .shadow(color: .init(white: 0.3), radius: 20)
                                        .animation(.default)
                                    Text("OMEGA PRO")
                                        .font(Font.system(.title2, design: .rounded).weight(.heavy))
                                        .lineLimit(0)
                                        .minimumScaleFactor(0.5)
                                        .foregroundColor(Color.white)
                                        .shadow(color: .init(white: 0.3), radius: 20)
                                        .animation(.default)
                                }
                                .padding(20)
                                .frame(maxWidth: .infinity)
                                .background(RadialGradient(colors: [.green.lighter(by: 0.4), .init(red: 0.2, green: 0.6, blue: 0.6)], center: .center, startRadius: 0, endRadius: 300))
                                .cornerRadius(20)
                            }
                            .padding(.horizontal, 5)
                            .padding(.top, 5)
                        }
                        
                        VStack {
                            MainMenuRowView(type: .recentCalculations, selected: self.$settings.menuType)
                            MainMenuRowView(type: .savedCalculations, selected: self.$settings.menuType)
                            MainMenuRowView(type: .storedValues, selected: self.$settings.menuType)
                        }
                        .animation(nil)

                        VStack {
                            MainMenuRowView(type: .themes, selected: self.$settings.menuType, themeCircles: true)
                            MainMenuRowView(type: .settings, selected: self.$settings.menuType)
                            MainMenuRowView(type: .testerSettings, selected: self.$settings.menuType)
                        }
                        .animation(nil)

                        VStack {
                            MainMenuRowView(type: .about, selected: self.$settings.menuType)
                        }
                        .animation(nil)
                        
                        VStack(spacing: 5) {
                            Text("Omega Calculator")
                                .font(.footnote)
                                .foregroundColor(Color.init(white: 0.5))
                            HStack(spacing: 3) {
                                Text("Version")
                                    .font(.footnote)
                                    .foregroundColor(Color.init(white: 0.5))
                                Text(appVersion ?? "")
                                    .font(.footnote)
                                    .foregroundColor(Color.init(white: 0.5))
                            }
                        }
                        .padding(10)
                        
                        Spacer()
                            .frame(height: 40)
                    }
                    .animation(nil)
                    .padding(5)
                }
                .animation(nil)
                .accentColor(color(self.settings.theme.color1, edit: true))
                .frame(width: horizontalSizeClass == .regular && sidebar ? 305 : geometry.size.width)
                .padding(.trailing, horizontalSizeClass == .regular && sidebar ? geometry.size.width-305 : 0)
            }
            .background(Color.init(white: 0.05))
            .cornerRadius(20)
            .edgesIgnoringSafeArea(.bottom)
            .simultaneousGesture(DragGesture(minimumDistance: 30)
                .onChanged { value in
                    if abs(value.translation.height) > abs(value.translation.width) && value.translation.height > 50 {
                        settings.showMenu = false
                    }
                }
            )
            .overlay(
                VStack(spacing: 0) {

                    if let menuType = settings.menuType {
                        
                        HStack {
                            
                            HStack {
                                
                                if horizontalSizeClass == .compact || !sidebar {
                                    Button(action: {
                                        self.settings.menuType = nil
                                    }) {
                                        HStack {
                                            Image(systemName: "chevron.backward")
                                                .imageScale(.large)
                                                .padding(.leading, 5)
                                            Text("Menu")
                                                .font(Font.system(.body, design: .rounded))
                                                .lineLimit(0)
                                                .minimumScaleFactor(0.5)
                                        }
                                        .foregroundColor(color(settings.theme.color1, edit: true))
                                    }
                                    .padding(.trailing, 10)
                                }
                                
                                if horizontalSizeClass == .regular {
                                    Button(action: {
                                        self.sidebar.toggle()
                                    }) {
                                        Image(systemName: "sidebar.leading")
                                            .imageScale(.large)
                                            .padding(.leading, 5)
                                            .foregroundColor(color(settings.theme.color1))
                                    }
                                }
                                
                                Spacer()
                            }
                            .animation(.default)
                            .transition(.move(edge: .leading))
                            
                            Text(LocalizedStringKey(menuType.text))
                                .font(Font.system(.headline, design: .rounded).weight(.bold))
                                .animation(.default)
                                .transition(.move(edge: .top))
                                .frame(width: horizontalSizeClass == .regular && sidebar ? geometry.size.width*0.3 : geometry.size.width*0.5)
                            
                            HStack {
                                
                                Spacer()
                                
                                XButton {
                                    self.settings.showMenu = false
                                }
                            }
                        }
                        .padding(7.5)
                        .background(Color.init(white: 0.05))
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .animation(.default)
                        .transition(.opacity)
                        .simultaneousGesture(DragGesture(minimumDistance: 30)
                            .onChanged { value in
                                if abs(value.translation.height) > abs(value.translation.width) && value.translation.height > 50 {
                                    self.settings.menuType = nil
                                }
                            }
                        )
                        
                        VStack {
                            
                            switch menuType {
                            case .recentCalculations:
                                PastCalcRecentView(displayType: $recentDisplayType, selectedDate: $selectedDate)
                            case .savedCalculations:
                                PastCalcSavedView(displayType: $savedDisplayType, selectedFolder: $selectedFolder)
                            case .storedValues:
                                StoredVarList(displayType: $storedVarDisplayType)
                            case .pro:
                                OmegaProView(storeManager: storeManager)
                            case .themes:
                                ThemeView(storeManager: storeManager)
                            case .settings:
                                SettingsView()
                            case .testerSettings:
                                TesterSettingsView()
                            case .about:
                                AboutView(storeManager: storeManager)
                            case .help:
                                ReferenceList()
                            }
                        }
                        .background(Color.init(white: 0.05))
                        .edgesIgnoringSafeArea(.bottom)
                        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                        .animation(.default)
                        .transition(.move(edge: .trailing))
                        .keypadShift()
                    }
                }
                .animation(.default)
                .transition(.move(edge: .trailing))
                .frame(width: horizontalSizeClass == .regular && sidebar ? geometry.size.width-300 : geometry.size.width)
                .padding(.leading, horizontalSizeClass == .regular && sidebar ? 300 : 0)
                .simultaneousGesture(DragGesture()
                    .onChanged { value in
                        if value.translation.width > abs(value.translation.height)*3, value.startLocation.x < 30 {
                            self.settings.menuType = nil
                        }
                     }
                )
            )
            .sheet(isPresented: self.$welcome) {
                Welcome()
            }
            .onAppear {
                if horizontalSizeClass == .regular, settings.menuType == nil {
                    self.settings.menuType = .about
                }
            }
            .onChange(of: horizontalSizeClass) { horizontalSizeClass in
                if horizontalSizeClass == .regular, settings.menuType == nil {
                    self.settings.menuType = .about
                }
            }
        }
        .contentOverlay()
    }
}

enum MenuType: String, Identifiable {
    
    case recentCalculations = "Recent Calculations"
    case savedCalculations = "Saved Calculations"
    case storedValues = "Stored Variables"
    case themes = "Colors"
    case settings = "Settings"
    case testerSettings = "Tester Settings"
    case pro = "Omega Pro"
    case about = "About"
    case help = "Help"
    
    var id: Self { self }
    
    var text: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .recentCalculations:
            return "clock.arrow.circlepath"
        case .savedCalculations:
            return "folder"
        case .storedValues:
            return "character.textbox"
        case .pro:
            return "star.fill"
        case .themes:
            return "paintpalette"
        case .settings:
            return "gearshape.fill"
        case .testerSettings:
            return "gear"
        case .about:
            return "square"
        case .help:
            return "questionmark"
        }
    }
}
