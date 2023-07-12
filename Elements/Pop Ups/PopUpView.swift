//
//  PopUpView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 4/30/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct PopUpView: View {
    
    @ObservedObject var settings = Settings.settings
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                ZStack {
                    if let popUp = settings.popUp {
                        
                        Rectangle()
                            .fill(Color.black)
                            .opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    settings.popUp = nil
                                }
                                SoundManager.play(haptic: .light)
                            }
                        
                        popUp
                            .padding(10)
                            .background(Color.init(white: 0.25).cornerRadius(20).shadow(radius: 10))
                            .padding(.horizontal, 20)
                    }
                }
                .animation(.default, value: settings.popUp != nil)
                
                if let warning = settings.warning {
                    
                    Rectangle()
                        .fill(Color.black)
                        .opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                settings.warning = nil
                            }
                            SoundManager.play(haptic: .light)
                        }
                    
                    VStack {
                        
                        VStack(spacing: 10) {
                            Text(LocalizedStringKey(warning.headline))
                                .font(Font.system(.title2, design: .rounded).weight(.bold))
                            Text(warning.message)
                                .font(Font.system(.body, design: .rounded))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: 450)
                        .padding(.bottom, 15)
                        .padding(.top, 2)
                        
                        HStack {
                            
                            Button(action: {
                                withAnimation {
                                    settings.warning = nil
                                    warning.cancelAction()
                                }
                                SoundManager.play(sound: .click2, haptic: .light)
                            }) {
                                Text(LocalizedStringKey(warning.cancelString))
                                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                    .padding(.vertical, 20)
                                    .frame(width: 125)
                                    .background(Color.init(white: 0.5))
                                    .cornerRadius(20)
                            }
                            
                            Button(action: {
                                withAnimation {
                                    settings.warning = nil
                                    warning.continueAction()
                                }
                                SoundManager.play(sound: .click3, haptic: .light)
                            }) {
                                Text(LocalizedStringKey(warning.continueString))
                                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                    .padding(.vertical, 20)
                                    .frame(width: 125)
                                    .background(color(settings.theme.color1))
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color.init(white: 0.25).cornerRadius(20).shadow(radius: 10))
                    .padding(.horizontal, 20)
                }
                
                VStack {
                    Spacer()
                    VStack {
                        if settings.notification == .none {}
                        else if settings.notification == .copy {
                            Notification(text: "Copied to Clipboard", image: "doc.on.clipboard.fill", notification: $settings.notification)
                        }
                        else if settings.notification == .save {
                            Notification(text: "Saved to Folder", image: "folder", notification: $settings.notification)
                        }
                        else if settings.notification == .unsave {
                            Notification(text: "Unsaved", image: "folder.badge.minus", notification: $settings.notification)
                        }
                        else if settings.notification == .assign {
                            Notification(text: "Assigned to Variable", image: "character.textbox", notification: $settings.notification)
                        }
                        else if settings.notification == .export {
                            Notification(text: "Exported File", image: "square.and.arrow.up", notification: $settings.notification)
                        }
                        else if settings.notification == .delete {
                            Notification(text: "Deleted", image: "trash", notification: $settings.notification)
                        }
                        else if settings.notification == .theme {
                            Notification(text: "Set Theme", image: "paintpalette", notification: $settings.notification)
                        }
                        else if settings.notification == .favorite {
                            Notification(text: "Added to Favorites", image: "star.fill", notification: $settings.notification)
                        }
                        else if settings.notification == .unfavorite {
                            Notification(text: "Removed from Favorites", image: "star.slash", notification: $settings.notification)
                        }
                    }
                    .animation(.default, value: settings.notification)
                    .padding(50)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .transition(.move(edge: .bottom))
            .animation(.default, value: settings.warning?.id)
        }
    }
}
