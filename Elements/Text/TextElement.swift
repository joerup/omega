//
//  TextElement.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/17/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

// A single text element
class TextElement: Equatable {
    
    var id = UUID()
    
    var text: String
    var display: String
    
    var position: CGFloat = 0
    var midline: CGFloat = 0
    
    var size: CGFloat = 20
    
    var leftPad: CGFloat = 0
    var rightPad: CGFloat = 0
    
    var aspectRatio: CGFloat = 1
    var verticalOffset: CGFloat = 0
    var horizontalOffset: CGFloat = 0
    
    var color: TextColor = .general
    
    var queueIndex: [Int] = []
    
    init(_ text: String) {
        self.text = text
        self.display = text
    }
    
    init(_ text: String, copy: TextElement) {
        self.text = text
        self.display = text
        self.size = copy.size
        self.midline = copy.midline
        self.leftPad = copy.leftPad
        self.rightPad = copy.rightPad
        self.aspectRatio = copy.aspectRatio
        self.verticalOffset = copy.verticalOffset
        self.horizontalOffset = copy.horizontalOffset
        self.color = copy.color
        self.queueIndex = copy.queueIndex
    }
    
    var width: CGFloat {
        guard size > 0 else { return 0 }
        let label = UILabel()
        label.text = display
        label.font = UIFont.rounded(size: size, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label.intrinsicContentSize.width
    }
    var height: CGFloat {
        return self.size * self.aspectRatio
    }
    
    // MARK: Positioning
    
    var centerPosition: CGFloat {
        return self.position + self.width/2 + self.leftPad + self.size/10
    }
    var endPosition: CGFloat {
        return self.position + self.width + self.leftPad + self.rightPad + self.size/5
    }
    
    var topPosition: CGFloat {
        return self.midline + self.height/2
    }
    var bottomPosition: CGFloat {
        return self.midline - self.height/2
    }
    
    var centerPoint: CGPoint {
        return CGPoint(x: self.centerPosition, y: self.midline)
    }
    
    // MARK: Modification
    
    func multiply(_ factor: Double) {
        self.size *= factor
        self.midline *= factor
        self.leftPad *= factor
        self.rightPad *= factor
        self.verticalOffset *= factor
    }
    
    func shrink(_ factor: Double) {
        self.position *= factor
        self.multiply(factor)
    }
    
    // MARK: Set Elements
    
    static var locallyStoredTextElements: [[String] : (elements: [TextElement], size: CGFloat)] = [:]
    
    static func setElements(_ strings: [String], map: [[Int]] = [], modes: ModeSettings? = nil, theme: Theme? = nil, size: CGFloat) -> [TextElement] {
        
        let formatting = TextFormatting(elements: strings.enumerated().map { createElement($1, index: ($0 < map.count ? map[$0] : []), size: size) })
        formatting.modeSettings = modes
        formatting.theme = theme
        formatting.formatElements()
        
        var totalWidth: CGFloat = 0
        for element in formatting.elements {
            element.position += totalWidth
            totalWidth = element.endPosition
        }
        
        return formatting.elements
    }
    
    // MARK: Create Element
    
    static func createElement(_ string: String, index: [Int], size: CGFloat) -> TextElement {
        
        let element = TextElement(string)
        element.queueIndex = index
        element.size = size
        
        return element
    }
    
    static func == (lhs: TextElement, rhs: TextElement) -> Bool {
        return lhs.id == rhs.id
    }
}

class Vinculum: TextElement {
    
    var vinculumWidth: CGFloat
    
    override var width: CGFloat {
        return vinculumWidth
    }
    
    init(width: CGFloat, thickness: CGFloat) {
        self.vinculumWidth = width
        super.init("VINCULUM")
        self.size = thickness
    }
    
    override func multiply(_ factor: Double) {
        super.multiply(factor)
        self.vinculumWidth *= factor
    }
}

class Radical: TextElement {
    
    init(size: CGFloat) {
        super.init("RADICAL")
        self.size = size
    }
    
    override var width: CGFloat {
        return size*0.5
    }
}

extension UIFont {
    class func rounded(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        let font: UIFont
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: size)
        } else {
            font = systemFont
        }
        return font
    }
}

enum TextColor {
    case theme
    case prominent
    case general
    case gray1
    case gray2
    case gray3
    case invisible
    
    func inContext(_ context: ColorContext) -> Color {
        switch context {
        case .primary:
            return primaryColor
        case .secondary:
            return secondaryColor
        case .theme:
            return themeColor
        case .none:
            return noColor
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .theme: return themeColor.opacity(0.7)
        case .prominent: return .white
        case .general: return .init(white: 0.8)
        case .gray1: return .init(white: 0.4)
        case .gray2: return .init(white: 0.3)
        case .gray3: return .init(white: 0.2)
        case .invisible: return .clear
        }
    }
    var secondaryColor: Color {
        switch self {
        case .theme: return themeColor.opacity(0.5)
        case .prominent: return .init(white: 0.6)
        case .general: return .init(white: 0.5)
        case .gray1: return .init(white: 0.35)
        case .gray2: return .init(white: 0.25)
        case .gray3: return .init(white: 0.15)
        case .invisible: return .clear
        }
    }
    var themeColor: Color {
        return color(Settings.settings.theme.color1)
    }
    var noColor: Color {
        switch self {
        case .prominent, .general, .gray1: return .white
        case .theme, .gray2, .gray3: return .white.opacity(0.4)
        case .invisible: return .clear
        }
    }
}

enum ColorContext {
    case primary
    case secondary
    case theme
    case none
}
