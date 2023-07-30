//
//  CoreDataContributions.swift
//  Bumblebee
//
//  Created by sugarbaron on 09.04.2023.
//

import CoreData

public extension NSPredicate {
    
    static var all: NSPredicate { .init(value: true) }
    
}

public typealias Predicate = NSPredicate
public typealias Sort = NSSortDescriptor


