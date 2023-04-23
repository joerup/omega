//
//  PlaySound.swift
//  Calculator
//
//  Created by Joe Rupertus on 4/15/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import AVFoundation

var soundPlayer: AVAudioPlayer?

func playSound(sound:String) {
    
    let path = Bundle.main.path(forResource: sound, ofType: nil)!
    let url = URL(fileURLWithPath: path)
    
    do {
        soundPlayer = try AVAudioPlayer(contentsOf: url)
        soundPlayer?.play()
    } catch {
        print("Could not load sound file")
    }
}


