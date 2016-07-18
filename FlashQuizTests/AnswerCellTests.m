//
//  AnswerCellTests.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/10/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AnswerCell.h"

@interface AnswerCellTests : XCTestCase

@end

@implementation AnswerCellTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAnswerCellGenerically {
    // This test is simply used to boost code coverage and try to catch any
    // which may go wrong when calling these methods.

    AnswerCell *cell = [AnswerCell new];
    [cell layoutSubviews];
    [cell prepareForReuse];
    cell.selected = !cell.selected; // change selected
    cell.selected = !cell.selected; // change it back
    [cell startLoadingImage];
    UIImage *image = nil;
    [cell finishLoadingWithImage:image];
}

@end
