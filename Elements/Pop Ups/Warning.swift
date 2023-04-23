//
//  Warning.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 5/25/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

class Warning {
    
    var headline: String
    var message: LocalizedStringKey
    var cancelString: String
    var continueString: String
    var cancelAction: () -> Void
    var continueAction: () -> Void
    
    init(headline: String, message: LocalizedStringKey, cancelString: String = "Cancel", continueString: String = "Continue", cancelAction: @escaping () -> Void = {}, continueAction: @escaping () -> Void = {}) {
        self.headline = headline
        self.message = message
        self.cancelString = cancelString
        self.continueString = continueString
        self.cancelAction = cancelAction
        self.continueAction = continueAction
    }
}
