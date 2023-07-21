//
//  Settings.swift
//  Calculator
//
//  Created by Joe Rupertus on 5/25/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

class Settings: ObservableObject {
    
    static let settings = Settings()
    
    @Published var modes: ModeSettings = ModeSettings(raw: UserDefaults.standard.string(forKey: "modes"))
    
    @Published var clipboard: [Item] = []
    
    @Published var showMenu = false
    @Published var menuSheetRefresh = false
    
    @Published var popUp: AnyView? = nil
    @Published var warning: Warning? = nil
    @Published var keypad: Keypad? = nil
    @Published var notification: Notification.NotificationType = .none
    
    @Published var calculatorOverlay: CalculatorOverlayType = .none
    @Published var detailOverlay: DetailOverlayType = .none
    @Published var buttonDisplayMode: ButtonDisplayMode = .basic
    @Published var selectedAlphabet: Alphabet = .english
    @Published var buttonUppercase: Bool = false
    
    @Published var showProPopUp: Bool = false
    @Published var previewTheme1: Theme = ThemeData.allThemes[0]
    @Published var previewTheme2: Theme = ThemeData.allThemes[0]
    @Published var previewTheme3: Theme = ThemeData.allThemes[0]
    @Published var proPopUpType: ProFeatureDisplay? = nil
    @Published var purchaseConfirmation: Bool = false
    @Published var restoreConfirmation: Bool = false
    
    // Temporary settings
    @Published var guidelines = false
    @Published var noElements = false
    @Published var noButtonElements = false
    @Published var noSoundsHaptics = false
    
    @Published var folders: [String] = UserDefaults.standard.object(forKey: "folders") as? [String] ?? [] {
        didSet {
            UserDefaults.standard.set(self.folders, forKey: "folders")
        }
    }
    
    
    // MARK: - Premium
    
    var pro: Bool {
        return proOverride ?? UserDefaults.standard.bool(forKey: "com.rupertusapps.OmegaCalc.PRO")
    }
    @Published var proOverride: Bool? = true
    
    @Published var featureVersionIdentifier: Int = UserDefaults.standard.integer(forKey: "featureVersionIdentifier") {
        didSet {
            UserDefaults.standard.set(self.featureVersionIdentifier, forKey: "featureVersionIdentifier")
        }
    }
    
    func popUp(_ displayType: ProFeatureDisplay? = nil) {
        self.proPopUpType = displayType
        self.showProPopUp = true
    }
    
    
    // MARK: - Calculator Type
    
    var calculatorType: CalculatorType? {
        get {
            guard let type = UserDefaults.standard.value(forKey: "calculatorType") as? String else {
                return nil
            }
            return CalculatorType(rawValue: type)
        }
        set(type) {
            UserDefaults.standard.set(type?.rawValue, forKey: "calculatorType")
        }
    }
    
    
    // MARK: - Theme
    
    var theme: Theme {
        let theme = ThemeData.allThemes[themeID]
        if !theme.locked {
            return theme
        }
        return ThemeData.allThemes[0]
    }
    
    @Published var themeID: Int = UserDefaults.standard.integer(forKey: "themeID") {
        didSet {
            UserDefaults.standard.set(self.themeID, forKey: "themeID")
        }
    }
    @Published var favoriteThemes: [Int] = UserDefaults.standard.object(forKey: "favoriteThemes") as? [Int] ?? [] {
        didSet {
            UserDefaults.standard.set(self.favoriteThemes, forKey: "favoriteThemes")
        }
    }
    @Published var unlockedThemeCategories: [String] = UserDefaults.standard.object(forKey: "unlockedThemeCategories") as? [String] ?? [] {
        didSet {
            UserDefaults.standard.set(self.unlockedThemeCategories, forKey: "unlockedThemeCategories")
        }
    }
    
    // MARK: - Settings
    
    // MARK: Buttons
    @Published var soundEffects: Bool = UserDefaults.standard.bool(forKey: "soundEffects") {
        didSet {
            UserDefaults.standard.set(self.soundEffects, forKey: "soundEffects")
        }
    }
    @Published var hapticFeedback: Bool = UserDefaults.standard.bool(forKey: "hapticFeedback") {
        didSet {
            UserDefaults.standard.set(self.hapticFeedback, forKey: "hapticFeedback")
        }
    }
    
    // MARK: Text
    @Published var textAnimations: Bool = UserDefaults.standard.bool(forKey: "textAnimations") {
        didSet {
            UserDefaults.standard.set(self.textAnimations, forKey: "textAnimations")
        }
    }
    
    // MARK: Display
    
    @Published var roundPlaces: Int = UserDefaults.standard.integer(forKey: "roundPlaces") {
        didSet {
            UserDefaults.standard.set(self.roundPlaces, forKey: "roundPlaces")
            Calculation.current.refresh()
        }
    }
    @Published var thousandsSeparators: Int = UserDefaults.standard.integer(forKey: "thousandsSeparators") {
        didSet {
            UserDefaults.standard.set(self.thousandsSeparators, forKey: "thousandsSeparators")
            Calculation.current.refresh()
        }
    }
    @Published var commaDecimal: Bool = UserDefaults.standard.bool(forKey: "commaDecimal") {
        didSet {
            UserDefaults.standard.set(self.commaDecimal, forKey: "commaDecimal")
            Calculation.current.refresh()
        }
    }
    @Published var displayX10: Bool = UserDefaults.standard.bool(forKey: "displayX10") {
        didSet {
            UserDefaults.standard.set(self.displayX10, forKey: "displayX10")
            Calculation.current.refresh()
        }
    }
    @Published var arcInverseTrig: Bool = UserDefaults.standard.bool(forKey: "arcInverseTrig") {
        didSet {
            UserDefaults.standard.set(self.arcInverseTrig, forKey: "arcInverseTrig")
            Calculation.current.refresh()
        }
    }
    @Published var minimumTextSize: Int = UserDefaults.standard.integer(forKey: "minimumTextSize") {
        didSet {
            UserDefaults.standard.set(self.minimumTextSize, forKey: "minimumTextSize")
            Calculation.current.refresh()
        }
    }
    
