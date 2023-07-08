//
//  OmegaProView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/25/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct OmegaProView: View {
    
    @ObservedObject var settings = Settings.settings
    
    @StateObject var storeManager: StoreManager
    
    @State private var showAd: Bool = false
    
    @State private var scale: Double = 0.95
    
    let accentColor: [CGFloat] = [0.2*255,0.6*255,0.6*255]
    
    let expression1 = Queue([Number(1),Operation(.fra),Number(2),Operation(.con),Letter("x"),Operation(.pow),Number(2),Operation(.sub),Number(4)])
    let expression2 = Queue([Number(2),Operation(.con),Function(.cos),Letter("θ")], modes: ModeSettings(angleUnit: .rad))
    let expression3 = Queue([Number(3),Operation(.con),Number(3),Operation(.rad),Letter("x")])
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                NavigationHeader("Omega Pro")
                
                ZStack {
                    
                    ScrollView {
                        
                        VStack(spacing: 20) {
                            
                            Button(action: {
                                self.showAd.toggle()
                            }) {
                                Text("OMEGA PRO")
                                    .font(.system(size: 50, weight: .heavy, design: .rounded))
                                    .lineLimit(0)
                                    .minimumScaleFactor(0.5)
                                    .foregroundColor(Color.white)
                                    .shadow(color: .init(white: 0.3), radius: 20)
                                    .animation(.default)
                                    .padding(20)
                            }
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(RadialGradient(colors: [.green.lighter(by: 0.4), .init(red: 0.2, green: 0.6, blue: 0.6)], center: .center, startRadius: 0, endRadius: 300))
                            .cornerRadius(20)
                            .padding(10)
                            
                            OmegaProStarDecoration()
                            
                            VStack(spacing: 30) {
                                
                                if settings.pro {
                                    
                                    VStack {
                                        VStack(spacing: -15) {
                                            ProGradientText("Congratulations!")
                                            ProGradientText("You're an Omega Pro user.")
                                        }
                                    }
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 10)
                                    
                                } else {
                                    ProGradientText("Take your calculator to the next level.")
                                }
                                
                                Group {
                                    
                                    FeatureGrouping(geometry: geometry) {
                                        Group {
                                            FeatureDetailView("Unlock All Colors", icon: "paintpalette", desc: "Customization to the extreme.") {
                                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 8)) {
                                                    ForEach(ThemeData.allThemes[8...], id: \.id) { theme in
                                                        ThemeIcon(theme: theme, size: geometry.size.width > 1000 ? 50 : 30)
                                                            .animation(nil)
                                                    }
                                                    .animation(nil)
                                                }
                                                .animation(nil)
                                                .padding(.vertical, 10)
                                            }
                                        }
                                    }
                                    
                                    FeatureGrouping(geometry: geometry) {
                                        Group {
                                            FeatureDetailView("Input Line Text Pointer", icon: "character.cursor.ibeam", desc: "Move anywhere in the input line and add or delete characters. Either use the on-screen arrow keys or simply tap where you want to go.") {
                                                HStack {
                                                    TextDisplay(strings: ["2","+","7","-","#|","3","^","2","-","5"], size: 30)
                                                    Spacer()
                                                }
                                                .padding(.vertical, 10)
                                            }
                                        }
                                    }
                                    
                                    FeatureGrouping(geometry: geometry) {
                                        Group {
                                            FeatureDetailView("Stored Variables", icon: "character.textbox", desc: "Store values to variables. Then use the variable in more calculations.") {
                                                VStack(spacing: 10) {
                                                    HStack {
                                                        HStack {
                                                            TextDisplay(strings: ["w"], size: 20, color: color(accentColor))
                                                            TextDisplay(strings: ["="], size: 20, opacity: 0.5)
                                                        }
                                                        .frame(width: 50)
                                                        Spacer()
                                                        TextDisplay(strings: ["24.125"], size: 20)
                                                    }
                                                    .frame(height: 45)
                                                    .padding(.horizontal, 12)
                                                    .background(Color.init(white: 0.2).cornerRadius(20))
                                                    HStack {
                                                        VStack(alignment: .trailing, spacing: 20) {
                                                            TextDisplay(strings: ["2","*","¶w","+","3"], size: 22, opacity: 0.9, equals: true)
                                                            TextDisplay(strings: ["51.25"], size: 22)
                                                        }
                                                        .frame(maxWidth: .infinity)
                                                        VStack(alignment: .trailing, spacing: 20) {
                                                            TextDisplay(strings: ["¶w","^","2","+","6","*","¶w","-","7"], size: 22, opacity: 0.9, equals: true)
                                                            TextDisplay(strings: ["719.765625"], size: 22)
                                                        }
                                                        .frame(maxWidth: .infinity)
                                                    }
                                                    .frame(maxHeight: 50)
                                                    .padding(.vertical, 10)
                                                }
                                            }
                                            FeatureDetailView("Variable Expressions", icon: "x.squareroot", desc: "Use unknown variables to create a variable expression. Easily plug in values for quick results.") {
                                                VStack(spacing: 10) {
                                                    TextDisplay(strings: ["1","/","2","*","»m","*","»v","^","2"], size: 32)
                                                        .frame(maxWidth: .infinity)
                                                        .padding(.vertical, 12.5)
                                                    VStack(spacing: 5) {
                                                        HStack {
                                                            TextDisplay(strings: ["»m"], size: 18, color: color(accentColor))
                                                                .frame(width: 20)
                                                            HStack {
                                                                Text(NSLocalizedString("Unknown Variable", comment: "").uppercased())
                                                                    .font(.caption2)
                                                                    .lineLimit(0)
                                                                    .minimumScaleFactor(0.01)
                                                                    .foregroundColor(Color.init(white: 0.6))
                                                                    .padding(.leading, 2)
                                                                Spacer()
                                                                TextDisplay(strings: ["2.34"], size: 18)
                                                            }
                                                            .frame(maxWidth: .infinity)
                                                            .frame(height: 22)
                                                            .padding(10)
                                                            .background(Color.init(white: 0.2).cornerRadius(20))
                                                        }
                                                        HStack {
                                                            TextDisplay(strings: ["»v"], size: 18, color: color(accentColor))
                                                                .frame(width: 20)
                                                            HStack {
                                                                Text(NSLocalizedString("Unknown Variable", comment: "").uppercased())
                                                                    .font(.caption2)
                                                                    .lineLimit(0)
                                                                    .minimumScaleFactor(0.01)
                                                                    .foregroundColor(Color.init(white: 0.6))
                                                                    .padding(.leading, 2)
                                                                Spacer()
                                                                TextDisplay(strings: ["9.57","#|"], size: 18)
                                                            }
                                                            .frame(maxWidth: .infinity)
                                                            .frame(height: 22)
                                                            .padding(10)
                                                            .background(Color.init(white: 0.2).cornerRadius(20))
                                                        }
                                                    }
                                                    HStack {
                                                        SmallIconButton(symbol: "plus.circle", textColor: color(accentColor), smallerLarge: true) {}
                                                        SmallIconButton(symbol: "doc.on.clipboard", textColor: color(accentColor), smallerLarge: true) {}
                                                        Spacer()
                                                        TextDisplay(strings: ["= 107.154333"], size: 20)
                                                    }
                                                    .padding(.trailing, 5)
                                                }
                                            }
                                        }
                                    }
                                    
                                    FeatureGrouping(geometry: geometry) {
                                        Group {
                                            FeatureDetailView("Graphs", icon: "perspective", desc: "Cartesian graphs of any single-variable expression.") {
                                                HStack {
                                                    GraphView([Line(equation: expression1, color: accentColor)], gridLines: false, interactive: false, precision: 60)
                                                        .aspectRatio(1.0, contentMode: .fit)
                                                        .cornerRadius(20)
                                                    GraphView([Line(equation: expression2, color: accentColor)], horizontalAxis: Letter("θ"), gridLines: false, interactive: false, precision: 100)
                                                        .aspectRatio(1.0, contentMode: .fit)
                                                        .cornerRadius(20)
                                                }
                                                .frame(maxWidth: .infinity)
                                            }
                                            FeatureDetailView("Tables", icon: "table", desc: "Input-output tables of any single-variable expression.") {
                                                HStack {
                                                    TableView(equation: expression1, horizontalAxis: Letter("x"), verticalAxis: Letter("y"), lowerBound: -10, upperBound: 10, increment: 1, fullTable: false, fontSize: 12, color: accentColor)
                                                        .aspectRatio(1.0, contentMode: .fit)
                                                        .cornerRadius(20)
                                                    TableView(equation: expression2, horizontalAxis: Letter("θ"), verticalAxis: Letter("r"), lowerBound: -10, upperBound: 10, increment: 1, fullTable: false, fontSize: 12, color: accentColor)
                                                        .aspectRatio(1.0, contentMode: .fit)
                                                        .cornerRadius(20)
                                                }
                                                .frame(maxWidth: .infinity)
                                            }
                                        }
                                    }
                                }
                                
                                Group {
                                    
                                    FeatureGrouping(geometry: geometry) {
                                        Group {
                                            FeatureDetailView("Unlimited Saved Calculations", icon: "folder", desc: "Save an unlimited number of calculations so they remain in the app forever.")
                                            FeatureDetailView("Saved Calculation Folders", icon: "folder.fill", desc: "Organize saved calculations into folders to access them more easily.")
                                            FeatureDetailView("Recents last 180 days", icon: "clock.arrow.circlepath", desc: "Unsaved calculations will expire after 180 days instead of the default 14.")
                                        }
                                    }
                                    
                                    FeatureGrouping(geometry: geometry) {
                                        Group {
                                            FeatureDetailView("Export Calculations", icon: "square.and.arrow.up", desc: "Export any or all of your past calculations to spreadsheet format in a CSV file, which can be imported into other programs.")
                                            FeatureDetailView("Keyboard Support", icon: "keyboard", desc: "External/bluetooth keyboards for iPad and Mac can be used in place of the calculator buttons.")
                                        }
                                    }
                                }
                                
                                Group {
                                    
                                    FeatureGrouping(geometry: geometry) {
                                        Group {
                                            FeatureDetailView("Derivatives & Integrals", icon: "chart.bar.xaxis", desc: "Calculate a derivative at a point. Use definite integrals to find the area under a curve.") {
                                                HStack {
                                                    TextDisplay(strings: ["d/d|","#1","»x","(","2","*","»x","^","2","-","6",")","3"], size: 30)
                                                        .frame(maxWidth: .infinity)
                                                    TextDisplay(strings: ["∫d","0","8","(","»z","^","4","-","7","*","»z",")","»z"], size: 30)
                                                        .frame(maxWidth: .infinity)
                                                }
                                                .padding(.vertical, 15)
                                                .padding(.horizontal, 4)
                                            }
                                            FeatureDetailView("Summation & Product Notation", icon: "sum", desc: "Calculate large sums and large products using these important functions.") {
                                                HStack {
                                                    TextDisplay(strings: ["∑","»n","1","10","#(","1","/","»n","#)"], size: 40)
                                                        .frame(maxWidth: .infinity)
                                                    TextDisplay(strings: ["∏","»x","1","30","(","»x","^","2","-","1",")"], size: 40)
                                                        .frame(maxWidth: .infinity)
                                                }
                                                .padding(.vertical, 15)
                                                .padding(.horizontal, 4)
                                            }
                                        }
                                    }
                                    
                                    FeatureGrouping(geometry: geometry) {
                                        Group {
                                            FeatureDetailView("Extra Results", icon: "ellipsis.circle", desc: "Additional representations of a calculated result: fraction form, in terms of π, etc. Generated automatically when a calculation is made.") {
                                                VStack {
                                                    HStack(spacing: 20) {
                                                        VStack(alignment: .trailing, spacing: 20) {
                                                            TextDisplay(strings: ["1","/","9","×","2"], size: 20, opacity: 0.7, equals: true)
                                                            TextDisplay(strings: ["0.2222222222"], size: 20)
                                                        }
                                                        .frame(maxWidth: .infinity)
                                                        VStack(alignment: .trailing, spacing: 20) {
                                                            TextDisplay(strings: ["sin","#(","60","#)"], modes: ModeSettings(angleUnit: .deg), size: 20, opacity: 0.7, equals: true)
                                                            TextDisplay(strings: ["0.8660254038"], size: 20)
                                                        }
                                                        .frame(maxWidth: .infinity)
                                                    }
                                                    .frame(maxHeight: 60)
                                                    .padding(.vertical, 10)
                                                    HStack(alignment: .top, spacing: 20) {
                                                        VStack {
                                                            HStack {
                                                                SmallIconButton(symbol: "arrowshape.turn.up.forward", color: Color.init(white: 0.25), smallerLarge: true) {}
                                                                    .scaleEffect(0.7)
                                                                Spacer()
                                                                TextDisplay(strings: ["="]+["2","/","9"], size: 20, color: .white, scrollable: true)
                                                            }
                                                            HStack {
                                                                SmallIconButton(symbol: "arrowshape.turn.up.forward", color: Color.init(white: 0.25), smallerLarge: true) {}
                                                                    .scaleEffect(0.7)
                                                                Spacer()
                                                                TextDisplay(strings: ["="]+["0.2 ̅"], size: 20, color: .white, scrollable: true)
                                                            }
                                                        }
                                                        .padding(.vertical, 5)
                                                        .background(Color.init(white: 0.2).cornerRadius(10))
                                                        VStack {
                                                            HStack {
                                                                SmallIconButton(symbol: "arrowshape.turn.up.forward", color: Color.init(white: 0.25), smallerLarge: true) {}
                                                                    .scaleEffect(0.7)
                                                                Spacer()
                                                                TextDisplay(strings: ["="]+["#(","#2","√","3","#)","/","2"], size: 20, color: .white, scrollable: true)
                                                            }
                                                        }
                                                        .padding(.vertical, 5)
                                                        .background(Color.init(white: 0.2).cornerRadius(10))
                                                    }
                                                    .padding(.vertical, 5)
                                                }
                                                .frame(maxWidth: .infinity)
                                                .padding(.top, 5)
                                            }
                                            FeatureDetailView("Special Graphs", icon: "chart.pie", desc: "Calculate a trig function and get a visual unit circle representation. Or get a graph of the tangent line or the area under the curve when you calculate derivatives and integrals.") {
                                                HStack {
                                                    UnitCircleView(function: Function(.sin), angle: Number(45), unit: .deg, color1: accentColor, color2: accentColor, gridLines: false, interactive: false)
                                                        .aspectRatio(1.0, contentMode: .fit)
                                                        .cornerRadius(20)
                                                    GraphView([Line(equation: expression3, color: accentColor), LineShape(equation: expression3, location: .center, domain: -6...6, color: accentColor, opacity: 0.5)], gridLines: false, interactive: false, precision: 100)
                                                        .aspectRatio(1.0, contentMode: .fit)
                                                        .cornerRadius(20)
                                                }
                                                .frame(maxWidth: .infinity)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            SettingsGroup {
                                SettingsButton(title: "Restore Purchases") {
                                    self.storeManager.restoreProducts()
                                }
                            }
                            
                            Text("OMEGA PRO")
                                .font(Font.system(.title, design: .rounded).weight(.bold))
                                .lineLimit(0)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(Color.green.lighter(by: 0.8))
                                .padding(.top, 15)
                                .padding(.bottom, 40)
                            
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                    
                    VStack {
                        
                        Spacer()
                        
                        VStack {
                            
                            if settings.pro {
                                
                                Button(action: {
                                    
                                }) {
                                    HStack {
                                        Text("Unlocked")
                                            .font(Font.system(.title2, design: .rounded).weight(.bold))
                                            .foregroundColor(.white)
                                            .shadow(color: .init(white: 0.4), radius: 15)
                                        Image(systemName: "checkmark")
                                            .imageScale(.large)
                                            .foregroundColor(.white)
                                            .shadow(color: .init(white: 0.4), radius: 15)
                                    }
                                    .frame(height: 100)
                                    .frame(maxWidth: .infinity)
                                    .background(RadialGradient(gradient: Gradient(colors: [.green.lighter(by: 0.4), .init(red: 0.2, green: 0.6, blue: 0.6)]), center: .init(x: scale*20 - 19, y: 0), startRadius: 1, endRadius: 400))
                                    .cornerRadius(20)
                                    .shadow(color: .init(white: 0.1).opacity(0.3), radius: 15)
                                }
                                .frame(maxWidth: 500)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                                .padding(.top, 10)
                                .scaleEffect(scale*1.1)
                                
                            } else if let product = storeManager.myProducts.first(where: { $0.productIdentifier == "com.rupertusapps.OmegaCalc.PRO" }) {
                                
                                Button(action: {
                                    storeManager.purchaseProduct(product: product)
                                    print("Buying \(product.localizedTitle)")
                                }) {
                                    VStack {
                                        Text("Purchase for \(product.localizedPrice)")
                                            .font(Font.system(.title2, design: .rounded).weight(.bold))
                                            .foregroundColor(.white)
                                        Text("One-Time Payment")
                                            .font(Font.system(.footnote, design: .rounded).weight(.bold))
                                            .foregroundColor(.white)
                                    }
                                    .shadow(color: .init(white: 0.4), radius: 15)
                                    .frame(height: 100)
                                    .frame(maxWidth: .infinity)
                                    .background(RadialGradient(gradient: Gradient(colors: [.green.lighter(by: 0.4), .init(red: 0.2, green: 0.6, blue: 0.6)]), center: .init(x: scale*20 - 19, y: 0), startRadius: 1, endRadius: 400))
                                    .cornerRadius(20)
                                    .shadow(color: .init(white: 0.1).opacity(0.3), radius: 15)
                                }
                                .frame(maxWidth: 500)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                                .padding(.top, 10)
                                .scaleEffect(scale*1.1)
                            }
                        }
                        .background(Color.clear.blur(radius: 20))
                    }
                }
            }
        }
        .sheet(isPresented: self.$showAd) {
            OmegaProAd(storeManager: storeManager)
        }
        .sheet(isPresented: self.$settings.purchaseConfirmation) {
            PurchaseConfirmation()
        }
        .sheet(isPresented: self.$settings.restoreConfirmation) {
            PurchaseConfirmation(restore: true)
        }
    }
}

struct ProGradientText: View {
    
    var text: String
                            
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        
        Text(LocalizedStringKey(text))
            .font(Font.system(.title3, design: .rounded).weight(.bold))
            .multilineTextAlignment(.center)
            .overlay(
                LinearGradient(colors: [.green.lighter(by: 0.4), .init(red: 0.2, green: 0.6, blue: 0.6)], startPoint: .leading, endPoint: .trailing)
                    .mask(
                        Text(LocalizedStringKey(text))
                            .font(Font.system(.title3, design: .rounded).weight(.bold))
                            .multilineTextAlignment(.center)
                    )
            )
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
    }
}
