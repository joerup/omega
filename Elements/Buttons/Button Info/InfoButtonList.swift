//
//  InfoButtonList.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 3/28/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct InfoButtonList: View {
    
    @ObservedObject var settings = Settings.settings
    
    var buttons: [InfoButton]
    
    @Binding var selectedButton: InfoButton?
    
    var body: some View {
            
        VStack {
            ForEach(buttons, id: \.id) { button in
                VStack {
                    HStack {
                        ButtonView(button: button.button, backgroundColor: color(self.settings.theme.color3), width: 30, height: 30, relativeSize: 0.4, active: false)
                        
                        Text(button is InfoButtonCluster ? (button as! InfoButtonCluster).clusterName : button.fullName)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        if !(button is InfoButtonCluster) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color.init(white: 0.8))
                                .padding(.trailing, 7)
                                .onTapGesture {
                                    button.insert()
                                }
                        }
                    }
                    .padding(10)
                    .background(Color.init(white: equalButtonFill(button) ? 0.25 : 0.1).cornerRadius(20))
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        if button.fullName == selectedButton?.fullName && button.cluster == selectedButton?.cluster {
                            selectedButton = nil
                        } else {
                            selectedButton = button
                        }
                    }
                    
                    if let cluster = button as? InfoButtonCluster, equalButton(button) {
                        InfoButtonList(buttons: cluster.buttons, selectedButton: $selectedButton)
                            .padding(.leading, 20)
                    }
                }
            }
        }
    }
    
    func equalButton(_ button: InfoButton) -> Bool {
        if let cluster = button as? InfoButtonCluster {
            return cluster.buttons.contains(where: { $0.name == selectedButton?.name })
        } else {
            return button.name == selectedButton?.name
        }
    }
    
    func equalButtonFill(_ button: InfoButton) -> Bool {
        if let cluster = button as? InfoButtonCluster, let selectedCluster = selectedButton as? InfoButtonCluster {
            return cluster.clusterName == selectedCluster.clusterName
        } else {
            return button.name == selectedButton?.name && !(selectedButton is InfoButtonCluster)
        }
    }
}


struct InfoConstantList: View {
    
    @ObservedObject var settings = Settings.settings
    
    var constants: [InfoConstant]
    
    var body: some View {
        
        ForEach(constants, id: \.id) { constant in
            
            InfoConstantView(constant: constant)
                .padding(.leading, 15)
                .padding(.trailing, 5)
        }
    }
}
