//
//  StartQuizViewControllerTests.swift
//  FlashQuiz
//
//  Created by Brennan Stehling on 7/17/16.
//  Copyright © 2016 SmallSharpTools. All rights reserved.
//

import XCTest
import UIKit

class StartQuizViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testViewControllerGenerically() {
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
            nc.popToRootViewControllerAnimated(false)
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
