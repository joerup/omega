//
//  LayoutButtonPicker.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/3/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct LayoutButtonPicker: View {

    @ObservedObject var settings = Settings.settings
    
    @Environment(\.presentationMode) var presentationMode

    @Binding var button: String?
    
    var group: Int
    var index: Int
    
    var showAll = false
    @Binding var display: Bool
    
    var scrollDirection: Axis.Set = .horizontal

    var body: some View {
        
        if showAll {
            
            NavigationView {
        
                GeometryReader { geometry in
                    
                    ScrollView {

                        VStack {
                                
                            ForEach(Reference.buttons.indices, id: \.self) { buttonIndex in
                                
                                Divider()
                                
                                HStack {
                                    Text(Reference.buttons[buttonIndex].name)
                                        .foregroundColor(Color.init(white: 0.8))
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.top)
                                
                                ScrollView(.horizontal) {
                                    HStack {
                                        LayoutButtonPickerRow(category: buttonIndex, button: self.$button, group: group, index: index)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.bottom, 40)
                    }
                    .onChange(of: self.button) { _ in
                        self.display = false
                    }
                }
                .navigationTitle("Replace Button")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: MenuX(sheet: true, presentationMode: self.presentationMode))
            }
            .accentColor(color(self.settings.theme.color1))
            .navigationViewStyle(StackNavigationViewStyle())
        }
        else {
            
            VStack {
            
                if scrollDirection == .horizontal {
                    
                    VStack {
                        
                        HStack {
                            Text("Replace")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.init(white: 0.8))
                            Spacer()
                            Button(action: {
                                self.display.toggle()
                            }) {
                                Image(systemName: !display ? "chevron.up.circle" : "chevron.down.circle")
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 15)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                LayoutButtonPickerRow(category: -1, button: self.$button, group: group, index: index)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 40)
                }
                
                else {
                    
                    HStack {
                        
                        VStack {
                            Text("Replace")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.init(white: 0.8))
                            Spacer()
                            Button(action: {
                                self.display.toggle()
                            }) {
                                Image(systemName: !display ? "chevron.left.circle" : "chevron.down.circle")
                            }
                        }
                        .padding(.vertical)
                        .padding(.leading, 15)
                        
                        ScrollView(.vertical) {
                            VStack {
                                LayoutButtonPickerRow(category: -1, button: self.$button, group: group, index: index)
                            }
                            .padding(.vertical, 30)
                        }
                    }
                    .padding(.trailing, 20)
                }
            
            }
            .onChange(of: self.button) { _ in
                self.display = false
            }
        }
    }
}


struct LayoutButtonPickerRow: View {
    
    @ObservedObject var settings = Settings.settings
    
    var category: Int
    
    @Binding var button: String?
    
    var group: Int
    var index: Int
    
    var body: some View {
        
        Text("hi")
//        Group {
//            let buttons = category == -1 ? getAllButtons() : self.information.buttons[category].buttons
//            ForEach(buttons.indices, id: \.self) { index in
//                let button = buttons[index]
//                if button is InfoButtonCluster {
//                    ForEach((button as! InfoButtonCluster).buttons) { button in
//                        Button(action: {
//                            self.button = button.name
//                            self.changeButton(to: button.name)
//                        }) {
//                            VStack {
//                                ButtonView(button: button.name,
//                                           backgroundColor: color(self.settings.theme.color3),
//                                           width: 70,
//                                           height: 70,
//                                           fontSize: 50,
//                                           active: false
//                                )
//                                Text(button.fullName)
//                                    .font(.caption)
//                                    .fontWeight(.bold)
//                                    .frame(width: 70, height: 30)
//                                    .lineLimit(0)
//                                    .minimumScaleFactor(0.5)
//                            }
//                        }
//                        .id(button.id)
//                    }
//                }
//                else {
//                    Button(action: {
//                        self.button = button.name
//                        self.changeButton(to: button.name)
//                    }) {
//                        VStack {
//                            ButtonView(button: button.name,
//                                       backgroundColor: color(self.settings.theme.color3),
//                                       width: 70,
//                                       height: 70,
//                                       fontSize: 50,
//                                       active: false
//                            )
//                            Text(button.fullName)
//                                .font(.caption)
//                                .fontWeight(.bold)
//                                .frame(width: 70, height: 30)
//                                .lineLimit(0)
//                                .minimumScaleFactor(0.5)
//                        }
//                    }
//                    .id(button.id)
//                }
//            }
//        }
    }
    
    func getAllButtons() -> [InfoButton] {

        var buttons: [InfoButton] = []

        for category in Reference.buttons {
            for button in category.buttons {
                buttons += [button]
            }
        }
        
        buttons.removeSubrange(0..<4)
        buttons.insert(contentsOf: [
                InfoButton(id: 0,
                           name: "(",
                           fullName: "Parenthesis",
                           category: "Operations",
                           syntax: [[]],
                           example: [],
                           exampleQuestions: [[]],
                           exampleAnswers: [[]]
                ),
                InfoButton(id: 1,
                           name: ")",
                           fullName: "Parenthesis",
                           category: "Operations",
                           syntax: [[]],
                           example: [],
                           exampleQuestions: [[]],
                           exampleAnswers: [[]]
                )
            ],
            at: 0
        )

        return buttons
    }
    
    func changeButton(to: String) {
        
    }
}

