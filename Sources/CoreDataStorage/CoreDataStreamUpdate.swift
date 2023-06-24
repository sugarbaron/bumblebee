//
//  CoreDataStreamUpdate.swift
//  Bumblebee
//
//  Created by sugarbaron on 22.04.2023.
//

import CoreData

// MARK: constructor
@available(iOS 15.0, *)
public extension CoreDataStorage.DataStream {
    
    final class Update {
        
        private let controller: NSFetchedResultsController<R>
        
        internal init(_ controller: NSFetchedResultsController<R>) { self.controller = controller }
        
    }
    
}

// MARK: interface
@available(iOS 15.0, *)
public extension CoreDataStorage.DataStream.Update {
    
    var item: R.DataClass? { threadSafe { controller.fetchedObjects?.first }?.original }
    
    var items: [R.DataClass] { threadSafe { controller.fetchedObjects ?? [ ] }.compactMap { $0.original } }
    
    func item(at index: IndexPath) -> R.DataClass? { threadSafe {
        guard let section: Section = controller.sections?.at(index.section),
              let item: R = section.objects?.at(index.item) as? R
        else { return nil }
        return item
    }?.original }
    
    func items(of sectionIndex: Int) -> [R.DataClass] { threadSafe {
        guard let section: Section = controller.sections?.at(sectionIndex) else { return [ ] }
        return section.objects?.compactMap { $0 as? R } ?? [ ]
    }.compactMap { $0.original } }
    
    func sectionName(at index: Int) -> String? { threadSafeRead { controller.sections?.at(index)?.name } }
    
    var itemsNumber: Int { threadSafeRead { controller.fetchedObjects?.count } ?? 0 }
    
    var sectionsNumber: Int { threadSafeRead { controller.sections?.count } ?? 0 }
    
}

// MARK: tools
@available(iOS 15.0, *)
private extension CoreDataStorage.DataStream.Update {
    
    func threadSafe(_ access: () -> [R]) -> [R] {
        if Thread.isMain { log(error: "[CoreDataStream][1] access from main is denied"); return [ ] }
        var unitList: [R] = [ ]
        controller.managedObjectContext.performAndWait { unitList = access() }
        return unitList
    }
    
    func threadSafe(_ access: () -> R?) -> R? {
        if Thread.isMain { log(error: "[CoreDataStream][2] access from main is denied"); return nil }
        var dataUnit: R? = nil
        controller.managedObjectContext.performAndWait { dataUnit = access() }
        return dataUnit
    }
    
    func threadSafeRead(_ read: () -> String?) -> String? {
        if Thread.isMain { log(error: "[CoreDataStream][3] access from main is denied"); return nil }
        var result: String? = nil
        controller.managedObjectContext.performAndWait { result = read() }
        return result
    }
    
    func threadSafeRead(_ read: () -> Int?) -> Int? {
        if Thread.isMain { log(error: "[CoreDataStream][4] access from main is denied"); return nil }
        var result: Int? = nil
        controller.managedObjectContext.performAndWait { result = read() }
        return result
    }
    
    typealias Section = NSFetchedResultsSectionInfo
    
}
