//
//  Notifications.swift
//  Bumblebee
//
//  Created by sugarbaron on 18.03.2021.
//

import Foundation

public class Notifications {

    public static func subscribe(on name: Notification.Name,
                                 _ observer: Any,
                                 _ selector: Selector,
                                 _ object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }

    public static func unsubscribe(from name: Notification.Name, _ observer: Any, _ object: Any? = nil) {
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
    }

    public static func post(_ name: Notification.Name, object: Any? = nil, info: [AnyHashable : Any]? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: info)
    }

}

public extension Notifications { typealias Subscriber = NotificationCenterSubscriber }

public extension Notifications {

    final class Subscription {
        
        private let eventHandler: (Notification) -> Void

        public init(_ notification: Notification.Name, _ object: Any?, _ eventHandler: @escaping (Notification) -> Void) {
            self.eventHandler = eventHandler
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(selector(_:)),
                                                   name: notification,
                                                   object: object)
        }
        
        @objc
        private func selector(_ notification: Notification) { eventHandler(notification) }
        
    }
    
}

public protocol NotificationCenterSubscriber { }

public extension NotificationCenterSubscriber {

    func subscribe(on notification: Notification.Name,
                   object: Any? = nil,
                   eventHandler: @escaping (Notification) -> Void) -> Notifications.Subscription {
        Notifications.Subscription(notification, object, eventHandler)
    }

    func unsubscribe(from notification: Notification.Name, _ object: Any? = nil) {
        NotificationCenter.default.removeObserver(self, name: notification, object: object)
    }

}
