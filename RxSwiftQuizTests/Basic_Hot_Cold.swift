//
//  Basic_Hot_Cold.swift
//  RxSwiftQuizTests
//
//

import RxSwift
import RxTest
import XCTest

// Cold/Hot
class Basic_Hot_Cold: XCTestCase {
    // This test code is a sample. The answer has already been written.
    func testExample() throws {
        let coldResult: TestableObserver<Int>
        do {
            let scheduler = TestScheduler(initialClock: 0)
            let cold = scheduler.createColdObservable([
                .next(100, 1),
                .next(200, 2),
                .next(300, 3),
            ])

            // !! Note the default argument for `scheduler.start`. !!
            // Subscribe when virtual time 200
            coldResult = scheduler.start { cold }
        }

        let hotResult: TestableObserver<Int>
        do {
            let scheduler = TestScheduler(initialClock: 0)
            let hot = scheduler.createHotObservable([
                .next(100, 1),
                .next(200, 2),
                .next(300, 3),
            ])
            // !! Note the default argument for `scheduler.start`. !!
            // Subscribe when virtual time 200
            hotResult = scheduler.start { hot }
        }

        XCTAssertRecordedElements(coldResult.events, [1, 2, 3])
        /* Why??

         `createColdObservable` creates *Cold* observable.
         *Cold* will start emitting values after it is subscribed.
         Cold = Don't produce heat.

         So you can get all the values because the values are emit after you subscribe.

         ex) Async operations, HTTP Connections, TCP connections, streams
         */

        XCTAssertRecordedElements(hotResult.events, [3])
        /* Why??

         `createHotObservable` creates *Hot* observable.
         *Hot* will start emitting values immediately even if it is not subscribed.
         Hot = Produce heat

         So you can only get the values that were emited after being subscribed.

         ex) Variables / properties / constants, tap coordinates, mouse coordinates, UI control values, current time
         */

        // More Info: `“Hot” and “Cold” Observables` in http://reactivex.io/documentation/observable.html
        // And: https://github.com/ReactiveX/RxSwift/blob/main/Documentation/HotAndColdObservables.md
    }

    // This test code is a sample. The answer has already been written.
    func testInputTextAndTapButton() throws {
        // Another example
        // ユーザーはテキストを入力した後にボタンを押すことができます.
        // The user can press the button after entering the text.

        let scheduler = TestScheduler(initialClock: 0)
        let inputTextEvents = scheduler.createHotObservable([
            .next(100, "a"),
            .next(200, "ab"),
            .next(300, "abc"),
            .next(400, "abcd"),
            .next(500, "abcde"),
        ])

        let tapButton = scheduler.createHotObservable([
            .next(200, ()),
            .next(350, ()),
            .next(600, ()),
        ])

        // !! Note the default argument for `scheduler.start`. !!
        // Subscribe when virtual time 200
        let result = scheduler.start {
            tapButton.withLatestFrom(inputTextEvents)
        }

        // `withLatestFrom` によって、tapButton のイベント時点での inputTextEvents の値が取得できます.
        // ただし tapButton の @200 のイベントは subscribe 前に発生しているので取得できません.
        // `withLatestFrom` will get the value of inputTextEvents at the time of the tapButton event.
        // However, the @200 event of tapButton cannot be obtained because they occurred before subscribe.
        XCTAssertEqual(result.events, [
            .next(350, "abc"),
            .next(600, "abcde"),
        ])
    }

    func testCold() throws {
        let scheduler = TestScheduler(initialClock: 0)
        let xs = scheduler.createColdObservable([
            .next(100, 1),
            .next(200, 2),
            .next(300, 3),
            .next(400, 4),
            .next(500, 5),
        ])

        // !! Note the default argument for `scheduler.start`. !!
        // Subscribe when virtual time 200
        let result = scheduler.start {
            xs.map { $0 * 10 }
        }

        // Let's explain why this happens after modifying it to pass the test.
        XCTAssertEqual(result.events, [
        ])

        XCTAssertEqual(xs.subscriptions, [Subscription(200, 1000)])
    }

    func testHot() throws {
        let scheduler = TestScheduler(initialClock: 0)
        let xs = scheduler.createHotObservable([
            .next(100, 1),
            .next(200, 2),
            .next(300, 3),
            .next(400, 4),
            .next(500, 5),
        ])

        // !! Note the default argument for `scheduler.start`. !!
        // Subscribe when virtual time 200
        let result = scheduler.start {
            xs.map { $0 * 10 }
        }

        // Let's explain why this happens after modifying it to pass the test.
        XCTAssertEqual(result.events, [
        ])

        XCTAssertEqual(xs.subscriptions, [Subscription(200, 1000)])
    }

