//
//  TextLabel.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/19/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI
import UIKit

struct TextLabel: View {
    
    @ObservedObject var settings = Settings.settings
    
    var element: TextElement
    
    var colorContext: ColorContext
    
    var interaction: InteractionType = .none
    
    var body: some View {
        Text(element.display)
            .font(.system(size: element.size, weight: .medium, design: .rounded))
            .foregroundColor(element.color.inContext(colorContext))
            .if(interaction == .edit && (element.text == "#|" || element.text == "■"), transform: { view in
                view
                    .contextMenu {
                        Button(action: {
                            Calculation.current.queue.paste()
                        }) {
                            Image(systemName: "doc.on.clipboard")
                            Text("Paste")
                        }
                    }
            })
    }
}


