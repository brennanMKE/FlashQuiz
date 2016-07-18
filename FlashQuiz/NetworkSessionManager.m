//
//  NetworkSessionManager.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/9/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import "NetworkSessionManager.h"

#pragma mark - Class Extension
#pragma mark -

@interface NetworkSessionManager ()

@property (strong, nonatomic) NSURLSession *session;

@end

@implementation NetworkSessionManager

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    }

    return _session;
}

- (nullable NSURLSessionTask *)fetchImageWithURL:(nonnull NSURL *)url params:(nullable NSDictionary *)params withCompletionBlock:(void (^ __nullable)(UIImage * __nullable image, NSError * __nullable error))completionBlock {
    if (!completionBlock) {
        return nil;
    }

    NSURLSessionTask *task = [self fetchDataWithURL:url params:params withCompletionBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        }
        else {
            UIImage *image = [UIImage imageWithData:data];
            // return to main queue from background
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(image, nil);
            });
        }
    }];

    return task;
}

- (nullable NSURLSessionTask *)fetchJSONWithURL:(nonnull NSURL *)url params:(nullable NSDictionary *)params withCompletionBlock:(void (^ __nullable)(id __nullable json, NSError * __nullable error))completionBlock {
    if (!completionBlock) {
        return nil;
    }

    NSURLSessionTask *task = [self fetchDataWithURL:url params:params withCompletionBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        }
        else {
            NSError *jsonError = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, jsonError);
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(json, nil);
                });
            }
        }
    }];

    return task;
}

- (nullable NSURLSessionTask *)fetchDataWithURL:(nonnull NSURL *)url params:(nullable NSDictionary *)params withCompletionBlock:(void (^ __nullable)(NSData * __nullable data, NSError * __nullable error))completionBlock {
    if (!completionBlock) {
        return nil;
    }

    url = [self appendQueryParameters:params toURL:url];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    request.HTTPMethod = @"GET";

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            completionBlock(nil, error);
        }
        else {
            completionBlock(data, nil);
        }
    }];
    [task resume];

    return task;
}

- (nonnull NSURL *)appendQueryParameters:(nullable NSDictionary *)params toURL:(nonnull NSURL *)url {
    NSAssert(url, @"URL must not be nil");
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];

    NSMutableArray<NSURLQueryItem *> *queryItems = @[].mutableCopy;

    for (NSString *name in params) {
        NSObject *parameterValue = params[name];

        NSURLQueryItem *item = nil;

        if ([parameterValue isKindOfClass:[NSString class]]) {
            item = [[NSURLQueryItem alloc] initWithName:name value:params[name]];
        }
        else if ([parameterValue respondsToSelector:@selector(stringValue)]) {
            item = [[NSURLQueryItem alloc] initWithName:name value:[params[name] stringValue]];
        }

        if (item) {
            [queryItems addObject:item];
        }
    }
    
    components.queryItems = queryItems;
    
    return components.URL;
}

@end
