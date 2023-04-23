//
//  TextDisplay.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/25/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

// A display of scrollable text
struct TextDisplay: View {
    
    @ObservedObject var settings = Settings.settings
    
    @State var textElements: [TextElement] = []
    
    var data: RawTextData
    
    @ObservedObject var calculation: Calculation
    
    var size: CGFloat
    var height: CGFloat
    var color: Color?
    var opacity: CGFloat?
    
    var equals: Bool
    var scrollable: Bool
    var animations: Bool
    var interaction: InteractionType
    
    var count: Int {
        return data.strings.count
    }
    var totalWidth: CGFloat {
        return textElements.last?.endPosition ?? 0
    }
    var totalHeight: CGFloat {
        guard !textElements.isEmpty else { return size }
        let top = textElements.max(by: { $0.topPosition < $1.topPosition })?.topPosition ?? 0
        let bottom = textElements.min(by: { $0.bottomPosition < $1.bottomPosition })?.bottomPosition ?? 0
        return top-bottom
    }
    var pointerPosition: CGFloat {
        return textElements.first(where: { $0.text == "#|" || $0.text == "■" })?.centerPosition ?? 0
    }
    
    @State private var position: CGFloat = 0
    @State private var scroll: CGFloat = 0
    
    init(strings: [String], map: [[Int]] = [], modes: ModeSettings? = nil, calculation: Calculation = Calculation.current, size: CGFloat = 50, height: CGFloat? = nil, color: Color? = nil, opacity: CGFloat? = nil, equals: Bool = false, scrollable: Bool = false, animations: Bool = false, interaction: InteractionType = .none) {
        self.data = RawTextData(strings: strings, map: map, modes: modes)
        self.calculation = calculation
        self.size = size
        self.color = color
        self.opacity = opacity
        self.height = height ?? size*1.2
        self.equals = equals
        self.scrollable = scrollable
        self.animations = animations
        self.interaction = interaction
    }
    
    var body: some View {
        
        if scrollable {
        
            GeometryReader { geometry in
                
                ScrollView {
                    
                    HStack(spacing: 0) {
                        
                        Rectangle()
                            .fill(Color.purple)
                            .frame(minWidth: geometry.leadingPadding, maxWidth: .infinity)
                            .frame(height: height)
                            .opacity(settings.guidelines ? 0.7 : 1e-50)
                            .id(0)
                            .onTapGesture {
                                if interaction == .edit {
                                    // Jump to the beginning of the queue
                                    Calculation.current.setUpInput()
                                    Calculation.current.queue.continueResult()
                                    Calculation.current.queue.jump(to: [0])
                                    SoundManager.play(sound: .click3, haptic: .medium)
                                }
                            }
                        
                        TextSequence(textElements: textElements, color: color, opacity: opacity, calculation: calculation, animations: animations, interaction: interaction)
                            .frame(width: totalWidth, height: totalHeight)
                        
                        Rectangle()
                            .fill(Color.purple)
                            .frame(width: geometry.trailingPadding, height: height)
                            .opacity(settings.guidelines ? 0.7 : 1e-50)
                            .id(count+1)
                            .onTapGesture {
                                if interaction == .edit {
                                    // Jump to the end of the queue
                                    Calculation.current.setUpInput()
                                    Calculation.current.queue.continueResult()
                                    Calculation.current.queue.jump(to: data.map.last ?? [0], position: 1.0)
                                    SoundManager.play(sound: .click3, haptic: .medium)
                                }
                            }
                    }
                }
                .edgesIgnoringSafeArea(.horizontal)
                .offset(x: -(position+scroll))
                .border(Color.white, width: settings.guidelines ? 1 : 0)
                .onAppear {
                    let originalWidth = totalWidth
                    setElements(data.strings, map: data.map, modes: data.modes, maxWidth: geometry.unpaddedWidth, maxHeight: geometry.size.height)
                    
                    if totalWidth > geometry.unpaddedWidth {
                        position += totalWidth-originalWidth
                        if pointerPosition > position + geometry.unpaddedWidth*0.8 {
                            position = pointerPosition - geometry.unpaddedWidth*0.8
                        }
                        if pointerPosition < position + geometry.unpaddedWidth*0.5 {
                            position = pointerPosition - geometry.unpaddedWidth*0.5
                        }
                        if position > totalWidth - geometry.halfUnpaddedWidth {
                            position = totalWidth - geometry.halfUnpaddedWidth
                        }
                        if position < 0 {
                            position = 0
                        }
                        if pointerPosition == 0 {
                            position = totalWidth - geometry.halfUnpaddedWidth
                        }
                    } else {
                        position = 0
                    }
                }
                .onChange(of: self.data) { data in
                    let originalWidth = totalWidth
                    setElements(data.strings, map: data.map, modes: data.modes, maxWidth: geometry.unpaddedWidth, maxHeight: geometry.size.height)
                    
                    if totalWidth > geometry.unpaddedWidth {
                        position += totalWidth-originalWidth
                        if pointerPosition > position + geometry.unpaddedWidth*0.8 {
                            position = pointerPosition - geometry.unpaddedWidth*0.8
                        }
                        if pointerPosition < position + geometry.unpaddedWidth*0.5 {
                            position = pointerPosition - geometry.unpaddedWidth*0.5
                        }
                        if position > totalWidth - geometry.halfUnpaddedWidth {
                            position = totalWidth - geometry.halfUnpaddedWidth
                        }
                        if position < 0 {
                            position = 0
                        }
                    } else {
                        position = 0
                    }
                }
                .simultaneousGesture(DragGesture(minimumDistance: 30)
                .onChanged { value in
                    if totalWidth > geometry.size.width {
                        scroll = -value.translation.width*1.5
                        if position + scroll < 0 {
                            scroll = -position
                        }
                        if position + scroll > totalWidth - geometry.halfUnpaddedWidth {
                            scroll = totalWidth - geometry.halfUnpaddedWidth - position
                        }
                    }
                }
                .onEnded { _ in
                    self.position += self.scroll
                    self.scroll = 0
                })
            }
            .id(calculation.update)
            .frame(height: totalHeight > height ? totalHeight : height, alignment: .trailing)
            .animation(animations && settings.textAnimations ? .easeInOut : nil)
            .environment(\.layoutDirection, .leftToRight)
        }
        else {
            
            GeometryReader { geometry in
            
                TextSequence(textElements: textElements, color: color, opacity: opacity, calculation: calculation, interaction: interaction)
                    .border(Color.white, width: settings.guidelines ? 1 : 0)
                    .onAppear {
                        setElements(data.strings, map: data.map, modes: data.modes, maxWidth: geometry.size.width, maxHeight: totalHeight)
                    }
                    .onChange(of: self.data) { data in
                        setElements(data.strings, map: data.map, modes: data.modes, maxWidth: geometry.size.width, maxHeight: totalHeight)
                    }
            }
            .id(calculation.update)
            .frame(maxWidth: textElements.last?.endPosition)
            .environment(\.layoutDirection, .leftToRight)
        }
    }
    
