//
//  NetworkSessionManagerTests.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/10/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AppConfiguration.h"
#import "NetworkSessionManager.h"
#import "Question.h"

@interface NetworkSessionManager (NetworkSessionManagerTests)

- (nonnull NSURL *)appendQueryParameters:(nullable NSDictionary *)params toURL:(nonnull NSURL *)url;

@end

@interface NetworkSessionManagerTests : XCTestCase

@end

@implementation NetworkSessionManagerTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testFetchingJSON {
    NSURL *jsonURL = [NSURL URLWithString:@"https://sst-robots.s3.amazonaws.com/data.json"];
    NetworkSessionManager *manager = [NetworkSessionManager new];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetching JSON"];

    [manager fetchJSONWithURL:jsonURL params:nil withCompletionBlock:^(id  _Nullable json, NSError * _Nullable error) {
        XCTAssertTrue([NSThread isMainThread], @"Must be main thread");
        XCTAssertNil(error, @"Error is not expected");
        XCTAssertNotNil(json, @"JSON is expected");
        XCTAssertTrue([json isKindOfClass:[NSDictionary class]], @"Must be a dictionary");
        [expectation fulfill];
    }];

    NSTimeInterval timeout = 10; // 10 seconds
    [self waitForExpectationsWithTimeout:timeout handler:^(NSError * _Nullable error) {
        // do nothing
    }];
}

- (void)testFetchingImage {
    NSURL *imageURL = [NSURL URLWithString:@"https://sst-robots.s3.amazonaws.com/robot.jpg"];
    NetworkSessionManager *manager = [NetworkSessionManager new];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetching Image"];

    [manager fetchImageWithURL:imageURL params:nil withCompletionBlock:^(UIImage * _Nullable image, NSError * _Nullable error) {
        XCTAssertTrue([NSThread isMainThread], @"Must be main thread");
        XCTAssertNil(error, @"Error is not expected");
        XCTAssertNotNil(image, @"Image is expected");
        [expectation fulfill];
    }];

    NSTimeInterval timeout = 10; // 10 seconds
    [self waitForExpectationsWithTimeout:timeout handler:^(NSError * _Nullable error) {
        // do nothing
    }];
}

- (void)testFetchingImages {
    NSURL *fileURL = [AppConfiguration questionsFileURL];
    NSArray<Question *> *questions = [Question questionsWithFileURL:fileURL];
    NetworkSessionManager *manager = [NetworkSessionManager new];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Fetching Images"];

    __block NSUInteger count = 0;

    Question *question = questions.firstObject;
    XCTAssertNotNil(question);
    XCTAssert(question.answers.count > 0);

    for (NSString *answer in question.answers) {
        NSURL *imageURL = [NSURL URLWithString:answer];
        [manager fetchImageWithURL:imageURL params:nil withCompletionBlock:^(UIImage * _Nullable image, NSError * _Nullable error) {
            XCTAssertNil(error, @"Error is not expected");
            XCTAssertNotNil(image, @"Image is expected");
            count++;

            if (count == question.answers.count) {
                [expectation fulfill];
            }
        }];
    }

    NSTimeInterval timeout = 10; // 10 seconds
    [self waitForExpectationsWithTimeout:timeout handler:^(NSError * _Nullable error) {
        // do nothing
    }];
}

- (void)testNoCompletionBlocks {
    NSURL *anyURL = nil;
    NetworkSessionManager *manager = [NetworkSessionManager new];

    NSURLSessionTask *task1 = [manager fetchJSONWithURL:anyURL params:nil withCompletionBlock:nil];
    NSURLSessionTask *task2 = [manager fetchImageWithURL:anyURL params:nil withCompletionBlock:nil];
    NSURLSessionTask *task3 = [manager fetchDataWithURL:anyURL params:nil withCompletionBlock:nil];

    XCTAssertNil(task1);
    XCTAssertNil(task2);
    XCTAssertNil(task3);
}

- (void)testAppendingParameters1 {
    NSURL *servicesURL = [NSURL URLWithString:@"https://api.FlashQuiz.com/search"];
    NSDictionary *params = @{ @"text" : @"carrot", @"format" : @"json" };
    NetworkSessionManager *manager = [NetworkSessionManager new];

    NSURL *appendedURL = [manager appendQueryParameters:params toURL:servicesURL];
    XCTAssertNotNil(appendedURL);
    XCTAssertTrue([appendedURL.absoluteString rangeOfString:servicesURL.absoluteString].location != NSNotFound);
    for (NSString *key in params.allKeys) {
        NSString *pair = [NSString stringWithFormat:@"%@=%@", key, params[key]];
        XCTAssertTrue([appendedURL.query rangeOfString:pair].location != NSNotFound);
    }
}

- (void)testAppendingParameters2 {
    NSURL *servicesURL = [NSURL URLWithString:@"https://api.FlashQuiz.com/search"];
    NSDictionary *params = @{ @"text" : @"carrot", @"format" : @"json", @"pageSize" : @(20) };
    NetworkSessionManager *manager = [NetworkSessionManager new];

    NSURL *appendedURL = [manager appendQueryParameters:params toURL:servicesURL];
    XCTAssertNotNil(appendedURL);
    XCTAssertTrue([appendedURL.absoluteString rangeOfString:servicesURL.absoluteString].location != NSNotFound);
    for (NSString *key in params.allKeys) {
        NSString *pair = [NSString stringWithFormat:@"%@=%@", key, params[key]];
        XCTAssertTrue([appendedURL.query rangeOfString:pair].location != NSNotFound);
    }
}

@end
