//
//  Keyboard.swift
//  bumblebee
//
//  Created by sugarbaron on 06.03.2023.
//

import UIKit
import Combine

public final class Keyboard : ObservableObject {
    
    @Published public private (set) var status: Status
    @Published public private (set) var size: CGSize
    
    private var subscriptions: [AnyCancellable] = [ ]
    
    public init() {
        self.status = .collapsed
        self.size = .zero
        
        NotificationCenter.default
            .publisher(for: UIWindow.keyboardWillShowNotification)
            .subscribe { [weak self] in self?.set(status: .expanding) }
            .store { subscriptions += $0 }
        
        NotificationCenter.default
            .publisher(for: UIWindow.keyboardDidShowNotification)
            .subscribe { [weak self] in
                let keyboard: CGRect? = ($0.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                self?.set(expanded: keyboard?.size)
            }
            .store { subscriptions += $0 }
        
        NotificationCenter.default
            .publisher(for: UIWindow.keyboardWillHideNotification)
            .subscribe { [weak self] _ in self?.set(status: .collapsing) }
            .store { subscriptions += $0 }
        
        NotificationCenter.default
            .publisher(for: UIWindow.keyboardDidHideNotification)
            .subscribe { [weak self] _ in self?.set(status: .collapsed) }
            .store { subscriptions += $0 }
    }
    
    private func set(status: Status) {
        switch self.status {
        case .collapsed: if status == .expanding {
            onMain { [weak self] in self?.status = .expanding }
        }
        case .expanding: if status == .expanded {
            onMain { [weak self] in self?.status = .expanded }
        }
        case .expanded: if status == .collapsing {
            onMain { [weak self] in self?.status = .collapsing; self?.size = .zero }
        }
        case .collapsing: if status == .collapsed {
            onMain { [weak self] in self?.status = .collapsed } }
        }
    }
    
    private func set(expanded size: CGSize?) {
        onMain { [weak self] in self?.status = .expanded; self?.size = size ?? .zero }
    }
    
    public enum Status {
        case collapsed
        case expanding
        case expanded
        case collapsing
    }
    
}
