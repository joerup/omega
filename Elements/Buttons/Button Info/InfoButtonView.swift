//
//  InfoButtonView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/26/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct InfoButtonView: View {
    
    var settings = Settings.settings
    
    @Environment(\.presentationMode) var presentationMode
    
    var button: InfoButton
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
            
                VStack(alignment: .leading) {
                    
                    HStack {
                        ButtonView(button: button.button, backgroundColor: color(self.settings.theme.color3), width: 100, height: 100, relativeSize: 0.45, active: false)
                        
                        VStack(alignment: .leading) {
                        
                            Text(LocalizedStringKey(button.fullName))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.white)
                            
                            Text(LocalizedStringKey(button.category))
                                .fontWeight(.bold)
                                .foregroundColor(Color.init(white: 0.6))
                        }
                        .padding(.leading, 5)
                        
                        Spacer()
                        
                        Image(systemName: "plus.circle")
                            .foregroundColor(Color.init(white: 0.8))
                            .padding(.trailing, 7)
                            .onTapGesture {
                                button.insert()
                            }
                    }
                    .padding(.bottom, 5)
                    
                    if button.constValue != nil {
                        
                        Text("Value")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.init(white: 0.6))
                            .padding(.top)
                            .padding(.bottom, -3)
                            .padding(.leading, 5)
                        
                        VStack {
                            Text(button.constValue!)
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                                .lineLimit(0)
                        }
                        .padding()
                        .background(Color.init(white: 0.2))
                        .cornerRadius(20)
                    }
                    
                    if button.description != nil {
                        
                        Text("Definition")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.init(white: 0.6))
                            .padding(.top)
                            .padding(.bottom, -3)
                            .padding(.leading, 5)
                        
                        VStack {
                            Text(button.description!)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.init(white: 0.2))
                        .cornerRadius(20)
                    }
                    
                    if !button.formula.isEmpty {
                        
                        Text("Formula")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.init(white: 0.6))
                            .padding(.top)
                            .padding(.bottom, -3)
                            .padding(.leading, 5)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                HStack(spacing: 0) {
                                    
                                    TextDisplay(strings: button.sample+["="], size: 40, color: .init(white: 0.7))
                                    
                                    TextDisplay(strings: button.formula, size: 45)
                                    
                                }
                                .environment(\.layoutDirection, .leftToRight)
                                .padding(.vertical, 20)
                                Spacer()
                                if button.formula.count < 7 {
                                    VStack(alignment: .trailing) {
                                        ForEach(button.formulaDesc, id: \.self) { desc in
                                            Text(desc)
                                                .foregroundColor(Color.init(white: 0.6))
                                        }
                                    }
                                }
                            }
                            if button.formula.count >= 7 && !button.formulaDesc.isEmpty {
                                VStack(alignment: .leading) {
                                    ForEach(button.formulaDesc, id: \.self) { desc in
                                        Text(desc)
                                            .foregroundColor(Color.init(white: 0.6))
                                    }
                                }
                                .padding(.top, 5)
                            }
                        }
                        .padding()
                        .background(Color.init(white: 0.2))
                        .cornerRadius(20)
                    }
                    
                    if !button.domain.isEmpty || !button.range.isEmpty {
                        
                        HStack {
                            
                            if !button.domain.isEmpty {
                                
                                VStack(alignment: .leading) {
                                    
                                    Text("Domain")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.init(white: 0.6))
                                        .padding(.top)
                                        .padding(.bottom, -3)
                                        .padding(.leading, 5)
                                    
                                    TextDisplay(strings: button.domain, size: 24)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.init(white: 0.2))
                                        .cornerRadius(20)
                                }
                            }
                            
                            if !button.range.isEmpty {
                                
                                VStack(alignment: .leading) {
                                    
                                    Text("Range")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.init(white: 0.6))
                                        .padding(.top)
                                        .padding(.bottom, -3)
                                        .padding(.leading, 5)
                                    
                                    TextDisplay(strings: button.range, size: 24)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.init(white: 0.2))
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                    
                    Text("Syntax")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.init(white: 0.6))
                        .padding(.top)
                        .padding(.bottom, -3)
                        .padding(.leading, 5)
                    
                    VStack(alignment: .leading) {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(button.syntax.indices, id: \.self) { index in
                                    ForEach(button.syntax[index].indices, id: \.self) { index2 in
                                        let syntaxButton = button.syntax[index][index2]
                                        ButtonView(button: InputButton(syntaxButton),
                                                   backgroundColor: syntaxButton == button.name ? color(self.settings.theme.color3) : Color.init(white: 0.4),
                                                   width: 40,
                                                   height: 40,
                                                   relativeSize: 0.45,
                                                   active: false
                                        )
                                        if index2 < button.syntax[index].count-1 {
                                            Text("+")
                                                .font(.caption)
                                                .foregroundColor(Color.init(white: 0.6))
                                                .padding(.horizontal, -2)
                                        }
                                    }
                                    if index < button.syntax.count-1 {
                                        Text("or")
                                            .font(.subheadline)
                                            .foregroundColor(Color.init(white: 0.8))
                                            .padding(5)
                                    }
                                }
                                Spacer()
                            }
                        }
                        .padding(.bottom, 5)
                            
                        TextDisplay(strings: button.example, size: 40, color: .init(white: 0.7))
                            .padding(.vertical, 20)
                    }
                    .padding()
                    .background(Color.init(white: 0.2))
                    .cornerRadius(20)
                    
                    Text("Examples")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.init(white: 0.6))
                        .padding(.top)
                        .padding(.bottom, -3)
                        .padding(.leading, 5)
                    
                    VStack {
                        ForEach(button.exampleQuestions.indices, id: \.self) { index in
                            HStack {
                                HStack(spacing: 0) {
                                    
                                    TextDisplay(strings: button.exampleQuestions[index]+["="], size: 24, color: .init(white: 0.7))
                                    
                                    TextDisplay(strings: button.exampleAnswers[index], size: 24)
                                    
                                    Spacer()
                                }
                                .environment(\.layoutDirection, .leftToRight)
                                .padding(.vertical, 10)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(Color.init(white: 0.2))
                    .cornerRadius(20)
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarTitle("Button")
        .navigationBarTitleDisplayMode(.inline)
    }
}
