//
//  CalculatorModel.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/31/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct CalculatorModel: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var displayType: ModelDisplayType
    
    var deviceSize: CGSize {
        return UIScreen.main.bounds.size
    }
    var deviceType: UIUserInterfaceIdiom {
        return UIDevice.current.userInterfaceIdiom
    }
    
    var setOrientation: Orientation?
    var setSize: Size?
    
    var orientation: Orientation {
        return setOrientation ?? (deviceSize.width > deviceSize.height ? .landscape : .portrait)
    }
    var size: Size {
        return setSize ?? (deviceType == .phone ? .small : .large)
    }
    
    var buttonHeight: CGFloat {
        if size == .large {
            return orientation == .portrait ? 1/11.5 : 1/9
        } else {
            return orientation == .portrait ? 1/9 : 1/8
        }
    }
    var standardSize: CGFloat {
        return size == .small && orientation == .landscape ? size.smallerSmallSize : size.standardSize
    }
    var horizontalPadding: CGFloat {
        return size == .small && orientation == .landscape ? 5 : 10
    }
    var verticalPadding: CGFloat {
        return size == .small ? 5 : 10
    }
    
    var maxWidth: CGFloat?
    var maxHeight: CGFloat?
    var sideInsets: CGFloat
    
    var flippedOrientation: Bool {
        return deviceSize.width > deviceSize.height && orientation == .portrait || deviceSize.height > deviceSize.width && orientation == .landscape
    }
    
    var modelSize: CGSize {
        
        if let maxWidth = maxWidth, let maxHeight = maxHeight {
        
            var size: CGSize = !flippedOrientation ? CGSize(width: deviceSize.width, height: deviceSize.height) : CGSize(width: deviceSize.height, height: deviceSize.width)
            
            if size.width > maxWidth {
                size.height *= maxWidth/size.width
                size.width *= maxWidth/size.width
            }
            if size.height > maxHeight {
                size.width *= maxHeight/size.height
                size.height *= maxHeight/size.height
            }
            
            return size
        }
        
        return deviceSize
    }
    
    var scale: CGFloat {
        return !flippedOrientation ? modelSize.height / deviceSize.height : modelSize.width / deviceSize.height
    }
    
    var topSafeArea: CGFloat {
        return (!flippedOrientation ? safeAreaInsets.top : safeAreaInsets.left) * scale
    }
    var bottomSafeArea: CGFloat {
        return (!flippedOrientation ? safeAreaInsets.bottom : safeAreaInsets.right) * scale
    }
    var leftSafeArea: CGFloat {
        return (!flippedOrientation ? safeAreaInsets.left : safeAreaInsets.top) * scale
    }
    var rightSafeArea: CGFloat {
        return (!flippedOrientation ? safeAreaInsets.right : safeAreaInsets.top) * scale
    }
    var safeSize: CGSize {
        return CGSize(width: modelSize.width - leftSafeArea - rightSafeArea, height: modelSize.height - topSafeArea - bottomSafeArea)
    }
    
    private var safeAreaInsets: UIEdgeInsets {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.safeAreaInsets ?? .zero
    }
    
    var ignoreSafeArea: Bool {
        if case .graph(_) = displayType {
            return true
        } else if case .table(_) = displayType {
            return true
        }
        return false
    }
    
    var border: CGFloat {
        return scale * 20
    }
    
    var theme: Theme = Settings.settings.theme
    
    var modes: ModeSettings? = nil
    
    @State private var animatedIndex: Int = 0
    @State private var timer: Timer?
    
    init(_ displayType: ModelDisplayType = .buttons, orientation: Orientation? = nil, size: Size? = nil, maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil, sideInsets: CGFloat = 0, theme: Theme? = nil, modes: ModeSettings? = nil) {
        self.displayType = displayType
        self.setOrientation = orientation
        self.setSize = size
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.sideInsets = sideInsets
        self.theme = theme ?? Settings.settings.theme
        self.modes = modes
    }
    
    var body: some View {
        if safeSize != .zero {
            ZStack {
                Rectangle()
                    .fill(Color.init(white: 0.05))
                VStack {
                    Spacer(minLength: 0)
                    ZStack {
                        switch displayType {
                        case .buttons:
                            ButtonPad(size: size, orientation: orientation, width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false)
                                .padding(.bottom, bottomSafeArea)
                                .padding(.top, 2*scale)
                        case .shapes:
                            ButtonPad(size: size, orientation: orientation, width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false, showText: false)
                                .padding(.bottom, bottomSafeArea)
                                .padding(.top, 2*scale)
                        case .smiley:
                            VStack {
                                VStack(spacing: 0) {
                                    Spacer(minLength: 0)
                                    HStack(spacing: 20) {
                                        Circle().fill(.white).frame(width: 5)
                                        Circle().fill(.white).frame(width: 5)
                                    }
                                    Circle().trim(from: 0.1, to: 0.4).stroke(.white, lineWidth: 3).frame(width: 40).padding(.top, -15)
                                    Spacer(minLength: 0)
                                }
                                .scaleEffect(safeSize.width/40/4)
                                .padding(.top, 2*scale)
                                ButtonPad(size: size, orientation: orientation, width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false, showText: false)
                                    .padding(.bottom, bottomSafeArea)
                            }
                        case .theme(let theme):
                            VStack {
                                Spacer(minLength: 0)
                                Text(theme.name)
                                    .font(.system(.caption, design: .rounded).weight(.bold))
                                    .foregroundColor(.white)
                                    .dynamicTypeSize(..<DynamicTypeSize.xLarge)
                                    .lineLimit(0)
                                    .minimumScaleFactor(0.5)
                                    .padding(.top, 2*scale)
                                ThemeCircles(theme: theme)
                                    .scaleEffect(0.7)
                                Spacer(minLength: 0)
                                Spacer(minLength: 0)
                                ButtonPad(size: size, orientation: orientation, width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false, showText: false)
                                    .padding(.bottom, bottomSafeArea)
                            }
                        case .buttonsText(let text):
                            VStack {
                                TextDisplay(strings: text.strings, modes: modes, size: safeSize.height*0.09, scrollable: true, theme: theme)
                                    .padding(.top, 2*scale)
                                ButtonPad(size: size, orientation: orientation, width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false, showText: false)
                                    .padding(.bottom, bottomSafeArea)
                            }
                        case .buttonsAnimatedText(let textSequence, _):
                            VStack {
                                let index = animatedIndex < textSequence.count ? animatedIndex : textSequence.count-1
                                TextDisplay(strings: textSequence[index].strings, modes: modes, size: safeSize.height*0.09, scrollable: true, theme: theme)
                                    .padding(.top, 2*scale)
                                ButtonPad(size: size, orientation: orientation, width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false, showText: false)
                                    .padding(.bottom, bottomSafeArea)
                            }
                        case .variableButtonsText(let text):
                            VStack {
                                TextDisplay(strings: text.strings, modes: modes, size: safeSize.height*0.09, scrollable: true, theme: theme)
                                    .padding(.top, 2*scale)
                                ButtonPad(size: size, orientation: orientation, display: .vars, width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false, showText: false)
                                    .padding(.bottom, bottomSafeArea)
                            }
                        case .graph(let elements):
                            if (maxWidth ?? 0) > 0, (maxHeight ?? 0) > 0 {
                                GraphView(elements, gridLines: false, interactive: false, precision: 200)
                            }
                        case .table(let function):
                            TableView(equation: function, horizontalAxis: Letter("x"), verticalAxis: Letter("y"), lowerBound: -10, upperBound: 10, lightBackground: true, fontSize: safeSize.height*0.04, color: theme.color1)
                        case .popUp(let text):
                            ZStack {
                                VStack {
                                    Spacer()
                                    ButtonPad(size: size, orientation: orientation, width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false, showText: false)
                                        .padding(.bottom, bottomSafeArea)
                                        .padding(.top, 2*scale)
                                }
                                VStack {
                                    Text(text)
                                        .font(.system(.caption, design: .rounded).weight(.semibold))
                                        .lineLimit(0).minimumScaleFactor(0.5)
                                        .padding([.top, .horizontal])
                                    VStack(spacing: 2.5) {
                                        ForEach(0...4, id: \.self) { _ in
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(Color.init(white: 0.3))
                                                .frame(width: min(200, safeSize.width*0.7)*0.75, height: min(300, safeSize.height*0.6)*0.075)
                                        }
                                    }
                                    Spacer()
                                }
                                .frame(width: min(200, safeSize.width*0.7), height: min(300, safeSize.height*0.6))
                                .background(Color.init(white: 0.25).cornerRadius(10))
                            }
                        case .pastCalculations(let inputs, let outputs):
                            VStack {
                                ButtonPad(size: size, orientation: orientation, width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false, showText: false)
                                    .padding(.bottom, bottomSafeArea)
                                    .padding(.top, 10)
                                    .overlay(
                                        VStack(spacing: 2.5) {
                                            Text("Folder")
                                                .font(.system(size: safeSize.height*0.04).weight(.bold))
                                                .foregroundColor(.white)
                                                .frame(width: safeSize.width-10, height: safeSize.height*0.08)
                                                .background(Color.init(white: 0.25).cornerRadius(10))
                                                .padding(.top, 4).padding(.bottom, 2)
                                            ForEach(outputs.indices, id: \.self) { i in
                                                RoundedRectangle(cornerRadius: safeSize.height*0.025)
                                                    .fill(Color.init(white: 0.2))
                                                    .frame(width: safeSize.width-10, height: safeSize.height*0.12)
                                                    .overlay {
                                                        HStack(spacing: 0) {
                                                            ZStack {
                                                                RoundedRectangle(cornerRadius: safeSize.height*0.015)
                                                                    .fill(color(theme.color1, edit: true))
                                                                    .frame(width: safeSize.height*0.07, height: safeSize.height*0.07)
                                                                Image(systemName: outputs[i].allVariables.isEmpty ? "number" : "x.squareroot")
                                                                    .foregroundColor(.white)
                                                                    .font(.system(size: safeSize.height*0.03, weight: .black))
                                                            }
                                                            VStack(spacing: 0) {
                                                                if i < inputs.count {
                                                                    TextDisplay(strings: inputs[i].strings, size: safeSize.height*0.03, opacity: 0.8, equals: true, scrollable: true)
                                                                }
                                                                TextDisplay(strings: outputs[i].strings, size: safeSize.height*0.045, scrollable: true)
                                                            }
                                                            Image(systemName: "plus.circle")
                                                                .font(.system(size: safeSize.height*0.03))
                                                                .padding(.leading, -safeSize.height*0.02)
                                                        }
                                                        .padding(.horizontal, safeSize.height*0.015)
                                                    }
                                            }
                                            Spacer()
                                        }
                                        .frame(width: safeSize.width-4)
                                        .background(Color.init(white: 0.15).cornerRadius(10))
                                        .padding(.horizontal, 2)
                                        .background(Color.init(white: 0.075))
                                    )
                            }
                        case .extraResults(let result, let function, let angle, let extraResults):
                            VStack {
                                VStack(spacing: 2) {
                                    TextDisplay(strings: Queue([function,Expression(angle, grouping: .hidden)]).strings, modes: .init(), size: safeSize.height*0.06, opacity: 0.8, equals: true, scrollable: true, theme: theme)
                                        .padding(.top, 2*scale)
                                    TextDisplay(strings: result.strings, size: safeSize.height*0.09, scrollable: true, theme: theme)
                                }
                                ButtonPad(size: size, orientation: orientation, overlay: AnyView(
                                    VStack(spacing: 4) {
                                        UnitCircleView(function: function, angle: angle, unit: .deg, color1: theme.color1, color2: theme.color2, gridLines: false, interactive: false, popUpGraph: true)
                                            .disabled(true)
                                            .frame(width: safeSize.width-4)
                                            .background(Color.init(white: 0.15).cornerRadius(10))
                                        VStack(spacing: 2.5) {
                                            ForEach(extraResults, id: \.id) { result in
                                                TextDisplay(strings: ["="]+result.strings, size: safeSize.height*0.075, scrollable: true)
                                                    .frame(width: safeSize.width-10, height: safeSize.height*0.15)
                                            }
                                            Spacer(minLength: 0)
                                        }
                                        .frame(width: safeSize.width-4)
                                        .padding(.vertical, 5)
                                        .background(Color.init(white: 0.15).cornerRadius(10))
                                        .padding(.bottom, 2.5)
                                    }
                                    .padding(.horizontal, 2)
                                    .background(Color.init(white: 0.075))
                                ), width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false, showText: false)
                                    .padding(.bottom, bottomSafeArea)
                            }
                        case .variablePlug(let expression, let variables, let values, let result):
                            VStack {
                                VStack {
                                    VStack(spacing: 2) {
                                        TextDisplay(strings: expression.strings, size: safeSize.height*0.09, scrollable: true, theme: theme)
                                            .padding(.top, 2*scale)
                                    }
                                    ButtonPad(size: size, orientation: orientation, overlay: AnyView(
                                        VStack(spacing: safeSize.height*0.02) {
                                            ForEach(variables.indices, id: \.self) { i in
                                                HStack(spacing: 2) {
                                                    TextDisplay(strings: [variables[i].name], size: safeSize.height*0.05, color: color(theme.color1, edit: true))
                                                        .frame(width: safeSize.width*0.12, height: safeSize.height*0.06)
                                                    TextDisplay(strings: values[i].strings, size: safeSize.height*0.045, scrollable: true)
                                                        .frame(height: safeSize.height*0.06)
                                                        .background(Color.init(white: 0.2).cornerRadius(10))
                                                }
                                                .frame(width: safeSize.width-10)
                                            }
                                            TextDisplay(strings: ["="]+result.strings, size: safeSize.height*0.05, scrollable: true, theme: theme)
                                            Spacer(minLength: 0)
                                        }
                                        .frame(width: safeSize.width-10)
                                        .padding(.vertical, 7.5)
                                        .padding(.horizontal, 3)
                                        .background(Color.init(white: 0.15).cornerRadius(10))
                                        .padding(.bottom, 2.5)
                                        .padding(.horizontal, 2)
                                        .background(Color.init(white: 0.075))
                                    ), width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false, showText: false)
                                        .padding(.bottom, bottomSafeArea)
                                }
                            }
                        }
                    }
                    .id(theme.id)
                }
                .padding(.top, ignoreSafeArea ? 0 : topSafeArea)
                .padding(.leading, ignoreSafeArea ? 0 : leftSafeArea)
                .padding(.trailing, ignoreSafeArea ? 0 : rightSafeArea)
            }
            .frame(width: modelSize.width, height: modelSize.height)
            .background(Color.init(white: 0.075).edgesIgnoringSafeArea(.all))
            .cornerRadius(scale*50)
            .overlay(
                RoundedRectangle(cornerRadius: scale*50)
                    .stroke(.black, lineWidth: border)
                    .frame(width: modelSize.width+border/2, height: modelSize.height+border/2)
            )
            .padding(.horizontal, modelSize.width*sideInsets)
            .onAppear {
                timer?.invalidate()
                if case .buttonsAnimatedText(let textSequence, let delay) = displayType {
                    animatedIndex = 0
                    timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true) { _ in
                        if animatedIndex == textSequence.count+5 {
                            animatedIndex = 0
                        } else {
                            animatedIndex += 1
                        }
                    }
                }
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }
}

enum ModelDisplayType {
    case shapes
    case buttons
    case smiley
    case theme(_ theme: Theme)
    case buttonsText(text: Queue)
    case variableButtonsText(text: Queue)
    case buttonsAnimatedText(textSequence: [Queue], delay: Double)
    case graph(elements: [GraphElement])
    case table(function: Queue)
    case popUp(text: String)
    case pastCalculations(inputs: [Queue], outputs: [Queue])
    case extraResults(result: Queue, function: Function, angle: Number, extraResults: [Queue])
    case variablePlug(expression: Queue, variables: [Letter], values: [Queue], result: Queue)
}
