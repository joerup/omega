//
//  Notification.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 5/25/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

struct Notification: View {
    
    var text: String
    var image: String
    
    @Binding var notification: NotificationType
    
    enum NotificationType {
        case none
        case insert
        case edit
        case copy
        case save
        case unsave
        case assign
        case export
        case delete
        case favorite
        case unfavorite
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Image(systemName: image)
                    .imageScale(.large)
                Text(LocalizedStringKey(text))
                    .font(Font.system(.headline, design: .rounded).weight(.bold))
            }
            .padding()
            .onAppear {
                let originalNotification = notification
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if originalNotification == notification {
                        self.notification = .none
                    }
                }
            }
        }
        .frame(height: 50)
        .padding(10)
        .background(Color.init(white: 0.2))
        .cornerRadius(30)
        .dynamicTypeSize(..<DynamicTypeSize.accessibility1)
        .shadow(radius: 10)
        .onTapGesture {
            self.notification = .none
        }
    }
}
