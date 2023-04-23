//
//  MathButtonView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/7/23.
//  Copyright © 2023 Rupertus. All rights reserved.
//

import SwiftUI

struct MathButtonView: View {
    
    @ObservedObject var settings = Settings.settings
    
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
    
    var categories: [MathPadCategory] = [.alg, .trig, .calc, .misc]
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                
                HStack {
                    
                    ForEach(self.categories, id: \.self) { category in
                        
                        Button(action: {
                            settings.mathPadCategory = category
                        }) {
                            Text(category.rawValue)
                                .foregroundColor(settings.mathPadCategory == category ? Color.white : color(settings.theme.color1, edit: true))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(2, contentMode: .fit)
                        }
                        .background(settings.mathPadCategory == category ? color(settings.theme.color1) : Color.init(white: 0.2))
                        .cornerRadius(100)
                    }
                }
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(self.buttons.indices, id: \.self) { index in
                            HStack {
                                ButtonView(button: buttons[index], backgroundColor: color(settings.theme.color1), width: 50, height: 50, relativeSize: 0.35)
                                    .animation(nil)
                                Spacer()
                            }
                            .background(Color.init(white: 0.2).cornerRadius(20))
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .background(Color.init(white: 0.1))
        .cornerRadius(20)
    }
}
