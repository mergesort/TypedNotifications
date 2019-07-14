//
//  ViewController.swift
//  TypedNotifications
//
//  Created by Joe Fabisevich on 8/30/17.
//  Copyright © 2017 Mergesort. All rights reserved.
//

import os.log
import UIKit
import TypedNotifications

// There are only 3 jobs in the world, trust me.
enum Job {
    
    case softwareDeveloper
    case designer
    case conArtist
    
    var title: String {
        switch self {

        case .softwareDeveloper:
            return "Software Developer"
            
        case .designer:
            return "Designer"
            
        case .conArtist:
            return "Con Artist"
            
        }
    }
    
}

struct Person {
    
    let name: String
    let job: Job
    
}

/// A `TypedNotification` with no payload.
struct PayloadFreeTypedNotification: TypedNotification {}

/// A very simple payload to send.
/// Just contains one boolean value.
struct TypedBooleanNotification: TypedPayloadNotification {
    
    let payload: Bool
    
}

/// A slightly more complicated payload to send.
/// It contains a struct as it's payload.
struct TypedPersonNotification: TypedPayloadNotification {
    
    let payload: Person
    
}

/// A more complicated payload to send.
/// It contains any generic value you want to send, and recieve.
struct TypedGenericNotification<T>: TypedPayloadNotification {
    
    let payload: T
    
}

class ViewController: UIViewController {
    
    @IBOutlet var currentNotificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.register(type: TypedBooleanNotification.self, observer: self, selector: #selector(booleanWasReceived))
        NotificationCenter.default.register(type: TypedPersonNotification.self, observer: self, selector: #selector(personWasReceived))
        NotificationCenter.default.register(type: TypedGenericNotification<String>.self, observer: self, selector: #selector(stringWasReceived))
        
        NotificationCenter.default.register(type: PayloadFreeTypedNotification.self, observer: self, selector: #selector(payloadFreeWasReceived))
    }
    
}

private extension ViewController {
    
    @IBAction func tappedSendPeopleButton() {
        let amanda = Person(name: "Amanda", job: .softwareDeveloper)
        let amandaNotification = TypedPersonNotification(payload: amanda)
        
        NotificationCenter.default.post(typedNotification: amandaNotification)
        
        let erica = Person(name: "Erica", job: .designer)
        let ericaNotification = TypedPersonNotification(payload: erica)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            NotificationCenter.default.post(typedNotification: ericaNotification)
        }
        
        let joe = Person(name: "Joe", job: .conArtist)
        let joeNotification = TypedPersonNotification(payload: joe)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
            NotificationCenter.default.post(typedNotification: joeNotification)
        }
    }
    
    @IBAction func tappedSendPayloadFreeButton() {
        let payloadFreeNotification = PayloadFreeTypedNotification()
        NotificationCenter.default.post(typedNotification: payloadFreeNotification)
    }

    @IBAction func tappedSendBooleanButton() {
        let booleanNotification = TypedBooleanNotification(payload: true)
        NotificationCenter.default.post(typedNotification: booleanNotification)
    }
    
    @IBAction func tappedGenericValuesButton() {
        let genericNotification = TypedGenericNotification<String>(payload: "This is a payload")
        NotificationCenter.default.post(typedNotification: genericNotification)
    }
    
    @objc func payloadFreeWasReceived(notification: Notification) {
        self.currentNotificationLabel.text = "Got our payload free notification!"
    }
    
    @objc func booleanWasReceived(notification: Notification) {
        guard let boolean = notification.getPayload(notificationType: TypedBooleanNotification.self) else {
            os_log("Could not properly retrieve payload from BooleanTypedNotification")
            return
        }
        
        self.currentNotificationLabel.text = "Got our Bool payload!\n\(boolean)"
    }
    
    @objc func personWasReceived(notification: Notification) {
        guard let person = notification.getPayload(notificationType: TypedPersonNotification.self) else {
            os_log("Could not properly retrieve payload from PersonTypedNotification")
            return
        }
        
        let nameText = "Name: \(person.name)"
        let jobText = "Job: \(person.job.title)"
        
        self.currentNotificationLabel.text = "Got our Person payload!\n\(nameText)\n\(jobText)"
    }
    
    @objc func stringWasReceived(notification: Notification) {
        guard let string = notification.getPayload(notificationType: TypedGenericNotification<String>.self) else {
            os_log("Could not properly retrieve payload from GenericTypedNotification")
            return
        }
        
        self.currentNotificationLabel.text = "Got our generic payload!\n\(string)"
    }
    
}
