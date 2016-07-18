//
//  QuestionsTests.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/9/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AppConfiguration.h"
#import "Question.h"

@interface QuestionsTests : XCTestCase

@end

@implementation QuestionsTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testLoadingQuestions1 {
    NSURL *fileURL = nil;
    NSArray<Question *> *questions = [Question questionsWithFileURL:fileURL];
    XCTAssertNil(questions, @"A nil value is expected");
}

- (void)testLoadingQuestions2 {
    NSURL *fileURL = [AppConfiguration questionsFileURL];
    NSArray<Question *> *questions = [Question questionsWithFileURL:fileURL];
    XCTAssertNotNil(questions, @"A valid value is expected");
    XCTAssertTrue(questions.count > 0, @"Count is exected to be greater than zero");
}

- (void)testLoadingQuestions3 {
    // Try using a file with invalid JSON data
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"invalid" ofType:@"json"];
    XCTAssertNotNil(path, @"Path is required");
    NSURL *fileURL = [NSURL URLWithString:path];
    NSArray<Question *> *questions = [Question questionsWithFileURL:fileURL];
    XCTAssertNil(questions, @"A nil value is expected");
}

- (void)testLoadingPerformance {
    [self measureBlock:^{
        NSURL *fileURL = [AppConfiguration questionsFileURL];
        NSArray<Question *> *questions = [Question questionsWithFileURL:fileURL];
        XCTAssertNotNil(questions, @"A valid value is expected");
    }];
}

@end
