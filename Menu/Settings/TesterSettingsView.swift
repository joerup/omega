//
//  TesterSettingsView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/11/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct TesterSettingsView: View {
    
    @ObservedObject var settings = Settings.settings
    
    @State private var proOverrideOn: Bool = false
    @State private var proOverride: Bool = false
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("These settings are used only for testing the app, and they are not saved between app sessions.")
                            .foregroundColor(Color.init(white: 0.7))
                            .padding(20)
                        
                        SettingsGroup {
                            SettingsToggle(toggle: self.$proOverrideOn,
                                           title: "Allow Pro Override"
                            )
                            SettingsToggle(toggle: self.$proOverride,
                                           title: "Omega Pro"
                            )
                            .disabled(!proOverrideOn)
                        }
                        .onChange(of: proOverride) { proOverride in
                            self.settings.proOverride = proOverrideOn ? proOverride : nil
                        }
                        .onChange(of: proOverrideOn) { proOverrideOn in
                            self.settings.proOverride = proOverrideOn ? proOverride : nil
                        }
                        
                        SettingsGroup {
                            SettingsToggle(toggle: self.$settings.guidelines,
                                           title: "Layout Guidelines"
                            )
                        }
                        
                        //                    SettingsGroup {
                        //                        SettingsToggle(toggle: self.$settings.noButtonElements,
                        //                                       title: "No Button Formatting"
                        //                                    )
                        //                        SettingsToggle(toggle: self.$settings.noElements,
                        //                                       title: "No Text Formatting"
                        //                                    )
                        //                        SettingsToggle(toggle: self.$settings.noSoundsHaptics,
                        //                                       title: "No Sounds/Haptics"
                        //                                    )
                        //                    }
                        
                        Spacer()
                            .frame(height: 30)
                    }
                }
            }
        }
        .onAppear {
            if let override = self.settings.proOverride {
                self.proOverrideOn = true
                self.proOverride = override
            }
        }
    }
}
