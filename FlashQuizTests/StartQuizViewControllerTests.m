//
//  StartQuizViewControllerTests.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/10/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AppDelegate.h"
#import "StartQuizViewController.h"

CG_INLINE UINavigationController *GetNavigationController() {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return (UINavigationController *)appDelegate.window.rootViewController;
}

@interface StartQuizViewControllerTests : XCTestCase

@end

@implementation StartQuizViewControllerTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testViewControllerGenerically {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    XCTAssertNotNil(storyboard);
//
//    UINavigationController *nc = (UINavigationController *)[storyboard instantiateInitialViewController];

    XCTestExpectation *expectation = [self expectationWithDescription:@"UI"];

    UINavigationController *nc = GetNavigationController();
    XCTAssertNotNil(nc);
    XCTAssertTrue([nc isKindOfClass:[UINavigationController class]]);

    [nc popViewControllerAnimated:NO];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        StartQuizViewController *vc = (StartQuizViewController *)nc.topViewController;
        XCTAssertNotNil(vc);
        XCTAssertTrue([vc isKindOfClass:[StartQuizViewController class]]);

        // Runs the button tap action.
        [vc performSegueWithIdentifier:@"pushQuizSession" sender:vc];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [nc popViewControllerAnimated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [expectation fulfill];
            });
        });
    });

    NSTimeInterval timeout = 60; // 10 seconds
    [self waitForExpectationsWithTimeout:timeout handler:^(NSError * _Nullable error) {
        // do nothing
    }];
}

@end
