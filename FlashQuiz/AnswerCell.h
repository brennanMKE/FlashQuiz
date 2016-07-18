//
//  AnswerCell.h
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/9/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerCell : UICollectionViewCell

- (void)startLoadingImage;
- (void)finishLoadingWithImage:(nonnull UIImage *)image;

@end
