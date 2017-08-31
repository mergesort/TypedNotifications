import Foundation

/// A protocol to define notifications that are sent around with our `NotificationCenter` extension functionality
public protocol TypedNotification {

    /// The type must be defined a `Notification`.
    associatedtype Payload

    /// A payload to send in a notification. It is sent through `Notification`'s the `object` property.
    var payload: Payload { get }
}

public extension NotificationCenter {

    /// This function posts notifications, using a generic parameter tailored to `TypedNotification`s.
    ///
    /// - Parameter typedNotification: The `TypedNotification` to post.
    func post<T>(typedNotification: T) where T: TypedNotification {
        let notification = NotificationCenter.generateNotification(typedNotification: typedNotification)
        self.post(notification)
    }

    /// This function registers notifications, tailored to the `TypedNotification` type.
    ///
    /// - Parameters:
    ///   - type: The `TypedNotification` type to register.
    ///   - observer: An observer to use for calling the target selector.
    ///   - selector: The selector to call the observer with.
    func register<T>(type: T.Type, observer: Any, selector: Selector) where T: TypedNotification {
        let notificationName = NotificationCenter.generateNotificationName(type: type)
        self.addObserver(observer, selector: selector, name: notificationName, object: nil)
    }
}

extension NotificationCenter {

    static func generateNotification<T>(typedNotification: T) -> Notification where T: TypedNotification {
        let notificationName = self.generateNotificationName(type: T.self)
        return Notification(name: notificationName, object: typedNotification.payload)
    }

    static func generateNotificationName<T>(type: T.Type) -> Notification.Name where T: TypedNotification {
        let name = String(describing: type)
        let notificationName = Notification.Name(name)

        return notificationName
    }
}

public extension Notification {

    /// This function allows you to pull a payload out of a `Notification`, with the result being
    /// typed to the defined `Payload` type.
    ///
    /// - Parameter notificationType: The notificationType to retrieve the payload from.
    /// - Returns: The payload from the `TypedNotification`.
    func getPayload<T>(notificationType: T.Type) -> T.Payload? where T: TypedNotification {
        return self.object as? T.Payload
    }
}
