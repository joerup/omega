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
    
    var setOrientation: Orientation?
    var setSize: Size?
    
    var orientation: Orientation {
        return setOrientation ?? (deviceSize.width > deviceSize.height ? .landscape : .portrait)
    }
    var size: Size {
        return setSize ?? (verticalSizeClass == .compact || horizontalSizeClass == .compact ? .small : .large)
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
        return (!flippedOrientation ? UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 : UIApplication.shared.windows.first?.safeAreaInsets.left ?? 0) * scale
    }
    var bottomSafeArea: CGFloat {
        return (!flippedOrientation ? UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0 : UIApplication.shared.windows.first?.safeAreaInsets.right ?? 0) * scale
    }
    var leftSafeArea: CGFloat {
        return (!flippedOrientation ? UIApplication.shared.windows.first?.safeAreaInsets.left ?? 0 : UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) * scale
    }
    var rightSafeArea: CGFloat {
        return (!flippedOrientation ? UIApplication.shared.windows.first?.safeAreaInsets.right ?? 0 : UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) * scale
    }
    var safeSize: CGSize {
        return CGSize(width: modelSize.width - leftSafeArea - rightSafeArea, height: modelSize.height - topSafeArea - bottomSafeArea)
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
    
    init(_ displayType: ModelDisplayType = .buttons, orientation: Orientation? = nil, size: Size? = nil, maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil, theme: Theme? = nil) {
        self.displayType = displayType
        self.setOrientation = orientation
        self.setSize = size
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.theme = theme ?? Settings.settings.theme
    }
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.init(white: 0.05))
            VStack {
                Spacer(minLength: 0)
                ZStack {
                    switch displayType {
                    case .buttons:
                        ButtonPad(size: size, orientation: orientation, width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false, showText: true)
                            .padding(.bottom, bottomSafeArea)
                            .padding(.top, 2*scale)
                    case .shapes:
                        ButtonPad(size: size, orientation: orientation, width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false, showText: false)
                            .padding(.bottom, bottomSafeArea)
                            .padding(.top, 2*scale)
                    case .buttonsText(let text):
                        VStack {
                            TextDisplay(strings: text.strings, size: 40)
                            ButtonPad(size: size, orientation: orientation, width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false, showText: false)
                                .padding(.bottom, bottomSafeArea)
                                .padding(.top, 2*scale)
                        }
                    case .graph(let elements):
                        if (maxWidth ?? 0) > 0, (maxHeight ?? 0) > 0 {
                            GraphView(elements, gridLines: false, interactive: false, precision: 60)
                        }
                    case .table(let function):
                        TableView(equation: function, horizontalAxis: Letter("x"), verticalAxis: Letter("y"), fullTable: true)
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
    }
    
    enum ModelDisplayType {
        case shapes
        case buttons
        case buttonsText(text: Queue)
        case graph(elements: [GraphElement])
        case table(function: Queue)
    }
}
