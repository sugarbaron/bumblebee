//
//  ArrayAdvanced.swift
//  Bumblebee
//
//  Created by sugarbaron on 28.07.2021.
//

public extension Array {
    
    var lastIndex: Int? { isEmpty ? nil : count - 1 }
    
    var isNotEmpty: Bool { !isEmpty }
    
    func split(partSize: Int) -> [[Element]] {
        guard partSize > 0 else { log("illegal argument. partSize:[\(partSize)]"); return [self] }
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
    
    mutating func addUnique(_ element: Element, _ areEqual: (Element, Element) -> Bool) {
        if contains(where: { areEqual(element, $0) }) { return }
        append(element)
    }
    
    private func log(_ error: String) { Bumblebee.log(error: "[Array] \(error)") }

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

    func isAbsent(among elements: Range<Self>) -> Bool { !( elements.contains(self) ) }

    func isOne(of elements: Range<Self>) -> Bool { elements.contains(self) }

}

// MARK: range-safe operations
public extension Array where Element : Equatable {

    mutating func remove(_ item: Element) {
        guard let index: Int = firstIndex(where: { $0 == item }) else { return }
        remove(at: index)
    }

}

public extension Array {

    func at(_ index: Int) -> Element? { index.isOne(of: indices) ? self[index] : nil }

}

public extension Array where Element : Nullable {

    func at(_ index: Int) -> Element { index.isOne(of: indices) ? self[index] : nil }

}
