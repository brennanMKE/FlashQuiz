//
//  QuizSessionTests.swift
//  FlashQuiz
//
//  Created by Brennan Stehling on 7/17/16.
//  Copyright © 2016 SmallSharpTools. All rights reserved.
//

import XCTest

class QuizSessionTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLoadQuizSession() {
        let questions = Question.questions(withFileURL: AppConfiguration.questionsFileURL())
        XCTAssertNotNil(questions, "Questions must be defined")
        if let questions = questions {
            let quizSession = QuizSession<AnyObject>(questions: questions)
            XCTAssertGreaterThan(quizSession?.questions.count ?? 0, 0)
            XCTAssertNotNil(quizSession, "Valid value is expected")
        }
        else {
            XCTFail()
        }
    }

    // How are generics going to work between Objective-C and Swift?

    // Note: Lightweight Generics in Objective-C are not available to Swift.
    //
    // Objective-C declarations of NSArray, NSSet and NSDictionary types using 
    // lightweight generic parameterization are imported by Swift with 
    // information about the type of their contents preserved.
    // See: https://forums.developer.apple.com/thread/7394

    func testShufflingArray() {
        let numbers: [Int] = [1, 2, 3, 4, 5]
        let quizSession = QuizSession<AnyObject>()

        guard let randomNumbers = quizSession.shuffleArray(numbers as [AnyObject]) as? [Int] else {
            XCTFail()
            return
        }

        // Note: Testing randomness is not 100% accurate since the result could be
        // in the same order but with enough values that will be very unlikely.

        XCTAssertTrue(numbers.count == randomNumbers.count, "Counts should match")

        var notMatched: Bool = false
        for (index, original) in numbers.enumerated() {
            let random = randomNumbers[index]
            if original != random {
                notMatched = true
                break
            }
        }

        XCTAssertTrue(notMatched, "Random array should not match original array")
    }

    func testShuffleQuestions() {
        guard let questions = Question.questions(withFileURL: AppConfiguration.questionsFileURL()),
            let quizSession = QuizSession<AnyObject>(questions: questions) else {
                XCTFail()
                return
        }

        XCTAssertNotNil(questions, "Valid value is expected")
        XCTAssertNotNil(quizSession, "Valid value is expected")

        quizSession.shuffleQuestions()

        var notMatched: Bool = false
        for (index, question) in quizSession.questions.enumerated() {
            let random = questions[index]
            if question != random {
                notMatched = true
                break
            }
        }

        if AppConfiguration.isShuffleEnabled() {
            XCTAssertTrue(notMatched, "Random array should not match original array")
        }
        else {
            XCTAssertFalse(notMatched, "Random array should not match original array")
        }
    }

    func testQuestionForPrompt() {
        guard let questions = Question.questions(withFileURL: AppConfiguration.questionsFileURL()),
            let quizSession = QuizSession<AnyObject>(questions: questions) else {
                XCTFail()
                return
        }

        XCTAssertNotNil(questions, "Valid value is expected")
        XCTAssertNotNil(quizSession, "Valid value is expected")

        for (_, question) in questions.enumerated() {
            let otherQuestion = quizSession.question(forPrompt: question.prompt)
            XCTAssertTrue(question.prompt == otherQuestion?.prompt)
        }
    }

    func testUUID() {
        let quizSession = QuizSession<AnyObject>()
        XCTAssertNotNil(quizSession, "Valid value is expected")

        let uuidString1 = quizSession.uuidString()
        let uuidString2 = quizSession.uuidString()

        XCTAssertTrue(uuidString1.characters.count > 0, "String is required")
        XCTAssertTrue(uuidString2.characters.count > 0, "String is required")
        XCTAssertFalse(uuidString1 == uuidString2, "Strings must not be equal")
    }

    func testShufflingPerformance() {
        self.measure {
            guard let questions = Question.questions(withFileURL: AppConfiguration.questionsFileURL()),
                let quizSession = QuizSession<AnyObject>(questions: questions) else {
                    XCTFail()
                    return
            }

            XCTAssertNotNil(questions, "Valid value is expected")
            XCTAssertNotNil(quizSession, "Valid value is expected")

            quizSession.shuffleQuestions()
        }
    }

    func testQuizSessionAnsweringQuestions() {
        self.measure {
            guard let questions = Question.questions(withFileURL: AppConfiguration.questionsFileURL()),
                let quizSession = QuizSession<AnyObject>(questions: questions) else {
                    XCTFail()
                    return
            }

            XCTAssertNotNil(questions, "Valid value is expected")
            XCTAssertNotNil(quizSession, "Valid value is expected")

            quizSession.startNewSession()

            var currentQuestion = quizSession.currentQuestion
            while currentQuestion != nil {
                if let answer = currentQuestion?.answers.first {
                    quizSession.submitAnswer(answer)
                    currentQuestion = quizSession.currentQuestion
                }
                else {
                    XCTFail()
                    break
                }
            }

            XCTAssertTrue(quizSession.isSessionCompleted, "Session should be completed")

            // Now store the session to the Documents folder
            quizSession.completeCurrentSession()

            quizSession.startNewSession()

            XCTAssertTrue(quizSession.answers.count == 0, "Answers count should be zero")

            XCTAssertNotNil(questions, "Valid value is expected")
            XCTAssertNotNil(quizSession, "Valid value is expected")
        }
    }

}
