//
//  ViewController.swift
//  AppNotificationsExample
//
//  Created by Joe Fabisevich on 8/30/17.
//  Copyright © 2017 Mergesort. All rights reserved.
//

import os.log
import UIKit

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

/// A very simple payload to send.
/// Just contains one boolean value.
struct BooleanAppNotification: AppNotification {
    
    let payload: Bool
    
}

/// A slightly more complicated payload to send.
/// It contains a struct as it's payload.
struct PersonAppNotification: AppNotification {
    
    let payload: Person
    
}

/// A more complicated payload to send.
/// It contains any generic value you want to send, and recieve.
struct GenericAppNotification<T>: AppNotification {
    
    let payload: T
    
}

class ViewController: UIViewController {

    @IBOutlet var currentNotificationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.register(type: BooleanAppNotification.self, observer: self, selector: #selector(booleanWasReceived))
        NotificationCenter.default.register(type: PersonAppNotification.self, observer: self, selector: #selector(personWasReceived))
        NotificationCenter.default.register(type: GenericAppNotification<String>.self, observer: self, selector: #selector(stringWasReceived))
    }
    
}

private extension ViewController {

    @IBAction func tappedSendPeopleButton() {
        let amanda = Person(name: "Amanda", job: .softwareDeveloper)
        let amandaNotification = PersonAppNotification(payload: amanda)

        NotificationCenter.default.post(appNotification: amandaNotification)

        let erica = Person(name: "Erica", job: .designer)
        let ericaNotification = PersonAppNotification(payload: erica)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            NotificationCenter.default.post(appNotification: ericaNotification)
        }

        let joe = Person(name: "Joe", job: .conArtist)
        let joeNotification = PersonAppNotification(payload: joe)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
            NotificationCenter.default.post(appNotification: joeNotification)
        }
    }

    @IBAction func tappedSendBooleanButton() {
        let booleanNotification = BooleanAppNotification(payload: true)
        NotificationCenter.default.post(appNotification: booleanNotification)
    }

    @IBAction func tappedGenericValuesButton() {
        let genericNotification = GenericAppNotification<String>(payload: "This is a payload")
        NotificationCenter.default.post(appNotification: genericNotification)
    }

    @objc func booleanWasReceived(notification: Notification) {
        guard let boolean = notification.getPayload(notificationType: BooleanAppNotification.self) else {
            os_log("Could not properly retrieve payload from BooleanAppNotification")
            return
        }

        self.currentNotificationLabel.text = "Got our Bool payload!\n\(boolean)"
    }

    @objc func personWasReceived(notification: Notification) {
        guard let person = notification.getPayload(notificationType: PersonAppNotification.self) else {
            os_log("Could not properly retrieve payload from PersonAppNotification")
            return
        }
        
        let nameText = "Name: \(person.name)"
        let jobText = "Job: \(person.job.title)"
        
        self.currentNotificationLabel.text = "Got our Person payload!\n\(nameText)\n\(jobText)"
    }

    @objc func stringWasReceived(notification: Notification) {
        guard let string = notification.getPayload(notificationType: GenericAppNotification<String>.self) else {
            os_log("Could not properly retrieve payload from GenericAppNotification")
            return
        }

        self.currentNotificationLabel.text = "Got our generic payload!\n\(string)"
    }

}
