//
//  ThemeUnlockView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/22/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//
import SwiftUI
import StoreKit

struct ThemeUnlockView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var settings = Settings.settings
    
    @StateObject var storeManager: StoreManager
    
    @State var category: String
    
    @Binding var preview: ThemePreviewItem?
    
    @State private var showUnlockAll = false
    
    @State private var purchaseConfirmation = false
    @State private var restoreConfirmation = false
    
    var size: Size {
        return verticalSizeClass == .compact || horizontalSizeClass == .compact ? .small : .large
    }
    
    var body: some View {
            
        VStack(spacing: 0) {
            
            HStack {
                
                Button(action: {
                    storeManager.restoreProducts()
                }) {
                    Text("Restore")
                        .fontWeight(.semibold)
                        .padding(.leading, 10)
                        .lineLimit(0)
                        .minimumScaleFactor(0.5)
                }
                
                Text("Unlock Colors")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                
                Text("Restore")
                    .fontWeight(.semibold)
                    .padding(.trailing, 10)
                    .lineLimit(0)
                    .minimumScaleFactor(0.5)
                    .opacity(0)
            }
            .frame(height: size.smallerLargeSize+15)
            .padding(.horizontal, 10)
            
            Divider()
                .padding(.horizontal, 10)
            
            ScrollViewReader { scrollView in
            
                ScrollView {
                    
                    VStack {
                        
                        ForEach(storeManager.myProducts.filter { $0.productIdentifier.contains("com.rupertusapps.OmegaCalc.ThemeSet") }, id: \.self) { product in
                            
                            HStack {
                                
                                Image("Omega_\(getThemeSetName(product.localizedTitle).replacingOccurrences(of:" ",with:""))")
                                    .resizable()
                                    .frame(width: 90, height: 90)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.init(white: 0.5), lineWidth: 3)
                                            .frame(width: 93, height: 93)
                                    )
                                    .padding(7.5)
                                
                                VStack(alignment: .leading, spacing: 1) {
                                    
                                    Text(getThemeSetName(product.localizedTitle))
                                        .font(Font.system(.title2, design: .rounded).weight(.semibold))
                                    
                                    if let category = ThemeData.themes.first(where: { $0.name == getThemeSetName(product.localizedTitle) }) {
                                    
                                        HStack(spacing: 5) {
                                            Text("\(category.themes.count)")
                                                .font(Font.system(.headline, design: .rounded))
                                                .foregroundColor(.gray)
                                            Text("Colors")
                                                .font(Font.system(.headline, design: .rounded))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Button(action: {
                                            self.preview = ThemePreviewItem(category.themes[0], category: category)
                                            self.category = category.name
                                        }) {
                                            Text(NSLocalizedString("Preview", comment: "").uppercased())
                                                .font(Font.system(.caption, design: .rounded).weight(.bold))
                                                .lineLimit(0)
                                                .minimumScaleFactor(0.5)
                                                .padding(.top, 5)
                                        }
                                    }
                                }
                                
                                Spacer()
                                
                                if !getFirstTheme(setName: getThemeSetName(product.localizedTitle)).locked {
                                    HStack {
                                        Text("Unlocked")
                                            .font(Font.system(.body, design: .rounded).weight(.semibold))
                                            .lineLimit(0)
                                            .minimumScaleFactor(0.5)
                                        Image(systemName: "checkmark")
                                    }
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                }
                                else {
                                    Button {
                                        storeManager.purchaseProduct(product: product)
                                        print("Buying \(product.localizedTitle)")
                                    } label: {
                                        VStack {
                                            Text(product.localizedPrice)
                                                .font(Font.system(.headline, design: .rounded).weight(.semibold))
                                                .foregroundColor(.white)
                                                .lineLimit(0)
                                                .minimumScaleFactor(0.5)
                                        }
                                        .frame(width: 90, height: 50)
                                        .background(Color.blue)
                                        .cornerRadius(15)
                                        .padding(.horizontal, 10)
                                    }
                                }
                            }
                            .background(Color.init(white: 0.4).opacity(category == getThemeSetName(product.localizedTitle) ? 0.7 : 0))
                            .cornerRadius(10)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 2)
                            .id(getThemeSetName(product.localizedTitle))
                        }
                        
                        Spacer()
                            .frame(height: 50)
                    }
                    .padding(.vertical, 10)
                }
                .onAppear {
                    scrollView.scrollTo(category, anchor: .center)
                }
            }
            .sheet(isPresented: self.$showUnlockAll) {
                SuperOmegaThemePackView(storeManager: storeManager, fromMenu: true)
            }
        }
    }
    
    func getThemeSetName(_ fullName: String) -> String {
        let index1 = fullName.firstIndex(where: { $0 == "\"" })
        let index2 = fullName.lastIndex(where: { $0 == "\"" })
        if let index1 = index1, let index2 = index2 {
            return String(fullName[index1...index2].dropFirst().dropLast())
        }
        return ""
    }
    
    func getFirstTheme(setName: String) -> Theme {
        for category in ThemeData.themes {
            if category.name == setName {
                return category.themes[0]
            }
        }
        return Theme(id: 0, name: "Test", category: "none", color1: [0,0,0], color2: [0,0,0], color3: [0,0,0])
    }
}

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
