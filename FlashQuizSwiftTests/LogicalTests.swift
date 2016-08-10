//
//  LogicalTests.swift
//  FlashQuiz
//
//  Created by Brennan Stehling on 7/17/16.
//  Copyright © 2016 SmallSharpTools. All rights reserved.
//

import XCTest

class LogicalTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBoolStrings() {
        XCTAssertTrue(NSString(string: "1").boolValue)
        XCTAssertTrue(NSString(string: "yes").boolValue)
        XCTAssertTrue(NSString(string: "YES").boolValue)
        XCTAssertTrue(NSString(string: "true").boolValue)
        XCTAssertTrue(NSString(string: "TRUE").boolValue)

        XCTAssertFalse(NSString(string: "0").boolValue)
        XCTAssertFalse(NSString(string: "no").boolValue)
        XCTAssertFalse(NSString(string: "NO").boolValue)
        XCTAssertFalse(NSString(string: "false").boolValue)
        XCTAssertFalse(NSString(string: "FALSE").boolValue)
    }

}
