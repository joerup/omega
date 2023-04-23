//
//  MoreAppsView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 7/25/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import SwiftUI

struct MoreAppsView: View {
    
    var body: some View {
        
        GeometryReader { geometry in
            
            SettingsGroup {
                
                SettingsRow {
                    Link(destination: URL(string: "https://apps.apple.com/is/app/planetaria/id1546887479")!) {
                        HStack {
                            Image("Planetaria")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                            VStack(alignment: .leading) {
                                Text("Planetaria")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.init(red: 0.3, green: 0.8, blue: 0.85))
                                Text("Explore Space")
                                    .font(.subheadline)
                                    .foregroundColor(Color(UIColor.systemGray))
                            }
                            .padding(.leading, 20)
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .imageScale(.small)
                                .foregroundColor(Color.init(white: 0.4))
                        }
                    }
                    .padding(.vertical, 10)
                }
                
                SettingsRow {
                    Link(destination: URL(string: "https://apps.apple.com/us/app/bits-and-bobs/id1554786457")!) {
                        HStack {
                            Image("BitsAndBobs")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                            VStack(alignment: .leading) {
                                Text("Bits & Bobs")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.init(red: 0.9, green: 0.7, blue: 0.4))
                                Text("A Personal Database")
                                    .font(.subheadline)
                                    .foregroundColor(Color(UIColor.systemGray))
                            }
                            .padding(.leading, 20)
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .imageScale(.small)
                                .foregroundColor(Color.init(white: 0.4))
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
        }
    }
}
