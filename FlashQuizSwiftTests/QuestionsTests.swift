//
//  QuestionsTests.swift
//  FlashQuiz
//
//  Created by Brennan Stehling on 7/17/16.
//  Copyright © 2016 SmallSharpTools. All rights reserved.
//

import XCTest

class QuestionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testLoadingQuestions1() {
        let fileURL: NSURL? = nil
        let questions = Question.questionsWithFileURL(fileURL)
        XCTAssertNil(questions)
    }

    func testLoadingQuestions() {
        let fileURL = AppConfiguration.questionsFileURL()
        let questions = Question.questionsWithFileURL(fileURL)
        XCTAssertNotNil(questions, "A valid value is expected")
        if let questions = questions {
            XCTAssertTrue(questions.count > 0, "Count is exected to be greater than zero")
        }
    }

    func testLoadingQuestions3() {
        let bundle = NSBundle(forClass: self.classForCoder)
        let path = bundle.pathForResource("invalid", ofType: "json")
        XCTAssertNotNil(path, "Path is required")
        if let path = path {
            let fileURL = NSURL(string: path)
            let questions = Question.questionsWithFileURL(fileURL)
            if let questions = questions {
                XCTAssertNil(questions, "A nil value is expected")
            }
        }
    }

    func testLoadingPerformance() {
        self.measureBlock { 
            let fileURL = AppConfiguration.questionsFileURL()
            let questions = Question.questionsWithFileURL(fileURL)
            XCTAssertNotNil(questions, "A valid value is expected")
        }
    }

}
