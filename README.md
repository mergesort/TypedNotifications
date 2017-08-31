# TypedNotifications

### A wrapper around `NotificationCenter` for sending typed notifications with payloads across your iOS app.
---

[![Pod Version](https://img.shields.io/badge/Pod-1.0-6193DF.svg)](https://cocoapods.org/)
![Swift Version](https://img.shields.io/badge/Swift-3.0%20|%203.1%20|%203.2%20|%204.0-brightgreen.svg)
![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg) 
![Plaform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)

### Asynchronous behavior is hard. Let's make it a little easier so we can turn that frown (🙁) upside down (🙃).

---

Using TypedNotifications is easy. You can drop it into your app and replace all of your un-typed `Notification`s in minutes.

--

### Registering for Notifications

```swift
func register<T>(type: T.Type, observer: Any, selector: Selector) where T: TypedNotification
```
--

### Sending Notifications


```swift
func post<T>(typedNotification: T) where T: TypedNotification

```
--

### Extracting values from Notifications


```swift
func getPayload<T>(notificationType: T.Type) -> T.Payload? where T: TypedNotification
```

--

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

```swift
struct PersonTypedNotification: TypedNotification {

    let payload: Person

}
```

#### Register the notification

```swift
NotificationCenter.default.register(type: PersonTypedNotification.self, observer: self, selector: #selector(personNotificationWasReceived))
```

#### Send the notification

```swift
let amanda = Person(name: "Amanda", job: .softwareDeveloper)
let amandaNotification = PersonTypedNotification(payload: amanda)
NotificationCenter.default.post(typedNotification: amandaNotification)
```


#### And handle the notification

```swift
@objc func personNotificationWasReceived(notification: Notification) {
    guard let person = notification.getPayload(notificationType: PersonTypedNotification.self) else {
        os_log("Could not properly retrieve payload from PersonTypedNotification")
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
struct GenericTypedNotification<T>: TypedNotification {

    let payload: T

}
```

## Requirements

- iOS 8.0+
- Xcode 7.3+

## Installation
You can use [CocoaPods](http://cocoapods.org/) to install `TypedNotifications` by adding it to your `Podfile`:

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