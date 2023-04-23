//
//  SoundManager.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/22/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class SoundManager {
    
    static let shared = SoundManager()
    
    enum Sound: SystemSoundID {
        case click1 = 1123
        case click2 = 1155
        case click3 = 1156
    }
    
    static func play(sound: Sound? = nil, haptic: UIImpactFeedbackGenerator.FeedbackStyle? = nil) {
        
        guard !Settings.settings.noSoundsHaptics else { return }
        
        // Sound
        if let sound = sound, Settings.settings.soundEffects {
            AudioServicesPlaySystemSound(sound.rawValue)
        }
        
        // Haptic
        if let haptic = haptic, Settings.settings.hapticFeedback {
            let impactMed = UIImpactFeedbackGenerator(style: haptic)
            impactMed.impactOccurred()
        }
    }
}
