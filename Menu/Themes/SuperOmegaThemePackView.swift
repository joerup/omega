//
//  SuperOmegaThemePackView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/27/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct SuperOmegaThemePackView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var settings = Settings.settings
    
    @StateObject var storeManager: StoreManager
    
    var fromMenu: Bool = false
    
    @State private var purchaseConfirmation = false
    
    var body: some View {
        
        GeometryReader { geometry in
        
            if let product = storeManager.myProducts.first(where: { $0.productIdentifier == "com.rupertusapps.OmegaCalc.SuperOmegaThemePack" }) {
            
                VStack {
                    
                    ScrollView {
                        
                        Text("SUPER OMEGA")
                            .font(.custom("AvenirNext-Heavy", size: 40, relativeTo: .body))
                            .foregroundColor(.white)
                            .lineLimit(0)
                            .minimumScaleFactor(0.5)
                            .shadow(color: .init(white: 0.3), radius: 20)
                            .padding(.top, 20)
                        
                        Text("THEME PACK")
                            .font(.custom("AvenirNext-Heavy", size: 40, relativeTo: .body))
                            .foregroundColor(.white)
                            .lineLimit(0)
                            .minimumScaleFactor(0.5)
                            .shadow(color: .init(white: 0.3), radius: 20)
                        
                        Image("SuperOmegaThemePack")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.init(white: 0.4), lineWidth: 5)
                            )
                            .cornerRadius(10)
                            .shadow(color: .init(white: 0.3), radius: 20)
                            .padding(7.5)
                            .padding(.top, -20)
                        
                        Text("24 Premium Themes")
                            .font(.custom("AvenirNext-Heavy", size: 30, relativeTo: .body))
                            .foregroundColor(.white)
                            .shadow(color: .init(white: 0.3), radius: 20)
                            .padding(.bottom)
                    
                        VStack {
                            
                            let range1 = geometry.size.height > geometry.size.width ? 2...4 : 2...7
                            let range2 = geometry.size.height > geometry.size.width ? 5...7 : nil
                        
                            HStack {
                                ForEach(ThemeData.themes[range1], id: \.id) { category in
                                    VStack {
                                        Image("Omega_\(category.name.replacingOccurrences(of: " ", with: ""))")
                                            .resizable()
                                            .shadow(color: .init(white: 0.3), radius: 20)
                                            .frame(width: 75, height: 75)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.init(white: 0.4), lineWidth: 5)
                                            )
                                            .cornerRadius(10)
                                        Text(category.name)
                                            .fontWeight(.bold)
                                            .font(.headline)
                                            .shadow(color: .init(white: 0.3), radius: 20)
                                            .frame(width: 80)
                                            .lineLimit(0)
                                            .minimumScaleFactor(0.5)
                                    }
                                    .padding(.horizontal, 7.5)
                                }
                            }
                            .padding(.bottom, 7.5)
                            
                            if range2 != nil {
                                HStack {
                                    ForEach(ThemeData.themes[range2!], id: \.id) { category in
                                        VStack {
                                            Image("Omega_\(category.name.replacingOccurrences(of: " ", with: ""))")
                                                .resizable()
                                                .shadow(color: .init(white: 0.3), radius: 20)
                                                .frame(width: 75, height: 75)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.init(white: 0.4), lineWidth: 5)
                                                )
                                                .cornerRadius(10)
                                            Text(category.name)
                                                .fontWeight(.bold)
                                                .font(.headline)
                                                .shadow(color: .init(white: 0.3), radius: 20)
                                                .frame(width: 80)
                                                .lineLimit(0)
                                                .minimumScaleFactor(0.5)
                                        }
                                        .padding(.horizontal, 7.5)
                                    }
                                }
                                .padding(.horizontal, 10)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    if !proCheck() {
                        Button(action: {
                            storeManager.purchaseProduct(product: product)
                            print("Buying \(product.localizedTitle)")
                        }) {
                            VStack {
                                Text("Purchase for \(product.localizedPrice)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .shadow(color: Color.init(white: 0.1), radius: 20)
                            }
                            .padding()
                            .frame(height: 100)
                            .frame(maxWidth: 500)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(20)
                            .shadow(color: Color.init(white: 0.3), radius: 20)
                            .padding(.horizontal, 10)
                        }
                    }
                    else {
                        HStack {
                            Text("Unlocked")
                                .fontWeight(.semibold)
                            Image(systemName: "checkmark")
                        }
                        .font(.title3)
                        .padding()
                        .frame(height: 100)
                        .frame(maxWidth: 500)
                        .foregroundColor(.white)
                        .background(Color.init(white: 0.3))
                        .shadow(color: Color.init(white: 0.3), radius: 20)
                        .cornerRadius(20)
                        .padding(.horizontal, 10)
                    }
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Not Now")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color: .init(white: 0.3), radius: 20)
                            .padding(.top, 5)
                            .padding(.bottom, 10)
                    }
                }
            }
        }
        .background(LinearGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple], startPoint: .top, endPoint: .bottom).overlay(Color.white.opacity(0.4)).opacity(0.8).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: self.$purchaseConfirmation) {
            PurchaseConfirmation()
        }
        .onChange(of: UserDefaults.standard.string(forKey: "purchaseConfirmation")) { id in
            if id?.contains("SuperOmegaThemePack") == true && !fromMenu {
                self.purchaseConfirmation = true
            }
        }
    }
}
