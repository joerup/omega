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
    
    var body: some View {
        
        GeometryReader { geometry in
            
            if settings.detailOverlay == .result {
            
                ScrollView {

                    VStack {

                        ResultOverlay(geometry: geometry)

                        Spacer()

                    }
                    .padding(.top, 7.5)
                }
                .background(Color.init(white: 0.1))
                .cornerRadius(20)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

enum DetailOverlayType {
    case none
    case letters
    case result
}
