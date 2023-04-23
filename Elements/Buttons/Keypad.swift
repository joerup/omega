//
//  Keypad.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/4/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct Keypad: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Environment(\.presentationMode) var presentationMode
    
    var queue: Queue
    
    var onChange: (Queue) -> Void
    var onDismiss: (Queue) -> Void
    
    init(queue: Queue, type: KeypadType, onChange: @escaping (Queue) -> Void = { _ in }, onDismiss: @escaping (Queue) -> Void = { _ in }) {
        self.queue = queue
        self.onDismiss = { queue in
            Settings.settings.keypad = nil
            onDismiss(queue)
        }
        self.onChange = onChange
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            if verticalSizeClass == .regular {
                
                ShortPadA(queue: queue, width: geometry.size.width, buttonHeight: geometry.size.height/4, onChange: onChange)
                    .animation(.default)
                
            } else {
                
                ShortPadB(queue: queue, width: geometry.size.width, buttonHeight: geometry.size.height/2, onChange: onChange)
                    .animation(.default)
                
            }
        }
    }
}


enum KeypadType {
    case numbers
    case decimal
    case negative
    case negativeDecimal
    case basicOperations
}


