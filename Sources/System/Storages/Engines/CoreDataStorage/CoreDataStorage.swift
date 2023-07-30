//
//  CoreDataStorage.swift
//  Bumblebee
//
//  Created by sugarbaron on 09.04.2023.
//

import CoreData

/// namespace class
@available(iOS 15.0, *)
public final class CoreDataStorage { }

// MARK: constructor
@available(iOS 15.0, *)
public extension CoreDataStorage {
    
    final class Engine {
        
        private let storage: NSPersistentContainer
        private let context: NSManagedObjectContext
        private let scheduled: BackgroundEngine
        
        /// specify xcdatamodel filename without extension
        /// example: `.init(xcdatamodel: "MyStorage")`
        public init?(xcdatamodel fileName: String, bundle: Bundle? = nil) {
            guard let storage: NSPersistentContainer = .load(model: fileName, from: bundle) else { return nil }
            
            self.storage = storage
            self.context = storage.newBackgroundContext()
            self.scheduled = BackgroundEngine(self.context)
        }
        
    }
    
}

@available(iOS 15.0, *)
public extension CoreDataStorage {
 
    final class BackgroundEngine {
        
        private let context: CoreDataStorage.Context
        private let background: Async.Fifo
        
        internal init(_ context: CoreDataStorage.Context) {
            self.context = context
            self.background = Async.Fifo()
        }
        
    }
    
}

private extension NSPersistentContainer {
    
    static func load(model: String, from bundle: Bundle?) -> NSPersistentContainer? {
        guard let engine: NSPersistentContainer = construct(model, from: bundle)
        else { return log(nil: "[CoreDataStorage] not constructed:[\(model)] bundle:[\((bundle?.id).log)]") }
        
        engine.loadPersistentStores { if $1 != nil { log(error: "[CoreDataStorage] start failed:[\($0)][\($1.log)]") } }
        return engine
    }
    
    private static func construct(_ modelName: String, from bundle: Bundle?) -> NSPersistentContainer? {
        guard let bundle else { return NSPersistentContainer(name: modelName) }
        guard let modelURL: URL = bundle.url(forResource: modelName, withExtension: "momd"),
              let model: NSManagedObjectModel = .init(contentsOf: modelURL)
        else { return log(nil: "[CoreDataStorage] unable to load model:[\(modelName)] from bundle") }
        return NSPersistentContainer(name: modelName, managedObjectModel: model)
    }
    
}

// MARK: interface
@available(iOS 15.0, *)
public extension CoreDataStorage.Engine {
    
    var background: CoreDataStorage.BackgroundEngine { scheduled }
    
    func write(_ transaction: @escaping (CoreDataAccess) throws -> Void,
               catch: @escaping (Error) -> Void = { log(error: "[CoreDataStorage] async write() error: \($0)") })
    async {
        await context.write(transaction, `catch`)
    }
    
    func read<R>(_ transaction: @escaping (CoreDataRead) throws -> R?,
                 catch: @escaping (Error) -> Void = { log(error: "[CoreDataStorage] read() -> R? error: \($0)") })
    async -> R.DataClass? where R : CoreDataRecord {
        var original: R.DataClass? = nil
        await context.perform(schedule: .immediate) { [context] in
            do {
                let record: R? = try transaction(context.access)
                original = record?.original
            } catch { `catch`(error) }
        }
        return original
    }
    
    func read<R>(_ transaction: @escaping (CoreDataRead) throws -> [R],
                 catch: @escaping (Error) -> Void = { log(error: "[CoreDataStorage] read() -> [R] error: \($0)") })
    async -> [R.DataClass] where R : CoreDataRecord {
        var original: [R.DataClass] = [ ]
        await context.perform(schedule: .immediate) { [context] in
            do {
                let records: [R] = try transaction(context.access)
                original = records.compactMap { $0.original }
            } catch { `catch`(error) }
        }
        return original
    }
    
    func keepInformed<R:CoreDataRecord>(_ config: CoreDataStorage.DataStream<R>.Config)
    -> CoreDataStorage.DataStream<R> {
        .init(config, context)
    }
    
}

@available(iOS 15.0, *)
public extension CoreDataStorage.BackgroundEngine {
    
    func write(_ transaction: @escaping (CoreDataAccess) -> Void,
               catch: @escaping (Error) -> Void = { log("write() error: \($0)") }) {
        background.enqueue { [weak self] in await self?.context.write(transaction, `catch`) }
    }
    
}


// MARK: tools
@available(iOS 15.0, *)
private extension CoreDataStorage.Context {
    
    func write(_ transaction: @escaping (CoreDataAccess) throws -> Void, _ catch: @escaping (Error) -> Void) async {
        await perform(schedule: .immediate) { [weak self] in
            do    { if let self: Context { try transaction(self.access); if hasChanges { try save() } } }
            catch { `catch`(error) }
        }
    }
    
    private typealias Context = CoreDataStorage.Context
    
}

private extension Bundle { var id: String? { bundleIdentifier } }
