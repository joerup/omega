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
    
    @State private var startValue: Int = 0
    @State private var endValue: Int = 0
    
    var fullTable: Bool = false
    var popUpTable: Bool = false
    var lightBackground: Bool = false
    
    @State var showPopUpTable: Bool = false
    
    var fontSize: CGFloat
    var overlayColor: [CGFloat]
    
    @GestureState private var dragOffset: CGFloat = 0
    @State private var offset: CGFloat = 0
    
    init(equation: Queue, horizontalAxis: Letter, verticalAxis: Letter, lowerBound: Binding<Double>, upperBound: Binding<Double>, centerValue: Binding<Double>, increment: Binding<Double>, fullTable: Bool = false, popUpTable: Bool = false, lightBackground: Bool = false, fontSize: CGFloat = 25) {
        self.equation = equation
        self.horizontalAxis = horizontalAxis
        self.verticalAxis = verticalAxis
        self._lowerBound = lowerBound
        self._upperBound = upperBound
        self._centerValue = centerValue
        self._increment = increment
        self.fullTable = fullTable
        self.popUpTable = popUpTable
        self.lightBackground = lightBackground
        self.fontSize = fontSize
        self.overlayColor = Settings.settings.theme.color1
    }
    
    init(equation: Queue, horizontalAxis: Letter, verticalAxis: Letter, lowerBound: Double? = nil, upperBound: Double? = nil, centerValue: Double? = nil, increment: Double? = nil, fullTable: Bool = false, popUpTable: Bool = false, lightBackground: Bool = false, fontSize: CGFloat = 25, color: [CGFloat]? = nil) {
        self.equation = equation
        self.horizontalAxis = horizontalAxis
        self.verticalAxis = verticalAxis
        self._lowerBound = .constant(lowerBound ?? -30)
        self._upperBound = .constant(upperBound ?? 30)
        self._centerValue = .constant(centerValue ?? 0)
        self._increment = .constant(increment ?? 1)
        self.fullTable = fullTable
        self.popUpTable = popUpTable
        self.lightBackground = lightBackground
        self.fontSize = fontSize
        self.overlayColor = color ?? Settings.settings.theme.color1
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {

                ZStack {

                    ForEach(startValue...endValue, id: \.self) { num in

                        let x = round((Double(num)*increment + lowerBound.truncatingRemainder(dividingBy: increment)) * 1E10)/1E10

                        let y = value(input: x)

                        let number = Value.setValue(y)

                        HStack(spacing: 5) {
                            
                            let xStrings = Queue([Number(x)]).strings

                            HStack {
                                Spacer(minLength: 0)
                                TextDisplay(strings: xStrings, size: fontSize, colorContext: .none)
                                    .opacity(0.6)
                            }
                            .frame(maxWidth: geometry.size.width*(fullTable ? 0.3 : 0.2), maxHeight: fontSize*1.2)
                            .padding(.horizontal, fontSize/2)
                            .background(Color.init(white: !fullTable ? 0.25 : isCenter(x) ? 0.3 : 0.2).overlay(color(overlayColor).opacity(0.1)).cornerRadius(20))

                            let yStrings = number is Expression ? (number as! Expression).queue.strings : Queue([number]).strings

                            HStack {
                                TextDisplay(strings: yStrings, size: fontSize, colorContext: .none)
                                Spacer(minLength: 0)
                            }
                            .frame(minWidth: geometry.size.width*(fullTable ? 0.3 : 0.2))
                            .padding(.horizontal, fontSize/2)
                            .background(Color.init(white: !fullTable ? 0.25 : isCenter(x) ? 0.3 : 0.2).overlay(color(overlayColor).opacity(0.1)).cornerRadius(20))
                            .contextMenu {
                                if fullTable {
                                    Button {
                                        guard yStrings != ["ERROR"] else { return }
                                        UIPasteboard.general.string = Queue([number]).exportString()
                                        Settings.settings.clipboard = [number]
                                        Settings.settings.notification = .copy
                                    } label: {
                                        Label("Copy", systemImage: "doc.on.clipboard")
                                    }
                                }
                            }
                        }
                        .id(x)
                        .frame(height: fontSize*1.2)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 1)
                        .position(x: geometry.size.width/2, y: geometry.size.height/2 + CGFloat((x - centerValue) / increment) * (fontSize*1.2+2))
                    }
                }
                .offset(y: dragOffset + offset)
                .gesture(DragGesture()
                    .updating($dragOffset) { value, gestureOffset, _ in
                        gestureOffset = value.translation.height
                    }
                    .onEnded { value in
                        self.offset += value.translation.height
                        let boundChange = round(offset / (fontSize*1.2 + 2)) * increment
                        let difference = upperBound - lowerBound
                        lowerBound = centerValue - difference/2 - boundChange
                        upperBound = centerValue + difference/2 - boundChange
                        setLimits()
                    }
                )
                .onChange(of: centerValue) { centerValue in
                    lowerBound = centerValue - 30*increment
                    upperBound = centerValue + 30*increment
                    offset = 0
                    setLimits()
                }
                .onChange(of: increment) { increment in
                    lowerBound = centerValue - 30*increment
                    upperBound = centerValue + 30*increment
                    offset = 0
                    setLimits()
                }
                .onAppear {
                    setLimits()
                }
                .overlay(
                    ZStack {
                        if popUpTable {
                            Rectangle()
                                .fill(Color.init(white: 0.75))
                                .opacity(lightBackground ? 0.1 : 1e-6)
                                .onTapGesture {
                                    SoundManager.play(haptic: .medium)
                                    self.showPopUpTable.toggle()
                                }
                        }
                    }
                )
            }
            .background(Color.init(white: 0.1).opacity(fullTable ? 1 : 0))
            .cornerRadius(20)
            .fullScreenCover(isPresented: self.$showPopUpTable) {
                TableMenuView(equation: equation, horizontalAxis: horizontalAxis, verticalAxis: verticalAxis)
                    .contentOverlay()
            }
        }
    }
    
    private func setLimits() {
        startValue = Int(lowerBound / increment)
        endValue = Int(upperBound / increment)
    }
    
    private func isCenter(_ x: Double) -> Bool {
        return abs(centerValue - x) < 1E-12
    }
    
    private func value(input: Double) -> Value {
        return Expression(equation.items).plugIn(Number(input), to: horizontalAxis, using: equation.modes)
    }
}
