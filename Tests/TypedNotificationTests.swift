@testable import TypedNotifications
import XCTest

struct TypedTestNotification: TypedNotification {}

struct TypedPayloadTestNotification: TypedPayloadNotification {
    
    let payload: Bool
    
}


final class TypedNotificationTests: XCTestCase {

    static let passingValue = true
    static let failingValue = false

    // MARK: TypedNotification properties
    
    let payloadFreeTypedNotification = TypedTestNotification()

    lazy var payloadFreeNotification: Notification = {
        return NotificationCenter.generateNotification(typedNotification: self.payloadFreeTypedNotification)
    }()
    
    // MARK: TypedPayloadNotification properties
    
    let passingTypedPayloadNotification = TypedPayloadTestNotification(payload: TypedNotificationTests.passingValue)
    
    lazy var passingNotification: Notification = {
        return NotificationCenter.generateNotification(typedNotification: self.passingTypedPayloadNotification)
    }()

    let failingTypedPayloadNotification = TypedPayloadTestNotification(payload: TypedNotificationTests.failingValue)

    lazy var failingNotification: Notification = {
        return NotificationCenter.generateNotification(typedNotification: self.failingTypedPayloadNotification)
    }()
    
    // MARK: TypedNotification tests
    
    func testCorrectTypedNotificationGeneration() {
        let generatedNotification = NotificationCenter.generateNotification(typedNotification: self.payloadFreeTypedNotification)
        XCTAssertTrue(generatedNotification == payloadFreeNotification, "passingTypedNotification was expected to generate a matching notification")
    }
    
    // MARK: NotificationName tests
    
    func testCorrectNotificationNameGeneration() {
        let generatedNotificationName = NotificationCenter.generateNotificationName(type: TypedPayloadTestNotification.self)
        XCTAssertTrue(generatedNotificationName == passingNotification.name, "generatedNotificationName was expected to generate a name")
    }
    
    // MARK: TypedPayloadNotification tests

    func testCorrectTypedPayloadNotificationGeneration() {
        let generatedNotification = NotificationCenter.generateNotification(typedNotification: self.passingTypedPayloadNotification)
        XCTAssertTrue(generatedNotification == passingNotification, "passingTypedNotification was expected to generate a matching notification")
    }

    func testIncorrectTypedPayloadNotificationGeneration() {
        let generatedNotification = NotificationCenter.generateNotification(typedNotification: self.failingTypedPayloadNotification)
        XCTAssertFalse(generatedNotification == passingNotification, "failingTypedNotification was expected to generate an incorrect notification")
    }
    
    // MARK: Payload tests
    
    func testCorrectPayloadExtraction() {
        let payload = passingNotification.getPayload(notificationType: TypedPayloadTestNotification.self)
        let expectedPayload = TypedNotificationTests.passingValue
        XCTAssertTrue(payload == expectedPayload, "passingNotification was expected to carry a payload of true")
    }
    
    func testIncorrectPayloadExtract() {
        let payload = failingNotification.getPayload(notificationType: TypedPayloadTestNotification.self)
        let expectedPayload = TypedNotificationTests.passingValue
        XCTAssertFalse(payload == expectedPayload, "failingNotification was expected to carry a payload of false")
    }
    

}
