//
//  AnswerCell.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/9/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import "AnswerCell.h"

#pragma mark - Class Extension
#pragma mark -

@interface AnswerCell ()

@property (weak, nonatomic, nullable) IBOutlet UIView *selectionView;
@property (readwrite, weak, nonatomic, nullable) IBOutlet UIImageView *imageView;
@property (readwrite, weak, nonatomic, nullable) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation AnswerCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectionView.layer.cornerRadius = 5.0;
}

- (void)prepareForReuse {
    self.selected = NO;
    self.imageView.image = nil;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    UIColor *selectedColor = [UIColor colorWithRed:0.2941 green:0.6510 blue:0.2157 alpha:1.0];
    self.selectionView.backgroundColor = selected ? selectedColor : [UIColor clearColor];
}

- (void)startLoadingImage {
    [self.activityIndicatorView startAnimating];
    self.imageView.image = nil;
}

- (void)finishLoadingWithImage:(nonnull UIImage *)image {
    [self.activityIndicatorView stopAnimating];
    self.imageView.image = image;
}

@end
