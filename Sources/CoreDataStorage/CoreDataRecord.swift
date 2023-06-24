//
//  CoreDataRecord.swift
//  Bumblebee
//
//  Created by sugarbaron on 09.04.2023.
//

import CoreData

public protocol CoreDataRecord where Self : NSManagedObject {

    associatedtype DataClass
    
    var original: DataClass? { get }
    
    func fill(with original: DataClass)
    
}

public extension CoreDataRecord {
    
    static var recordName: String? {
        if let name: String = entity().name {
            return name
        } else {
            return log(nil: "[\(type(of: Self.self))] record name is missing")
        }
    }
    
}
