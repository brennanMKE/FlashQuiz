//
//  QuizSession.h
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/9/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Question.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuizSession<__covariant ObjectType> : NSObject

@property (readonly, copy, nonatomic, nonnull) NSArray<Question *> *questions;
@property (readonly, nonatomic, nullable) Question *currentQuestion;
@property (readonly, strong, nonatomic, nonnull) NSMutableArray<NSString *> *answers;
@property (readonly, nonatomic) BOOL isSessionCompleted;

+ (nullable instancetype)quizSessionWithQuestions:(nonnull NSArray<Question *>*)questions;

- (void)startNewSession;
- (void)submitAnswer:(nonnull NSString *)answer;
- (NSUInteger)countCorrectAnswers;
- (void)completeCurrentSession;

@end

NS_ASSUME_NONNULL_END
