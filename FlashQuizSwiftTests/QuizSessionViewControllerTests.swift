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
        let expectation = self.expectation(description: "UI")

        guard let nc = getNavigationController() else {
            XCTFail("Failed to get navigation controller")
            return
        }

        nc.popToRootViewController(animated: false)

        guard let vc = nc.topViewController as? StartQuizViewController else {
            XCTFail()
            return
        }

        vc.performSegue(withIdentifier: "pushQuizSession", sender: vc)

        DispatchQueue.main.asyncAfter(deadline: whenInSeconds(1.5)) {
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

            DispatchQueue.main.asyncAfter(deadline: self.whenInSeconds(0.75)) {
                expectation.fulfill()
            }
        }

        let timeout: TimeInterval = 10
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testViewController2() {
        let expectation = self.expectation(description: "UI")

        guard let nc = getNavigationController() else {
            XCTFail("Failed to get navigation controller")
            return
        }

        nc.popToRootViewController(animated: false)

        guard let vc = nc.topViewController as? StartQuizViewController else {
            XCTFail()
            return
        }

        vc.performSegue(withIdentifier: "pushQuizSession", sender: vc)

        DispatchQueue.main.asyncAfter(deadline: whenInSeconds(1.5)) {
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

            DispatchQueue.main.asyncAfter(deadline: self.whenInSeconds(0.75)) {
                expectation.fulfill()
            }
        }

        let timeout: TimeInterval = 10
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    func testViewController3() {
        let expectation = self.expectation(description: "UI")

        guard let nc = getNavigationController() else {
            XCTFail("Failed to get navigation controller")
            return
        }

        nc.popToRootViewController(animated: false)

        guard let vc = nc.topViewController as? StartQuizViewController else {
            XCTFail()
            return
        }

        vc.performSegue(withIdentifier: "pushQuizSession", sender: vc)

        DispatchQueue.main.asyncAfter(deadline: whenInSeconds(1.5)) {
            guard let qs = nc.topViewController as? QuizSessionViewController,
                let collectionView = qs.collectionView else {
                    XCTFail()
                    return
            }

            while !qs.quizSession.isSessionCompleted {
                guard let indexPath = collectionView.indexPathsForVisibleItems.first else {
                        XCTFail()
                        break
                }
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
                qs.submitButtonTapped(qs.submitButton)
            }

            DispatchQueue.main.asyncAfter(deadline: self.whenInSeconds(0.75)) {
                expectation.fulfill()
            }
        }

        let timeout: TimeInterval = 10
        self.waitForExpectations(timeout: timeout) { (error) in
            // do nothing
        }
    }

    // MARK: Private -

    fileprivate func whenInSeconds(_ seconds: Double) -> DispatchTime {
        return DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    }

    fileprivate func getNavigationController() -> UINavigationController? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
        let navigationController = appDelegate.window.rootViewController as? UINavigationController {
            return navigationController
        }

        return nil
    }

}
