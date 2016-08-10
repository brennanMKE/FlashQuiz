//
//  QuizSession.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/9/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import "QuizSession.h"

#import "AppConfiguration.h"
#import "Question.h"

#pragma mark - Class Extension
#pragma mark -

@interface QuizSession ()

@property (readwrite, copy, nonatomic, nonnull) NSArray<Question *> *questions;
@property (readwrite, copy, nonatomic, nonnull) NSDictionary *correctAnswers;

@property (readwrite, strong, nonatomic, nonnull) NSMutableArray<NSString *> *answers;

@end

@interface QuizSession<__covariant ObjectType> (Shuffling)

- (nonnull NSArray<ObjectType> *)shuffleArray:(nonnull NSArray<ObjectType> *)array;

@end

@implementation QuizSession

+ (nullable instancetype)quizSessionWithQuestions:(nonnull NSArray<Question *>*)questions {
    QuizSession *quizSession = nil;

    if (questions.count) {
        quizSession = [QuizSession new];
        // randomize the order of the questions and answers?
        quizSession.questions = questions;

        // Hold onto the correct answers
        NSMutableDictionary *correctAnswers = @{}.mutableCopy;
        for (Question *question in questions) {
            correctAnswers[question.prompt] = question.answers.firstObject;
        }
        quizSession.correctAnswers = correctAnswers;
    }

    return quizSession;
}

- (Question *)currentQuestion {
    // Note: Current question is based on the count of answers
    Question *question = nil;
    if (self.answers.count < self.questions.count) {
        NSUInteger index = self.answers.count;
        question = self.questions[index];
    }

    return question;
}

- (BOOL)isSessionCompleted {
    return self.questions.count == self.answers.count;
}

- (void)startNewSession {
    // clear out the answers and shuffle the questions
    self.answers = @[].mutableCopy;
    [self shuffleQuestions];
}

- (void)submitAnswer:(nonnull NSString *)answer {
    // Note: The answer must be in the answers array for the current question
    NSAssert(self.answers, @"Answers array must be defined");
    NSAssert(self.currentQuestion, @"Current Question is required");
    NSAssert([self.currentQuestion.answers containsObject:answer], @"Question must contain answer");

    if ([self.currentQuestion.answers containsObject:answer]) {
        [self.answers addObject:answer];
    }
}

- (NSUInteger)countCorrectAnswers {
    NSUInteger count = 0;

    for (NSUInteger i=0; i<self.answers.count; i++) {
        NSString *answer = self.answers[i];
        Question *question = self.questions[i];
        if ([answer isEqualToString:self.correctAnswers[question.prompt]]) {
            count++;
        }
    }

    return count;
}

- (void)completeCurrentSession {
    // Store the current session to the Documents folder with a UUID
    NSString *uuid = [self uuidString];
    NSDate *timestamp = [NSDate date];
    NSUInteger total = self.answers.count;
    NSUInteger count = [self countCorrectAnswers];
    NSString *score = [NSString stringWithFormat:@"%ld of %ld", (unsigned long)count, (unsigned long)total];
    NSDictionary *session = @{
                              @"uuid" : uuid,
                              @"timestamp" : timestamp,
                              @"score" : score,
                              @"total" : @(total),
                              @"count" : @(count)
                              };
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = paths.firstObject;
    NSString *sessionsPath = [documentsPath stringByAppendingPathComponent:@"sessions"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (![fileManager fileExistsAtPath:sessionsPath isDirectory:&isDirectory]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:sessionsPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }

    NSString *filename = [NSString stringWithFormat:@"%@.plist", uuid];
    NSString *outputPath = [sessionsPath stringByAppendingPathComponent:filename];
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:session format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];
    [data writeToFile:outputPath atomically:YES];
}

#pragma mark - Private
#pragma mark -

- (void)shuffleQuestions {
    // All questions and answers will be sorted into a random order
    if ([AppConfiguration isShuffleEnabled]) {
        NSMutableArray<Question *>* shuffledQuestions = @[].mutableCopy;
        NSArray<Question *>* questions = [self shuffleArray:self.questions];
        NSAssert(self.questions.count == questions.count, @"Counts must match");
        for (Question *question in questions) {
            NSArray<NSString *> *randomAnswers = [self shuffleArray:question.answers];
            NSAssert(question.answers.count == randomAnswers.count, @"Counts must match");
            Question *randomQuestion = [Question questionWithPrompt:question.prompt andAnswers:randomAnswers];
            [shuffledQuestions addObject:randomQuestion];
        }
        self.questions = shuffledQuestions;
    }
}

- (nonnull NSArray<id> *)shuffleArray:(nonnull NSArray<id> *)array {
    NSMutableArray *temp = [NSMutableArray arrayWithArray:array];

    for (NSUInteger i = array.count; i > 1; i--) {
        NSUInteger j = arc4random_uniform((u_int32_t)i);
        [temp exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }

    return [NSArray arrayWithArray:temp];
}

- (nullable Question *)questionForPrompt:(nonnull NSString *)prompt {
    Question *result = nil;

    for (Question *question in self.questions) {
        if ([prompt isEqualToString:question.prompt]) {
            result = question;
            break;
        }
    }

    return result;
}

- (nonnull NSString *)uuidString {
    // Returns a UUID
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);

    return uuidString;
}

@end
