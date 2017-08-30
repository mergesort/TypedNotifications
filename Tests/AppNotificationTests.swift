@testable import AppNotificationsExample
import XCTest

struct TestAppNotification: AppNotification {

    let payload: Bool

}

final class AppNotificationTests: XCTestCase {

    static let passingValue = true
    static let failingValue = false

    let passingTestAppNotification = TestAppNotification(payload: AppNotificationTests.passingValue)

    lazy var passingTestNotification: Notification = {
        return NotificationCenter.generateNotification(appNotification: passingTestAppNotification)
    }()

    let failingTestAppNotification = TestAppNotification(payload: AppNotificationTests.failingValue)

    lazy var failingTestNotification: Notification = {
        return NotificationCenter.generateNotification(appNotification: failingTestAppNotification)
    }()
    
    func testCorrectPayloadExtraction() {
        let payload = passingTestNotification.getPayload(notificationType: TestAppNotification.self)
        let expectedPayload = AppNotificationTests.passingValue
        XCTAssertTrue(payload == expectedPayload, "passingTestNotification was expected to carry a payload of true")
    }
    
    func testIncorrectPayloadExtract() {
        let payload = failingTestNotification.getPayload(notificationType: TestAppNotification.self)
        let expectedPayload = AppNotificationTests.passingValue
        XCTAssertFalse(payload == expectedPayload, "failingTestNotification was expected to carry a payload of false")
    }

    func testCorrectNotificationNameGeneration() {
        let generatedNotificationName = NotificationCenter.generateNotificationName(type: TestAppNotification.self)
        XCTAssertTrue(generatedNotificationName == passingTestNotification.name, "passingTestNotification should have a name")
    }

    func testCorrectNotificationGeneration() {
        let generatedNotification = NotificationCenter.generateNotification(appNotification: passingTestAppNotification)
        XCTAssertTrue(generatedNotification == passingTestNotification, "passingTestAppNotification should generate a matching notification")
    }

    func testIncorrectNotificationGeneration() {
        let generatedNotification = NotificationCenter.generateNotification(appNotification: failingTestAppNotification)
        XCTAssertFalse(generatedNotification == passingTestNotification, "passingTestAppNotification should generate a matching notification")
    }
}
