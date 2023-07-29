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
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @StateObject var storeManager: StoreManager
    
    @State private var array: [ProFeatureDisplay] = []
    
    @State private var scale: Double = 0.95
    @State private var pressedScale: Double = 1.0
    @State private var spotlight: Double = 0.95
    
    var theme1: Theme { settings.previewTheme1 }
    var theme2: Theme { settings.previewTheme2 }
    var theme3: Theme { settings.previewTheme3 }
    
    var body: some View {
        
        GeometryReader { geometry in
                
            if verticalSizeClass == .regular {
                VStack(spacing: 0) {
                    title
                    tabs(size: geometry.size)
                    purchase(size: geometry.size)
                }
                .frame(width: geometry.size.width)
                .background(Color.init(white: 0.22).edgesIgnoringSafeArea(.all))
            }
            else if verticalSizeClass == .compact {
                HStack(spacing: 0) {
                    tabs(size: geometry.size)
                        .padding(.top)
                        .padding(.leading, 1)
                        .padding(.bottom, -3)
                    purchase(size: geometry.size)
                }
                .frame(minWidth: geometry.size.width)
                .background(Color.init(white: 0.22))
            }
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: self.$settings.purchaseConfirmation) {
            PurchaseConfirmation()
        }
        .sheet(isPresented: self.$settings.restoreConfirmation) {
            PurchaseConfirmation(restore: true)
        }
        .onAppear {
            array = ProFeatureDisplay.randomArray(startingWith: Settings.settings.proPopUpType)
        }
    }
    
    private var title: some View {
        Text("OMEGA PRO")
            .font(.system(size: 50, weight: .heavy, design: .rounded))
            .lineLimit(0)
            .minimumScaleFactor(0.5)
            .foregroundColor(Color.white)
            .shadow(color: .init(white: 0.05).opacity(0.5), radius: 15)
            .padding(.top, verticalSizeClass == .compact ? 10 : 30)
    }
    
    @ViewBuilder
    private func tabs(size: CGSize) -> some View {
        Group {
            if array.count == ProFeatureDisplay.allCases.count {
                TabView {
                    ForEach(array) { display in
                        page(displayType: display, size: size)
                    }
                    .edgesIgnoringSafeArea(.horizontal)
                }
                .tabViewStyle(.page)
            }
            else {
                Spacer()
            }
        }
    }
    
    private func page(displayType: ProFeatureDisplay, size: CGSize) -> some View {
        VStack {
            
            if let text = displayType.text {
                Text(text)
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .lineLimit(0)
                    .minimumScaleFactor(0.5)
                    .dynamicTypeSize(..<DynamicTypeSize.accessibility2)
                    .foregroundColor(Color.white)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                    .padding(.top, verticalSizeClass == .compact ? 0 : 10)
            }
            
            Spacer(minLength: 0)
            
            displayType.previews(theme1: theme1, theme2: theme2, theme3: theme3)
                .frame(maxWidth: size.height > 800 ? .infinity : 500)
                .shadow(radius: 10)
            
            Spacer(minLength: 0)
            
            Text(displayType.description)
                .font(.system(.callout, design: .rounded).weight(.semibold))
                .foregroundColor(.white.opacity(0.9))
                .dynamicTypeSize(..<DynamicTypeSize.accessibility2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .shadow(radius: 15)
                .frame(maxWidth: min(500, verticalSizeClass == .compact ? size.width*0.4 : size.width))
                .padding(.vertical, 5)
                .padding(.horizontal)
                .padding(.bottom, 40)
        }
    }
    
    private func summaryPage(size: CGSize) -> some View {
        VStack {
            
            Text("Take your calculator to the next level.")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .lineLimit(0)
                .minimumScaleFactor(0.5)
                .foregroundColor(Color.white)
                .shadow(radius: 10)
                .padding(.horizontal)
                .padding(.top, verticalSizeClass == .compact ? 0 : 10)
            
            Spacer(minLength: 0)
            
            if verticalSizeClass == .regular {
                ProFeatureDisplay.summaryDisplay(theme: theme1)
                    .shadow(radius: 10, y: 10)
                    .padding(.bottom, -20)
                
                VStack(alignment: .leading) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                        ForEach(array, id: \.self) { display in
                            ForEach(display.summary, id: \.self) { summary in
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(.vertical, 2)
                                    Text(summary)
                                        .font(.system(.callout, design: .rounded).weight(.semibold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .shadow(radius: 15)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 500)
                .background(Color.init(white: 0.5).overlay(theme1.primaryColor.opacity(0.8)).opacity(0.8))
                .cornerRadius(20)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .padding(.bottom, 10)
                .zIndex(1)
            }
            
            Spacer(minLength: 0)
            
            Text("The best calculator experience.\nOne lifetime purchase.")
                .font(.system(.callout, design: .rounded).weight(.semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .shadow(radius: 15)
                .frame(maxWidth: 500)
                .padding(.horizontal)
                .padding(.bottom, 45)
        }
    }
    
    private func purchase(size: CGSize) -> some View {
        VStack {
            
            if verticalSizeClass == .compact {
                title
                Spacer(minLength: 0)
            }
            
            if settings.pro {
                
                Button(action: {
                    pressScale()
                    self.dismiss()
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
                    .background(RadialGradient(gradient: Gradient(colors: [.white, .black]), center: .init(x: spotlight*20 - 19, y: 0), startRadius: 1, endRadius: 400).overlay(theme1.primaryColor.opacity(0.6)))
                    .cornerRadius(20)
                    .shadow(color: .init(white: 0.1).opacity(0.3), radius: 15)
                    .dynamicTypeSize(..<DynamicTypeSize.xxxLarge)
                }
                .frame(maxWidth: 500)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .padding(.top, 20)
                .scaleEffect(scale*pressedScale*1.05)
                .buttonStyle(.plain)
                .onAppear {
                    introScale()
                }
                
            } else if let product = storeManager.myProducts.first(where: { $0.productIdentifier == "com.rupertusapps.OmegaCalc.PRO" }) {
                
                Button(action: {
                    pressScale()
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
                    .background(RadialGradient(gradient: Gradient(colors: [.white, .black]), center: .init(x: spotlight*20 - 19, y: 0), startRadius: 1, endRadius: 400).overlay(theme1.primaryColor.opacity(0.6)))
                    .cornerRadius(20)
                    .shadow(color: .init(white: 0.1).opacity(0.3), radius: 15)
                    .dynamicTypeSize(..<DynamicTypeSize.xxxLarge)
                }
                .frame(maxWidth: 500)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .padding(.top, 20)
                .scaleEffect(scale*pressedScale*1.05)
                .buttonStyle(.plain)
                .onAppear {
                    introScale()
                }
                
            } else {
                
                VStack {
                    Text("No connection")
                        .font(Font.system(.title2, design: .rounded).weight(.bold))
                        .lineLimit(0)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.white)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.4))
                        .cornerRadius(20)
                        .shadow(color: .init(white: 0.1).opacity(0.3), radius: 15)
                        .dynamicTypeSize(..<DynamicTypeSize.xxxLarge)
                }
                .frame(maxWidth: 500)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .padding(.top, 20)
                .scaleEffect(scale*pressedScale*1.05)
            }
            
            Button(action: {
                self.storeManager.restoreProducts()
            }) {
                Text("Restore Purchases")
                    .font(Font.system(.subheadline, design: .rounded).weight(.bold))
                    .foregroundColor(.white)
                    .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                    .shadow(color: .init(white: 0.3), radius: 20)
            }
            .padding(.top, -10)
            .padding(.bottom, 5)
            
            Button(action: {
                self.dismiss()
            }) {
                Text("Not Now")
                    .font(Font.system(.subheadline, design: .rounded).weight(.bold))
                    .foregroundColor(.white)
                    .dynamicTypeSize(..<DynamicTypeSize.xxLarge)
                    .shadow(color: .init(white: 0.3), radius: 20)
            }
            .padding(.bottom, 15)
        }
        .frame(width: verticalSizeClass == .compact ? size.width/2 : size.width)
        .background(Color.white.opacity(0.2).frame(maxWidth: .infinity).cornerRadius(10).edgesIgnoringSafeArea(.vertical))
    }
    
    private func introScale() {
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            scale = 1.0
        }
        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
            spotlight = 1.0
        }
    }
    private func pressScale() {
        SoundManager.play(haptic: .heavy)
        withAnimation(.easeOut(duration: 0.1)) {
            pressedScale = 0.8
        }
        withAnimation(.easeIn(duration: 1.0).delay(0.1)) {
            pressedScale = 1.0
        }
    }
}



