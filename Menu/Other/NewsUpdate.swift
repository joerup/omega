//
//  NewsUpdate.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/5/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct NewsUpdate: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var scale: Double = 1.0
    
    var majorVersion: String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        let version = (appVersion as! String)
        return String(version.prefix(3))
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
                
                VStack(spacing: 15) {
                    
                    Text("Omega Calculator Version \(majorVersion)")
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                    
                    Text("Our biggest update ever.")
                        .font(.title.bold())
                        .multilineTextAlignment(.center)
                        .overlay(
                            LinearGradient(colors: [Color.blue.lighter(by: 0.4), Color.blue.darker(by: 0.4)], startPoint: .leading, endPoint: .trailing)
                                .mask(
                                    Text("Our biggest update ever.")
                                        .font(.title.bold())
                                        .multilineTextAlignment(.center)
                                )
                        )
                        .padding(.vertical, 10)
                    
                    NewsUpdateItem(
                        title: "The text pointer is here.",
                        desc: "Move anywhere in the input line and add or delete characters. Either use the on-screen arrow keys or simply tap where you want to go."
                    ) {
                        TextDisplay(strings: ["2","+","#|","3","^","2","-","5"], size: 30)
                            .padding(.vertical, 10)
                    }
                    
                    NewsUpdateItem(
                        title: "Placeholder squares.",
                        desc: "Click a placeholder to move to its location in the input line."
                    ) {
                        TextDisplay(strings: ["7.12","-","8.9","+","■","√","□"], size: 30)
                            .padding(.vertical, 10)
                    }
                    
                    NewsUpdateItem(
                        title: "Gemstones.",
                        desc: "A stunning brand new theme set. Available to unlock now."
                    ) {
                        ZStack {
                            if let category = ThemeData.themes.first(where: { $0.name == "Gemstones" }) {
                                ThemeGrouping(themes: category.themes, geometry: geometry, preview: .constant(nil), showUnlock: .constant(false))
                                    .padding(.vertical, -10)
                            }
                        }
                    }
                    
                    NewsUpdateItem(
                        title: "Favorite themes and theme previews.",
                        desc: "Select your favorites for easy access. And check out a preview of a theme you haven't unlocked."
                    )
                    
                    NewsUpdateItem(
                        title: "The brand new calculation toolbar.",
                        desc: "The classic 2nd button, along with easy access to math buttons with the new MAT menu. Plus, quick actions for calculated results."
                    ) {
                        HStack {
                            SmallTextButton(text: "2nd", color: Color.init(white: 0.25), textColor: color(settings.theme.color3, edit: true)) {}
                            SmallTextButton(text: "MAT", color: Color.init(white: 0.25), textColor: color(settings.theme.color3, edit: true)) {}
                            Spacer()
                            SmallIconButton(symbol: "doc.on.clipboard", color: Color.init(white: 0.25), textColor: color(settings.theme.color1, edit: true)) {}
                            SmallIconButton(symbol: "folder", color: Color.init(white: 0.25), textColor: color(settings.theme.color1, edit: true)) {}
                            SmallIconButton(symbol: "character.textbox", color: Color.init(white: 0.25), textColor: color(settings.theme.color1, edit: true)) {}
                        }
                    }
                    
                    NewsUpdateItem(
                        title: "Updated calculation menus.",
                        desc: "A fresh look for past calculations. Insert directly from the list. Select multiple calculations and perform quick actions."
                    ) {
                        HStack {
                            VStack {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(color(self.settings.theme.color1, edit: true))
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(50/4)
                                    Image(systemName: "number")
                                        .foregroundColor(.init(white: 0.1))
                                        .opacity(0.6)
                                        .font(.system(size: 50/2, weight: .black))
                                }
                                .padding(.horizontal, 5)
                                .padding(.top, 5)
                                Text("4:00")
                                    .foregroundColor(Color.init(white: 0.7))
                                    .font(.caption)
                                    .frame(width: 60)
                                    .minimumScaleFactor(0.1)
                                    .lineLimit(0)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 0) {
                                    TextDisplay(strings: ["#2","√","#(","25","+","3","#)","+","8"], size: 24, opacity: 0.7, equals: true)
                                        .frame(height: 36)
                                    TextDisplay(strings: ["15.912512668"], size: 36)
                                        .frame(height: 45)
                            }
                            .border(Color.yellow, width: settings.guidelines ? 1 : 0)
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color.init(white: 0.8))
                                .imageScale(.large)
                                .frame(maxHeight: .infinity)
                        }
                        .frame(minHeight: 90)
                        .padding(.horizontal, 7)
                        .padding(5)
                        .background(Color.init(white:0.25).cornerRadius(20))
                        .padding(.horizontal, -10)
                    }
                    
                    Group {
                        
                        VStack {
                                
                            Text("OMEGA PRO")
                                .font(.custom("AvenirNext-Heavy", size: 40, relativeTo: .body))
                                .lineLimit(0)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(Color.white)
                                .shadow(color: .init(white: 0.3), radius: 20)
                                .padding(20)
                                .scaleEffect(sqrt(scale)*1.1)
                                .padding(.vertical, -10)
                            
                            Text("A new premium option with even more awesome features.")
                                .font(.title3.bold())
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.white)
                                .opacity(0.8)
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 30)
                        
                        NewsUpdateItem(
                            title: "Stored Variables.",
                            desc: "Store values in variables. Use them in more calculations.",
                            pro: true
                        ) {
                            VStack(alignment: .leading, spacing: 30) {
                                TextDisplay(strings: ["2","*","¶w","+","3"], size: 30)
                                TextDisplay(strings: ["¶P","-","27"], size: 30)
                            }.padding(.vertical, 10)
                        }
                        
                        NewsUpdateItem(
                            title: "Variable Expressions.",
                            desc: "Create expressions with unknown variables. Then plug values into them.",
                            pro: true
                        ) {
                            VStack(alignment: .leading, spacing: 20) {
                                TextDisplay(strings: ["0.5","*","»x","^","2","-","3"], size: 30)
                                HStack {
                                    TextDisplay(strings: ["»x"], size: 28, color: color(settings.theme.color1))
                                        .frame(width: 28)
                                    HStack {
                                        Text("UNKNOWN VAR")
                                            .font(.caption)
                                            .foregroundColor(Color.init(white: 0.6))
                                            .padding(.leading, 2)
                                        Spacer()
                                        TextInput(queue: Queue([Number(2.34)]), placeholder: ["x"], defaultValue: Queue(), size: 22, scrollable: true)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 28)
                                    .padding(10)
                                    .background(Color.init(white: 0.27).cornerRadius(20))
                                }
                                HStack {
                                    Spacer()
                                    TextDisplay(strings: ["= -0.2622"], size: 20)
                                        .padding(.horizontal, 10)
                                }
                            }.padding(.vertical, 10)
                        }
                        
                        NewsUpdateItem(
                            title: "Graphs & Tables.",
                            desc: "Beautiful graphs and tables representing single-variable expressions.",
                            pro: true
                        ) {
                            HStack {
                                GraphView([Line(equation: Queue([Number(0.5),Operation(.con),Letter("x"),Operation(.pow),Number(2)]), color: settings.theme.color1)], gridLines: false, interactive: false, precision: 100)
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        self.settings.showMenu = false
                    }) {
                        Text("Continue")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .shadow(color: .init(white: 0.5), radius: 10)
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                            .background(RadialGradient(colors: [Color.blue.lighter(by: 0.2), Color.blue.darker(by: 0.2)], center: .center, startRadius: 0, endRadius: 300))
                            .cornerRadius(20)
                    }
                    .frame(maxWidth: 500)
                    .shadow(color: Color.init(white: 0.2), radius: 15)
                    .scaleEffect(scale)
                    .padding(20)
                    .onAppear {
                        withAnimation(Animation.linear(duration: 5.0).repeatForever()) {
                            scale = 1.05
                        }
                    }
                }
            }
        }
    }
}

