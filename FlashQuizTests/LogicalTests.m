//
//  LogicalTests.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/10/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface LogicalTests : XCTestCase

@end

@implementation LogicalTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testBoolStrings {
    XCTAssertTrue([@"1" boolValue]);
    XCTAssertTrue([@"yes" boolValue]);
    XCTAssertTrue([@"YES" boolValue]);
    XCTAssertTrue([@"true" boolValue]);
    XCTAssertTrue([@"TRUE" boolValue]);

    XCTAssertFalse([@"0" boolValue]);
    XCTAssertFalse([@"no" boolValue]);
    XCTAssertFalse([@"NO" boolValue]);
    XCTAssertFalse([@"false" boolValue]);
    XCTAssertFalse([@"FALSE" boolValue]);

    XCTAssertFalse([@"" boolValue]);
    NSString *nilString = nil;
    XCTAssertFalse([nilString boolValue]);
}

@end
