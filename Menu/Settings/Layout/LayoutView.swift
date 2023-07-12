//
//  LayoutView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/3/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct LayoutView: View {

    @ObservedObject var settings = Settings.settings

    @State var displayVariant: LayoutDisplayVariant? = nil
    
    var size: Size {
        return UIDevice.current.userInterfaceIdiom == .phone ? .large : .small
    }
    
    var body: some View {
        
        GeometryReader { geometry in

            ScrollView {
                
                let longerSide = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
                let shorterSide = UIScreen.main.bounds.height > UIScreen.main.bounds.width ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
                
                HStack {
                    Text("Portrait")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.init(white: 0.6))
                        .padding(.top)
                        .padding(.bottom, -3)
                        .padding(.leading, 5)
                    Spacer()
                }
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0...1, id: \.self) { variant in
                            VStack {
                                ButtonMenuButton(displayVariant: $displayVariant, type: .portrait, variant: variant, width: shorterSide/3, height: longerSide/3) {
                                    LayoutIcon(displayType: .portrait, expanded: variant == 1, longerSize: longerSide/3, shorterSize: shorterSide/3)
                                }
                                Button(action: {
//                                    self.settings.portraitLayout = variant
                                }) {
                                    ZStack {
                                        Circle()
                                            .frame(width: 50, height: 50)
//                                            .foregroundColor(Color.init(white: self.settings.portraitLayout == variant ? 0.3 : 0.1))
                                        Image(systemName: "checkmark")
//                                            .opacity(self.settings.portraitLayout == variant ? 1 : 0)
                                    }
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Text("Landscape")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.init(white: 0.6))
                        .padding(.top)
                        .padding(.bottom, -3)
                        .padding(.leading, 5)
                    Spacer()
                }
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0...0, id: \.self) { variant in
                            VStack {
                                ButtonMenuButton(displayVariant: $displayVariant, type: .landscape, variant: variant, width: longerSide/3, height: shorterSide/3) {
                                    LayoutIcon(displayType: .landscape, longerSize: longerSide/3, shorterSize: shorterSide/3)
                                }
                                Button(action: {
//                                    self.settings.landscapeLayout = variant
                                }) {
                                    ZStack {
                                        Circle()
                                            .frame(width: 50, height: 50)
//                                            .foregroundColor(Color.init(white: self.settings.landscapeLayout == variant ? 0.3 : 0.1))
                                        Image(systemName: "checkmark")
//                                            .opacity(self.settings.landscapeLayout == variant ? 1 : 0)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Layout")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: self.$displayVariant) { type in
                LayoutEditor(displayType: type.orientation, variant: type.variant)
            }
        }
    }
}

struct ButtonMenuButton<Content: View>: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Binding var displayVariant: LayoutDisplayVariant?
    
    var type: LayoutDisplayType
    var variant: Int
    
    var width: CGFloat
    var height: CGFloat
    
    var menu: () -> Content
    
    var body: some View {
            
        Button(action: {
//            if type == .portrait {
//                self.settings.portraitLayout = variant
//            }
//            else {
//                self.settings.landscapeLayout = variant
//            }
//            self.displayVariant = LayoutDisplayVariant(orientation: type, variant: variant)
        }) {
            
            ZStack {
            
                Rectangle()
                    .fill(Color.init(white: 0.15))
                    .frame(height: height)
                    .cornerRadius(20)
                VStack {
                    Spacer()
                    menu()
                }
                .frame(width: width, height: height)
                .padding(2)
                
            }
        }
    }
}

enum LayoutDisplayType {
    case portrait
    case landscape
}
            
struct LayoutDisplayVariant: Identifiable {
    var id = UUID()
    var orientation: LayoutDisplayType
    var variant: Int
}

struct LayoutButtonOverlay: View {
    
    var group: Int
    var index: Int
    var button: String
    
    @Binding var selectedGroup: Int?
    @Binding var selectedIndex: Int?
    @Binding var selectedButton: String?
    
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        
        Button(action: {
            self.selectedGroup = group
            self.selectedIndex = index
            self.selectedButton = button
        }) {
            Rectangle()
                .fill(Color.white)
                .frame(width: width, height: height)
                .cornerRadius((width+height)/2*0.4)
                .opacity(selectedGroup == group && selectedIndex == index ? 0.4 : 0)
        }
    }
}

