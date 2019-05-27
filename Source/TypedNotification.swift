import Foundation

/// A protocol to define notifications that are sent around with our `NotificationCenter` extension functionality.
public protocol TypedNotification {}

private let userInfoPayloadKey = "_payload"

/// A protocol to define notifications that are sent around with our `NotificationCenter` extension functionality
/// and contain a payload.
public protocol TypedPayloadNotification: TypedNotification {

    /// The type must be defined a `Notification`.
    associatedtype Payload

    /// A payload to send in a notification. It is sent through `Notification`'s the `userInfo` property.
    var payload: Payload { get }
}

public extension NotificationCenter {

    /// This function posts notifications, using a generic parameter tailored to `TypedNotification`s.
    ///
    /// - Parameter typedNotification: The `TypedNotification` to post.
    func post<T: TypedNotification>(typedNotification: T, object: Any? = nil) {
        let notification = NotificationCenter.generateNotification(
            typedNotification: typedNotification,
            object: object
        )
        self.post(notification)
    }

    /// This function posts notifications, using a generic parameter tailored to `TypedPayloadNotification`s.
    ///
    /// - Parameter typedNotification: The `TypedPayloadNotification` to post.
    func post<T: TypedPayloadNotification>(typedNotification: T, object: Any?) {
        let notification = NotificationCenter.generateNotification(
            typedNotification: typedNotification,
            object: object
        )
        self.post(notification)
    }
    
    /// This function registers notifications, tailored to the `TypedNotification` type.
    ///
    /// - Parameters:
    ///   - type: The `TypedNotification` type to register.
    ///   - observer: An observer to use for calling the target selector.
    ///   - selector: The selector to call the observer with.
    func register<T: TypedNotification>(type: T.Type, observer: Any, object: Any? = nil, selector: Selector) {
        let notificationName = NotificationCenter.generateNotificationName(type: type)
        self.addObserver(observer, selector: selector, name: notificationName, object: object)
    }

}

extension NotificationCenter {

    static func generateNotification<T: TypedNotification>(typedNotification: T, object: Any? = nil) -> Notification {
        let notificationName = self.generateNotificationName(type: T.self)
        return Notification(
            name: notificationName,
            object: object,
            userInfo: nil
        )
    }

    static func generateNotification<T: TypedPayloadNotification>(typedNotification: T, object: Any? = nil) -> Notification {
        let notificationName = self.generateNotificationName(type: T.self)
        return Notification(
            name: notificationName,
            object: object,
            userInfo: [userInfoPayloadKey : typedNotification.payload]
        )
    }
    
    static func generateNotificationName<T: TypedNotification>(type: T.Type) -> Notification.Name {
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
    func getPayload<T: TypedPayloadNotification>(notificationType: T.Type) -> T.Payload? {
        return self.userInfo?[userInfoPayloadKey] as? T.Payload
    }

}
