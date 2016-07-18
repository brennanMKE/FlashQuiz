//
//  AppConfigurationTests.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/9/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AppConfiguration.h"

@interface AppConfigurationTests : XCTestCase

@end

@implementation AppConfigurationTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBundleIndentifier {
    XCTAssertNotNil([AppConfiguration bundleIdentifier]);
}

- (void)testDisplayName {
    XCTAssertNotNil([AppConfiguration bundleDisplayName]);
}

- (void)testAppName {
    XCTAssertNotNil([AppConfiguration appName]);
}

- (void)testAppVersion {
    XCTAssertNotNil([AppConfiguration appVersion]);
}

- (void)testDebugging {
    XCTAssertNotNil(@([AppConfiguration isDebuggingEnabled]));
}

- (void)testIsUnitTesting {
    XCTAssertTrue([AppConfiguration isUnitTesting]);
}

- (void)testMyAppSettingsNotNil {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    NSDictionary *myAppsettings = [AppConfiguration myAppsettings];
    XCTAssertNotNil(myAppsettings, @"Value must be defined");
}

- (void)testFileURLNotNil {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    NSURL *fileURL = [AppConfiguration questionsFileURL];
    XCTAssertNotNil(fileURL, @"Value must be defined");
}

@end
