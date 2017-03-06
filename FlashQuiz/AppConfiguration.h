//
//  AppConfiguration.h
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/9/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppConfiguration : NSObject

+ (NSString *)bundleIdentifier;
+ (NSString *)bundleDisplayName;
+ (NSString *)appName;
+ (NSString *)appVersion;
+ (NSDictionary<NSString *, id> *)myAppsettings;
+ (BOOL)isDebuggingEnabled;
+ (BOOL)isShuffleEnabled;
+ (BOOL)isUnitTesting;
+ (NSURL *)questionsFileURL;

@end

NS_ASSUME_NONNULL_END
