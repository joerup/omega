//
//  ThemePreview.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/30/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct ThemePreview: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Binding var preview: ThemePreviewItem?
    
    @Environment(\.presentationMode) var presentationMode
    
    var theme: Theme {
        return preview?.theme ?? ThemeData.themes[0].themes[0]
    }
    var category: ThemeCategory? {
        return preview?.category
    }
    var name: String? {
        return preview?.name
    }
    
    var next: Theme? {
        return category?.themes.first(where: { $0.id > theme.id }) ?? category?.themes.first
    }
    var last: Theme? {
        return category?.themes.last(where: { $0.id < theme.id }) ?? category?.themes.last
    }
    
    @State private var orientation: Orientation = .portrait
    
    @State private var update = false
    
    var size: Size {
        return verticalSizeClass == .compact || horizontalSizeClass == .compact ? .small : .large
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                HStack {
                    
                    SmallIconButton(symbol: "rotate.right", smallerLarge: true) {
                        self.orientation = orientation == .portrait ? .landscape : .portrait
                    }
                    .padding(.top, size == .large ? -5 : 0)
                    
                    Spacer()
                    
                    if let name = name {
                        Text(LocalizedStringKey(name))
                            .font(Font.system(.headline, design: .rounded).weight(.bold))
                    }
                    else if let category = category {
                        Text(LocalizedStringKey("\(category.name) Series"))
                            .font(Font.system(.headline, design: .rounded).weight(.bold))
                    }
                    
                    Spacer()
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        SoundManager.play(haptic: .medium)
                    } label: {
                        Text("Done")
                            .foregroundColor(theme.primaryTextColor)
                            .font(.system(.body, design: .rounded).weight(.semibold))
                    }
                    .padding(.horizontal)
                }
                .frame(height: size.smallerLargeSize+15)
                .padding(.horizontal, 7.5)
                
                GeometryReader { geometry2 in
                    CalculatorModel(orientation: orientation, maxWidth: geometry2.size.width - 30, maxHeight: geometry2.size.height - 20, theme: theme)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                HStack {
                    
                    SmallIconButton(symbol: "chevron.backward") {
                        if let last = last {
                            self.preview = ThemePreviewItem(last, category: category)
                        }
                    }
                    .opacity(last != nil ? 1 : 0)
                    .padding(20)
                    
                    Spacer()
                    
                    VStack {
                        
                        Text(theme.name)
                            .font(Font.system(verticalSizeClass == .regular ? .title : .title3, design: .rounded).weight(.bold))
                            .lineLimit(0)
                            .minimumScaleFactor(0.5)
                            .padding(.vertical, 5)
                        
                        ThemeCircles(theme: theme)
                    }
                    
                    Spacer()
                    
                    SmallIconButton(symbol: "chevron.forward") {
                        if let next = next {
                            self.preview = ThemePreviewItem(next, category: category)
                        }
                    }
                    .opacity(next != nil ? 1 : 0)
                    .padding(20)
                }
                .padding(.vertical, geometry.size.height*0.01)
                .padding(.bottom, verticalSizeClass == .regular ? 10 : 0)
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                self.orientation = geometry.size.width > geometry.size.height ? .landscape : .portrait
            }
        }
    }
}

struct ThemePreviewItem: Identifiable {
    
    var id = UUID()
    var theme: Theme
    var category: ThemeCategory?
    var name: String?
    
    init(_ theme: Theme, category: ThemeCategory? = nil, name: String? = nil) {
        self.theme = theme
        self.category = category
        self.name = name
    }
}
