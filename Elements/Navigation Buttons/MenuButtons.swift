//
//  MenuButtonViews.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/6/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct MenuX: View {
    
    @ObservedObject var settings = Settings.settings
    
    var sheet: Bool = false
    
    var presentBool: Binding<Bool>? = nil
    var presentationMode: Binding<PresentationMode>? = nil
    
    var body: some View {
        VStack {
            Button(action: {
                if !sheet {
                    withAnimation {
                        self.settings.showMenu = false
                    }
                }
                else {
                    if presentBool != nil {
                        presentBool!.wrappedValue.toggle()
                    } else if presentationMode != nil {
                        presentationMode!.wrappedValue.dismiss()
                    }
                }
            }) {
                ZStack {
                    Rectangle()
                        .fill(Color.init(white: sheet ? 0.3 : 0.15))
                        .aspectRatio(1.0, contentMode: .fit)
                        .cornerRadius(100)
                    Image(systemName: "xmark")
                        .foregroundColor(Color.init(white: sheet ? 0.7 : 0.6))
                        .padding(10)
                }
            }
        }
        .border(Color.orange, width: self.settings.guidelines ? 1 : 0)
    }
}

struct MenuXOverlay: View {
    
    var presentBool: Binding<Bool>? = nil
    var presentationMode: Binding<PresentationMode>? = nil
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                if presentBool != nil {
                    MenuX(sheet: true, presentBool: self.presentBool)
                        .frame(width: 10)
                        .padding(.top, 5)
                        .padding(.trailing, 20)
                } else if presentationMode != nil {
                    MenuX(sheet: true, presentationMode: self.presentationMode)
                        .frame(width: 10)
                        .padding(.top, 5)
                        .padding(.trailing, 20)
                }
            }
            Spacer()
        }
    }
}

struct XButton: View {
    
    var action: () -> Void
    
    var body: some View {
        SmallIconButton(symbol: "xmark", color: Color.init(white: 0.25), smallerSmall: true, action: action)
    }
}

struct XButtonOverlay: View {
    
    var action: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                XButton(action: action)
                    .padding(7.5)
            }
            Spacer()
        }
    }
}

