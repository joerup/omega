//
//  UnitPad.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 5/26/23.
//  Copyright © 2023 Rupertus. All rights reserved.
//

import SwiftUI

struct UnitPad: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var queue: Queue? = nil
    
    var width: CGFloat
    var buttonHeight: CGFloat
    
    var size: Size
    var orientation: Orientation
    
    var expanded: Bool = false
    
    var theme: Theme? = nil
    
    var active: Bool = true
    var showText: Bool = true
    var onChange: (Queue) -> Void = { _ in }
    
    var buttons: [InputButton] {
        return Input.units.buttons
    }

    var body: some View {
        
        GeometryReader { geometry in
                
            VStack(spacing: 0) {
                
                let count = orientation == .landscape ? 7 : size == .large ? 8 : 5
                    
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: count), spacing: 0) {
                    
                    ForEach(0..<(count*Int(geometry.size.height/buttonHeight)), id: \.self) { index in
                            
                        if index < buttons.count {
                            ButtonView(button: buttons[index], input: queue, backgroundColor: buttons[index].name == "Ω" ? (theme ?? settings.theme).color1 : (theme ?? settings.theme).color3, width: width*0.95/CGFloat(count), height: buttonHeight, relativeSize: 0.45, active: active, showText: showText, onChange: onChange)
                                .padding(.vertical, buttonHeight*0.025)
                                .padding(.horizontal, width*0.025/CGFloat(count))
                        } else {
                            ButtonView(button: InputButton(""), input: queue, backgroundColor: (theme ?? settings.theme).color3.opacity(0.4), width: width*0.95/CGFloat(count), height: buttonHeight, relativeSize: 0.45, active: false, showText: false)
                                .padding(.vertical, buttonHeight*0.025)
                                .padding(.horizontal, width*0.025/CGFloat(count))
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .frame(width: width)
            .border(Color.green, width: self.settings.guidelines ? 1 : 0)
            .background(Color.init(white: 0.07))
        }
    }
}
