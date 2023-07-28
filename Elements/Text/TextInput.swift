//
//  TextInput.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/14/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct TextInput: View {
    
    @ObservedObject var settings = Settings.settings
    
    @State private var queue: Queue
    @State private var strings: [String]
    
    var placeholder: [String]
    var defaultValue: Queue
    
    var size: CGFloat
    var scrollable: Bool
    
    var onChange: (Queue) -> Void
    var onDismiss: (Queue) -> Void
    
    @State private var editing: Bool = false
    
    init(queue: Queue? = nil, placeholder: [String] = [], defaultValue: Queue = Queue(), size: CGFloat, scrollable: Bool = false, onChange: @escaping (Queue) -> Void = { _ in }, onDismiss: @escaping (Queue) -> Void = { _ in }) {
        self.queue = queue ?? Queue()
        self.strings = queue?.strings ?? []
        self.placeholder = placeholder
        self.defaultValue = defaultValue
        self.size = size
        self.scrollable = scrollable
        self.onChange = onChange
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        
        TextDisplay(strings: editing ? strings.isEmpty ? ["#|"] : strings : queue.empty ? placeholder : queue.final.strings,
                    size: size,
                    colorContext: queue.empty ? .secondary : .primary,
                    scrollable: scrollable,
                    animations: false,
                    interaction: .none
        )
        .transaction { $0.animation = nil }
        .overlay(
            Button(action: edit) {
                Rectangle()
                    .fill(Color.init(white: 0.1))
                    .opacity(0.00001)
            }
        )
        .onChange(of: settings.keypadUpdate) { _ in
            if editing, let queue = settings.keypadInput {
                self.queue = queue
                self.strings = queue.strings
                self.onChange(queue.combined())
            } else {
                self.editing = false
                self.onDismiss(queue.combined())
            }
        }
    }
    
    func edit() {
        self.editing = true
        self.queue = Queue()
        withAnimation {
            self.settings.keypadInput = queue
        }
        SoundManager.play(haptic: .heavy)
    }
}
