import Foundation

/// A protocol to define notifications that are sent around with our `NotificationCenter` extension functionality
public protocol AppNotification {

    /// The type must be defined a `Notification`.
    associatedtype Payload

    /// A payload to send in a notification. It is sent through `Notification`'s the `object` property.
    var payload: Payload { get }
}

public extension NotificationCenter {

    /// This function posts notifications, using a generic parameter tailored to `AppNotification`s.
    ///
    /// - Parameter appNotification: The appNotification to post.
    func post<T>(appNotification: T) where T: AppNotification {
        let notification = NotificationCenter.generateNotification(appNotification: appNotification)
        self.post(notification)
    }

    /// This function registers notifications, tailored to the `AppNotification` type.
    ///
    /// - Parameters:
    ///   - type: The AppNotification type to register.
    ///   - observer: An observer to use for calling the target selector.
    ///   - selector: The selector to call the observer with.
    func register<T>(type: T.Type, observer: Any, selector: Selector) where T: AppNotification {
        let notificationName = NotificationCenter.generateNotificationName(type: type)
        self.addObserver(observer, selector: selector, name: notificationName, object: nil)
    }
}

extension NotificationCenter {

    static func generateNotification<T>(appNotification: T) -> Notification where T: AppNotification {
        let notificationName = self.generateNotificationName(type: T.self)
        return Notification(name: notificationName, object: appNotification.payload)
    }

    static func generateNotificationName<T>(type: T.Type) -> Notification.Name where T: AppNotification {
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
    /// - Returns: The payload from the AppNotification.
    func getPayload<T>(notificationType: T.Type) -> T.Payload? where T: AppNotification {
        return self.object as? T.Payload
    }
}
