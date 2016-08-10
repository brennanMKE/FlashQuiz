//
//  QuizSessionViewControllerTests.swift
//  FlashQuiz
//
//  Created by Brennan Stehling on 7/17/16.
//  Copyright © 2016 SmallSharpTools. All rights reserved.
//

import XCTest
import UIKit

class QuizSessionViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRoot() {
        let nc = getNavigationController()
        XCTAssertNotNil(nc)
    }

    func testViewController1() {
        let expectation = expectationWithDescription("UI")

        guard let nc = getNavigationController() else {
            XCTFail()
            return
        }

        nc.popToRootViewControllerAnimated(false)

        guard let vc = nc.topViewController as? StartQuizViewController else {
            XCTFail()
            return
        }

        vc.performSegueWithIdentifier("pushQuizSession", sender: vc)

        dispatch_after(whenInSeconds(0.5), dispatch_get_main_queue()) {
            guard let qs = nc.topViewController as? QuizSessionViewController,
                let collectionView = qs.collectionView else {
                    XCTFail()
                    return
            }

            collectionView.reloadData()

            var currentQuestion = qs.quizSession.currentQuestion
            while currentQuestion != nil {
                guard let question = currentQuestion,
                    let answer = question.answers.first else {
                        XCTFail()
                        break
                }
                qs.submitAnswer(answer)
                currentQuestion = qs.quizSession.currentQuestion
            }

            dispatch_after(self.whenInSeconds(0.25), dispatch_get_main_queue()) {
                expectation.fulfill()
            }
        }

        let timeout: NSTimeInterval = 10
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testViewController2() {
        let expectation = expectationWithDescription("UI")

        guard let nc = getNavigationController() else {
            XCTFail()
            return
        }

        nc.popToRootViewControllerAnimated(false)

        guard let vc = nc.topViewController as? StartQuizViewController else {
            XCTFail()
            return
        }

        vc.performSegueWithIdentifier("pushQuizSession", sender: vc)

        dispatch_after(whenInSeconds(0.5), dispatch_get_main_queue()) {
            guard let qs = nc.topViewController as? QuizSessionViewController,
                let collectionView = qs.collectionView else {
                    XCTFail()
                    return
            }

            collectionView.reloadData()

            var currentQuestion = qs.quizSession.currentQuestion
            guard let lastQuestion = qs.quizSession.questions.last else {
                XCTFail()
                return
            }

            // submit all answers except the last one
            while currentQuestion != nil && currentQuestion != lastQuestion {
                guard let question = currentQuestion,
                    let answer = question.answers.first else {
                        XCTFail()
                        break
                }
                qs.submitAnswer(answer)
                currentQuestion = qs.quizSession.currentQuestion
            }

            qs.expireAfterTimeout()

            dispatch_after(self.whenInSeconds(0.25), dispatch_get_main_queue()) {
                expectation.fulfill()
            }
        }

        let timeout: NSTimeInterval = 10
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    func testViewController3() {
        let expectation = expectationWithDescription("UI")

        guard let nc = getNavigationController() else {
            XCTFail()
            return
        }

        nc.popToRootViewControllerAnimated(false)

        guard let vc = nc.topViewController as? StartQuizViewController else {
            XCTFail()
            return
        }

        vc.performSegueWithIdentifier("pushQuizSession", sender: vc)

        dispatch_after(whenInSeconds(0.5), dispatch_get_main_queue()) {
            guard let qs = nc.topViewController as? QuizSessionViewController,
                let collectionView = qs.collectionView else {
                    XCTFail()
                    return
            }

            while !qs.quizSession.isSessionCompleted {
                guard let indexPath = collectionView.indexPathsForVisibleItems().first else {
                        XCTFail()
                        break
                }
                collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                qs.submitButtonTapped(qs.submitButton)
            }

            dispatch_after(self.whenInSeconds(0.25), dispatch_get_main_queue()) {
                expectation.fulfill()
            }
        }

        let timeout: NSTimeInterval = 10
        self.waitForExpectationsWithTimeout(timeout) { (error) in
            // do nothing
        }
    }

    // MARK: Private -

    private func whenInSeconds(seconds: Double) -> dispatch_time_t {
        return dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
    }

    private func getNavigationController() -> UINavigationController? {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate,
        let navigationController = appDelegate.window.rootViewController as? UINavigationController {
            return navigationController
        }

        return nil
    }

}
