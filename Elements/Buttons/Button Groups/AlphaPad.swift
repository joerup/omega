//
//  AlphaPad.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/15/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct AlphaPad: View {
    
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
    var onChange: (Queue) -> Void = { _ in }
    
    var buttons: [InputButton] {
        switch settings.alphaPadCategory {
        case .vars:
            return Input.alphaLower.buttons
        case .units:
            return Input.units.buttons
        }
    }

    var body: some View {
        
        GeometryReader { geometry in
        
            if settings.buttonDisplayMode == .alpha {
                
                VStack(spacing: 0) {
                    
                    let count = geometry.size.width > geometry.size.height ? 7 : 6
                    
                    if orientation == .portrait {
                        AlphaPadSelector(buttonHeight: buttonHeight, width: width, count: count, size: size)
                    }
                
                    VStack(spacing: 5) {
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: count), spacing: 0) {
                            
                            ForEach(0..<(count*Int(geometry.size.height/buttonHeight - 1)), id: \.self) { index in
                                    
                                if index < buttons.count {
                                    ButtonView(button: buttons[index], input: queue, backgroundColor: color(buttons[index].name == "Ω" ? (theme ?? self.settings.theme).color1 : (theme ?? self.settings.theme).color3), width: width*0.94/CGFloat(count), height: buttonHeight, relativeSize: 0.45, active: active, onChange: onChange)
                                        .padding(.vertical, buttonHeight*0.025)
                                        .padding(.horizontal, width*0.025/CGFloat(count))
                                } else {
                                    ButtonView(button: InputButton(""), input: queue, backgroundColor: color((theme ?? self.settings.theme).color3).opacity(0.4), width: width*0.94/CGFloat(count), height: buttonHeight, relativeSize: 0.45, active: false)
                                        .padding(.vertical, buttonHeight*0.025)
                                        .padding(.horizontal, width*0.025/CGFloat(count))
                                }
                            }
                        }
                    }
                    .id(settings.alphaPadCategory)
                    .proLock()
                    
                    if orientation == .landscape {
                        AlphaPadSelector(buttonHeight: buttonHeight, width: width, count: count, size: size)
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                .frame(width: width)
                .border(Color.green, width: self.settings.guidelines ? 1 : 0)
                .background(Color.init(white: 0.1))
                .cornerRadius(20)
            }
        }
    }
}

struct AlphaPadSelector: View {
    
    @ObservedObject var settings = Settings.settings
    
    var buttonHeight: CGFloat
    var width: CGFloat
    var count: Int
    
    var size: Size
    
    var categories: [AlphaPadCategory] = [.vars, .units]
    
    var body: some View {
        
        ScrollView(.horizontal) {
            
            HStack(spacing: 0) {
                
                ForEach(self.categories, id: \.self) { category in
                    
                    Button(action: {
                        settings.alphaPadCategory = category
                    }) {
                        Text(category.rawValue)
                            .font(.system(size: buttonHeight*(size == .large ? 0.2 : 0.25), design: .rounded).weight(.bold))
                            .foregroundColor(settings.alphaPadCategory == category ? Color.white : color(settings.theme.color1, edit: true))
                            .padding(size == .large ? 15 : 10)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(2, contentMode: .fit)
                    }
                    .background(settings.alphaPadCategory == category ? color(settings.theme.color1) : Color.init(white: 0.2))
                    .cornerRadius(100)
                    .padding(size == .large ? 5 : 2)
                }
            }
            .padding(5)
        }
        .cornerRadius(30)
        .frame(height: buttonHeight)
        .background(Color.init(white: 0.15))
        .clipShape(RoundedRectangle(cornerRadius: (width+buttonHeight)/CGFloat(settings.buttonCornerRadius), style: .continuous))
        .padding(.vertical, buttonHeight*0.025)
        .padding(.horizontal, width*0.025/CGFloat(count))
    }
}


enum AlphaPadCategory: String {
    case vars = "VARS"
    case units = "UNITS"
}
