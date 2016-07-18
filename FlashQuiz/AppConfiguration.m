//
//  AppConfiguration.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/9/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import "AppConfiguration.h"

@implementation AppConfiguration

+ (NSString *)bundleIdentifier {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleIdentifier"];
}

+ (NSString *)bundleDisplayName {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
}

+ (NSString *)appName {
    NSString *appName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    return appName.length ? appName : @"Quiz";
}

+ (NSString *)appVersion {
    return [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

+ (NSDictionary *)myAppsettings {
    return [[NSBundle mainBundle] infoDictionary][@"MyAppSettings"];
}

+ (BOOL)isDebuggingEnabled {
    // Note: Environment variables will not be false when not defined, like an App Store build.
    NSString* value = [[[NSProcessInfo processInfo] environment] objectForKey:@"EnableDebugging"];
    return [value boolValue];
}

+ (BOOL)isShuffleEnabled {
    // Note: Environment variables will not be false when not defined, like an App Store build.
    NSString* value = [[[NSProcessInfo processInfo] environment] objectForKey:@"DisableShuffling"];
    return ![value boolValue];
}

+ (BOOL)isUnitTesting {
    BOOL isTesting = NSClassFromString(@"XCTestProbe") != nil;
    return isTesting;
}

+ (NSURL *)questionsFileURL {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"json"];
    NSURL *fileURL = [NSURL URLWithString:path];
    return fileURL;
}

@end
