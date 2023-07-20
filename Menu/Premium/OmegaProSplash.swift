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
    
    var array: [ProFeatureDisplay] = ProFeatureDisplay.randomArray(startingWith: Settings.settings.proPopUpType)
    
    @State private var scale: Double = 0.95
    @State private var spotlight: Double = 0.95
    
    var theme1: Theme { settings.previewTheme1 }
    var theme2: Theme { settings.previewTheme2 }
    var theme3: Theme { settings.previewTheme3 }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                
                Text("OMEGA PRO")
                    .font(.system(size: 50, weight: .heavy, design: .rounded))
                    .lineLimit(0)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Color.white)
                    .shadow(color: .init(white: 0.05).opacity(0.5), radius: 15)
                    .padding(.top, verticalSizeClass == .compact ? 10 : 30)
                
                TabView {
                    ForEach(array, id: \.self) { display in
                        page(displayType: display, size: geometry.size)
                    }
                }
                .tabViewStyle(.page)
                .onTapGesture {
                    withAnimation {
                        setThemes()
                    }
                }
                
                purchaseButtons(size: geometry.size)
                
            }
            .frame(width: geometry.size.width)
            .background(
                LinearGradient(colors: [.init(white: 0.3), .init(white: 0.2)], startPoint: .top, endPoint: .bottom)
                    .overlay(color(theme1.color1).opacity(0.6))
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .sheet(isPresented: self.$settings.purchaseConfirmation) {
            PurchaseConfirmation()
        }
        .sheet(isPresented: self.$settings.restoreConfirmation) {
            PurchaseConfirmation(restore: true)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                scale = 1.0
            }
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                spotlight = 1.0
            }
            setThemes()
        }
    }
    
    private func page(displayType: ProFeatureDisplay, size: CGSize) -> some View {
        VStack {
            
            if let text = displayType.text {
                Text(text)
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .lineLimit(0)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Color.white)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                    .padding(.top, verticalSizeClass == .compact ? 0 : 10)
            }
            
            Spacer(minLength: 0)
            
            VStack {
                if verticalSizeClass == .regular {
                    displayType.previews(theme1: theme1, theme2: theme2, theme3: theme3)
                }
            }
            .frame(maxWidth: size.height > 800 ? .infinity : 500)
            .shadow(radius: 10)
            
            Spacer(minLength: 0)
            
            Text(displayType.description)
                .font(.callout.weight(.semibold))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .shadow(radius: 15)
                .frame(maxWidth: 500)
                .padding(.vertical, 5)
                .padding(.horizontal)
                .padding(.bottom, 40)
        }
    }
    
    private func purchaseButtons(size: CGSize) -> some View {
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
                    .background(RadialGradient(gradient: Gradient(colors: [.white, .black]), center: .init(x: spotlight*20 - 19, y: 0), startRadius: 1, endRadius: 400).overlay(color(theme1.color1).opacity(0.6)))
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
                    .background(RadialGradient(gradient: Gradient(colors: [.white, .black]), center: .init(x: spotlight*20 - 19, y: 0), startRadius: 1, endRadius: 400).overlay(color(theme1.color1).opacity(0.6)))
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
                self.settings.purchaseConfirmation.toggle()
//                self.storeManager.restoreProducts()
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
                    .padding(.bottom, 15)
            }
        }
        .frame(width: size.width)
        .background(Color.white.opacity(0.3).frame(maxWidth: .infinity).cornerRadius(10).edgesIgnoringSafeArea(.all))
    }
    
    private func setThemes() {
        settings.previewTheme1 = ThemeData.allThemes[4...].filter({ ![theme1,theme2,theme3].map({ $0.id }).contains($0.id) }).randomElement()!
        settings.previewTheme2 = ThemeData.allThemes[4...].filter({ ![theme1,theme2,theme3].map({ $0.id }).contains($0.id) }).randomElement()!
        settings.previewTheme3 = ThemeData.allThemes[4...].filter({ ![theme1,theme2,theme3].map({ $0.id }).contains($0.id) }).randomElement()!
    }
}



