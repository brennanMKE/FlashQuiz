//
//  QuizSessionViewControllerTests.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/10/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AppDelegate.h"
#import "QuizSessionViewController.h"
#import "StartQuizViewController.h"
#import "Question.h"
#import "QuizSession.h"

CG_INLINE UINavigationController *GetNavigationController() {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return (UINavigationController *)appDelegate.window.rootViewController;
}

@interface QuizSessionViewController (QuizSessionViewControllerTests)

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic, nullable) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic, nonnull) QuizSession *quizSession;

- (IBAction)submitButtonTapped:(id)sender;

- (void)submitAnswer:(NSString *)answer;
- (void)expireAfterTimeout;
- (void)finishQuiz;

@end

@interface QuizSessionViewControllerTests : XCTestCase

@end

@implementation QuizSessionViewControllerTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testRoot {
    UINavigationController *nc = GetNavigationController();
    XCTAssertNotNil(nc);
}

- (void)testViewController1 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"UI"];

    UINavigationController *nc = GetNavigationController();
    XCTAssertNotNil(nc);
    XCTAssertTrue([nc isKindOfClass:[UINavigationController class]]);

    [nc popViewControllerAnimated:NO];
    StartQuizViewController *vc = (StartQuizViewController *)nc.topViewController;
    XCTAssertNotNil(vc);
    XCTAssertTrue([vc isKindOfClass:[StartQuizViewController class]]);

    // Runs the button tap action.
    [vc performSegueWithIdentifier:@"pushQuizSession" sender:vc];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        QuizSessionViewController *qs = (QuizSessionViewController *)nc.topViewController;
        XCTAssertNotNil(qs);
        XCTAssertTrue([qs isKindOfClass:[QuizSessionViewController class]]);

        [qs.collectionView reloadData];

        Question *question = qs.quizSession.currentQuestion;

        while (question) {
            [qs submitAnswer:question.answers.firstObject];
            question = qs.quizSession.currentQuestion;
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [expectation fulfill];
        });
    });

    NSTimeInterval timeout = 10; // 10 seconds
    [self waitForExpectationsWithTimeout:timeout handler:^(NSError * _Nullable error) {
        // do nothing
    }];
}

- (void)testViewController2 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"UI"];

    UINavigationController *nc = GetNavigationController();
    XCTAssertNotNil(nc);
    XCTAssertTrue([nc isKindOfClass:[UINavigationController class]]);

    [nc popViewControllerAnimated:NO];
    StartQuizViewController *vc = (StartQuizViewController *)nc.topViewController;
    XCTAssertNotNil(vc);
    XCTAssertTrue([vc isKindOfClass:[StartQuizViewController class]]);

    // Runs the button tap action.
    [vc performSegueWithIdentifier:@"pushQuizSession" sender:vc];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        QuizSessionViewController *qs = (QuizSessionViewController *)nc.topViewController;
        XCTAssertNotNil(qs);
        XCTAssertTrue([qs isKindOfClass:[QuizSessionViewController class]]);

        [qs.collectionView reloadData];

        Question *question = qs.quizSession.currentQuestion;
        Question *lastQuestion = qs.quizSession.questions.lastObject;

        while (question && ![question isEqual:lastQuestion]) {
            [qs submitAnswer:question.answers.firstObject];
            question = qs.quizSession.currentQuestion;
        }

        [qs expireAfterTimeout];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [expectation fulfill];
        });
    });

    NSTimeInterval timeout = 10; // 10 seconds
    [self waitForExpectationsWithTimeout:timeout handler:^(NSError * _Nullable error) {
        // do nothing
    }];
}

- (void)testViewController3 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"UI"];

    UINavigationController *nc = GetNavigationController();
    XCTAssertNotNil(nc);
    XCTAssertTrue([nc isKindOfClass:[UINavigationController class]]);

    [nc popViewControllerAnimated:NO];
    StartQuizViewController *vc = (StartQuizViewController *)nc.topViewController;
    XCTAssertNotNil(vc);
    XCTAssertTrue([vc isKindOfClass:[StartQuizViewController class]]);

    // Runs the button tap action.
    [vc performSegueWithIdentifier:@"pushQuizSession" sender:vc];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        QuizSessionViewController *qs = (QuizSessionViewController *)nc.topViewController;
        XCTAssertNotNil(qs);
        XCTAssertTrue([qs isKindOfClass:[QuizSessionViewController class]]);
        XCTAssertNotNil(qs.collectionView);
        XCTAssertTrue(qs.collectionView.visibleCells.count > 0);

        while (!qs.quizSession.isSessionCompleted) {
            NSIndexPath *indexPath = qs.collectionView.indexPathsForVisibleItems.firstObject;
            [qs.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [qs submitButtonTapped:qs.submitButton];
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [expectation fulfill];
        });
    });

    NSTimeInterval timeout = 10; // 10 seconds
    [self waitForExpectationsWithTimeout:timeout handler:^(NSError * _Nullable error) {
        // do nothing
    }];
}

@end