    // Set the elements
    func setElements(_ strings: [String], map: [[Int]], modes: ModeSettings?, maxWidth: CGFloat, maxHeight: CGFloat) {
        
//        var elements: [TextElement] {
//            // Attempt to use locally stored elements for these strings
//            if let stored = TextElement.locallyStoredTextElements.first(where: { $0.key == strings })?.value {
//                stored.elements.forEach { $0.shrink(size/stored.size) }
//                return stored.elements
//            }
//            // Create new elements
//            else {
//                let elements = TextElement.setElements(strings, map: map, size: size)
//                TextElement.locallyStoredTextElements[strings] = (elements, size)
//                return elements
//            }
//        }
        
        // Set the elements
        var textStrings: [String] {
            return strings + (equals ? ["="] : [])
        }
        self.textElements = TextElement.setElements(textStrings, map: map, modes: modes ?? Settings.settings.modes, size: size)
        
        // Set the width
        
        let width = textElements.last?.endPosition ?? 0
        
        let top = textElements.max(by: { $0.topPosition < $1.topPosition })?.topPosition ?? 0
        let bottom = textElements.min(by: { $0.bottomPosition < $1.bottomPosition })?.bottomPosition ?? 0
        
        let height = abs(top-bottom)
        let offset = -(top+bottom)/2
        
        // Center the elements
        if offset != 0 {
            self.textElements.forEach { $0.midline += offset }
        }
        
        // Shrink the elements
        var shrinkFactor: CGFloat = 1
        
        if width > maxWidth {
            let factor = maxWidth/width
            if factor < shrinkFactor {
                shrinkFactor = factor
            }
        }
        if height > maxHeight {
            let factor = maxHeight/height
            if factor < shrinkFactor {
                shrinkFactor = factor
            }
        }
        
        if shrinkFactor < 1-settings.shrink {
            shrinkFactor = 1-settings.shrink
        }
        if shrinkFactor < 1 {
            self.textElements.forEach { $0.shrink(shrinkFactor) }
        }
    }
}

struct RawTextData: Equatable {
    
    var strings: [String]
    var map: [[Int]]
    var modes: ModeSettings?
    
    static func == (a: RawTextData, b: RawTextData) -> Bool {
        return a.strings == b.strings && a.map == b.map && a.modes == b.modes
    }
}

extension GeometryProxy {
    
    var leadingPadding: CGFloat {
        return self.safeAreaInsets.leading < 10 ? 10 : self.safeAreaInsets.leading
    }
    var trailingPadding: CGFloat {
        return self.safeAreaInsets.trailing < 10 ? 10 : self.safeAreaInsets.trailing
    }
    var totalPadding: CGFloat {
        return self.leadingPadding + self.trailingPadding
    }
    var unpaddedWidth: CGFloat {
        return self.safeAreaInsets.trailing < 10 ? self.size.width - self.totalPadding : self.size.width
    }
    var halfUnpaddedWidth: CGFloat {
        return self.safeAreaInsets.trailing < 10 ? self.size.width - self.totalPadding : self.size.width - self.totalPadding/2
    }
}
