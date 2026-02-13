//
//  ArrayAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 28.07.2021.
//

public extension Array {

    var lastIndex: Int? { isEmpty ? nil : count - 1 }

    var isNotEmpty: Bool { !(isEmpty) }

    func split(partSize: Int) -> [[Element]] {
        guard partSize > 0 else { log(error: "[Array] illegal argument. partSize:[\(partSize)]"); return [self] }
        guard partSize < self.count else { return [self] }
        var parts: [[Element]] = [ ]
        var currentPart: [Element] = [ ]
        self.forEach { element in
            if (currentPart.count == partSize) {
                parts.append(currentPart)
                currentPart = [ ]
            }
            currentPart.append(element)
        }
        if currentPart.isNotEmpty {
            parts.append(currentPart)
        }
        return parts
    }
    
    private func log(error record: String) { Bumblebee.log(error: record) }
    
    // like suffix(_ maxLength) but o(1)
    func suffix(last n: Int) -> [Element] {
        guard n > 0 else { return [ ] }
        let index: Int = count - n
        guard index > 0 else { return self }
        return Array(suffix(from: index))
    }

    mutating func addUnique(_ element: Element, _ areEqual: (Element, Element) -> Bool) {
        if contains(where: { areEqual(element, $0) }) { return }
        append(element)
    }
    
    func transform<T>(key field: KeyPath<Element, T>) -> [T:Element] {
        reduce(into: [ : ]) { map, element in map[element[keyPath: field]] = element }
    }
    
    func transform<K,V>(key field: KeyPath<Element, K>, _ transform: (Element) -> V?) -> [K:V] {
        reduce(into: [ : ]) { map, element in
            if let transformed: V = transform(element) { map[element[keyPath: field]] = transformed }
        }
    }
    
    func transform<T>(_ transform: (Element) -> T?) -> [Element : T] {
        reduce(into: [ : ]) { map, element in
            if let transformed: T = transform(element) { map[element] = transformed }
        }
    }

}

public extension Array where Element : Equatable {

    mutating func addUnique(among array: [Element]) { array.forEach { addUnique($0) } }

    mutating func addUnique(_ element: Element) { if element.isAbsent(among: self) { append(element) } }

}

public extension Equatable {

    func isAbsent(among elements: Array<Self>) -> Bool { !( elements.contains(self) ) }

    func isOne(of elements: Array<Self>) -> Bool { elements.contains(self) }

}

public func +=<E>(array: inout Array<E>, _ element: E) { array.append(element) }

public func +=<E>(set: inout Set<E>, _ element: E) { set.insert(element) }

public extension Comparable {

    func isAbsent(among elements: Range<Self>) -> Bool { elements.contains(self) == false }
    
    func isAbsent(among elements: ClosedRange<Self>) -> Bool { elements.contains(self) == false }

    func isOne(of elements: Range<Self>) -> Bool { elements.contains(self) }
    
    func isOne(of elements: ClosedRange<Self>) -> Bool { elements.contains(self) }
    
    func `is`(in range: Range<Self>) -> Bool { range.contains(self) }
    
    func `is`(in range: ClosedRange<Self>) -> Bool { range.contains(self) }
    
    func `is`(outOf range: Range<Self>) -> Bool { range.contains(self) == false }
    
    func `is`(outOf range: ClosedRange<Self>) -> Bool { range.contains(self) == false }
    
}

public extension Int {
    
    func isIndex<E>(of array: [E]?) -> Bool {
        guard let array: [E] else { return false }
        return (self > -1) && (self < array.count)
    }
    
}

// MARK: range-safe operations
public extension Array where Element : Equatable {

    mutating func remove(_ item: Element) {
        guard let index: Int = firstIndex(where: { $0 == item }) else { return }
        remove(at: index)
    }

}

public extension Array {

    subscript(safe index: Int) -> Element? {
        get { if (index > -1) && (index < count) { self[index] } else { nil } }
        set { if (index > -1) && (index < count) { update(at: index, with: newValue) } }
    }
    
    private mutating func update(at index: Int, with new: Element?) {
        if case .some(let new) = new {
            self[index] = new
        }
    }

}

public extension Array where Element : Nullable {

    subscript(safe index: Int) -> Element? { 
        get { if (index > -1) && (index < count) { self[index] } else { nil } }
        set { if (index > -1) && (index < count) { update(at: index, with: newValue) } }
    }

}
