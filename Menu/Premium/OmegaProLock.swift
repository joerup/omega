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

func proCheck() -> Bool {
    return Settings.settings.pro
}
func proCheckNotice() -> Bool {
    if !proCheck() {
        Settings.settings.promptProAd = true
    }
    return proCheck()
}

extension View {
    func proLock() -> some View {
        modifier(OmegaProLockFade())
    }
}
