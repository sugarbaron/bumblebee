//
//  CoreDataRequest.swift
//  Bumblebee
//
//  Created by sugarbaron on 09.04.2023.
//

import CoreData

@available(iOS 15.0, *)
internal extension CoreDataStorage {
    
    final class Request<Record:CoreDataRecord> {
        
        private let request: NSFetchRequest<Record>
        
        internal init?(_ context: Context, where predicate: Predicate = .all, sort: [Sort] = [ ], limit: Int? = nil) {
            guard let recordName: String = Record.entity().name
            else { log(error: "[CoreDataRequest] unable to access entity name"); return nil }
            self.request = NSFetchRequest<Record>()
            request.entity = NSEntityDescription.entity(forEntityName: recordName, in: context)
            request.predicate = predicate
            request.sortDescriptors = sort
            request.returnsObjectsAsFaults = false
            if let limit { request.fetchLimit = limit }
        }
        
        internal func execute() -> [Record] { (try? request.execute()) ?? [ ] }
        
    }
    
}


