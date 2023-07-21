//
//  TextSequence.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/17/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

// A simple sequence of text
struct TextSequence: View {
    
    @ObservedObject var settings = Settings.settings
    
    var textElements: [TextElement]
    
    var colorContext: ColorContext = .primary
    
    var calculation: Calculation = Calculation.current
    
    var animations: Bool = false
    var interaction: InteractionType = .none
    
    @Namespace private var namespace
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                ForEach(textElements.indices, id: \.self) { e in
                    
                    let element = textElements[e]
                        
                    HStack(alignment: .center, spacing: 0) {
                        
                        Rectangle()
                            .frame(width: element.size/10)
                            .foregroundColor(Color.blue)
                            .opacity(settings.guidelines ? 0.1 : 0)
                            .onTapGesture {
                                interact(element: element, position: 0)
                            }
                        
                        if element is Vinculum {
                            
                            RoundedRectangle(cornerRadius: 0.5*element.size)
                                .fill(element.color.inContext(colorContext))
                                .frame(width: element.width, height: element.size)
                            
                        } else if element is Radical {
                                
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: element.size * element.aspectRatio * 0.55))
                                path.addLine(to: CGPoint(x: element.width*0.375, y: element.size * (element.aspectRatio - 0.12)))
                                path.addLine(to: CGPoint(x: element.width*0.75, y: element.size * 0.05))
                            }
                            .stroke(element.color.inContext(colorContext),
                                    style: StrokeStyle(lineWidth: element.size*0.1, lineCap: .round, lineJoin: .round))
                            .frame(width: element.width, height: element.size * element.aspectRatio)
                            
                        } else if interaction != .none {
                            
                            TextLabel(element: element, colorContext: colorContext, interaction: interaction)
                                .frame(width: element.width, height: element.height)
                                .offset(x: element.horizontalOffset, y: -element.verticalOffset)
                                .scaleEffect(x: 1, y: element.aspectRatio)
                                .border(Color.green, width: settings.guidelines ? 1 : 0)
                                .background(Color.blue.opacity(settings.guidelines ? 0.3 : 0))
                                .gesture(DragGesture(minimumDistance: 0).onEnded { value in
                                    if value.translation.width < 1 && value.translation.height < 1 {
                                        interact(element: element, position: value.location.x/element.width)
                                    }
                                })
                                .simultaneousGesture(LongPressGesture().onEnded { value in
                                    interact(element: element, position: 0, hold: true)
                                })
                            
                        } else {
                            
                            TextLabel(element: element, colorContext: colorContext)
                                .frame(width: element.width, height: element.height)
                                .offset(x: element.horizontalOffset, y: -element.verticalOffset)
                                .scaleEffect(x: 1, y: element.aspectRatio)
                                .border(Color.green, width: settings.guidelines ? 1 : 0)
                        }
                        
                        Rectangle()
                            .frame(width: element.size/10)
                            .foregroundColor(Color.pink)
                            .opacity(settings.guidelines ? 0.1 : 0)
                            .onTapGesture {
                                interact(element: element, position: 1)
                            }
                    }
                    .position(x: element.centerPosition, y: geometry.size.height/2 - element.midline)
                    .if(settings.textAnimations && animations) { view in
                        view.animation(.easeIn(duration: 0.2), value: element)
                    }
                    
                    Rectangle()
                        .fill(Color.red)
                        .opacity(settings.guidelines ? 1 : 0)
                        .frame(width: element.width, height: 1)
                        .position(x: element.centerPosition, y: geometry.size.height/2 - element.midline)
                    
                    Rectangle()
                        .fill(settings.theme.primaryColor)
                        .opacity(calculation.queue.highlighted(element.queueIndex) ? 0.3 : 0)
                        .frame(width: element.width)
                        .position(x: element.centerPosition, y: geometry.size.height/2 - element.midline)
                }
            }
        }
        .frame(width: textElements.last?.endPosition ?? 0)
        .frame(maxHeight: .infinity)
    }
    
    func interact(element: TextElement, position: Double, hold: Bool = false) {
        
        // Make sure the text is interactive
        guard interaction != .none, !((element.text == "#|" || element.text == "■") && hold) else { return }
        
        // Jump to the item that was pressed
        if interaction == .edit, !element.queueIndex.isEmpty {
            
            // Set up input
            Calculation.current.setUpInput()
            
            // Continue result
            Calculation.current.queue.continueResult()
            
            // Jump to the item
            Calculation.current.queue.jump(to: element.queueIndex, position: position)
            
            // Play a sound
            SoundManager.play(sound: .click3, haptic: .medium)
        }
        
        // Go back to the input
        else if interaction == .back {
            
            // Go back
            Calculation.current.backspace()
            
            // Play a sound
            SoundManager.play(sound: .click2, haptic: .medium)
        }
        
        // Update
        Calculation.current.update.toggle()
    }
}
