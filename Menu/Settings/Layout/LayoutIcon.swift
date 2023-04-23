//
//  LayoutIcon.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/8/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct LayoutIcon: View {
    
    @ObservedObject var settings = Settings.settings
    
    var displayType: LayoutDisplayType
    var expanded: Bool
    
    var width: CGFloat
    var height: CGFloat
    
    init(displayType: LayoutDisplayType, expanded: Bool = false, longerSize: CGFloat, shorterSize: CGFloat) {
        self.displayType = displayType
        self.expanded = expanded
        self.width = displayType == .landscape ? longerSize : shorterSize
        self.height = displayType == .portrait ? longerSize : shorterSize
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            if displayType == .portrait && !expanded {
                
                VStack(spacing: geometry.size.width*0.05) {
                    
                    Spacer()
                        .frame(height: geometry.size.height*0.18)
                    
                    Rectangle()
                        .frame(width: geometry.size.width*0.85, height: geometry.size.height*0.1, alignment: .center)
                        .foregroundColor(color(self.settings.theme.color3))
                        .cornerRadius(geometry.size.width*0.05)
                    
                    HStack(spacing: geometry.size.width*0.05) {
                        
                        Rectangle()
                            .frame(width: geometry.size.width*0.6, height: geometry.size.height*0.4, alignment: .center)
                            .foregroundColor(color(self.settings.theme.color1))
                            .cornerRadius(geometry.size.width*0.06)
                        
                        Rectangle()
                            .frame(width: geometry.size.width*0.18, height: geometry.size.height*0.4, alignment: .center)
                            .foregroundColor(color(self.settings.theme.color2))
                            .cornerRadius(geometry.size.width*0.05)
                    }
                    
                    Rectangle()
                        .frame(width: geometry.size.width*0.85, height: geometry.size.height*0.08, alignment: .center)
                        .foregroundColor(Color.init(white: 0.1))
                        .cornerRadius(geometry.size.width*0.04)
                }
                .frame(width: self.width, height: self.height, alignment: .center)
            }
            
            else if displayType == .portrait && expanded {
                
                VStack(spacing: geometry.size.width*0.05) {
                    
                    Spacer()
                        .frame(height: geometry.size.height*0.18)
                    
                    Rectangle()
                        .frame(width: geometry.size.width*0.85, height: geometry.size.height*0.16, alignment: .center)
                        .foregroundColor(color(self.settings.theme.color3))
                        .cornerRadius(geometry.size.width*0.05)
                    
                    HStack(spacing: geometry.size.width*0.05) {
                        
                        Rectangle()
                            .frame(width: geometry.size.width*0.14, height: geometry.size.height*0.36, alignment: .center)
                            .foregroundColor(color(self.settings.theme.color3))
                            .cornerRadius(geometry.size.width*0.05)
                        
                        Rectangle()
                            .frame(width: geometry.size.width*0.47, height: geometry.size.height*0.36, alignment: .center)
                            .foregroundColor(color(self.settings.theme.color1))
                            .cornerRadius(geometry.size.width*0.06)
                        
                        Rectangle()
                            .frame(width: geometry.size.width*0.14, height: geometry.size.height*0.36, alignment: .center)
                            .foregroundColor(color(self.settings.theme.color2))
                            .cornerRadius(geometry.size.width*0.05)
                    }
                    
                    Rectangle()
                        .frame(width: geometry.size.width*0.85, height: geometry.size.height*0.08, alignment: .center)
                        .foregroundColor(Color.init(white: 0.1))
                        .cornerRadius(geometry.size.width*0.04)
                }
                .frame(width: self.width, height: self.height, alignment: .center)
            }
            
            else if displayType == .landscape {
                
                VStack(spacing: geometry.size.height*0.05) {
                    
                    Spacer()
                        .frame(height: geometry.size.height*0.18)
                    
                    HStack(spacing: geometry.size.height*0.05) {
                        
                        Rectangle()
                            .frame(width: geometry.size.width*0.48, height: geometry.size.height*0.48, alignment: .center)
                            .foregroundColor(color(self.settings.theme.color3))
                            .cornerRadius(geometry.size.width*0.05)
                            
                        Rectangle()
                            .frame(width: geometry.size.width*0.27, height: geometry.size.height*0.48, alignment: .center)
                            .foregroundColor(color(self.settings.theme.color1))
                            .cornerRadius(geometry.size.width*0.04)
                        
                        Rectangle()
                            .frame(width: geometry.size.width*0.1, height: geometry.size.height*0.48, alignment: .center)
                            .foregroundColor(color(self.settings.theme.color2))
                            .cornerRadius(geometry.size.width*0.03)
                    }
                    
                    HStack(spacing: geometry.size.height*0.05) {
                        
                        Rectangle()
                            .frame(width: geometry.size.width*0.48, height: geometry.size.height*0.08, alignment: .center)
                            .foregroundColor(Color.init(white: 0.1))
                            .cornerRadius(geometry.size.width*0.01)
                            
                        Rectangle()
                            .frame(width: geometry.size.width*0.42, height: geometry.size.height*0.08, alignment: .center)
                            .foregroundColor(Color.init(white: 0.1))
                            .cornerRadius(geometry.size.width*0.01)
                    }
                }
                .frame(width: self.width, height: self.height, alignment: .center)
                
            }
        }
        .frame(width: self.width, height: self.height, alignment: .center)
    }
}
