//
//  StartQuizViewController.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/9/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import "StartQuizViewController.h"

#import "AppConfiguration.h"
#import "QuizSessionViewController.h"

@interface StartQuizViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startQuizButton;

@end

@implementation StartQuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [AppConfiguration bundleDisplayName];
    self.startQuizButton.layer.cornerRadius = 10.0;

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[QuizSessionViewController class]]) {
        QuizSessionViewController *vc = (QuizSessionViewController *)segue.destinationViewController;
        [vc startNewSession];
    }
}

- (IBAction)unwindToStart:(UIStoryboardSegue *)segue {
    // do nothing
}

@end
