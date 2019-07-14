# TypedNotifications

### A wrapper around `NotificationCenter` for sending typed notifications with payloads across your iOS app.

[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=59a836506532420001f89b3b&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/59a836506532420001f89b3b/build/latest?branch=master) 
[![Pod Version](https://img.shields.io/badge/Pod-1.4.0-6193DF.svg)](https://cocoapods.org/)
![Swift Version](https://img.shields.io/badge/Swift%205.0-brightgreen.svg)
![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg) 
![Plaform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)


### Asynchronous behavior is hard. Let's make it a little easier so we can turn that frown (🙁) upside down (🙃).

---

Using TypedNotifications is easy. You can drop it into your app and replace all of your un-typed `Notification`s in minutes.

---

### Registering for Notifications

You can register notifications for either payload containing notifications, or payload-free notifications.

```swift
func register<T: TypedNotification>(type: T.Type, observer: Any, object: Any? = nil, selector: Selector)
```

```swift
func register<T: TypedPayloadNotification>(type: T.Type, observer: Any, object: Any? = nil, selector: Selector)
```
---

### Sending Notifications

You can send notifications for either payload containing notifications, or payload-free notifications.

```swift
func post<T: TypedNotification>(typedNotification: T, object: Any? = nil)
```

```swift
func post<T: TypedPayloadNotification>(typedNotification: T, object: Any? = nil)
```
---

### Extracting values from Notifications

Only payload containing notifications can have their payload extracted, because, duh.

```swift
func getPayload<T: TypedPayloadNotification>(notificationType: T.Type) -> T.Payload?
```
---

Now that might look a little scary at first with all those `T`s, but let's break it down with some examples and show you how easy this is.

## Examples

#### Create some values you'd like to send through your app.

```swift
enum Job {
    
    case softwareDeveloper
    case designer
    case conArtist

}

struct Person {

    let name: String
    let job: Job

}
```

#### Create the notification to send your value

If you have no payload and just want to send a message, use a `TypedNotification` like so.

```swift
struct SomeEventNotification: TypedNotification {}
```

For our example, let's use a `TypedPayloadNotification` with a payload though.

```swift
struct TypedPersonNotification: TypedPayloadNotification {

    let payload: Person

}
```

#### Register the notification

```swift
NotificationCenter.default.register(type: TypedPersonNotification.self, observer: self, selector: #selector(personNotificationWasReceived))
```

#### Send the notification

```swift
let amanda = Person(name: "Amanda", job: .softwareDeveloper)
let amandaNotification = TypedPersonNotification(payload: amanda)
NotificationCenter.default.post(typedNotification: amandaNotification)
```


#### And handle the notification

```swift
@objc func personNotificationWasReceived(notification: Notification) {
    guard let person = notification.getPayload(notificationType: TypedPersonNotification.self) else {
        os_log("Could not properly retrieve payload from TypedPersonNotification")
        return
    }
    
    let nameText = "Name: \(person.name)"
    let jobText = "Job: \(person.job.title)"

    print("Got our Person payload!\n\(nameText)\n\(jobText)")
}
```

### And that's it! You've sent a typed notification throughout your app.

If you want to play on expert mode, I recommend using generics and passing notifications through your app that way.

```swift
struct GenericTypedPayloadNotification<T>: TypedPayloadNotification {

    let payload: T

}
```

---

## Requirements

- iOS 8.0+
- Xcode 7.3+

## Installation

SPM will be the default supported installation method from version 1.4.0 and higher, so please integrate by using SPM.

If you're still using [CocoaPods](http://cocoapods.org/) for version 1.4.0 or below you can install `TypedNotifications` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

pod 'TypedNotifications'
```

Or install it manually by downloading `TypedNotifications.swift` and dropping it in your project.

## About me

Hi, I'm [Joe](http://fabisevi.ch) everywhere on the web, but especially on [Twitter](https://twitter.com/mergesort).

## License

See the [license](LICENSE) for more information about how you can use TypedNotifications.
