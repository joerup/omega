//
//  ScrollRow.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/7/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct ScrollRow: View {
    
    @ObservedObject var settings = Settings.settings
    
    var queue: Queue? = nil
    
    var width: CGFloat
    var buttonHeight: CGFloat
    
    var theme: Theme? = nil
    
    var active: Bool = true
    var onChange: (Queue) -> Void = { _ in }
    
    var body: some View {
        
        HStack(spacing:0) {
            
            ScrollView(.horizontal) {
                
                HStack(spacing:0) {
                    
                    ForEach(Input.scrollRow.buttons.indices, id: \.self) { index in
                        
                        let button = Input.scrollRow.buttons[index]
                        
                        ButtonView(button: button, input: queue, backgroundColor: color((theme ?? self.settings.theme).color3), width: width*0.95/4, height: buttonHeight, relativeSize: 0.35, active: active, onChange: onChange)
                            .padding(.leading, index == 0 ? 0 : width*0.025/4)
                            .padding(.trailing, index == Input.scrollRow.buttons.count-1 ? 0 : width*0.025/4)
                    }
                }
            }
            .frame(width: width*(1-2*0.025/4), height: buttonHeight, alignment: .center)
            .background(color((theme ?? self.settings.theme).color3).darker(by: 0.05))
            .clipShape(RoundedRectangle(cornerRadius: (width*0.95/4 + buttonHeight)/CGFloat(settings.buttonCornerRadius), style: .continuous))
            .padding(.horizontal, width*0.025/4)
            .padding(.vertical, buttonHeight*0.025)
        }
        .frame(width: width)
        .border(Color.purple, width: self.settings.guidelines ? 1 : 0)
    }
}
