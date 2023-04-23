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
    var textOffset: CGFloat = 0
    
    var font: String = "PingFangTC-Medium"
    var color: Color = .white
    var opacity: CGFloat = 1
    
    var queueIndex: [Int] = []
    
    init(_ text: String) {
        self.text = text
        self.display = text
        self.font = TextFormatting.getFont()
    }
    
    init(_ text: String, copy: TextElement) {
        self.text = text
        self.display = text
        self.size = copy.size
        self.midline = copy.midline
        self.leftPad = copy.leftPad
        self.rightPad = copy.rightPad
        self.aspectRatio = copy.aspectRatio
        self.textOffset = copy.textOffset
        self.color = copy.color
        self.opacity = copy.opacity
        self.queueIndex = copy.queueIndex
    }
    
    var width: CGFloat {
        let label = UILabel()
        label.text = display
        label.font = UIFont(name: font, size: size)
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
        self.textOffset *= factor
    }
    
    func shrink(_ factor: Double) {
        self.position *= factor
        self.multiply(factor)
    }
    
    // MARK: Set Elements
    
    static var locallyStoredTextElements: [[String] : (elements: [TextElement], size: CGFloat)] = [:]
    
    static func setElements(_ strings: [String], map: [[Int]] = [], modes: ModeSettings? = nil, size: CGFloat) -> [TextElement] {
        
        let formatting = TextFormatting(elements: strings.enumerated().map { createElement($1, index: ($0 < map.count ? map[$0] : []), size: size) })
        formatting.modeSettings = modes
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
