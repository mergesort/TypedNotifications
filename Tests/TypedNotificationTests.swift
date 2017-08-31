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
        return NotificationCenter.generateNotification(typedNotification: passingTypedNotification)
    }()

    let failingTypedNotification = TestTypedNotification(payload: TypedNotificationTests.failingValue)

    lazy var failingNotification: Notification = {
        return NotificationCenter.generateNotification(typedNotification: failingTypedNotification)
    }()
    
    func testCorrectPayloadExtraction() {
        let payload = passingNotification.getPayload(notificationType: TestTypedNotification.self)
        let expectedPayload = TypedNotificationTests.passingValue
        XCTAssertTrue(payload == expectedPayload, "passingTypedNotification was expected to carry a payload of true")
    }
    
    func testIncorrectPayloadExtract() {
        let payload = failingNotification.getPayload(notificationType: TestTypedNotification.self)
        let expectedPayload = TypedNotificationTests.passingValue
        XCTAssertFalse(payload == expectedPayload, "failingTypedNotification was expected to carry a payload of false")
    }

    func testCorrectNotificationNameGeneration() {
        let generatedNotificationName = NotificationCenter.generateNotificationName(type: TestTypedNotification.self)
        XCTAssertTrue(generatedNotificationName == passingNotification.name, "passingTypedNotification should have a name")
    }

    func testCorrectNotificationGeneration() {
        let generatedNotification = NotificationCenter.generateNotification(typedNotification: passingTypedNotification)
        XCTAssertTrue(generatedNotification == passingNotification, "passingTypedNotification should generate a matching notification")
    }

    func testIncorrectNotificationGeneration() {
        let generatedNotification = NotificationCenter.generateNotification(typedNotification: failingTypedNotification)
        XCTAssertFalse(generatedNotification == passingNotification, "passingTypedNotification should generate a matching notification")
    }
}
