//
//  Intermediate.swift
//  RxSwiftQuizTests
//
//

import RxSwift
import RxTest
import XCTest

// TBD
class Intermediate: XCTestCase {
    func test1() throws {
        var apiResponse = 0
        func requestAPI() -> Single<Int> {
            defer { apiResponse += 1 }
            return .just(apiResponse)
                .delay(.milliseconds(5 - apiResponse), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
        }

        let tasks = Observable.of(
            requestAPI(),
            requestAPI(),
            requestAPI(),
            requestAPI()
        )

        let answer1 = tasks.concat()
        let answer2 = tasks.merge()

        XCTAssertEqual(try answer1.toBlocking().toArray(), [0, 1, 2, 3])
        XCTAssertEqual(try answer2.toBlocking().toArray(), [3, 2, 1, 0])
    }

    func test2() throws {
        let scheduler = TestScheduler(initialClock: 0)

        let tasks = scheduler.createColdObservable([
            .next(10, 1),
            .next(20, 2),
            .next(30, 3),
            .next(40, 4),
        ])

        let tapStartButton = scheduler.createHotObservable([
            .next(100, ()),
        ])
        let tapCancelButton = scheduler.createHotObservable([
            .next(130, ()),
        ])

        let result = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            tapStartButton
                .flatMap { tasks }
                .take(until: tapCancelButton)
        }

        XCTAssertEqual(result.events, [
            .next(110, 1),
            .next(120, 2),
            .completed(130),
        ])
    }
}
