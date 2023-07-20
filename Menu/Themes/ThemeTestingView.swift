//
//  ThemeTestingView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/18/23.
//  Copyright © 2023 Rupertus. All rights reserved.
//

import SwiftUI

struct ThemeTestingView: View {
    
    @Environment(\.self) var environment
    
    @State private var color1: Color = .white
    @State private var color2: Color = .white
    @State private var color3: Color = .white
    
    private var theme: Theme {
        Theme(id: 24, name: "Test", category: "Basic", color1: color1.rgb, color2: color2.rgb, color3: color3.rgb)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ButtonPad(size: .small, orientation: .portrait, width: geometry.size.width, buttonHeight: geometry.size.height*0.2, theme: theme, active: false)
                VStack {
                    HStack {
                        Text(color1.rgbString)
                        ColorPicker("", selection: $color1)
                    }
                    HStack {
                        Text(color2.rgbString)
                        ColorPicker("", selection: $color2)
                    }
                    HStack {
                        Text(color3.rgbString)
                        ColorPicker("", selection: $color3)
                    }
                }
                .padding(.horizontal)
                HStack {
                    Button {
                        UIPasteboard.general.string = copyString
                    } label: {
                        Text("Copy RGB Values")
                    }
                    Spacer()
                    Button {
                        UIPasteboard.general.string = color1.rgbString
                    } label: {
                        Text("COLOR 1").font(.body.bold()).foregroundColor(color1)
                    }
                    Button {
                        UIPasteboard.general.string = color2.rgbString
                    } label: {
                        Text("COLOR 2").font(.body.bold()).foregroundColor(color2)
                    }
                    Button {
                        UIPasteboard.general.string = color3.rgbString
                    } label: {
                        Text("COLOR 3").font(.body.bold()).foregroundColor(color3)
                    }
                }
                .padding(.horizontal)
                Spacer(minLength: 0)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(ThemeData.allThemes, id: \.id) { theme in
                            Button {
                                setCurrentTheme(theme)
                            } label: {
                                VStack {
                                    Text(theme.name).fontWeight(.bold)
                                    ThemeCircles(theme: theme)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .onAppear {
                setCurrentTheme()
            }
            .background(Color.init(white: 0.075).edgesIgnoringSafeArea(.all))
        }
    }
    
    private var copyString: String {
        return """
        
        color1: [\(color1.rgbString)],
        color2: [\(color2.rgbString)],
        color3: [\(color3.rgbString)]
        """
    }
    
    private func setCurrentTheme(_ theme: Theme? = nil) {
        let theme = theme ?? Settings.settings.theme
        color1 = color(theme.color1)
        color2 = color(theme.color2)
        color3 = color(theme.color3)
        Settings.settings.themeID = theme.id
    }
}

extension Color {
    var rgb: [CGFloat] {

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return [0,0,0]
        }

        return [255*r, 255*g, 255*b]
    }
    
    var rgbString: String {
        return "\(Int(rgb[0])),\(Int(rgb[1])),\(Int(rgb[2]))"
    }
}

