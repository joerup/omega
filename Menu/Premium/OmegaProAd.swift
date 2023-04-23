//
//  OmegaProAd.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/26/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct OmegaProAd: View {
    
    @ObservedObject var settings = Settings.settings
    
    @StateObject var storeManager: StoreManager
    
    @Environment(\.presentationMode) var presentationMode
    
    var prompted: Bool = false
    
    @State private var introPadding: Double = 200
    @State private var introScale: Double = 0.001
    @State private var introStarScale: Double = 0
    @State private var introContentPadding: Double = UIScreen.main.bounds.height
    @State private var introButtonScale: Double = 0
    @State private var introProScale: Double = 0
    
    @State private var scale: Double = 0.95
    
    let features: [String] = [
        "Input Line Text Pointer",
        "Stored Variables",
        "Variable Expressions",
        "Graphs & Tables",
        "Unlimited Saved Calculations",
        "Saved Calculation Folders",
        "Export Calculations",
        "Calculus Functions",
    ]
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
            
                ScrollView {
                    
                    VStack(spacing: 5) {
                        
                        VStack(spacing: 10) {
                            
                            Text(prompted ? "This feature requires" : "Introducing")
                                .font(Font.system(.title3, design: .rounded).weight(.bold))
                                .lineLimit(0)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(Color.white)
                                .opacity(0.95)
                                .shadow(color: .init(white: 0.3), radius: 20)
                                .padding(.horizontal, 10)
                                .padding(.top, 25)
                            
                            HStack(spacing: 0) {
                                Text("OMEGA")
                                    .font(.system(size: 50, weight: .heavy, design: .rounded))
                                    .lineLimit(0)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.green.lighter(by: 0.95))
                                Text(" PRO")
                                    .font(.system(size: 50, weight: .heavy, design: .rounded))
                                    .lineLimit(0)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.green.lighter(by: 0.95))
                                    .scaleEffect(introProScale)
                            }
                            .shadow(color: .init(white: 0.3), radius: 20)
                            .scaleEffect(sqrt(scale)*1.1*introScale)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        }
                        .padding(.top, introPadding)
                        
                        OmegaProStarDecoration()
                            .scaleEffect(introStarScale)
                        
                        VStack {
                        
                            Text("Take your calculator to the next level.")
                                .font(Font.system(.title2, design: .rounded).weight(.bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.white)
                                .shadow(color: .init(white: 0.3), radius: 20)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                            
                            Button(action: {
                                self.settings.showMenu = true
                                self.settings.menuType = .pro
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                VStack {
                                    
                                    VStack(alignment: .leading) {
                                        
                                        HStack {
                                            Image(systemName: "star.fill")
                                                .imageScale(.large)
                                                .foregroundColor(Color.init(red: 0.5, green: 0.95, blue: 0.95).lighter(by: 0.3))
                                            HStack(spacing: 0) {
                                                Text("Unlock All Colors")
                                                    .font(Font.system(.body, design: .rounded).weight(.bold))
                                                    .foregroundColor(.white)
                                                    .multilineTextAlignment(.center)
                                                    .overlay(
                                                        LinearGradient(
                                                            colors: [.red, .orange, .yellow, .green, .blue, .purple],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                        .opacity(0.3)
                                                        .mask(
                                                            Text("Unlock All Colors")
                                                                .font(Font.system(.body, design: .rounded).weight(.bold))
                                                                .multilineTextAlignment(.center)
                                                        )
                                                    )
                                            }
                                            .padding(5)
                                            Spacer()
                                        }
                                        
                                        ForEach(self.features, id: \.self) { feature in
                                            HStack {
                                                Image(systemName: "star.fill")
                                                    .imageScale(.large)
                                                    .foregroundColor(Color.init(red: 0.5, green: 0.95, blue: 0.95).lighter(by: 0.3))
                                                Text(LocalizedStringKey(feature))
                                                    .font(Font.system(.body, design: .rounded).weight(.bold))
                                                    .foregroundColor(.white)
                                                    .multilineTextAlignment(.leading)
                                                    .padding(5)
                                                Spacer()
                                            }
                                        }
                                    }
                                    
                                    Text("See All Features")
                                        .font(Font.system(.body, design: .rounded).weight(.bold))
                                        .foregroundColor(Color.init(red: 0.5, green: 0.95, blue: 0.95).lighter(by: 0.3))
                                }
                                .padding(15)
                                .frame(maxWidth: 400)
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(20)
                                .shadow(color: .init(white: 0.2), radius: 20)
                                .padding(.horizontal, 20)
                            }
                            
                        }
                        .padding(.top, 10)
                        .padding(.top, introContentPadding)
                        
                        Spacer()
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.bottom, 100)
                .onAppear {
                    if prompted {
                        introScale = 1.0
                        introPadding = 0
                        introProScale = 1.0
                        introStarScale = 1.0
                        introContentPadding = 0
                        introButtonScale = 1.0
                        return
                    }
                    
                    withAnimation(Animation.easeInOut(duration: 1)) {
                        introScale = 1.0
                    }
                    withAnimation(Animation.easeInOut(duration: 2)) {
                        introPadding = 0
                    }
                    withAnimation(Animation.easeInOut(duration: 1.2).delay(0.2)) {
                        introProScale = 1.0
                    }
                    withAnimation(Animation.easeInOut(duration: 2.5).delay(0.3)) {
                        introStarScale = 1.0
                    }
                    withAnimation(Animation.easeInOut(duration: 1).delay(0.7)) {
                        introContentPadding = 0
                        introButtonScale = 1.0
                    }
                }
                .onAppear {
                    let baseAnimation = Animation.easeInOut(duration: 3)
                    let repeated = baseAnimation.repeatForever(autoreverses: true)

                    withAnimation(repeated) {
                        scale = 1.0
                    }
                }
                
                VStack {
                    
                    Spacer()
                        
                    VStack {
                        
                        if settings.pro {
                            
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
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
                    
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Not Now")
                                .font(Font.system(.subheadline, design: .rounded).weight(.bold))
                                .foregroundColor(.white)
                                .padding(.top, -10)
                                .padding(.bottom, 10)
                        }
                    }
                    .scaleEffect(introButtonScale, anchor: .bottom)
                }
            }
        }
        .background(LinearGradient(colors: [.green.lighter(by: 0.4), .init(red: 0.2, green: 0.6, blue: 0.6)], startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}

struct OmegaProStarDecoration: View {
    
    @State private var star: Double = 0.0
    
    var body: some View {
        HStack {
            ForEach(0..<7) { num in
                Image(systemName: "star.fill")
                    .font(.custom("AvenirNext-Heavy", size: 30, relativeTo: .body).weight(.black))
                    .foregroundColor(Color.init(red: 0.45, green: 0.82, blue: 0.82).lighter(by: convertValue(num)))
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 2).repeatForever()) {
                star = 1.0
            }
        }
    }
    
    func convertValue(_ num: Int) -> Double {
        let ratio = Double(num+1)/8
        return 1 - abs(ratio-star)
    }
}
