//
//  OmegaProLock.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/4/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct OmegaProLockFade: ViewModifier {
    
    @ObservedObject var settings = Settings.settings
    
    func body(content: Content) -> some View {
        
        if settings.pro {
            content
        } else {
            ZStack {
                content
                    .disabled(true)
                    .opacity(0.3)
                Image(systemName: "lock")
                    .font(.title2.bold())
                    .foregroundColor(Color.init(white: 0.5))
            }
            .onTapGesture {
                let _ = proCheckNotice()
            }
        }
    }
}

func proCheck(maxFreeVersion: Int? = nil) -> Bool {
    if let maxFreeVersion, Settings.settings.featureVersionIdentifier <= maxFreeVersion { return true }
    return Settings.settings.pro
}
func proCheckNotice(_ type: ProFeatureDisplay? = nil, maxFreeVersion: Int? = nil) -> Bool {
    if !proCheck(maxFreeVersion: maxFreeVersion) {
        Settings.settings.popUp(type)
    }
    return proCheck(maxFreeVersion: maxFreeVersion)
}

extension View {
    func proLock() -> some View {
        modifier(OmegaProLockFade())
    }
}
