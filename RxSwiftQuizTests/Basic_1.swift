//
//  Basic_1.swift
//  RxSwiftQuizTests
//
//

import RxBlocking
import RxSwift
import RxTest
import XCTest

// Super basic Level
class Basic_1: XCTestCase {
    let oneToFiveEvent = Observable.of(1, 2, 3, 4, 5)
    let sameValueEvent = Observable.of(1, 1, 1, 2, 2)

    /*

     !! Here are some tips and answers !!

     https://github.com/mironal/RxSwiftQuiz/blob/main/Answers/Answers_Basic1.md

      */

    // This test code is a sample. The answer has already been written.
    func testSample() throws {
        // Write the code to convert `oneToFiveEvent` so that the test passes
        let answer = oneToFiveEvent
            .map { $0 * 2 } // <- You write the code so that the test passes like this.

        // ↓↓ Please do not edit below from here ↓↓
        let result = try answer.toBlocking().toArray()
        XCTAssertEqual(result, [2, 4, 6, 8, 10], "Each value will be doubled")
    }

    func test1() throws {
        // Write the code to convert `oneToFiveEvent` so that the test passes
        let answer = oneToFiveEvent // 1, 2, 3, 4, 5

        // ↓↓ Please do not edit below from here ↓↓
        let result = try answer.toBlocking().toArray()
        XCTAssertEqual(result, [1, 3, 5], "Odd only")
    }

    func test2() throws {
        // Write the code to convert `oneToFiveEvent` so that the test passes
        let answer = oneToFiveEvent

        // ↓↓ Please do not edit below from here ↓↓
        let result = try answer.toBlocking().toArray()
        XCTAssertEqual(result, [15], "Total only")
    }

    func test3() throws {
        // Write the code to convert `oneToFiveEvent` so that the test passes
        let answer = oneToFiveEvent

        // ↓↓ Please do not edit below from here ↓↓
        let result = try answer.toBlocking().toArray()
        XCTAssertEqual(result, [1, 3, 6, 10, 15], "The added values are emitted in sequence")
    }

    func test4() throws {
        // Write the code to convert `oneToFiveEvent` so that the test passes
        let answer = oneToFiveEvent

        // ↓↓ Please do not edit below from here ↓↓
        let result = try answer.toBlocking().toArray()
        XCTAssertEqual(result, [0, 1, 2, 3, 4, 5], "Zero is added to the beginning")
    }

    func test5() throws {
        // Write the code to convert `oneToFiveEvent` so that the test passes
        let answer = oneToFiveEvent

        // ↓↓ Please do not edit below from here ↓↓
        let result = try answer.toBlocking().toArray()
        XCTAssertEqual(result, [2, 3, 4, 5, 6], "Add 1 to each value")
    }

    func test6() throws {
        // Write the code to convert `sameValueEvent` so that the test passes
        let answer = sameValueEvent // 1, 1, 1, 2, 2

        // ↓↓ Please do not edit below from here ↓↓
        let result = try answer.toBlocking().toArray()
        XCTAssertEqual(result, [2, 2, 2, 4, 4], "Each value will be doubled")
    }

    func test7() throws {
        // Write the code to convert `sameValueEvent` so that the test passes
        let answer = sameValueEvent

        // ↓↓ Please do not edit below from here ↓↓
        let result = try answer.toBlocking().toArray()
        XCTAssertEqual(result, [1, 1], "First two values")
    }

    func test8() throws {
        // Write the code to convert `sameValueEvent` so that the test passes
        let answer = sameValueEvent

        // ↓↓ Please do not edit below from here ↓↓
        let result = try answer.toBlocking().toArray()
        XCTAssertEqual(result, [1, 2], "Remove duplicate values")
    }

    func test9() throws {
        // Write the code to convert `sameValueEvent` so that the test passes
        let answer = sameValueEvent

        // ↓↓ Please do not edit below from here ↓↓
        let result = try answer.toBlocking().toArray()
        XCTAssertEqual(result, [2], "Get 2 only once")
    }

    func test10() throws {
        // Write the code to convert `sameValueEvent` so that the test passes
        let answer = sameValueEvent

        // ↓↓ Please do not edit below from here ↓↓
        let result = try answer.toBlocking().toArray()
        XCTAssertEqual(result, [], "Only completed")
    }
}
