//
//  Question.h
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/9/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Question : NSObject

@property (readonly, copy, nonatomic, nonnull) NSString *prompt;
@property (readonly, strong, nonatomic, nonnull) NSArray<NSString *> *answers;

+ (nullable NSArray<Question *>*)questionsWithFileURL:(nullable NSURL *)fileURL;

+ (nullable instancetype)questionWithPrompt:(nonnull NSString * )prompt andAnswers:(nonnull NSArray<NSString *>* )answers;

@end

NS_ASSUME_NONNULL_END
