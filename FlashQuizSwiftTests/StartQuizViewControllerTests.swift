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
            nc.popToRootViewController(animated: false)
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
