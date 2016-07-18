//
//  QuizSessionTests.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/9/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AppConfiguration.h"
#import "Question.h"
#import "QuizSession.h"

@interface QuizSession (QuizSessionTests)

- (void)shuffleQuestions;
- (nonnull NSArray *)shuffleArray:(nonnull NSArray *)array;
- (nullable Question *)questionForPrompt:(nonnull NSString *)prompt;
- (NSString *)uuidString;

@end

@interface QuizSessionTests : XCTestCase

@end

@implementation QuizSessionTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testLoadQuizSession {
    NSArray<Question *> *questions = [Question questionsWithFileURL:[AppConfiguration questionsFileURL]];
    QuizSession *quizSession = [QuizSession quizSessionWithQuestions:questions];
    XCTAssertNotNil(questions, @"Valid value is expected");
    XCTAssertNotNil(quizSession, @"Valid value is expected");
}

- (void)testShufflingArray {
    NSArray<NSNumber *> *numbers = @[@1, @2, @3, @4, @5];
    QuizSession *quizSession = [QuizSession new];
    NSArray<NSNumber *> *randomNumbers = [quizSession shuffleArray:numbers];

    // Note: Testing randomness is not 100% accurate since the result could be
    // in the same order but with enough values that will be very unlikely.

    XCTAssertTrue(numbers.count == randomNumbers.count, @"Counts should match");

    BOOL notMatched = NO;
    for (NSUInteger i; i<numbers.count; i++) {
        NSNumber *original = numbers[i];
        NSNumber *random = randomNumbers[i];
        if (![original isEqual:random]) {
            notMatched = YES;
            break;
        }
    }

    XCTAssertTrue(notMatched, @"Random array should not match original array");
}

- (void)testShuffleQuestions {
    NSArray<Question *> *questions = [Question questionsWithFileURL:[AppConfiguration questionsFileURL]];
    QuizSession *quizSession = [QuizSession quizSessionWithQuestions:questions];

    XCTAssertNotNil(questions, @"Valid value is expected");
    XCTAssertNotNil(quizSession, @"Valid value is expected");

    [quizSession shuffleQuestions];

    // Note: Testing randomness is not 100% accurate since the result could be
    // in the same order but with enough values that will be very unlikely.

    BOOL notMatched = NO;
    for (NSUInteger i; i<questions.count; i++) {
        Question *original = questions[i];
        Question *random = quizSession.questions[i];
        if (![original isEqual:random]) {
            notMatched = YES;
            break;
        }
    }

    if ([AppConfiguration isShuffleEnabled]) {
        XCTAssertTrue(notMatched, @"Random array should not match original array");
    }
    else {
        XCTAssertFalse(notMatched, @"Random array should not match original array");
    }
}

- (void)testQuestionForPrompt {
    NSArray<Question *> *questions = [Question questionsWithFileURL:[AppConfiguration questionsFileURL]];
    QuizSession *quizSession = [QuizSession quizSessionWithQuestions:questions];

    XCTAssertNotNil(questions, @"Valid value is expected");
    XCTAssertNotNil(quizSession, @"Valid value is expected");

    for (Question *question in questions) {
        Question *otherQuestion = [quizSession questionForPrompt:question.prompt];
        XCTAssertTrue([question.prompt isEqualToString:otherQuestion.prompt]);
    }
}

- (void)testUUID {
    QuizSession *quizSession = [QuizSession new];
    XCTAssertNotNil(quizSession, @"Valid value is expected");

    NSString *uuidString1 = [quizSession uuidString];
    NSString *uuidString2 = [quizSession uuidString];

    XCTAssertTrue(uuidString1.length, @"String is required");
    XCTAssertTrue(uuidString2.length, @"String is required");
    XCTAssertFalse([uuidString1 isEqualToString:uuidString2], @"Strings must not be equal");
}

- (void)testShufflingPerformance {
    [self measureBlock:^{
        NSArray<Question *> *questions = [Question questionsWithFileURL:[AppConfiguration questionsFileURL]];
        QuizSession *quizSession = [QuizSession quizSessionWithQuestions:questions];

        XCTAssertNotNil(questions, @"Valid value is expected");
        XCTAssertNotNil(quizSession, @"Valid value is expected");

        [quizSession shuffleQuestions];
    }];
}

- (void)testQuizSessionAnsweringQuestions {
    [self measureBlock:^{
        NSArray<Question *> *questions = [Question questionsWithFileURL:[AppConfiguration questionsFileURL]];
        QuizSession *quizSession = [QuizSession quizSessionWithQuestions:questions];

        // Start a new session
        [quizSession startNewSession];

        Question *currentQuestion = quizSession.currentQuestion;
        while (currentQuestion) {
            NSString *answer = currentQuestion.answers.firstObject;
            [quizSession submitAnswer:answer];
            currentQuestion = quizSession.currentQuestion;
        }
        XCTAssertTrue(quizSession.isSessionCompleted, @"Session should be completed");

        // Now store the session to the Documents folder
        [quizSession completeCurrentSession];

        [quizSession startNewSession];

        XCTAssertTrue(quizSession.answers.count == 0, @"Answers count should be zero");

        XCTAssertNotNil(questions, @"Valid value is expected");
        XCTAssertNotNil(quizSession, @"Valid value is expected");
    }];
}

@end
