//
//  Basic_Combine.swift
//  RxSwiftQuizTests
//
//

import RxSwift
import RxTest
import XCTest

class Basic_Combine: XCTestCase {
    func testSample() throws {
        let o1 = Observable.of("1", "2", "3")
        let o2 = Observable.of("10", "20", "30")

        // Check the difference in operation of zip, merge, concat, combineLatest, withLatestFrom

        let zip: Observable<String> = Observable
            .zip(o1, o2)
            .map { $0.0 + "-" + $0.1 }

        let merge: Observable<String> = Observable
            .merge(o1, o2)

        let concat: Observable<String> = Observable
            .concat(o1, o2)

        let combineLatest: Observable<String> = Observable
            .combineLatest(o1, o2)
            .map { $0.0 + "-" + $0.1 }

        let withLatestFrom: Observable<String> = o1.withLatestFrom(o2)

        XCTAssertEqual(try zip.toBlocking().toArray(), ["1-10", "2-20", "3-30"], "map { $0.0 + \"-\" + $0.1}")
        XCTAssertEqual(try merge.toBlocking().toArray(), ["1", "10", "2", "20", "3", "30"])
        XCTAssertEqual(try concat.toBlocking().toArray(), ["1", "2", "3", "10", "20", "30"])
        XCTAssertEqual(try combineLatest.toBlocking().toArray(), ["1-10", "2-10", "2-20", "3-20", "3-30"])
        XCTAssertEqual(try withLatestFrom.toBlocking().toArray(), ["10", "20", "30"])
    }

    func test1() throws {
        let o1 = Observable.of(1, 2, 3)
        let o2 = Observable.of("a", "b", "c")

        let answer1 = Observable.just("") // Rewrite the code to pass the test case.
        let answer2 = Observable.just("") // Rewrite the code to pass the test case.

        // ↓↓ Please do not edit below from here ↓↓

        XCTAssertEqual(try answer1.toBlocking().toArray(), ["1a", "2b", "3c"], "o1[0] + o2[0], o1[1] + o2[1], ...")
        XCTAssertEqual(try answer2.toBlocking().toArray(), ["1", "a", "2", "b", "3", "c"], "o1[0], o2[0], o1[1], o2[1], ...")
    }

    func test2() throws {
        let scheduler = TestScheduler(initialClock: 0)
        let inputTextEvents = scheduler.createHotObservable([
            .next(100, ""),
            .next(200, "a"),
            .next(300, "ab"),
            .next(400, "abc"),
        ])

        let tapButton = scheduler.createHotObservable([
            .next(150, ()),
            .next(350, ()),
        ])

        let answer = Observable.just("") // Rewrite the code to pass the test case.

        // ↓↓ Please do not edit below from here ↓↓

        let result = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            answer
        }
        XCTAssertEqual(result.events, [
            .next(150, ""),
            .next(350, "ab"),
        ], "The latest Text value when tapButton is pressed")
    }

    func test3() throws {
        let scheduler = TestScheduler(initialClock: 0)
        let inputTextEvents = scheduler.createHotObservable([
            .next(100, ""),
            .next(200, "a"),
            .next(300, "ab"),
            .next(400, "abc"),
        ])

        let tapButton = scheduler.createHotObservable([
            .next(150, ()),
            .next(250, ()),
            .next(350, ()),
        ])

        let condition = scheduler.createHotObservable([
            .next(0, false),
            .next(200, true),
            .next(300, false),
        ])

        let result = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            // Rewrite the code to pass the test case.
            tapButton.map { "" }
        }

        // ↓↓ Please do not edit below from here ↓↓
        XCTAssertEqual(result.events, [
            .next(250, "a"),
        ], "The latest Text value when tapButton is pressed when the `condition` is true")
    }

    func test4() throws {
        let scheduler = TestScheduler(initialClock: 0)
        let inputTextEvents = scheduler.createHotObservable([
            .next(100, ""),
            .next(200, "a"),
            .next(300, "ab"),
            .next(400, "abc"),
        ])

        let anotherTextEvents = scheduler.createHotObservable([
            .next(50, ""),
            .next(150, "A"),
            .next(250, "AB"),
            .next(350, "ABC"),
            .next(450, "ABCD"),
        ])

        let tapButton = scheduler.createHotObservable([
            .next(150, ()),
            .next(250, ()),
            .next(350, ()),
        ])

        let result = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            // Rewrite the code to pass the test case.
            tapButton.map { "" }
        }

        // ↓↓ Please do not edit below from here ↓↓
        XCTAssertEqual(result.events, [
            .next(250, "aAB"),
            .next(350, "abABC"),
        ], "The latest value when the button is pressed when the values of two InputText are one or more characters")
    }

    // Observable<Observable<Int>>
    func test5() throws {
        let tasks: Observable<Observable<Int>> = Observable.of(1, 2, 3)
            .map { Observable.just($0) }

        // Rewrite the code to pass the test case.
        let answer1 = tasks.map { _ in 0 }
        let answer2 = tasks.map { _ in 0 }

        // ↓↓ Please do not edit below from here ↓↓
        XCTAssertEqual(try answer1.toBlocking().toArray(), [1, 3], "Only odd number")
        XCTAssertEqual(try answer2.toBlocking().toArray(), [10, 20, 30], "* 10")
    }

    func test6() throws {
        let a = Observable.of(1, 2, 3, 4)
        let b = Observable.of(true, false, false, true)

        let answer = Observable.just(0)

        XCTAssertEqual(try answer.toBlocking().toArray(), [1, 4], "Only the value when `b` is true")
    }

    func test7() throws {}
}

// Ansowers
/*

  ## test1

  ```swift
  let answer1 = Observable.zip(o1, o2) { "\($0)" + $1 }
  let answer2 = Observable.merge(o1.map { "\($0)" }, o2)
  ```

  ## test2

  ```swift
  tapButton.withLatestFrom(inputTextEvents)
  ```

  ## test3

  ```swift
  tapButton
      .withLatestFrom(condition)
      .filter { $0 }
      .withLatestFrom(inputTextEvents)
  ```

  ## test4

  ```swift

   tapButton
      .withLatestFrom(inputTextEvents.filter { $0.count > 0 })
      .withLatestFrom(anotherTextEvents.filter { $0.count > 0 })
          { $0 + $1 }
 // OR

  tapButton
      .withLatestFrom(
          Observable.combineLatest(inputTextEvents, anotherTextEvents)
      )
      .filter { $0.0.count > 0 && $0.1.count > 0 }
      .map { $0 + $1 }
  ```

  ## test5

  ```swift

  let answer1 = tasks.merge().filter { $0 % 2 != 0 }
  let answer2 = tasks.merge().map { $0 * 10 }
  ```

  ## test6

  ```swift
  let answer = Observable.zip(a, b)
      .filter { $0.1 }
      .map { $0.0 }

  // Or

  let answer = Observable.zip(a, b)
      .compactMap { $0.1 ? $0.0 : nil }
  ```

  */
