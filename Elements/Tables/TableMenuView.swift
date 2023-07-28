//
//  TableMenuView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/6/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct TableMenuView: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.presentationMode) var presentationMode

    var equation: Queue
    
    var horizontalAxis: Letter
    var verticalAxis: Letter
    
    @State var lowerBound: Double = -30
    @State var upperBound: Double = 30
    @State var centerValue: Double = 0
    @State var increment: Double = 1
    
    @State private var dx: Queue = Queue([Number(1)])
    @State private var x: Queue = Queue([Number(0)])
    
    var fullTable: Bool = true
    var fontSize: CGFloat = 25
    
    var body: some View {

        VStack {
            
            VStack {
                TableView(equation: equation, horizontalAxis: horizontalAxis, verticalAxis: verticalAxis, lowerBound: $lowerBound, upperBound: $upperBound, centerValue: $centerValue, increment: $increment, fullTable: true, fontSize: fontSize)
                    .padding(.top, 55)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .overlay(
                VStack {
                    HStack {
                        
                        HStack(spacing: 0) {
                            TextDisplay(strings: ["∆","*",horizontalAxis.text,"="], size: 25, colorContext: .secondary)
                            TextInput(queue: dx, defaultValue: Queue([Number(1)]), size: 25, scrollable: true, onDismiss: { dx in
                                let items = dx.final.items
                                if items.count == 1, let first = items.first, let increment = first as? Number, increment.value > 0 {
                                    self.dx = dx
                                    self.increment = increment.value
                                    print(increment.value)
                                }
                                else if let simplified = Expression(items).simplify(), let increment = simplified as? Number, increment.value > 0 {
                                    self.dx = dx
                                    self.increment = increment.value
                                    print(increment.value)
                                }
                            })
                        }
                        .frame(height: 30)
                        .padding(.horizontal, 10)
                        .padding(5)
                        .background(Color.init(white: 0.1).cornerRadius(20))
                        .frame(maxWidth: 300)
                        
                        HStack(spacing: 0) {
                            TextDisplay(strings: [horizontalAxis.text,"="], size: 25, colorContext: .secondary)
                            TextInput(queue: x, defaultValue: Queue([Number(0)]), size: 25, scrollable: true, onDismiss: { x in
                                let items = x.final.items
                                if items.count == 1, let first = items.first, let center = first as? Number {
                                    self.x = x
                                    self.centerValue = center.value
                                    print(center.value)
                                }
                                else if let simplified = Expression(items).simplify(), let center = simplified as? Number {
                                    self.x = x
                                    self.centerValue = center.value
                                    print(center.value)
                                }
                            })
                            .onChange(of: centerValue) { centerValue in
                                self.x = Queue([Number(centerValue)])
                            }
                        }
                        .frame(height: 30)
                        .padding(.horizontal, 10)
                        .padding(5)
                        .background(Color.init(white: 0.1).cornerRadius(20))
                        .frame(maxWidth: 300)
                        
                        Spacer(minLength: 10)
                        
                        Button {
                            withAnimation {
                                presentationMode.wrappedValue.dismiss()
                                SoundManager.play(haptic: .medium)
                            }
                        } label: {
                            Text("Done")
                                .foregroundColor(settings.theme.primaryTextColor)
                                .font(.system(.body, design: .rounded).weight(.semibold))
                                .padding(2)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2.5)
                    
                    Spacer()
                }
            )
        }
    }
}
