//
//  LayoutEditor.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/8/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct LayoutEditor: View {
    
    @ObservedObject var settings = Settings.settings
    
    @State var displayType: LayoutDisplayType = .portrait
    @State var variant: Int = 0
    var size: Size {
        return UIDevice.current.userInterfaceIdiom == .phone ? .small : .large
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedGroup: Int? = nil
    @State private var selectedIndex: Int? = nil
    @State private var selectedButton: String? = nil
    
    @State private var showPicker = false
    
    var body: some View {
        
        GeometryReader { geometry in
            
            NavigationView {
                
                ZStack {
                    
                    VStack {
                        
                        Spacer()
                        
                        HStack {
                            
                            Spacer()
                            
                            let ratio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
                                
                            let width = ratio > 1 ?
                                geometry.size.height*0.7/ratio :
                                geometry.size.height*0.7
                            let height = ratio > 1 ?
                                geometry.size.height*0.65 :
                                geometry.size.height*0.65/ratio
                        
                            VStack {
                                
                                if displayType == .landscape {
//                                    HStack {
//                                        ForEach(0..<3) { page in
//                                            Button(action: {
//                                                self.settings.buttonSection = page
//                                            }) {
//                                                ZStack {
//                                                    Circle()
//                                                        .frame(width: 30, height: 30)
//                                                        .foregroundColor(Color.init(white: settings.buttonSection == page ? 0.8 : 0.6))
//                                                        .opacity(0.4)
//                                                    Text(String(page+1))
//                                                }
//                                            }
//                                        }
//                                    }
                                }
                                
                                ScrollView(displayType == .landscape ? .horizontal : .vertical) {
                                    
                                    VStack {
                                        
                                        Spacer()
                                    
//                                        if displayType == .portrait {
//
//                                            if variant == 0 {
//                                                ButtonPad(layout: .portrait, size: size, width: width, buttonHeight: height/9.5, group: self.$selectedGroup, index: self.$selectedIndex, button: self.$selectedButton)
//                                            }
//                                            else if variant == 1 {
//                                                ButtonPad(layout: .portraitExpanded, size: size, width: width, buttonHeight: height/(size == .small ? 11 : 9.8), group: self.$selectedGroup, index: self.$selectedIndex, button: self.$selectedButton)
//                                            }
//                                        }
//                                        else if displayType == .landscape {
//
//                                            if variant == 0 {
//                                                ButtonPad(layout: .landscape, size: size, width: height, buttonHeight: width/(size == .small ? 7.3 : 8), group: self.$selectedGroup, index: self.$selectedIndex, button: self.$selectedButton)
//                                            }
//                                        }
                                    }
                                    .frame(width: displayType == .landscape ? height : width, height: displayType == .portrait ? height : width)
                                    .padding(geometry.size.width*0.0125)
                                    .background(Color.init(white: 0.1))
                                    .cornerRadius(20)
                                    .padding(geometry.size.width*0.0125)
                                }
                                .frame(
                                    maxWidth: displayType == .landscape ? height + geometry.size.width*0.05 : width + geometry.size.width*0.05,
                                    maxHeight: displayType == .portrait ? height + geometry.size.width*0.05 : width + geometry.size.width*0.05,
                                    alignment: .center)
                            }
                            .frame(minWidth: geometry.size.width > geometry.size.height ? geometry.size.width*0.75 : geometry.size.width,
                                   minHeight: geometry.size.height > geometry.size.width ? geometry.size.height*0.7 : geometry.size.height)
                            .padding(.trailing, geometry.size.width > geometry.size.height ? geometry.size.width*0.2 : 0)
                            .padding(.bottom, geometry.size.height > geometry.size.width ? geometry.size.height*0.25 : 0)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    
                    if geometry.size.height > geometry.size.width {
                        
                        VStack {
                            
                            Spacer()
                            
                            ZStack {
                                if selectedButton != nil {
                                    Rectangle()
                                        .fill(Color.init(white: 0.17))
                                        .cornerRadius(20)
                                        .edgesIgnoringSafeArea([.bottom, .leading, .trailing])
                                    if let group = selectedGroup, let index = selectedIndex {
                                        LayoutButtonPicker(button: self.$selectedButton, group: group, index: index, showAll: false, display: self.$showPicker, scrollDirection: .horizontal)
                                            .edgesIgnoringSafeArea(.bottom)
                                    }
                                }
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height*0.25)
                            .edgesIgnoringSafeArea(.bottom)
                        }
                    }
                    else {
                        
                        HStack {
                            
                            Spacer()
                        
                            ZStack {
                                if selectedButton != nil {
                                    Rectangle()
                                        .fill(Color.init(white: 0.17))
                                        .cornerRadius(20)
                                        .edgesIgnoringSafeArea([.trailing, .bottom, .top])
                                    if let group = selectedGroup, let index = selectedIndex {
                                        LayoutButtonPicker(button: self.$selectedButton, group: group, index: index, showAll: false, display: self.$showPicker, scrollDirection: .vertical)
                                            .edgesIgnoringSafeArea(.trailing)
                                            .padding(.trailing, -15)
                                    }
                                }
                            }
                            .frame(width: geometry.size.width*0.2, height: geometry.size.height)
                            .edgesIgnoringSafeArea(.trailing)
                        }
                    }
                }
                .sheet(isPresented: self.$showPicker) {
                    if let group = selectedGroup, let index = selectedIndex {
                        LayoutButtonPicker(button: self.$selectedButton, group: group, index: index, showAll: true, display: self.$showPicker)
                            .edgesIgnoringSafeArea([.bottom, .leading, .trailing])
                    }
                }
                .navigationTitle("Layout")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: LayoutResetButton(displayType: displayType, size: size, variant: variant, selectedGroup: $selectedGroup, selectedIndex: $selectedIndex, selectedButton: $selectedButton),
                    trailing: MenuX(sheet: true, presentationMode: self.presentationMode))
            }
            .accentColor(color(self.settings.theme.color1, edit: true))
        }
    }
}
