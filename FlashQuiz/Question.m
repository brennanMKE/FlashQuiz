//
//  Question.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/9/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import "Question.h"

#pragma mark - Class Extension
#pragma mark -

@interface Question ()

@property (readwrite, copy, nonatomic, nonnull) NSString *prompt;
@property (readwrite, strong, nonatomic, nonnull) NSArray<NSString *> *answers;

@end

@implementation Question

#pragma mark - Public
#pragma mark -

+ (nullable NSArray<Question *>*)questionsWithFileURL:(nonnull NSURL *)fileURL {
    NSArray<Question *> *questions = nil;

    NSString *filePath = fileURL.absoluteString;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager isReadableFileAtPath:filePath]) {
        NSData *data = [fileManager contentsAtPath:filePath];
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            // TODO: handle the error by logging to service
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else {
            if ([json isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dictionary = (NSDictionary *)json;
                questions = [self readFromDictionary:dictionary];
            }
        }
    }

    // A nil value is possible if the file cannot be read
    return questions;
}

+ (nullable instancetype)questionWithPrompt:(nonnull NSString * )prompt andAnswers:(nonnull NSArray<NSString *>* )answers {
    Question *question = nil;

    if (prompt.length && answers.count) {
        question = [Question new];
        question.prompt = prompt;
        question.answers = answers;
    }

    return question;
}

#pragma mark - Private
#pragma mark -

+ (nullable NSArray<Question *> *)readFromDictionary:(nonnull NSDictionary *)dictionary {
    NSMutableArray<Question *> *questions = @[].mutableCopy;
    for (NSString *prompt in dictionary.allKeys) {
        NSArray *answers = dictionary[prompt];
        Question *question = [Question questionWithPrompt:prompt andAnswers:answers];
        // Note: question is nullable
        if (question) {
            [questions addObject:question];
        }
    }

    return questions;
}

@end
