//
//  ReferenceList.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 9/30/20.
//  Copyright © 2020 Rupertus. All rights reserved.
//

import SwiftUI

struct ReferenceList: View {
    
    @ObservedObject var settings = Settings.settings
    
    @State private var selectedButton: InfoButton? = nil
    
    @State private var search: String = ""
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {

//                VStack {
//
//                    Text("Under Construction")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .multilineTextAlignment(.center)
//                        .padding(.bottom, 20)
//
//                    Text("Stay tuned – this location will be home to a new Reference menu soon.")
//                        .multilineTextAlignment(.center)
//
//                    Spacer()
//                }
//                .foregroundColor(Color.init(white: 0.6))
//                .padding(40)
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: self.$search)
                        if !search.isEmpty {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    search = ""
                                }
                        }
                    }
                    .padding(5)
                    .background(Color.init(white: 0.17))
                    .cornerRadius(10)
                    .padding(5)
                }
                .padding(.horizontal, 5)
                .padding(.bottom, 5)

                ScrollView {

                    LazyVStack(alignment: .leading) {

                        if search.isEmpty {

                            ForEach(Reference.buttons, id: \.id) { category in
                                Section(header:
                                    ZStack {
                                        Text(LocalizedStringKey(category.name))
                                            .fontWeight(.bold)
                                            .foregroundColor(Color.init(white: 0.6))
                                            .textCase(nil)
                                            .padding([.horizontal, .top], 10)
                                    }
                                ) {
                                    InfoButtonList(buttons: category.buttons, selectedButton: $selectedButton)
                                        .padding(.bottom, 25)
                                }
                            }
                        }
                        else {
                            InfoButtonList(buttons: getButtons(), selectedButton: $selectedButton)
                                .padding(.bottom, 25)
                        }

                        Spacer()
                            .frame(height: 25)
                    }
                }
            }
            .frame(width: geometry.size.width)
            .padding(.trailing, geometry.size.width > 800 ? geometry.size.width*0.5 : 0)
            .edgesIgnoringSafeArea(.bottom)
            .overlay(
                VStack {
                    if let button = selectedButton, !(button is InfoButtonCluster) {
                        ZStack {
                            InfoButtonView(button: button)
                            if geometry.size.width <= 800 {
                                XButtonOverlay(action: {
                                    self.selectedButton = nil
                                })
                            }
                        }
                        .background(Color.init(white: 0.15).cornerRadius(20))
                        .edgesIgnoringSafeArea(.bottom)
                        .transition(.move(edge: .bottom))
                    }
                }
                .frame(width: geometry.size.width > 800 ? geometry.size.width*0.5 : geometry.size.width)
                .padding(.leading, geometry.size.width > 800 ? geometry.size.width*0.5 : 0)
            )
        }
        .navigationBarTitle("Reference")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    func getButtons() -> [InfoButton] {
        
        var allButtons: [InfoButton] = []
        
        // Add all buttons to array
        for category in Reference.buttons {
            for button in category.buttons {
                if button is InfoButtonCluster {
                    let cluster = button as! InfoButtonCluster
                    for button in cluster.buttons {
                        allButtons += [button]
                    }
                }
                else {
                    allButtons += [button]
                }
            }
        }
        
        // Filter
        var filteredButtons: [InfoButton] = []
        
        // equal
        for button in allButtons.filter({ $0.fullName.uppercased() == search.uppercased() || $0.name.uppercased() == search.uppercased() }) {
            filteredButtons += [button]
        }
        
        // starting with
        for button in allButtons.filter({ $0.fullName.uppercased().starts(with: search.uppercased()) || $0.name.uppercased().starts(with: search.uppercased()) }) {
            if !filteredButtons.contains(where: { $0.id == button.id }) {
                filteredButtons += [button]
            }
        }
        
        // contains
        for button in allButtons.filter({ $0.fullName.uppercased().contains(search.uppercased()) || $0.name.uppercased().contains(search.uppercased()) }) {
            if !filteredButtons.contains(where: { $0.id == button.id }) {
                filteredButtons += [button]
            }
        }
        
        // same category
        for button in allButtons.filter({ $0.category.uppercased().contains(search.uppercased()) }) {
            if !filteredButtons.contains(where: { $0.id == button.id }) {
                filteredButtons += [button]
            }
        }
        
        return filteredButtons
    }
    
    
    func getConstants() -> [InfoConstant] {
        
        let allConstants: [InfoConstant] = Reference.constants
        
        // Filter
        var filteredConstants: [InfoConstant] = []
        
        // symbol
        for constant in allConstants.filter({ $0.symbol == search }) {
            filteredConstants += [constant]
        }
        
        // symbol
        for constant in allConstants.filter({ $0.symbol.uppercased() == search.uppercased() }) {
            if !filteredConstants.contains(where: { $0.id == constant.id }) {
                filteredConstants += [constant]
            }
        }
        
        // names equal
        for constant in allConstants.filter({ $0.name.uppercased() == search.uppercased() }) {
            if !filteredConstants.contains(where: { $0.id == constant.id }) {
                filteredConstants += [constant]
            }
        }
        
        // name starts with
        for constant in allConstants.filter({ $0.name.uppercased().starts(with: search.uppercased()) }) {
            if !filteredConstants.contains(where: { $0.id == constant.id }) {
                filteredConstants += [constant]
            }
        }
        
        // name contains
        for constant in allConstants.filter({ $0.name.uppercased().contains(search.uppercased()) }) {
            if !filteredConstants.contains(where: { $0.id == constant.id }) {
                filteredConstants += [constant]
            }
        }
        
        // same value
        for constant in allConstants.filter({ $0.value.contains(where: { $0.contains(search.uppercased()) }) }) {
            if !filteredConstants.contains(where: { $0.id == constant.id }) {
                filteredConstants += [constant]
            }
        }
        
        // same units
//        for constant in allConstants.filter({ $0.unit.uppercased().contains(search.uppercased()) }) {
//            if !filteredConstants.contains(where: { $0.id == constant.id }) {
//                filteredConstants += [constant]
//            }
//        }
        
        return filteredConstants
    }
    
    
    func getRecentConstants() -> [InfoConstant] {
        
        var constants: [InfoConstant] = []
            
        for constant in Reference.constants {
            if constant is InfoConstantCluster {
                for value in (constant as! InfoConstantCluster).constants {
                    if self.settings.recentConstants[0].contains(value.value) && self.settings.recentConstants[1].contains(value.unit) {
                        constants += [
                            InfoConstant(name: constant.name,
                                  symbol: constant.symbol,
                                  value: value.value,
                                  unit: value.unit
                            )
                        ]
                    }
                }
            }
            else {
                if self.settings.recentConstants[0].contains(constant.value) && self.settings.recentConstants[1].contains(constant.unit) {
                    constants += [constant]
                }
            }
        }
        
        return constants
            .sorted { (self.settings.recentConstants[0].firstIndex(of: $0.value) ?? Int.max < self.settings.recentConstants[0].firstIndex(of: $1.value) ?? Int.max) && (self.settings.recentConstants[1].firstIndex(of: $0.unit) ?? Int.max < self.settings.recentConstants[1].firstIndex(of: $1.unit) ?? Int.max) }
    }
}


