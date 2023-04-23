//
//  LayoutResetButton.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 8/8/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct LayoutResetButton: View {
    
    @ObservedObject var settings = Settings.settings
    
    var displayType: LayoutDisplayType
    var size: Size
    var variant: Int
    
    @Binding var selectedGroup: Int?
    @Binding var selectedIndex: Int?
    @Binding var selectedButton: String?
    
    var body: some View {
        
        VStack {
        
//            Menu("Reset") {
//
//                if displayType == .portrait {
//
//                    // 1
//                    if variant == 0 {
//
//                        if let group = selectedGroup, let index = selectedIndex {
//                            Button(action: {
//                                switch group {
//                                case 20:
//                                    self.settings.scrollRow[index] = self.uiData.scrollRow[index]
//                                default:
//                                    break
//                                }
//                                resetSelected()
//                            }) {
//                                Text("Reset Button")
//                            }
//                        }
//                        Button(action: {
//                            self.settings.scrollRow = self.uiData.scrollRow
//                            resetSelected()
//                        }) {
//                            Text("Reset All")
//                        }
//                    }
//
//                    else if variant == 1 {
//
//                        // 3A
//                        if size == .small {
//
//                            if let group = selectedGroup, let index = selectedIndex {
//                                Button(action: {
//                                    switch group {
//                                    case 40:
//                                        self.settings.portraitRow1[index] = self.uiData.portraitRow1[index]
//                                    case 41:
//                                        self.settings.portraitRow2[index] = self.uiData.portraitRow2[index]
//                                    case 42:
//                                        self.settings.portraitCol[index] = self.uiData.portraitCol[index]
//                                    default:
//                                        break
//                                    }
//                                    resetSelected()
//                                }) {
//                                    Text("Reset Button")
//                                }
//                            }
//                            Button(action: {
//                                self.settings.portraitRow1 = self.uiData.portraitRow1
//                                self.settings.portraitRow2 = self.uiData.portraitRow2
//                                self.settings.portraitCol = self.uiData.portraitCol
//                                resetSelected()
//                            }) {
//                                Text("Reset All")
//                            }
//                        }
//
//                        // 3B
//                        else if size == .large {
//
//                            if let group = selectedGroup, let index = selectedIndex {
//                                Button(action: {
//                                    switch group {
//                                    case 50:
//                                        self.settings.altPortraitRow1[index] = self.uiData.altPortraitRow1[index]
//                                    case 51:
//                                        self.settings.altPortraitRow2[index] = self.uiData.altPortraitRow2[index]
//                                    case 52:
//                                        self.settings.altPortraitCol1[index] = self.uiData.altPortraitCol1[index]
//                                    case 53:
//                                        self.settings.altPortraitCol2[index] = self.uiData.altPortraitCol2[index]
//                                    case 54:
//                                        self.settings.altPortraitCol3[index] = self.uiData.altPortraitCol3[index]
//                                    default:
//                                        break
//                                    }
//                                    resetSelected()
//                                }) {
//                                    Text("Reset Button")
//                                }
//                            }
//                            Button(action: {
//                                self.settings.altPortraitRow1 = self.uiData.altPortraitRow1
//                                self.settings.altPortraitRow2 = self.uiData.altPortraitRow2
//                                self.settings.altPortraitCol1 = self.uiData.altPortraitCol1
//                                self.settings.altPortraitCol2 = self.uiData.altPortraitCol2
//                                self.settings.altPortraitCol3 = self.uiData.altPortraitCol3
//                                resetSelected()
//                            }) {
//                                Text("Reset All")
//                            }
//                        }
//                    }
//                }
//
//                // 2
//                else if displayType == .landscape {
//
//                    if variant == 0 {
//
//                        if let group = selectedGroup, let index = selectedIndex {
//                            Button(action: {
//                                switch group {
//                                case 30...34:
//                                    self.settings.specialColumns[self.settings.buttonSection][group % 10][index] = self.uiData.specialColumns[self.settings.buttonSection][group % 10][index]
//                                default:
//                                    break
//                                }
//                                resetSelected()
//                            }) {
//                                Text("Reset Button")
//                            }
//                        }
//                        Button(action: {
//                            self.settings.specialColumns[self.settings.buttonSection] = self.uiData.specialColumns[self.settings.buttonSection]
//                            resetSelected()
//                        }) {
//                            Text("Reset Page")
//                        }
//                        Button(action: {
//                            self.settings.specialColumns = self.uiData.specialColumns
//                            resetSelected()
//                        }) {
//                            Text("Reset All Pages")
//                        }
//                    }
//                }
//            }
//            .onChange(of: self.settings.buttonSection) { _ in
//                resetSelected()
//            }
        }
    }
    
    func resetSelected() {
        self.selectedGroup = nil
        self.selectedIndex = nil
        self.selectedButton = nil
    }
}

