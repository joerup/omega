//
//  GraphInterface.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/13/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct GraphInterface: View {
    
    @ObservedObject var settings = Settings.settings
    
    var size: Size
    var orientation: Orientation
    
    var buttonHeight: CGFloat
    var standardSize: CGFloat
    var horizontalPadding: CGFloat
    
    @State private var lines: [GraphElement] = []
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                GraphView(lines, width: geometry.size.width, horizontalAxis: Letter("x"), verticalAxis: Letter("y"))
            }
        }
        .onAppear {
            for function in StoredVar.getAllVariables() {
                lines += [Line(equation: function.value, color: lines.count%3 == 0 ? settings.theme.color1 : lines.count%3 == 1 ? settings.theme.color2 : settings.theme.color3)]
            }
        }
    }
}
