//
//  MathPad.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/15/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct MathPad: View {
    
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
    var onChange: (Calculation) -> Void = { _ in }
    
    var buttons: [InputButton] {
        switch settings.mathPadCategory {
        case .alg:
            return Input.mathAlg.buttons
        case .trig:
            return Input.mathTrig.buttons
        case .calc:
            return Input.mathCalc.buttons
        case .misc:
            return Input.mathMisc.buttons
        }
    }
    
    var body: some View {
        
        GeometryReader { geometry in
        
            if settings.buttonDisplayMode == .math {
                
                VStack(spacing: 0) {
                    
                    if orientation == .portrait {
                        MathPadSelector(buttonHeight: buttonHeight, width: width, count: 6, size: size)
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 6), spacing: 0) {
                        
                        let totalSpaces = 6*Int(geometry.size.height/buttonHeight - 1)
                        
                        ForEach(0..<(totalSpaces >= buttons.count ? totalSpaces : buttons.count), id: \.self) { index in
                            
                            if index < buttons.count {
                                ButtonView(button: buttons[index], backgroundColor: color((theme ?? self.settings.theme).color3), width: (width*0.95)/6, height: buttonHeight, relativeSize: 0.35)
                                    .padding(.vertical, buttonHeight*0.025)
                                    .padding(.horizontal, width*0.025/6)
                            } else {
                                ButtonView(button: InputButton(""), backgroundColor: color((theme ?? self.settings.theme).color3).opacity(0.4), width: (width*0.95)/6, height: buttonHeight, relativeSize: 0.35, active: false)
                                    .padding(.vertical, buttonHeight*0.025)
                                    .padding(.horizontal, width*0.025/6)
                            }
                        }
                        .animation(nil)
                    }
                    .id(settings.mathPadCategory)
                    
                    if orientation == .landscape {
                        MathPadSelector(buttonHeight: buttonHeight, width: width, count: 6, size: size)
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

struct MathPadSelector: View {
    
    @ObservedObject var settings = Settings.settings
    
    var buttonHeight: CGFloat
    var width: CGFloat
    var count: Int
    
    var size: Size
    
    var categories: [MathPadCategory] = [.alg, .trig, .calc, .misc]
    
    var body: some View {
        
        ScrollView(.horizontal) {
            
            HStack(spacing: 0) {
                
                ForEach(self.categories, id: \.self) { category in
                    
                    Button(action: {
                        settings.mathPadCategory = category
                    }) {
                        Text(category.rawValue)
                            .font(.system(size: buttonHeight*(size == .large ? 0.2 : 0.25), design: .rounded).weight(.bold))
                            .foregroundColor(settings.mathPadCategory == category ? Color.white : color(settings.theme.color1, edit: true))
                            .padding(size == .large ? 15 : 10)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(2, contentMode: .fit)
                    }
                    .background(settings.mathPadCategory == category ? color(settings.theme.color1) : Color.init(white: 0.2))
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


enum MathPadCategory: String {
    case alg = "ALG"
    case trig = "TRIG"
    case calc = "CALC"
    case misc = "MISC"
}
