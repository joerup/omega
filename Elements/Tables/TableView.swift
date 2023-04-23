//
//  TableView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 4/21/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct TableView: View {
    
    @ObservedObject var settings = Settings.settings
    
    var equation: Queue
    
    var horizontalAxis: Letter
    var verticalAxis: Letter
    
    @Binding var lowerBound: Double
    @Binding var upperBound: Double
    @Binding var centerValue: Double
    @Binding var increment: Double
    
    var fullTable: Bool = false
    var popUpTable: Bool = false
    @State var showPopUpTable: Bool = false
    
    var fontSize: CGFloat
    var overlayColor: [CGFloat]
    
    init(equation: Queue, horizontalAxis: Letter, verticalAxis: Letter, lowerBound: Binding<Double>, upperBound: Binding<Double>, centerValue: Binding<Double>, increment: Binding<Double>, fullTable: Bool = false, popUpTable: Bool = false, fontSize: CGFloat = 25) {
        self.equation = equation
        self.horizontalAxis = horizontalAxis
        self.verticalAxis = verticalAxis
        self._lowerBound = lowerBound
        self._upperBound = upperBound
        self._centerValue = centerValue
        self._increment = increment
        self.fullTable = fullTable
        self.popUpTable = popUpTable
        self.fontSize = fontSize
        self.overlayColor = Settings.settings.theme.color1
    }
    
    init(equation: Queue, horizontalAxis: Letter, verticalAxis: Letter, lowerBound: Double? = nil, upperBound: Double? = nil, centerValue: Double? = nil, increment: Double? = nil, fullTable: Bool = false, popUpTable: Bool = false, fontSize: CGFloat = 25, color: [CGFloat]? = nil) {
        self.equation = equation
        self.horizontalAxis = horizontalAxis
        self.verticalAxis = verticalAxis
        self._lowerBound = .constant(lowerBound ?? -50)
        self._upperBound = .constant(upperBound ?? 50)
        self._centerValue = .constant(centerValue ?? .nan)
        self._increment = .constant(increment ?? 1)
        self.fullTable = fullTable
        self.popUpTable = popUpTable
        self.fontSize = fontSize
        self.overlayColor = color ?? Settings.settings.theme.color1
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {

                ScrollViewReader { scrollView in

                    ScrollView {

                        LazyVStack(spacing: 0) {

                            if fullTable {
                                Rectangle()
                                    .frame(height: 1)
                                    .opacity(0)
                                    .onAppear {
                                        if centerValue.isFinite {
                                            self.lowerBound -= 25*increment
                                            self.upperBound -= 25*increment
                                            scrollView.scrollTo(lowerBound+50*increment, anchor: .top)
                                        } else {
                                            centerValue = 0
                                        }
                                    }
                            }

                            ForEach(Int(lowerBound/increment)...Int(upperBound/increment), id: \.self) { num in

                                let x = round((Double(num)*increment + lowerBound.truncatingRemainder(dividingBy: increment)) * 1e10)/1e10

                                let y = Expression(equation.items).plugIn(Number(x), to: horizontalAxis, using: equation.modes)

                                if let number = Value.setValue(y) {

                                    HStack {
                                        
                                        let xString = Number(x).string

                                        HStack {
                                            Spacer()
                                            Text(xString)
                                                .font(Font(UIFont(name: TextFormatting.getFont(), size: fontSize) ?? UIFont()))
                                                .minimumScaleFactor(0.5)
                                                .opacity(0.6)
                                        }
                                        .frame(maxWidth: geometry.size.width*0.3, maxHeight: fontSize*1.2)
                                        .padding(.horizontal, 15)
                                        .background(Color.init(white: !fullTable ? 0.25 : x == centerValue ? 0.3 : 0.2).cornerRadius(20))
                                        .overlay(color(overlayColor).opacity(0.1).cornerRadius(20))

                                        let yStrings = number is Expression ? (number as! Expression).queue.strings : Queue([number]).strings

                                        HStack {
                                            TextDisplay(strings: yStrings, size: fontSize)
                                            Spacer()
                                        }
                                        .frame(minWidth: geometry.size.width*0.3)
                                        .padding(.horizontal, 15)
                                        .background(Color.init(white: !fullTable ? 0.25 : x == centerValue ? 0.3 : 0.2).cornerRadius(20))
                                        .overlay(color(overlayColor).opacity(0.1).cornerRadius(20))
                                        .contextMenu {
                                            Button(action: {
                                                guard yStrings != ["ERROR"] else { return }
                                                UIPasteboard.general.string = Queue([number]).exportString()
                                                Settings.settings.clipboard = [number]
                                                Settings.settings.notification = .copy
                                            }) {
                                                Image(systemName: "doc.on.clipboard")
                                                Text("Copy")
                                            }
                                        }

                                    }
                                    .id(x)
                                    .frame(height: fontSize*1.2)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 1)
                                }
                            }

                            if fullTable {
                                Rectangle()
                                    .frame(height: 1)
                                    .opacity(0)
                                    .onAppear {
                                        if centerValue.isFinite {
                                            self.lowerBound += 25*increment
                                            self.upperBound += 25*increment
                                            scrollView.scrollTo(upperBound-50*increment, anchor: .bottom)
                                        }
                                    }
                            }
                        }
                        .onAppear {
                            if centerValue.isNaN {
                                scrollView.scrollTo(0, anchor: .center)
                            } else {
                                scrollView.scrollTo(centerValue, anchor: .center)
                            }
                        }
                        .onChange(of: centerValue) { centerValue in
                            lowerBound = centerValue - 50*increment
                            upperBound = centerValue + 50*increment
                            scrollView.scrollTo(centerValue, anchor: .center)
                        }
                        .onChange(of: increment) { increment in
                            lowerBound = centerValue - 50*increment
                            upperBound = centerValue + 50*increment
                            scrollView.scrollTo(centerValue, anchor: .center)
                        }
                    }
                }
                .overlay(
                    Rectangle()
                        .fill(Color.init(white: 0.6))
                        .opacity(popUpTable ? 0.1 : 0)
                        .onTapGesture {
                            if popUpTable {
                                SoundManager.play(haptic: .medium)
                                self.showPopUpTable.toggle()
                            }
                        }
                )
            }
            .background(Color.init(white: 0.1).opacity(fullTable ? 1 : 0))
            .cornerRadius(20)
            .fullScreenCover(isPresented: self.$showPopUpTable) {
                TableMenuView(equation: equation, horizontalAxis: horizontalAxis, verticalAxis: verticalAxis)
            }
        }
    }
}
