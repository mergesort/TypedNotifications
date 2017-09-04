@testable import TypedNotifications
import XCTest

struct TestTypedNotification: TypedNotification {

    let payload: Bool

}

final class TypedNotificationTests: XCTestCase {

    static let passingValue = true
    static let failingValue = false

    let passingTypedNotification = TestTypedNotification(payload: TypedNotificationTests.passingValue)

    lazy var passingNotification: Notification = {
        return NotificationCenter.generateNotification(typedNotification: self.passingTypedNotification)
    }()

    let failingTypedNotification = TestTypedNotification(payload: TypedNotificationTests.failingValue)

    lazy var failingNotification: Notification = {
        return NotificationCenter.generateNotification(typedNotification: self.failingTypedNotification)
    }()
    
    func testCorrectPayloadExtraction() {
        let payload = passingNotification.getPayload(notificationType: TestTypedNotification.self)
        let expectedPayload = TypedNotificationTests.passingValue
        XCTAssertTrue(payload == expectedPayload, "passingNotification was expected to carry a payload of true")
    }
    
    func testIncorrectPayloadExtract() {
        let payload = failingNotification.getPayload(notificationType: TestTypedNotification.self)
        let expectedPayload = TypedNotificationTests.passingValue
        XCTAssertFalse(payload == expectedPayload, "failingNotification was expected to carry a payload of false")
    }

    func testCorrectNotificationNameGeneration() {
        let generatedNotificationName = NotificationCenter.generateNotificationName(type: TestTypedNotification.self)
        XCTAssertTrue(generatedNotificationName == passingNotification.name, "generatedNotificationName was expected to generate a name")
    }

    func testCorrectNotificationGeneration() {
        let generatedNotification = NotificationCenter.generateNotification(typedNotification: self.passingTypedNotification)
        XCTAssertTrue(generatedNotification == passingNotification, "passingTypedNotification was expected to generate a matching notification")
    }

    func testIncorrectNotificationGeneration() {
        let generatedNotification = NotificationCenter.generateNotification(typedNotification: self.failingTypedNotification)
        XCTAssertFalse(generatedNotification == passingNotification, "failingTypedNotification was expected to generate an incorrect notification")
    }
}
