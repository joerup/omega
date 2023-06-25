//
//  OmegaProSplash.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/24/23.
//  Copyright © 2023 Rupertus. All rights reserved.
//

import SwiftUI

struct OmegaProSplash: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @StateObject var storeManager: StoreManager
    
    @State private var displayType: ProFeatureDisplay = .themes
    
    @State private var theme: Theme = ThemeData.allThemes[4...].randomElement()!
    @State private var recentThemeIDs: [Int] = []
    
    @State private var scale: Double = 0.95
    @State private var starPositions: [CGPoint] = []
    @State private var starScales: [CGFloat] = []
    
    @State private var introBottomOffset: CGFloat = 0
    @State private var introTitleScale: CGFloat = 1
    @State private var introSubtitleScale: CGFloat = 1
    @State private var contentOffset: CGFloat = 0
    @State private var contentOpacity: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { geometry in
        
            VStack {
                
                Text("OMEGA PRO")
                    .font(.system(size: 50, weight: .heavy, design: .rounded))
                    .lineLimit(0)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Color.white)
                    .scaleEffect(introTitleScale)
                    .shadow(color: .init(white: 0.3), radius: 20)
                    .scaleEffect(scale)
                    .padding(.top, 30)
                
                if displayType != .all {
                    header(text)
                        .padding(.top, -30)
                }
                
                VStack {
                    
                    Spacer(minLength: 0)
                    
                    VStack {
                        if verticalSizeClass == .regular {
                            switch displayType {
                            case .all:
                                featureList()
                            case .themes:
                                themeDisplay(size: geometry.size)
                            case .variables:
                                EmptyView()
                            }
                        }
                    }
                    .shadow(color: .init(white: 0.3).opacity(0.5), radius: 20)
                    
                    Spacer(minLength: 0)
                    
                    if displayType != .all {
                        Button {
                            withAnimation(.easeOut(duration: 0.5)) {
                                contentOpacity = 0
                            }
                            withAnimation(.easeOut(duration: 0.1)) {
                                displayType = .all
                                contentOffset = 2000
                            }
                            withAnimation(.easeOut(duration: 0.5)) {
                                contentOffset = 0
                                contentOpacity = 1
                            }
                        } label: {
                            Text("See All Features")
                                .font(.system(.headline, design: .rounded).weight(.bold))
                                .foregroundColor(.white.opacity(0.9))
                                .minimumScaleFactor(0.5)
                                .shadow(color: .init(white: 0.3), radius: 20)
                        }
                        .shadow(color: .init(white: 0.3), radius: 20)
                    }
                }
                .offset(y: contentOffset)
                .opacity(contentOpacity)
                
                VStack {
                    
                    if settings.pro {
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Text("Unlocked")
                                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                                    .foregroundColor(.white)
                                    .lineLimit(0)
                                    .minimumScaleFactor(0.5)
                                    .shadow(color: .init(white: 0.4), radius: 15)
                                Image(systemName: "checkmark")
                                    .imageScale(.large)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(.white)
                                    .shadow(color: .init(white: 0.4), radius: 15)
                            }
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                            .background(RadialGradient(gradient: Gradient(colors: [.white, .black]), center: .init(x: scale*20 - 19, y: 0), startRadius: 1, endRadius: 400).overlay(color(theme.color1).opacity(0.6)))
                            .cornerRadius(20)
                            .shadow(color: .init(white: 0.1).opacity(0.3), radius: 15)
                        }
                        .frame(maxWidth: 500)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        .padding(.top, 20)
                        .scaleEffect(scale*1.05)
                        
                    } else if let product = storeManager.myProducts.first(where: { $0.productIdentifier == "com.rupertusapps.OmegaCalc.PRO" }) {
                        
                        Button(action: {
                            storeManager.purchaseProduct(product: product)
                            print("Buying \(product.localizedTitle)")
                        }) {
                            VStack {
                                Text("Purchase for \(product.localizedPrice)")
                                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                                    .lineLimit(0)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(.white)
                                Text("One-Time Payment")
                                    .font(Font.system(.footnote, design: .rounded).weight(.bold))
                                    .lineLimit(0)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(.white)
                            }
                            .shadow(color: .init(white: 0.4), radius: 15)
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                            .background(RadialGradient(gradient: Gradient(colors: [.white, .black]), center: .init(x: scale*20 - 19, y: 0), startRadius: 1, endRadius: 400).overlay(color(theme.color1).opacity(0.6)))
                            .cornerRadius(20)
                            .shadow(color: .init(white: 0.1).opacity(0.3), radius: 15)
                        }
                        .frame(maxWidth: 500)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        .padding(.top, 20)
                        .scaleEffect(scale*1.05)
                    }
                    
                    Button(action: {
                        self.storeManager.restoreProducts()
                    }) {
                        Text("Restore Purchases")
                            .font(Font.system(.subheadline, design: .rounded).weight(.bold))
                            .foregroundColor(.black.opacity(0.5))
                            .shadow(color: .init(white: 0.3), radius: 20)
                            .padding(.top, -10)
                            .padding(.bottom, 5)
                    }
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Not Now")
                            .font(Font.system(.subheadline, design: .rounded).weight(.bold))
                            .foregroundColor(.black.opacity(0.5))
                            .shadow(color: .init(white: 0.3), radius: 20)
                            .padding(.bottom, 10)
                    }
                }
                .frame(width: geometry.size.width)
                .background(Color.white.opacity(0.3).frame(maxWidth: .infinity).cornerRadius(10).edgesIgnoringSafeArea(.all))
                .offset(y: introBottomOffset)
            }
            .frame(width: geometry.size.width)
            .background(
                ZStack {
                    LinearGradient(colors: [.white, .gray], startPoint: .top, endPoint: .bottom)
                        .overlay(color(theme.color1).opacity(0.6))
                        .edgesIgnoringSafeArea(.all)
                    ForEach(starPositions.indices, id: \.self) { i in
                        Image(systemName: "star.fill")
                            .font(.system(size: (50-pow(Double(i), 0.7))))
                            .scaleEffect(starScales[i])
                            .foregroundColor(.white.opacity(0.8*scale))
                            .opacity((Double(i)/100 + 0.1)*0.5)
                            .position(starPositions[i])
                    }
                }
            )
            .onChange(of: geometry.size) { size in
                starScales = (0..<50).map { _ in CGFloat(Double.random(in: 0.5..<2)) }
                starPositions = (0..<50).map { _ in CGPoint(x: Double.random(in: 0..<max(size.width, 1)), y: Double.random(in: 0..<max(size.height, 1))) }
            }
        }
        .onAppear {
            recentThemeIDs = [theme.id]
            cycleTheme()
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                scale = 1.0
            }
            introBottomOffset = 2000
            contentOffset = 2000
            contentOpacity = 0
            introTitleScale = 0
            introSubtitleScale = 0
            withAnimation(.easeInOut(duration: 1)) {
                introTitleScale = 1.2
            }
            withAnimation(.easeInOut(duration: 0.5).delay(1)) {
                introTitleScale = 1.0
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.7)) {
                introSubtitleScale = 1.0
            }
            withAnimation(.easeOut(duration: 1)) {
                introBottomOffset = 0
            }
            if displayType != .all {
                contentOffset = 0
            }
            withAnimation(.easeOut(duration: 1).delay(0.7)) {
                contentOffset = 0
                contentOpacity = 1
            }
        }
    }
    
    private var text: String {
        switch displayType {
        case .all:
            return "All Features"
        case .themes:
            return "Customization to the extreme."
        case .variables:
            return "More ways to work."
        }
    }
    
    private func bubble<Content: View>(_ title: String, icon: String, link: ProFeatureDisplay? = nil, desc: String? = nil, content: @escaping () -> Content = { EmptyView() }) -> some View {
        FeatureBubble(displayType: $displayType, title: title, icon: icon, link: link, desc: desc, content: content)
    }
    private func header(_ text: String) -> some View {
        Text(text)
            .font(.system(.title2, design: .rounded).weight(.bold))
            .lineLimit(0)
            .minimumScaleFactor(0.5)
            .foregroundColor(Color.white)
            .scaleEffect(introSubtitleScale)
            .shadow(color: .init(white: 0.3), radius: 20)
            .padding(.horizontal)
            .padding(.top, 10)
    }
    
    private func featureList() -> some View {
        ScrollView {
            VStack {
                Group {
                    header("Premium Themes")
                    bubble("Themes", icon: "paintpalette", link: .themes, desc: "Access to over 30 premium themes.")
                }
                Group {
                    header("Functions & Variables")
                    bubble("Variables", icon: "character.textbox", link: .variables, desc: "Store values to variables. Then use them in more calculations.")
                    bubble("Functions", icon: "function", desc: "Plug in values to unassigned variables for quick and easy results.")
                    bubble("Graphing", icon: "perspective", desc: "Beautiful graphical displays of function behavior.")
                    bubble("Tables", icon: "table", desc: "See input-output tables for functions.")
                }
                Group {
                    header("Exclusive Buttons")
                    bubble("Derivative at a Point", icon: "app", desc: "")
                    bubble("Definite Integral", icon: "app", desc: "")
                    bubble("Summation/Product Notation", icon: "app", desc: "")
                }
                Group {
                    header("Miscellaneous")
                    bubble("Text Pointer", icon: "character.cursor.ibeam", link: .all, desc: "Move anywhere in the input line and add or delete characters. Either use the on-screen arrow keys or simply tap where you want to go.")
                    bubble("Export Calculations", icon: "arrow.up.doc", desc: "Export any or all of your past calculations to spreadsheet format in a CSV file, which can be imported into other programs.")
                    bubble("Keyboard Support", icon: "keyboard", desc: "External/bluetooth keyboards for iPad and Mac can be used in place of the calculator buttons.")
                    bubble("Unlimited Saved Calculations", icon: "folder", desc: "Save an unlimited number of calculations so they remain in the app forever.")
                    bubble("Recents last 180 days", icon: "clock.arrow.circlepath", desc: "Unsaved calculations will expire after 180 days instead of the default 14.")
                    bubble("Saved Calculation Folders", icon: "folder.fill", desc: "Organize saved calculations into folders to access them more easily.")
                    bubble("Extra Results", icon: "ellipsis.circle", desc: "Additional representations of a calculated result: fraction form, in terms of π, etc. Generated automatically when a calculation is made.")
                    bubble("Special Graphs", icon: "chart.pie", desc: "Calculate a trig function and get a visual unit circle representation. Or get a graph of the tangent line or the area under the curve when you calculate derivatives and integrals.")
                }
            }
            .padding(20)
        }
    }
    
    private func themeDisplay(size: CGSize) -> some View {
        CalculatorModel(maxWidth: size.width*0.8, maxHeight: size.height*0.5, theme: theme)
            .overlay(
                VStack {
                    Text(theme.name)
                        .font(.system(.callout, design: .rounded).weight(.heavy))
                        .foregroundColor(Color.white)
                        .lineLimit(0)
                        .minimumScaleFactor(0.5)
                        .padding(.top)
                    
                    ThemeCircles(theme: theme)
                        .scaleEffect(0.8)
                    
                    Spacer()
                }
            )
    }
    
    private func cycleTheme() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            if ThemeData.allThemes[4...].count == recentThemeIDs.count {
                recentThemeIDs.removeAll()
            }
            withAnimation(.easeIn(duration: 0.6)) {
                self.theme = ThemeData.allThemes[4...].filter({ !recentThemeIDs.contains($0.id) }).randomElement()!
                recentThemeIDs.append(theme.id)
            }
            withAnimation(.linear(duration: 5)) {
                for i in starPositions.indices {
                    starPositions[i].x += Double.random(in: -10...10)
                    starPositions[i].y += Double.random(in: -10...10)
                    starScales[i] = Double.random(in: 0.5..<2)
                }
            }
            cycleTheme()
        }
    }
}


enum ProFeatureDisplay {
    case all
    case themes
    case variables
}

struct FeatureBubble<Content: View>: View {
    
    @Binding var displayType: ProFeatureDisplay
    
    var title: String
    var icon: String
    var link: ProFeatureDisplay?
    var desc: String?
    var content: () -> Content
    
    @State private var showDetails = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.black.opacity(0.7))
                    .frame(width: 30)
                Text(title)
                    .font(.system(.headline, design: .rounded).weight(.bold))
                    .foregroundColor(.black.opacity(0.7))
                Spacer()
                Image(systemName: "chevron.\(showDetails ? "up" : "down")")
                    .foregroundColor(.black.opacity(0.7))
            }
            if showDetails {
                if let desc {
                    Text(desc)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.black.opacity(0.7))
                        .multilineTextAlignment(.leading)
                        .padding(.top, 3)
                }
                content()
            }
        }
        .padding(20)
        .frame(maxWidth: 400)
        .background(Color.white.opacity(0.6))
        .cornerRadius(20)
        .onTapGesture {
            withAnimation {
                showDetails.toggle()
            }
//            if let link {
//                displayType = link
//            }
        }
    }
}
