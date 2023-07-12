//
//  TextView.swift
//  Calculator
//
//  Created by Joe Rupertus on 4/15/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI
import UIKit

// The ultimate view which contains all of the rows of text
struct TextView: View {
    
    @ObservedObject var settings = Settings.settings
    
    @ObservedObject var calculation = Calculation.current
    
    var size: Size
    var orientation: Orientation
    
    var standardSize: CGFloat
    var verticalPadding: CGFloat {
        return orientation == .landscape ? 0 : 10
    }

	var body: some View {
        
        GeometryReader { geometry in
        
            VStack(spacing: 0) {
                
                if calculation.queue.editing {
                    
                    Spacer().frame(maxHeight: smallSize(geometry))
                   
                    TextDisplay(strings: calculation.queue.strings,
                                map: calculation.queue.map,
                                modes: calculation.queue.modes,
                                calculation: calculation,
                                size: largeSize(geometry)*0.9,
                                height: largeSize(geometry),
                                opacity: 1,
                                scrollable: true,
                                animations: true,
                                interaction: .edit
                    )
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                    
                } else if calculation.showResult {
                    
                    TextDisplay(strings: calculation.queue.strings,
                                modes: calculation.queue.modes,
                                calculation: calculation,
                                size: smallSize(geometry)*0.9,
                                height: smallSize(geometry),
                                opacity: 0.5,
                                equals: !calculation.result.error,
                                scrollable: true,
                                animations: true,
                                interaction: .back
                    )
                    .frame(maxHeight: smallSize(geometry))
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                    
                    TextDisplay(strings: calculation.result.strings,
                                map: calculation.result.map,
                                modes: calculation.queue.modes,
                                calculation: calculation,
                                size: largeSize(geometry)*0.9,
                                height: largeSize(geometry),
                                opacity: 1,
                                scrollable: true,
                                animations: true,
                                interaction: .edit
                    )
                    .frame(maxHeight: largeSize(geometry))
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                    
                } else {
                    
                    Spacer().frame(maxHeight: smallSize(geometry))
                    
                    TextDisplay(strings: calculation.queue.strings,
                                map: calculation.queue.map,
                                modes: calculation.queue.modes,
                                calculation: calculation,
                                size: largeSize(geometry)*0.9,
                                height: largeSize(geometry),
                                opacity: 1,
                                scrollable: true,
                                animations: true,
                                interaction: .edit
                    )
                    .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height-2*verticalPadding)
            .padding(.vertical, verticalPadding)
            .if(settings.textAnimations) { view in
                view.animation(.easeInOut, value: calculation.completed)
            }
        }
        .id(orientation)
	}
    
    func largeSize(_ geometry: GeometryProxy) -> CGFloat {
        if orientation == .landscape && size == .small {
            return min(geometry.size.height-size.smallerSmallSize, 112)
        } else {
            return min(geometry.size.height*0.5, 135)
        }
    }
    func smallSize(_ geometry: GeometryProxy) -> CGFloat {
        if orientation == .landscape && size == .small {
            return size.smallerSmallSize
        } else {
            return min(geometry.size.height*0.25, 65)
        }
    }
}

enum InteractionType {
    case none
    case edit
    case back
}
