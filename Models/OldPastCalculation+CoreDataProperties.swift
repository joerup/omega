//
//  OldPastCalculation+CoreDataProperties.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 1/3/22.
//  Copyright © 2022 Rupertus. All rights reserved.
//
//

import Foundation
import CoreData


extension OldPastCalculation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OldPastCalculation> {
        return NSFetchRequest<OldPastCalculation>(entityName: "OldPastCalculation")
    }
    
    @NSManaged public var uuid: UUID
    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    
    @NSManaged public var queue: [String]
    @NSManaged public var result: [String]
    @NSManaged public var results: [[String]]
    
    @NSManaged public var topOutput: [String]
    @NSManaged public var mainOutput: [String]
    @NSManaged public var bottomOutput: [String]
    @NSManaged public var prevOutput: [String]
    
    @NSManaged public var topFormattingGuide: [[String]]
    @NSManaged public var mainFormattingGuide: [[String]]
    @NSManaged public var bottomFormattingGuide: [[String]]
    
    @NSManaged public var backspaceQueue: [[String]]
    @NSManaged public var backspaceNum: [String]
    @NSManaged public var backspaceIndexingQueue: [[String]]
    
    @NSManaged public var stepsExpressions: [[String]]
    
    @NSManaged public var resultContinues: Bool
    @NSManaged public var save: Bool

}

extension OldPastCalculation : Identifiable {

}
