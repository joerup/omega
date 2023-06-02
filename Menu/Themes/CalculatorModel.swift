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
        return orientation == .portrait ? (size == .large ? 1/11.5 : 1/9.5) : 1/8.5
    }
    var standardSize: CGFloat {
        return size == .large ? 60 : 40
    }
    var horizontalPadding: CGFloat {
        return orientation == .landscape ? 5 : 10
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
    
    var border: CGFloat {
        return scale * 20
    }
    
    var theme: Theme = Settings.settings.theme
    
    init(orientation: Orientation? = nil, size: Size? = nil, maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil, theme: Theme? = nil) {
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
                Spacer()
                ButtonPad(size: size, orientation: orientation, width: safeSize.width, buttonHeight: safeSize.height*buttonHeight, theme: theme, active: false)
                    .padding(.bottom, bottomSafeArea)
                    .padding(.top, 2*scale)
                    .background(Color.init(white: 0.1).cornerRadius(scale * 20).edgesIgnoringSafeArea(.bottom))
            }
            .padding(.top, topSafeArea)
            .padding(.leading, leftSafeArea)
            .padding(.trailing, rightSafeArea)
        }
        .frame(width: modelSize.width, height: modelSize.height)
        .overlay(
            RoundedRectangle(cornerRadius: scale*50)
                .stroke(.black, lineWidth: border)
                .frame(width: modelSize.width+border, height: modelSize.height+border)
        )
        .animation(nil)
    }
}
