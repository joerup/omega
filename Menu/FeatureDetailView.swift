//
//  FeatureDetailView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/27/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct FeatureDetailView: View {
    
    @ObservedObject var settings = Settings.settings
     
    var text: String
    var icon: String
    var desc: String?
    var content: AnyView?
    
    init<Content: View>(_ text: String, icon: String, desc: String? = nil, content: @escaping () -> Content) {
        self.text = text
        self.icon = icon
        self.desc = desc
        self.content = AnyView(content())
    }
    init(_ text: String, icon: String, desc: String? = nil) {
        self.text = text
        self.icon = icon
        self.desc = desc
        self.content = nil
    }
    
    var body: some View {
        
        VStack {
        
            VStack(alignment: .leading, spacing: 0) {
                
                HStack {
                    
                    Image(systemName: icon)
                        .foregroundColor(Color.green.lighter(by: 0.4))
                        .padding(.leading, 3)
                        .padding(.trailing, -5)
                    
                    Text(LocalizedStringKey(text))
                        .font(Font.system(.title3, design: .rounded).weight(.bold))
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .overlay(
                            LinearGradient(colors: [Color.green.lighter(by: 0.9), Color.green.lighter(by: 0.6)], startPoint: .leading, endPoint: .trailing)
                                .mask(
                                    Text(LocalizedStringKey(text))
                                        .font(Font.system(.title3, design: .rounded).weight(.bold))
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.leading)
                                )
                        )
                        .padding(.vertical, 10)
                        .padding(.leading, 10)
                    
                    Spacer()
                }
                
                if let desc = desc {
                    Text(LocalizedStringKey(desc))
                        .font(Font.system(.caption, design: .rounded))
                        .foregroundColor(Color.init(white: 0.9))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 5)
                }
                
                if let content = content {
                    content
                        .padding(10)
                        .disabled(true)
                        .background(Color.init(white: 0.15).cornerRadius(20))
                        .padding(.top, 15)
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 15)
            .padding(.top, 5)
            .background(Color.init(white: 0.17).cornerRadius(10))
            .padding(.horizontal, 10)
            
            Spacer(minLength: 0)
        }
        .frame(maxHeight: .infinity)
    }
}


struct FeatureGrouping<Content: View>: View {
    
    var geometry: GeometryProxy
    
    var content: () -> Content
    
    var body: some View {
        
        if geometry.size.width > 700 {
            HStack(alignment: .top, spacing: 0, content: content)
        } else {
            VStack(spacing: 10, content: content)
        }
    }
}
