//
//  SettingsGroup.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/25/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct SettingsGroup<Content: View>: View {
    
    var title: String?
    var columns: Bool
    var light: Double
    
    var content: () -> Content
    
    init(_ title: String? = nil, columns: Bool = false, light: Double = 0.15, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.columns = columns
        self.light = light
        self.content = content
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            if let title = title {
                Text(NSLocalizedString(title, comment: "").uppercased())
                    .font(Font.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundColor(Color.init(white: 0.4))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
            }
            
            if columns {
                LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())], spacing: 0) {
                    content()
                        .padding(.horizontal, 5)
                }
                .padding(.horizontal, 10)
                .padding(.bottom, -1)
                .background(Color.init(white: light))
                .cornerRadius(10)
                .padding(.horizontal, 10)
            } else {
                VStack(spacing: 0, content: content)
                    .padding(.horizontal, 10)
                    .padding(.bottom, -1)
                    .background(Color.init(white: light))
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
            }
        }
    }
}

struct SettingsRow<Content: View>: View {
    
    var desc: LocalizedStringKey? = nil
    var content: () -> Content
    
    init(content: @escaping () -> Content) {
        self.desc = nil
        self.content = content
    }
    init(desc: LocalizedStringKey? = nil, content: @escaping () -> Content) {
        self.desc = desc
        self.content = content
    }
    init(desc: String? = nil, content: @escaping () -> Content) {
        self.desc = desc != nil ? LocalizedStringKey(desc!) : nil
        self.content = content
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            VStack(alignment: .leading, spacing: 0) {
                
                content()
                
                if let desc = desc {
                    Text(desc)
                        .font(Font.system(.caption, design: .rounded))
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                        .padding(.top, -5)
                        .padding(.bottom, 15)
                }
            }
            .padding(.horizontal, 5)
            
            Divider()
        }
    }
}

struct SettingsText: View {
    
    var title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey(self.title))
                .font(Font.system(.subheadline, design: .default).weight(.semibold))
                .foregroundColor(Color.init(white: 0.9))
        }
        .frame(minHeight: 3.5*UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
    }
}
