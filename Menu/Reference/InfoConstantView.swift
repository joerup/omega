//
//  InfoConstantView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/27/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct InfoConstantView: View {
    
    @ObservedObject var settings = Settings.settings
    
    var constant: InfoConstant
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                
                createSymbol(constant.symbol)
                    .padding(.horizontal, 5)
                
                Text(constant.name)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.init(white: 0.6))
                    .padding(.bottom, -3)
                    .lineLimit(0)
            }
            
            Spacer()
                
            if constant is InfoConstantCluster {
                let cluster = constant as! InfoConstantCluster
                ForEach(cluster.constants, id: \.id) { constant in
                    HStack {
                        let expression = roundValues(constant.value)
                        
                        TextDisplay(strings: expression, size: 40)
                        
                        TextDisplay(strings: constant.unit, size: 37, color: .init(white: 0.7))
                            .padding(.leading, -5)
                    }
                    .padding(5)
                    .onTapGesture {
                        insertConstant(value: constant.value, unit: constant.unit)
                    }
                }
            }
            else {
                HStack {
                    let expression = roundValues(constant.value)
                    
                    TextDisplay(strings: expression, size: 40)
                    
                    TextDisplay(strings: constant.unit, size: 37, color: .init(white: 0.7))
                        .padding(.leading, -5)
                }
                .padding(5)
                .onTapGesture {
                    insertConstant(value: constant.value, unit: constant.unit)
                }
            }

            Spacer()
        }
    }
    
    func createSymbol(_ symbol: String) -> AnyView {
        var array = [symbol]
        var format = [""]
        if symbol.contains("¬") {
            array = symbol.split(separator: "¬").map { String($0) }
            format = ["","¬"]
        }
        return AnyView(
            HStack {
                ForEach(array.indices, id: \.self) { index in
                    let subscripted = format[index] == "¬"
                    Text(array[index])
                        .font(subscripted ? .caption : .title2)
                        .baselineOffset(subscripted ? -15 : 0)
                        .fontWeight(.semibold)
                        .foregroundColor(color(self.settings.theme.color2, edit: true))
                        .padding(.leading, subscripted ? -5 : 0)
                }
            }
        )
    }
    
    func insertConstant(value: [String], unit: [String]) {
        // Insert constant into queue
//        self.input.insertToQueue(roundValues(value))
        
        // Set to recent constants
        if self.settings.recentConstants[0].contains(value) && self.settings.recentConstants[1].contains(unit) {
            self.settings.recentConstants[0].remove(at: self.settings.recentConstants[0].firstIndex(of: value)!)
            self.settings.recentConstants[1].remove(at: self.settings.recentConstants[1].firstIndex(of: unit)!)
        }
        self.settings.recentConstants[0].insert(value, at: 0)
        self.settings.recentConstants[1].insert(unit, at: 0)
        if self.settings.recentConstants[0].count > 3 && self.settings.recentConstants[1].count > 3 {
            self.settings.recentConstants[0].removeLast()
            self.settings.recentConstants[1].removeLast()
        }
    }
    
    func roundValues(_ array: [String]) -> [String] {
        
        var newArray: [String] = []
        
        if let value = Double(array[0]) {
            let formatter = NumberFormatter()
            formatter.usesSignificantDigits = true
            formatter.maximumSignificantDigits = self.settings.constantsRoundPlaces+1
            formatter.minimumSignificantDigits = self.settings.constantsRoundPlaces+1
            newArray += [formatter.string(from: NSNumber(value: value)) ?? array[0]]
        }
        
        for item in array.dropFirst() {
            newArray += [item]
        }
        
        return newArray
    }
}
