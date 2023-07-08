//
//  DetailOverlay.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/13/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct DetailOverlay: View {
    
    @ObservedObject var settings = Settings.settings
    
    var size: Size
    var orientation: Orientation
    
    var active: Bool = true
    
    var body: some View {
        if active {
            GeometryReader { geometry in
                if settings.detailOverlay == .result {
                    ResultOverlay(geometry: geometry, size: size, orientation: orientation, primary: true)
                        .background(Color.init(white: 0.075))
                }
            }
        }
    }
}

struct SecondDetailOverlay: View {
    
    @ObservedObject var settings = Settings.settings
    
    var size: Size
    var orientation: Orientation
    
    var active: Bool = true
    
    var body: some View {
        if active {
            GeometryReader { geometry in
                if settings.detailOverlay == .result {
                    ResultOverlay(geometry: geometry, size: size, orientation: orientation, primary: false)
                        .background(Color.init(white: 0.075))
                }
            }
        }
    }
}

enum DetailOverlayType {
    case none
    case letters
    case result
}
