//
//  AppConfigurationTests.swift
//  FlashQuiz
//
//  Created by Brennan Stehling on 7/17/16.
//  Copyright © 2016 SmallSharpTools. All rights reserved.
//

import XCTest

class AppConfigurationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBundleIndentifier() {
        XCTAssertNotNil(AppConfiguration.bundleIdentifier())
    }

    func testDisplayName() {
        XCTAssertNotNil(AppConfiguration.bundleDisplayName())
    }

    func testAppName() {
        XCTAssertNotNil(AppConfiguration.appName())
    }

    func testAppVersion() {
        XCTAssertNotNil(AppConfiguration.appVersion())
    }

    func testDebugging() {
        let enableDebugging = ProcessInfo.processInfo.environment["EnableDebugging"]
        var rawIsDebugging: Bool = false
        if let enableDebugging = enableDebugging {
            rawIsDebugging = NSString(string: enableDebugging).boolValue
        }

        let isDebugging = AppConfiguration.isDebuggingEnabled()
        XCTAssertEqual(rawIsDebugging, isDebugging)
    }

    func testIsUnitTesting() {
        XCTAssertTrue(AppConfiguration.isUnitTesting())
    }

    func testMyAppSettingsNotNil() {
        let myAppsettings = AppConfiguration.myAppsettings()
        XCTAssertNotNil(myAppsettings, "Value must be defined")
    }

    func testFileURLNotNil() {
        let fileURL = AppConfiguration.questionsFileURL()
        XCTAssertNotNil(fileURL, "Value must be defined")
    }

}