    // MARK: Input
    
    @Published var autoParFunction: Bool = UserDefaults.standard.bool(forKey: "autoParFunction") {
        didSet {
            UserDefaults.standard.set(self.autoParFunction, forKey: "autoParFunction")
            Calculation.current.refresh()
        }
    }
    @Published var stayInGroups: Bool = UserDefaults.standard.bool(forKey: "stayInGroups") {
        didSet {
            UserDefaults.standard.set(self.stayInGroups, forKey: "stayInGroups")
            Calculation.current.refresh()
        }
    }
    
    // MARK: Evaluation
    
    @Published var implicitMultFirst: Bool = UserDefaults.standard.bool(forKey: "implicitMultFirst") {
        didSet {
            UserDefaults.standard.set(self.implicitMultFirst, forKey: "implicitMultFirst")
            Calculation.current.refresh()
        }
    }
    
    // MARK: - Other
    
    @Published var constantsRoundPlaces: Int = UserDefaults.standard.integer(forKey: "constantsRoundPlaces") {
        didSet {
            UserDefaults.standard.set(self.constantsRoundPlaces, forKey: "constantsRoundPlaces")
        }
    }
    @Published var recentConstants: [[[String]]] = UserDefaults.standard.object(forKey: "recentConstants") as? [[[String]]] ?? [] {
        didSet {
            UserDefaults.standard.set(self.recentConstants, forKey: "recentConstants")
        }
    }
    @Published var recentMathButtons: [String] = UserDefaults.standard.object(forKey: "recentMathButtons") as? [String] ?? [] {
        didSet {
            UserDefaults.standard.set(self.recentMathButtons, forKey: "recentMathButtons")
        }
    }
    
}

func defaultSettings() {
    
    let userDefaults = UserDefaults.standard
    let settings = Settings.settings
    
    // MARK: Set Up
    
    if userDefaults.object(forKey: "calculatorType") == nil {
        settings.calculatorType = .calculator
        settings.featureVersionIdentifier = 1
    }
    
    // TRANSFER to new shrink setting, also allow old pro features to existing users! 2.2.0
    if let shrink = userDefaults.object(forKey: "shrink") as? Double {
        userDefaults.set(true, forKey: "oldProFeatures")
        userDefaults.removeObject(forKey: "shrink")
        settings.minimumTextSize = (shrink > 0.7 ? 2 : shrink > 0.3 ? 1 : 0)
    }
    
    // MARK: Default Settings Values
    
    // Buttons
    if userDefaults.object(forKey: "soundEffects") == nil {
        settings.soundEffects = true
    }
    if userDefaults.object(forKey: "hapticFeedback") == nil {
        settings.hapticFeedback = true
    }
    
    // Text
    if userDefaults.object(forKey: "textAnimations") == nil {
        settings.textAnimations = false
    }
    if userDefaults.object(forKey: "minimumTextSize") == nil {
        settings.minimumTextSize = 1
    }
    
    // Display
    if userDefaults.object(forKey: "roundPlaces") == nil {
        settings.roundPlaces = 9
    }
    if userDefaults.object(forKey: "thousandsSeparators") == nil {
        settings.thousandsSeparators = 1
        if let commas = userDefaults.object(forKey: "commaSeparators") as? Bool, let spaces = userDefaults.object(forKey: "spaceSeparators") as? Bool {
            settings.thousandsSeparators = commas ? 1 : spaces ? 2 : 0
            userDefaults.removeObject(forKey: "commaSeparators")
            userDefaults.removeObject(forKey: "spaceSeparators")
        }
    }
    if userDefaults.object(forKey: "commaDecimal") == nil {
        settings.commaDecimal = NumberFormatter().decimalSeparator == ","
    }
    if userDefaults.object(forKey: "displayX10") == nil {
        settings.displayX10 = false
    }
    if userDefaults.object(forKey: "minimumTextSize") == nil {
        settings.minimumTextSize = 1
    }
    
    // Input
    if userDefaults.object(forKey: "autoParFunction") == nil {
        settings.autoParFunction = true
    }
    if userDefaults.object(forKey: "stayInGroups") == nil {
        settings.stayInGroups = false
    }
    
    // Evaluation
    if userDefaults.object(forKey: "implicitMultFirst") == nil {
        settings.implicitMultFirst = false
    }
    
    // MARK: Other
    
    if userDefaults.object(forKey: "constantsRoundPlaces") == nil {
        settings.constantsRoundPlaces = 4
    }
    if userDefaults.object(forKey: "recentConstants") == nil {
        settings.recentConstants = [
            [
                ["2.99792458","E","8"],
                ["5.9722","E","24"],
                ["1.618033988749894848204586834365638"]
            ],
            [
                ["“","m","/","s","‘"],
                ["kg"],
                []
            ]
        ]
    }
    if userDefaults.object(forKey: "recentMathButtons") == nil {
        settings.recentMathButtons = []
    }
}