    // Easy practice of Hot Cold conversion
    func testConvertHot_Cold() throws {
        var superHeavyTaskCallCount = 0

        // This is a very heavy task and I don't want to call it multiple times.
        func superHeavyTask(num: Int) -> Int {
            superHeavyTaskCallCount += 1
            return num
        }

        let scheduler = TestScheduler(initialClock: 0)

        // This is *Hot* observable
        let hot = scheduler.createHotObservable([
            .next(400, 1),
        ])

        // Hot な Observable を map すると Cold な Observable に変換されます。
        // 殆どの Operator は Cold な Observable を返します。
        // If you `map` a Hot Observable, it will be converted to a Cold Observable.
        // Most Operators, not just `map`, convert Hot Observables to Cold.
        let superHeavyTaskStream = hot
            .map { superHeavyTask(num: $0) } // <- This line is *Cold* observable
        // `share` operator converts a cold observable to a hot.
        // `share` は Cold な Observable を Hot に変換します.
        // .share() // <- Let's try whether how the behavior changes in there is this line.

        let obs1 = scheduler.createObserver(Int.self)
        let obs2 = scheduler.createObserver(Int.self)

        // 2箇所から subscribe します
        _ = superHeavyTaskStream.subscribe(obs1)
        _ = superHeavyTaskStream.subscribe(obs2)

        scheduler.start()

        XCTAssertEqual(superHeavyTaskCallCount, 1, "Super heavy task should be called only once.")
        XCTAssertEqual(obs1.events, [.next(400, 1)])
        XCTAssertEqual(obs2.events, [.next(400, 1)])

        /*

         Sequence.subscribe(Observer 1)
         Sequence.subscribe(Observer 2)

         ## If Sequence is *Cold*

         <Cold Sequence> ---> Observer 1
         <Cold Sequence> ---> Observer 2

         ## If Sequence is *Hot*

                            |---> Observer 1
         <Hot Sequence> --->|
                            |---> Observer 2

         */
    }

    func testPublish() throws {
        var superHeavyTaskCallCount = 0
        func superHeavyTask(num: Int) -> Int {
            superHeavyTaskCallCount += 1
            return num
        }

        let scheduler = TestScheduler(initialClock: 0)

        let hot = scheduler.createHotObservable([
            .next(400, 1),
        ])

        let superHeavyTaskStream = hot
            .map { superHeavyTask(num: $0) }
            .publish() // <- publish !!

        let obs1 = scheduler.createObserver(Int.self)
        let obs2 = scheduler.createObserver(Int.self)

        _ = superHeavyTaskStream.subscribe(obs1)
        _ = superHeavyTaskStream.subscribe(obs2)

        // Add a line below this and let the test pass.
        // この下に何か一行追加してテストを通過させてください.

        // ↓↓ Please do not edit below from here ↓↓
        scheduler.start()

        XCTAssertEqual(superHeavyTaskCallCount, 1, "Super heavy task should be called only once.")
        XCTAssertEqual(obs1.events, [.next(400, 1)])
        XCTAssertEqual(obs2.events, [.next(400, 1)])
    }

    func test1() throws {
        var superHeavyTaskCallCount = 0
        func superHeavyTask(_ str: String) -> String {
            superHeavyTaskCallCount += 1
            return str
        }

        let scheduler = TestScheduler(initialClock: 0)
        let inputTextEvents = scheduler.createHotObservable([
            .next(100, ""),
            .next(200, "a"),
            .next(300, "ab"),
            .next(400, "abc"),
            .next(500, "abcd"),
        ])

        let tapButton = scheduler.createHotObservable([
            .next(150, ()),
            .next(350, ()),
        ])

        // Write code that passes the test using inputTextEvents and tapButton.

        let inputString: Observable<String> = .just("") // Rewrite it in your code.
        let validate: Observable<Bool> = .just(true) // Rewrite it in your code.

        // ↓↓ Please do not edit below from here ↓↓

        let observer1 = scheduler.createObserver(String.self)
        let observer2 = scheduler.createObserver(Bool.self)

        _ = inputString.subscribe(observer1)
        _ = validate.subscribe(observer2)

        scheduler.start()

        XCTAssertEqual(superHeavyTaskCallCount, 2, "Super heavy task should be called only twice.")
        XCTAssertEqual(observer1.events, [
            .next(150, ""),
            .next(350, "ab"),
        ], "Get the value of inputTextEvents at the time of the tapButton event.")

        XCTAssertEqual(observer2.events, [
            .next(150, false),
            .next(350, true),
        ], "True if one or more characters are entered")
    }

    func testReplay() throws {
        do {
            let scheduler = TestScheduler(initialClock: 0)
            let valueFromAPI = scheduler.createHotObservable([
                .next(300, 1),
                .completed(350),
            ]).share()

            let obs1 = scheduler.createObserver(Int.self)
            let obs2 = scheduler.createObserver(Int.self)

            scheduler.scheduleAt(200) {
                _ = valueFromAPI.subscribe(obs1)
            }

            scheduler.scheduleAt(350) {
                _ = valueFromAPI.subscribe(obs2)
            }

            scheduler.start()

            XCTAssertEqual(obs1.events, [
                .next(300, 1),
                .completed(350),
            ])
            XCTAssertEqual(obs2.events, [], "Why?")
        }

        do {
            let scheduler = TestScheduler(initialClock: 0)
            let valueFromAPI = scheduler.createHotObservable([
                .next(300, 1),
                .completed(350),
            ]).share(replay: 1) // <-!! share(reply: 1) ????????

            let obs1 = scheduler.createObserver(Int.self)
            let obs2 = scheduler.createObserver(Int.self)

            scheduler.scheduleAt(200) {
                _ = valueFromAPI.subscribe(obs1)
            }

            scheduler.scheduleAt(350) {
                _ = valueFromAPI.subscribe(obs2)
            }

            scheduler.start()

            XCTAssertEqual(obs1.events, [
                .next(300, 1),
                .completed(350),
            ])
            XCTAssertEqual(obs2.events, [], "Why?")
        }
    }
}

// Answers

/*
 ## test1

 ```
 let inputString = tapButton
     .withLatestFrom(inputTextEvents)
     .map { superHeavyTask($0) }
     .share() // or `publish` & `connect`

 let validate: Observable<Bool> = inputString
     .map { $0.count > 0 }
 ```

 */
