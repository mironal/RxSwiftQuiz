//
//  Basic_Subjects.swift
//  RxSwiftQuizTests
//
//

import RxCocoa
import RxSwift
import RxTest
import XCTest

// Quiz to see the difference in behavior of multiple Subjects in RxSwift.
class Basic_Subjects: XCTestCase {
    override func setUpWithError() throws {}

    // !! Edit only the XCTAssertEqual part. !!

    // This test code is a sample. The answer has already been written.
    func testSample() throws {
        let subject = PublishSubject<Int>()
        var behavior = [String]()

        _ = subject.subscribe(
            onNext: { behavior.append("onNext => \($0)") },
            onCompleted: { behavior.append("onCompleted") }
        )

        subject.onNext(1)
        subject.onCompleted()

        // !!
        // You should answer in other test cases so that the test passes as follows.
        // !!
        XCTAssertEqual(behavior, [
            "onNext => 1",
            "onCompleted",
        ])
    }

    func testPublishSubject() throws {
        // !! Edit only the XCTAssertEqual part. !!

        // Create a PublishSubject
        let subject = PublishSubject<Int>()

        var behavior = [String]()

        // PublishSubject can subscribe
        _ = subject.subscribe(
            onNext: { behavior.append("onNext:1 => \($0)") },
            onCompleted: { behavior.append("onCompleted:1") }
        )

        // PublishSubject can emit events.

        subject.onNext(1) // or `subject.on(.next(1))`
        subject.onNext(2)
        subject.onCompleted() // subject.on(.completed)

        // You can also emit an error.
        // subject.onError(SomeError))  or subject.on(.error(SomeError))

        _ = subject.subscribe(
            onNext: { behavior.append("onNext:2 => \($0)") },
            onCompleted: { behavior.append("onCompleted:2") }
        )

        subject.onNext(3)

        // Make sure you pass the `behavior` test, thinking about why this is the case.
        XCTAssertEqual(behavior, [
        ])
    }

    func testReplaySubject() throws {
        // !! Edit only the XCTAssertEqual part. !!

        // Create a ReplaySubject
        let subject = ReplaySubject<Int>.create(bufferSize: 1)

        var behavior = [String]()

        _ = subject.subscribe(
            onNext: { behavior.append("onNext:1 => \($0)") },
            onCompleted: { behavior.append("onCompleted:1") }
        )

        subject.onNext(1)
        subject.onNext(2)
        subject.onCompleted()

        _ = subject.subscribe(
            onNext: { behavior.append("onNext:2 => \($0)") },
            onCompleted: { behavior.append("onCompleted:2") }
        )

        subject.onNext(3)

        // Make sure you pass the `behavior` test, thinking about why this is the case.
        XCTAssertEqual(behavior, [
        ])
    }

    func testReplaySubject_Unbounded() throws {
        // !! Edit only the XCTAssertEqual part. !!

        // Create a ReplaySubject
        let subject = ReplaySubject<Int>.createUnbounded()

        var behavior = [String]()

        _ = subject.subscribe(
            onNext: { behavior.append("onNext:1 => \($0)") },
            onCompleted: { behavior.append("onCompleted:1") }
        )

        subject.onNext(1)
        subject.onNext(2)
        subject.onCompleted()

        _ = subject.subscribe(
            onNext: { behavior.append("onNext:2 => \($0)") },
            onCompleted: { behavior.append("onCompleted:2") }
        )

        subject.onNext(3)

        // Make sure you pass the `behavior` test, thinking about why this is the case.
        XCTAssertEqual(behavior, [
        ])
    }

    func testBehaviorSubject() throws {
        // !! Edit only the XCTAssertEqual part. !!

        // Create a BehaviorSubject
        let subject = BehaviorSubject<Int>(value: 0)

        var behavior = [String]()

        _ = subject.subscribe(
            onNext: { behavior.append("onNext:1 => \($0)") },
            onCompleted: { behavior.append("onCompleted:1") }
        )

        // BehaviorSubject can get the current value
        XCTAssertEqual(try subject.value(), Int.max, "Please correct it to the correct current value.")

        subject.onNext(1)
        subject.onNext(2)
        subject.onCompleted()

        _ = subject.subscribe(
            onNext: { behavior.append("onNext:2 => \($0)") },
            onCompleted: { behavior.append("onCompleted:2") }
        )

        subject.onNext(3)

        XCTAssertEqual(try subject.value(), Int.max, "Please correct it to the correct current value.")

        // Make sure you pass the `behavior` test, thinking about why this is the case.
        XCTAssertEqual(behavior, [
        ])
    }

    // MARK: - RxCocoa

    // Relay can’t terminate with error or completed. It can only emit values.

    func testPublishRelay() throws {
        // !! Edit only the XCTAssertEqual part. !!

        let relay = PublishRelay<Int>()

        var behavior = [String]()

        _ = relay.subscribe(
            onNext: { behavior.append("onNext:1 => \($0)") },
            onCompleted: { behavior.append("onCompleted:1") }
        )

        // Relay use `accept` instead of `onNext`.

        relay.accept(1)
        relay.accept(2)

        _ = relay.subscribe(
            onNext: { behavior.append("onNext:2 => \($0)") },
            onCompleted: { behavior.append("onCompleted:2") }
        )

        relay.accept(3)

        // Make sure you pass the `behavior` test, thinking about why this is the case.
        XCTAssertEqual(behavior, [
        ])
    }

    func testBehaviorRelay() throws {
        // !! Edit only the XCTAssertEqual part. !!

        let relay = BehaviorRelay(value: 0)

        // BehaviorSubject can get the current value
        XCTAssertEqual(relay.value, Int.max, "Please correct it to the correct current value.")

        var behavior = [String]()

        _ = relay.subscribe(
            onNext: { behavior.append("onNext:1 => \($0)") },
            onCompleted: { behavior.append("onCompleted:1") }
        )

        relay.accept(1)
        relay.accept(2)

        _ = relay.subscribe(
            onNext: { behavior.append("onNext:2 => \($0)") },
            onCompleted: { behavior.append("onCompleted:2") }
        )
        XCTAssertEqual(relay.value, Int.max, "Please correct it to the correct current value.")

        relay.accept(3)

        XCTAssertEqual(relay.value, Int.max, "Please correct it to the correct current value.")

        // Make sure you pass the `behavior` test, thinking about why this is the case.
        XCTAssertEqual(behavior, [
        ])
    }

    func testReplayRelay() throws {
        // !! Edit only the XCTAssertEqual part. !!

        let relay = ReplayRelay<Int>.create(bufferSize: 1)

        var behavior = [String]()

        _ = relay.subscribe(
            onNext: { behavior.append("onNext:1 => \($0)") },
            onCompleted: { behavior.append("onCompleted:1") }
        )

        relay.accept(1)
        relay.accept(2)

        _ = relay.subscribe(
            onNext: { behavior.append("onNext:2 => \($0)") },
            onCompleted: { behavior.append("onCompleted:2") }
        )

        relay.accept(3)

        // Make sure you pass the `behavior` test, thinking about why this is the case.
        XCTAssertEqual(behavior, [
        ])
    }
}