struct NewsUpdateItem: View {
    
    @ObservedObject var settings = Settings.settings
    
    var title: String
    var desc: String
    var pro: Bool
    var content: AnyView?
    
    init<Content: View>(title: String, desc: String, pro: Bool = false, content: @escaping () -> Content) {
        self.title = title
        self.desc = desc
        self.pro = pro
        self.content = AnyView(content())
    }
    
    init(title: String, desc: String, pro: Bool = false) {
        self.title = title
        self.desc = desc
        self.pro = pro
        self.content = nil
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                
                Text(title)
                    .font(.title3.bold())
                    .multilineTextAlignment(.leading)
                    .overlay(
                        LinearGradient(colors: pro ? [.green.lighter(by: 0.4), .init(red: 0.2, green: 0.6, blue: 0.6)] : [Color.blue.lighter(by: 0.4), Color.blue.darker(by: 0.4)], startPoint: .leading, endPoint: .trailing)
                            .mask(
                                Text(title)
                                    .font(.title3.bold())
                                    .multilineTextAlignment(.leading)
                            )
                    )
                
                Spacer()
                
                if pro {
                    Text("PRO")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }
            }
            
            Text(desc)
                .font(.caption)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            if let content = content {
                content
                    .padding(.top, 5)
                    .disabled(true)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.init(white: 0.2).cornerRadius(20))
        .padding(.horizontal, 10)
    }
}
