//
//  ConcurrentMap.swift
//  Bumblebee
//
//  Created by sugarbaron on 12.10.2020.
//

import Foundation

public final class ConcurrentMap<K : Hashable, V> {
    
    private let serialQueue: OperationQueue
    private var map: [K : V]
    
    public init() {
        self.serialQueue = OperationQueue()
        self.serialQueue.maxConcurrentOperationCount = 1
        self.map = [ : ]
    }
    
    public subscript(key: K) -> V? {
        get {
            var value: V? = nil
            let getAction = BlockOperation { [weak self] in value = self?.map[key] }
            serialQueue.addOperation(getAction)
            getAction.waitUntilFinished()
            return value
        }
        
        set(newValue) {
            let setAction = BlockOperation { [weak self] in self?.map[key] = newValue }
            serialQueue.addOperation(setAction)
            setAction.waitUntilFinished()
        }
    }
    
}
