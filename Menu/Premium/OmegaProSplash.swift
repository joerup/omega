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
    
    private var displayType: ProFeatureDisplay {
        return settings.proPopUpType ?? .list
    }
    
    @State private var theme: Theme = ThemeData.allThemes[4...].randomElement()!
    @State private var otherTheme1: Theme = ThemeData.allThemes[4...].randomElement()!
    @State private var otherTheme2: Theme = ThemeData.allThemes[4...].randomElement()!
    @State private var recentThemeIDs: [Int] = []
    
    @State private var scale: Double = 0.95
    @State private var starPositions: [CGPoint] = []
    @State private var starScales: [CGFloat] = []
    @State private var introTitleScale: CGFloat = 1
    @State private var introSubtitleScale: CGFloat = 1
    @State private var cycleContentOpacity: CGFloat = 1
    
    private let expression1 = Queue([Number(1),Operation(.fra),Number(2),Operation(.con),Letter("x"),Operation(.pow),Number(4),Operation(.sub),Number(2),Operation(.con),Letter("x"),Operation(.pow),Number(3)])
    private let expression2 = Queue([Letter("a"),Operation(.add),Letter("b"),Operation(.add),Letter("c"),Operation(.add),Pointer()])
    private let expression3 = Queue([Function(.definteg),Number(0),Expression([Number(3),Operation(.con),Number("π")], grouping: .hidden),Expression([Number(7),Operation(.con),Function(.sin),Expression([Number(1),Operation(.fra),Number(3),Operation(.con),Letter("x")])], grouping: .hidden),Letter("x")])
    private let expression4 = Queue([Function(.valDeriv),Number("#1"),Letter("z"),Expression([Function(.log),Number("#e"),Letter("z")]),Number("e")])
    private let expression5 = Queue([Number(2),Pointer(),Operation(.add),Number(3.01)])
    
    private let modes = ModeSettings(angleUnit: .rad)
    
    @State private var displayTimer: Timer? = nil
    @State private var themeTimer: Timer? = nil
    
    var body: some View {
        
        GeometryReader { geometry in
        
            VStack {
                
                Text("OMEGA PRO")
                    .font(.system(size: 50, weight: .heavy, design: .rounded))
                    .lineLimit(0)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Color.white)
                    .scaleEffect(introTitleScale)
                    .shadow(color: .init(white: 0.05), radius: 20)
                    .scaleEffect(scale)
                    .padding(.top, 30)
                
                if displayType != .list {
                    Text(text)
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .lineLimit(0)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(Color.white)
                        .opacity(cycleContentOpacity)
                        .scaleEffect(introSubtitleScale)
                        .shadow(color: .init(white: 0.05), radius: 10)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.top, -30)
                }
                
                VStack {
                    
                    Spacer(minLength: 0)
                    
                    VStack {
                        if verticalSizeClass == .regular {
                            switch displayType {
                            case .list, .cycle:
                                featureList()
                            case .themes:
                                themeDisplay()
                            case .variables:
                                variableDisplay()
                            case .calculus:
                                calculusDisplay()
                            case .misc:
                                miscDisplay()
                            }
                        } else if displayType == .list {
                            Text("Turn your device")
                                .font(.callout.weight(.medium))
                                .foregroundColor(.white.opacity(0.9))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .shadow(color: .init(white: 0.05), radius: 10)
                        }
                    }
                    .shadow(color: .init(white: 0.05).opacity(0.7), radius: 10)
                    
                    Spacer(minLength: 0)
                    
                    if displayType != .list {
                        Text(desc)
                            .font(.callout.weight(.medium))
                            .foregroundColor(.white.opacity(0.9))
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .shadow(color: .init(white: 0.05), radius: 10)
                            .padding(.vertical, 5)
                            .padding(.horizontal)
                            .opacity(cycleContentOpacity)
                    }
                    
                    if displayType != .list {
                        Button {
                            withAnimation {
                                settings.proPopUpType = .list
                            }
                        } label: {
                            Text("See All Features")
                                .font(.system(.headline, design: .rounded).weight(.bold))
                                .foregroundColor(.white.opacity(0.9))
                                .minimumScaleFactor(0.5)
                                .shadow(color: .init(white: 0.05), radius: 10)
                        }
                    }
                }
                
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
                        
                    } else {
                        
                        VStack {
                            Text("Loading")
                                .font(Font.system(.title2, design: .rounded).weight(.bold))
                                .lineLimit(0)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.white)
                                .frame(height: 100)
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.4))
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
                            .opacity((Double(i)/100 + 0.1)*0.3)
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
            // Cycle Displays
            displayTimer?.invalidate()
            if displayType == .cycle {
                settings.proPopUpType = ProFeatureDisplay.random()
                displayTimer = Timer.scheduledTimer(withTimeInterval: 7.0, repeats: true) { _ in
                    cycleDisplay()
                }
            }
            
            // Cycle Themes
            themeTimer?.invalidate()
            recentThemeIDs = [theme.id, otherTheme1.id, otherTheme2.id]
            themeTimer = Timer.scheduledTimer(withTimeInterval: 7.0, repeats: true) { _ in
                cycleTheme()
            }
            
            // Intro Animations
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                scale = 1.0
            }
            introTitleScale = 0
            introSubtitleScale = 0
            withAnimation(.easeInOut(duration: 0.7).delay(0.1)) {
                introTitleScale = 1.1
            }
            withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                introTitleScale = 1.0
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
                introSubtitleScale = 1.0
            }
        }
        .onDisappear {
            displayTimer?.invalidate()
            themeTimer?.invalidate()
        }
    }
    
    private var text: String {
        switch displayType {
        case .list, .cycle:
            return "All Features"
        case .themes:
            return "Customization to the extreme."
        case .variables:
            return "A graphing calculator on the go."
        case .calculus:
            return "Advanced functions made simple."
        case .misc:
            return "Convenient tools and features."
        }
    }
    private var desc: String {
        switch displayType {
        case .list, .cycle:
            return ""
        case .themes:
            return "Access to over 30 themes. With so many colorful options, there's a look for everyone."
        case .variables:
            return "Variables. Functions. Graphs. Make quick computations and easily analyze relationships."
        case .calculus:
            return "Summation & Products. Derivatives & Integrals. More power to meet your needs."
        case .misc:
            return "Make easy edits with an interactive text pointer. Save and export unlimited calculations. And more."
        }
    }
    
    
    private func featureList() -> some View {
        ScrollView {
            VStack {
                
                Text("Take your calculator to the next level.")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .lineLimit(0)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Color.white)
                    .shadow(color: .init(white: 0.3), radius: 20)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                FeatureBubble(title: "All the themes.", theme: theme, linkAction: { settings.proPopUpType = .themes }) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 8)) {
                        ForEach(ThemeData.allThemes[4...], id: \.id) { theme in
                            ThemeIcon(theme: theme, size: 36)
                        }
                    }
                    .padding(10)
                .frame(maxWidth: .infinity)
                }
                
                FeatureBubble(title: "More power to you.", theme: theme, linkAction: { settings.proPopUpType = .variables }) {
                    FeatureView(title: "Variables & functions", icon: "character.textbox", desc: "Assign values to variables and use them later. Or create functions to perform quick and easy calculations.")
                    HStack {
                        Spacer(minLength: 0)
                        TextDisplay(strings: expression1.strings, modes: modes, size: 20, theme: theme)
                        Spacer(minLength: 0)
                        TextDisplay(strings: expression2.strings, modes: modes, size: 20, theme: theme)
                        Spacer(minLength: 0)
                    }
                    .padding(10)
                    .frame(height: 120)
                    .background(Color.init(white: 0.05).opacity(0.9).cornerRadius(10))
                    .shadow(color: .init(white: 0.3).opacity(0.5), radius: 20)
                    .padding(10)
                    
                    FeatureView(title: "Graphs & tables", icon: "perspective", desc: "Visualize function relationships with full 2D graphs and input-output tables.")
                    HStack {
                        Spacer(minLength: 0)
                        GraphView([Line(equation: expression1, color: theme.color1)], gridLines: false, interactive: false, precision: 60)
                            .aspectRatio(1.0, contentMode: .fit)
                            .cornerRadius(20)
                            .disabled(true)
                        Spacer().frame(width: 10, height: 150)
                        TableView(equation: expression1, horizontalAxis: Letter("x"), verticalAxis: Letter("y"), lowerBound: -10, upperBound: 10, increment: 1, fullTable: false, fontSize: 12, color: theme.color1)
                            .background(Color.init(white: 0.1))
                            .aspectRatio(1.0, contentMode: .fit)
                            .cornerRadius(20)
                            .disabled(true)
                        Spacer(minLength: 0)
                    }
                    .frame(maxHeight: .infinity)
                    .shadow(color: .init(white: 0.3).opacity(0.5), radius: 20)
                    .padding(10)
                }
                
                FeatureBubble(title: "New mathematical tools.", theme: theme, linkAction: { settings.proPopUpType = .calculus }) {
                    FeatureView(title: "Advanced operations", icon: "sum", desc: "Calculate sums and products. Derivatives at points and definite integrals over areas.")
                    HStack {
                        Spacer(minLength: 0)
                        TextDisplay(strings: expression4.strings, modes: modes, size: 30, theme: theme)
                        Spacer(minLength: 0)
                        TextDisplay(strings: expression3.strings, modes: modes, size: 30, theme: theme)
                        Spacer(minLength: 0)
                    }
                    .padding(10)
                    .frame(height: 60)
                    .background(Color.init(white: 0.05).opacity(0.9).cornerRadius(10))
                    .shadow(color: .init(white: 0.3).opacity(0.5), radius: 20)
                    .padding(10)
                    
                    FeatureView(title: "Equivalent forms", icon: "ellipsis.circle", desc: "Fraction form, in terms of π, and more.")
                    FeatureView(title: "Special trig & calculus visuals", icon: "chart.pie", desc: "Unit circles, tangent lines, area under curves.")
                }
                
                FeatureBubble(title: "For your convenience.", theme: theme, linkAction: { settings.proPopUpType = .misc }) {
                    FeatureView(title: "Interactive text pointer", icon: "character.cursor.ibeam", desc: "Move anywhere in the input line to edit it. Use the arrows or simply tap the text directly.")
                    FeatureView(title: "Export calculations", icon: "arrow.up.doc", desc: "Export to CSV and use calculations into other programs.")
                    FeatureView(title: "Unlimited saved calculations", icon: "folder")
                    FeatureView(title: "Recent calculations last 180 days", icon: "clock.arrow.circlepath")
                    FeatureView(title: "Saved calculation folders", icon: "folder.fill")
                    FeatureView(title: "External keyboard support", icon: "keyboard")
                }
            }
            .padding(20)
        }
    }
    
    private func themeDisplay() -> some View {
        GeometryReader { geometry in
            ZStack {
                CalculatorModel(.shapes, orientation: .portrait, maxWidth: geometry.size.width*0.31, maxHeight: geometry.size.height*0.8, theme: otherTheme1)
                    .overlay(
                        VStack {
                            Text(otherTheme1.name)
                                .font(.system(.caption, design: .rounded).weight(.bold))
                                .foregroundColor(Color.white.opacity(0.8))
                                .lineLimit(0)
                                .minimumScaleFactor(0.5)
                                .padding(.top)
                            ThemeCircles(theme: otherTheme1)
                                .scaleEffect(0.7)
                            Spacer()
                        }
                    )
                .padding(.trailing, geometry.size.width*0.63)
                
                CalculatorModel(.shapes, orientation: .portrait, maxWidth: geometry.size.width*0.31, maxHeight: geometry.size.height*0.8, theme: otherTheme2)
                .overlay(
                    VStack {
                        Text(otherTheme2.name)
                            .font(.system(.caption, design: .rounded).weight(.bold))
                            .foregroundColor(Color.white.opacity(0.8))
                            .lineLimit(0)
                            .minimumScaleFactor(0.5)
                            .padding(.top)
                        ThemeCircles(theme: otherTheme2)
                            .scaleEffect(0.7)
                        Spacer()
                    }
                )
                .padding(.leading, geometry.size.width*0.63)
                
                CalculatorModel(.shapes, orientation: .portrait, maxWidth: geometry.size.width*0.36, maxHeight: geometry.size.height*0.8, theme: theme)
                    .overlay(
                        VStack {
                            Text(theme.name)
                                .font(.system(.caption, design: .rounded).weight(.bold))
                                .foregroundColor(Color.white.opacity(0.8))
                                .lineLimit(0)
                                .minimumScaleFactor(0.5)
                                .padding(.top)
                            ThemeCircles(theme: theme)
                                .scaleEffect(0.7)
                            Spacer()
                        }
                    )
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
        }
        .transition(.opacity)
        .disabled(true)
    }
    
    private func variableDisplay() -> some View {
        GeometryReader { geometry in
            ZStack {
                
                CalculatorModel(.buttonsText(text: expression2), orientation: .portrait, maxWidth: geometry.size.width*0.31, maxHeight: geometry.size.height*0.8, theme: theme)
                    .padding(.trailing, geometry.size.width*0.63)
                
                CalculatorModel(.buttonsText(text: expression1), orientation: .portrait, maxWidth: geometry.size.width*0.31, maxHeight: geometry.size.height*0.8, theme: theme)
                    .padding(.leading, geometry.size.width*0.63)
                
                CalculatorModel(.graph(elements: [Line(equation: expression1, color: theme.color1)]), orientation: .portrait, maxWidth: geometry.size.width*0.36, maxHeight: geometry.size.height*0.8, theme: theme)
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
        }
        .transition(.opacity)
        .disabled(true)
    }
    
    private func calculusDisplay() -> some View {
        GeometryReader { geometry in
            ZStack {
                
                CalculatorModel(.buttonsText(text: expression4), orientation: .portrait, maxWidth: geometry.size.width*0.31, maxHeight: geometry.size.height*0.8, theme: theme)
                    .padding(.trailing, geometry.size.width*0.63)
                
                CalculatorModel(.buttonsText(text: expression3), orientation: .portrait, maxWidth: geometry.size.width*0.31, maxHeight: geometry.size.height*0.8, theme: theme, modes: modes)
                    .padding(.leading, geometry.size.width*0.63)
                
                let function3 = Queue((expression3.queue1[3] as! Expression).queue.items, modes: modes)
                CalculatorModel(.graph(elements: [Line(equation: function3, modes: modes, color: theme.color1), LineShape(equation: function3, location: .center, domain: 0...3*Double.pi, color: theme.color2, opacity: 0.5)]), orientation: .portrait, maxWidth: geometry.size.width*0.36, maxHeight: geometry.size.height*0.8, theme: theme, modes: modes)
                
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
        }
        .transition(.opacity)
        .disabled(true)
    }
    
    private func miscDisplay() -> some View {
        GeometryReader { geometry in
            ZStack {
                
                CalculatorModel(.popUp(text: "Save"), orientation: .portrait, maxWidth: geometry.size.width*0.31, maxHeight: geometry.size.height*0.8, theme: theme)
                    .padding(.trailing, geometry.size.width*0.63)
                
                CalculatorModel(.popUp(text: "Export"), orientation: .portrait, maxWidth: geometry.size.width*0.31, maxHeight: geometry.size.height*0.8, theme: theme)
                    .padding(.leading, geometry.size.width*0.63)
                
                CalculatorModel(.buttonsText(text: expression5), orientation: .portrait, maxWidth: geometry.size.width*0.36, maxHeight: geometry.size.height*0.8, theme: theme)
                
            }
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
        }
        .transition(.opacity)
        .disabled(true)
    }
    
    private func cycleTheme() {
            
        // Cycle the theme
        if ThemeData.allThemes[4...].count <= recentThemeIDs.count+3 {
            recentThemeIDs.removeAll()
        }
        withAnimation(.easeIn(duration: 1.0)) {
            self.theme = ThemeData.allThemes[4...].filter({ !recentThemeIDs.contains($0.id) }).randomElement()!
            recentThemeIDs.append(theme.id)
            self.otherTheme1 = ThemeData.allThemes[4...].filter({ !recentThemeIDs.contains($0.id) }).randomElement()!
            recentThemeIDs.append(otherTheme1.id)
            self.otherTheme2 = ThemeData.allThemes[4...].filter({ !recentThemeIDs.contains($0.id) }).randomElement()!
            recentThemeIDs.append(otherTheme2.id)
        }
        
        // Move the stars
        withAnimation(.linear(duration: 7.0)) {
            for i in starPositions.indices {
                starPositions[i].x += Double.random(in: -10...10)
                starPositions[i].y += Double.random(in: -10...10)
                starScales[i] = Double.random(in: 0.5..<2)
            }
        }
    }
    
    private func cycleDisplay() {
        
        // Animate the changing titles
        withAnimation(.easeOut(duration: 0.4)) {
            cycleContentOpacity = 0
        }
        withAnimation(.easeIn(duration: 0.4).delay(0.6)) {
            cycleContentOpacity = 1.0
        }
        
        // Cycle to the next display
        withAnimation(.easeInOut(duration: 1.0)) {
            switch displayType {
            case .list:
                settings.proPopUpType = .list
            case .cycle:
                settings.proPopUpType = .themes
            case .themes:
                settings.proPopUpType = .variables
            case .variables:
                settings.proPopUpType = .misc
            case .misc:
                settings.proPopUpType = .calculus
            case .calculus:
                settings.proPopUpType = .themes
            }
        }
    }
}


enum ProFeatureDisplay: String, Identifiable {
    case list
    case cycle
    
    case themes
    case variables
    case calculus
    case misc
    
    var id: String {
        return self.rawValue
    }
    
    static func random() -> ProFeatureDisplay {
        return [.themes,.variables,.calculus,.misc].randomElement()!
    }
}

struct FeatureView: View {
    
    var title: String
    var icon: String
    var desc: String?
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(.headline, design: .rounded).weight(.bold))
                .foregroundColor(.black.opacity(0.7))
            if let desc {
                Text(desc)
                    .font(.footnote.weight(.medium))
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 3)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
    }
}

struct FeatureBubble<Content: View>: View {
    
    var title: String
    var theme: Theme
    var linkAction: () -> Void = { }
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    linkAction()
                }
            } label: {
                Text(title)
                    .foregroundColor(color(theme.color1).lighter(by: 0.9))
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .shadow(color: .black.opacity(0.7), radius: 20)
                    .padding(10).padding(.top, 10)
            }
            VStack(alignment: .leading) {
                content()
                    .id(theme.id)
            }
            .padding(10)
            .padding(.vertical, 10)
            .frame(maxWidth: 400)
            .background(Color.white.opacity(0.6))
            .cornerRadius(20)
        }
    }
}
