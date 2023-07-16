//
//  OmegaProCheck.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/4/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

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
