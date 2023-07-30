//
//  CoreDataStream.swift
//  Bumblebee
//
//  Created by sugarbaron on 22.04.2023.
//

import CoreData

// MARK: data stream
@available(iOS 15.0, *)
public extension CoreDataStorage {

    final class DataStream<R:CoreDataRecord> : NSObject, NSFetchedResultsControllerDelegate {
        
        private let update: Update
        
        public var onUpdate: (Update) -> Void
        
        internal init(_ config: Config, _ context: CoreDataStorage.Context) {
            let recordName: String = R.recordName ?? "<name is missing for \(type(of: R.self))>"
            
            let request = NSFetchRequest<R>()
            request.entity = .entity(forEntityName: recordName, in: context)
            request.sortDescriptors = config.sort
            request.predicate = config.predicate
            let controller: Controller = .init(fetchRequest: request,
                                               managedObjectContext: context,
                                               sectionNameKeyPath: config.sectionKey,
                                               cacheName: nil)
            context.performAndWait {
                do    { try controller.performFetch() }
                catch { log(error: "[CoreDataStream] unable to subscribe: \(error)") }
            }
            self.update = Update(controller)
            self.onUpdate = { _ in }
        }
        
        public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            onUpdate(update)
        }
        
        private typealias Controller = NSFetchedResultsController
        
    }

}

// MARK: config
@available(iOS 15.0, *)
public extension CoreDataStorage.DataStream {
    
    final class Config {
        
        public let predicate: Predicate
        public let sort: [Sort]
        public let sectionKey: String?
        
        public init(_ predicate: Predicate, sort: [Sort] = [ ], sectionKey: String? = nil) {
            self.predicate = predicate
            self.sort = sort
            self.sectionKey = sectionKey
        }
        
    }
    
}
