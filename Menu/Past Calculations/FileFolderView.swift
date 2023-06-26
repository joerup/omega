//
//  FileFolderView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/27/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct FileFolderView: View {
    
    @ObservedObject var settings = Settings.settings
    
    var folders: [String?] = []
    var unsave: Bool
    
    var saveAction: (String) -> Void
    var unsaveAction: () -> Void = {}
    
    @State private var selectedFolder: String? = nil
    @State private var selectedUnsave: Bool = false
    
    @State private var newFolderText: String = ""
    
    var body: some View {
        
        PopUpSheet(title: "Save", confirmText: selectedUnsave ? "Unsave" : "Save", confirmAction: {
            if selectedUnsave {
                unsaveAction()
            } else if let folder = selectedFolder {
                saveAction(folder)
            }
        }) {
            
            VStack {
                
                ScrollView {
                    
                    VStack {
                        
                        Button(action: {
                            SoundManager.play(haptic: .light)
                            self.selectedFolder = ""
                            self.selectedUnsave = false
                        }) {
                            HStack {
                                Image(systemName: "folder\(folders.contains("") ? ".fill" : "")")
                                    .foregroundColor(selectedFolder == "" ? .white : Color.init(white: 0.8))
                                Text("All Saved")
                                    .font(Font.system(.body, design: .rounded).weight(.semibold))
                                    .foregroundColor(selectedFolder == "" ? .white : Color.init(white: 0.8))
                                Spacer()
                            }
                            .frame(width: 250)
                            .padding(10)
                            .background(selectedFolder == "" ? color(settings.theme.color1, edit: true) : Color.init(white: 0.3))
                            .cornerRadius(10)
                        }
                        
                        if proCheck() {
                            
                            ForEach(Settings.settings.folders, id: \.self) { folder in
                                
                                Button(action: {
                                    SoundManager.play(haptic: .light)
                                    self.selectedFolder = folder
                                    self.selectedUnsave = false
                                }) {
                                    HStack {
                                        Image(systemName: "folder\(folders.contains(folder) ? ".fill" : "")")
                                            .foregroundColor(selectedFolder == folder ? .white : color(settings.theme.color1, edit: true))
                                        Text(folder)
                                            .font(Font.system(.body, design: .rounded).weight(.semibold))
                                            .foregroundColor(Color.white)
                                        Spacer()
                                    }
                                    .frame(width: 250)
                                    .padding(10)
                                    .background(selectedFolder == folder ? color(settings.theme.color1, edit: true) : Color.init(white: 0.3))
                                    .cornerRadius(10)
                                }
                            }
                            
                            HStack {
                                Image(systemName: "folder.badge.plus")
                                    .foregroundColor(Color.init(white: 0.8))
                                TextField(NSLocalizedString("New Folder", comment: ""), text: self.$newFolderText, onCommit: {
                                    guard proCheckNotice(.cycle) else { newFolderText.removeAll(); return }
                                    while self.newFolderText.last == " " {
                                        self.newFolderText.removeLast()
                                    }
                                    while self.newFolderText.first == " " {
                                        self.newFolderText.removeFirst()
                                    }
                                    if !self.newFolderText.isEmpty && !settings.folders.contains(newFolderText) {
                                        self.selectedFolder = newFolderText
                                        self.settings.folders.insert(newFolderText, at: 0)
                                    }
                                    self.newFolderText.removeAll()
                                    SoundManager.play(haptic: .light)
                                })
                                .font(Font.system(.body, design: .rounded).weight(.semibold))
                                .foregroundColor(Color.init(white: 0.8))
                                Spacer()
                            }
                            .frame(width: 250)
                            .padding(10)
                            .background(Color.init(white: 0.3))
                            .cornerRadius(10)
                            
                        } else {
                            Button(action: {
                                guard proCheckNotice(.cycle) else { return }
                            }) {
                                HStack {
                                    Image(systemName: "folder.badge.plus")
                                        .foregroundColor(Color.init(white: 0.8))
                                    Text("New Folder")
                                        .font(Font.system(.body, design: .rounded).weight(.semibold))
                                        .foregroundColor(Color.init(white: 0.6))
                                    Spacer()
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(color(settings.theme.color1))
                                }
                                .frame(width: 250)
                                .padding(10)
                                .background(Color.init(white: 0.3))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                
                Spacer()
                
                if unsave {
                    
                    Button(action: {
                        SoundManager.play(haptic: .light)
                        self.selectedFolder = nil
                        self.selectedUnsave = true
                    }) {
                        HStack {
                            Image(systemName: "folder.badge.minus")
                                .foregroundColor(selectedUnsave ? .white : Color.init(white: 0.8))
                            Text("Unsave")
                                .font(Font.system(.body, design: .rounded).weight(.semibold))
                                .foregroundColor(selectedUnsave ? .white : Color.init(white: 0.8))
                            Spacer()
                        }
                        .frame(width: 250)
                        .padding(10)
                        .background(selectedUnsave ? color(settings.theme.color1, edit: true) : Color.init(white: 0.4))
                        .cornerRadius(10)
                    }
                    .padding(.bottom, 10)
                }
            }
        }
        .onAppear {
            if folders.count == 1 {
                self.selectedFolder = folders[0] ?? ""
            }
        }
    }
}

