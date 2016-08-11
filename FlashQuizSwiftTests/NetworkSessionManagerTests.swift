//
//  NetworkSessionManagerTests.swift
//  FlashQuiz
//
//  Created by Brennan Stehling on 7/17/16.
//  Copyright © 2016 SmallSharpTools. All rights reserved.
//

import XCTest

class NetworkSessionManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchingJSON() {
        let expectation = self.expectationWithDescription("Fetching JSON")

        guard let jsonURL = NSURL(string: "https://sst-robots.s3.amazonaws.com/data.json") else {
            XCTFail("Unable to create URL")
            return
        }

        let manager = NetworkSessionManager()
        manager.fetchJSONWithURL(jsonURL, params: nil) { (json, error) in
            XCTAssertTrue(NSThread.isMainThread(), "Must be main thread")
            XCTAssertNil(error, "Error is not expected")
            XCTAssertNotNil(json, "JSON is expected")
            if let json = json {
                XCTAssertTrue(json.isKindOfClass(NSDictionary), "Must be a dictionary")
            }

            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 10
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testFetchingImage() {
        let expectation = self.expectationWithDescription("Fetching Image")

        guard let imageURL = NSURL(string: "https://sst-robots.s3.amazonaws.com/robot.jpg") else {
            XCTFail("Unable to create URL")
            return
        }

        let manager = NetworkSessionManager()
        manager.fetchImageWithURL(imageURL, params: nil) { (image, error) in
            XCTAssertTrue(NSThread.isMainThread(), "Must be main thread")
            XCTAssertNil(error, "Error is not expected")
            XCTAssertNotNil(image, "Image is expected")

            expectation.fulfill()
        }

        let timeout: NSTimeInterval = 10
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testFetchingImages() {
        let fileURL = AppConfiguration.questionsFileURL()
        let questions = Question.questionsWithFileURL(fileURL)
        let manager = NetworkSessionManager()

        let expectation = self.expectationWithDescription("Fetching Images")

        XCTAssertNotNil(questions)
        if let questions = questions {
            let question = questions.first
            XCTAssertNotNil(question)

            var count: Int = 0

            if let question = question {
                XCTAssert(question.answers.count > 0)
                for answer in question.answers {
                    print("Answer: \(answer)")
                    let imageURL = NSURL(string: answer)
                    if let imageURL = imageURL {
                        manager.fetchImageWithURL(imageURL, params: nil, withCompletionBlock: { (image, error) in
                            XCTAssertNil(error, "Error is not expected")
                            XCTAssertNotNil(image, "Image is expected")
                            count += 1

                            if count == question.answers.count {
                                expectation.fulfill()
                            }
                        })

                    }
                }
            }
        }
        
        let timeout: NSTimeInterval = 10
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testNoCompletionBlocks() {
        let anyURL = NSURL(string: "")
        let manager = NetworkSessionManager()

        let task1 = manager.fetchJSONWithURL(anyURL!, params: nil, withCompletionBlock: nil)
        let task2 = manager.fetchImageWithURL(anyURL!, params: nil, withCompletionBlock: nil)
        let task3 = manager.fetchDataWithURL(anyURL!, params: nil, withCompletionBlock: nil)

        XCTAssertNil(task1)
        XCTAssertNil(task2)
        XCTAssertNil(task3)
    }

}
