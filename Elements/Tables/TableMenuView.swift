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
    
    @State var lowerBound: Double = -50
    @State var upperBound: Double = 50
    @State var centerValue: Double = .nan
    @State var increment: Double = 1
    
    @State private var dx: Queue = Queue([Number(1)])
    @State private var x: Queue = Queue([Number(0)])
    
    var fullTable: Bool = true
    var fontSize: CGFloat = 25
    
    var body: some View {
        
        GeometryReader { geometry in

            VStack(spacing: 0) {
                
                HStack {
                    
                    HStack(spacing: 0) {
                        TextDisplay(strings: ["∆","*",horizontalAxis.text,"="], size: 25, opacity: 0.6)
                        TextInput(queue: dx, defaultValue: Queue([Number(1)]), size: 25, scrollable: true, onDismiss: { dx in
                            let items = dx.final.items
                            if items.count == 1, let first = items.first, let increment = first as? Number, !increment.negative {
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
                    
                    HStack(spacing: 0) {
                        TextDisplay(strings: [horizontalAxis.text,"="], size: 25, opacity: 0.6)
                        TextInput(queue: x, defaultValue: Queue([Number(0)]), size: 25, scrollable: true, onDismiss: { x in
                            let items = x.final.items
                            if items.count == 1, let first = items.first, let center = first as? Number {
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
                    
                    XButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(height: 30)
                }
                .padding(.horizontal, 10)
                .padding(.top, 2.5)
                .padding(.bottom, geometry.size.height > geometry.size.width ? 10 : 5)
                
                TableView(equation: equation, horizontalAxis: horizontalAxis, verticalAxis: verticalAxis, lowerBound: $lowerBound, upperBound: $upperBound, centerValue: $centerValue, increment: $increment, fullTable: true, fontSize: fontSize)
                    .edgesIgnoringSafeArea(.bottom)
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .contentOverlay()
        }
    }
}
