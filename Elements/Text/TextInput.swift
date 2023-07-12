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
                    opacity: queue.empty ? 0.3 : 1,
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
    }
    
    func edit() {
        self.editing = true
        var oldQueue = queue
        self.queue = Queue()
        SoundManager.play(haptic: .heavy)
        withAnimation {
            settings.keypad = Keypad(queue: queue, type: .numbers, onChange: { queue in
                self.queue = queue
                self.strings = queue.strings
                oldQueue = queue
                onChange(queue.combined())
            }, onDismiss: { queue in
                self.editing = false
                queue.combineQueues(all: true)
                if queue.empty { self.queue = oldQueue; self.strings = oldQueue.strings }
                onDismiss(queue.combined())
            })
        }
    }
}
