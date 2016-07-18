//
//  QuizSessionViewController.m
//  SmallSharpTools
//
//  Created by Brennan Stehling on 7/9/16.
//  Copyright © 2016 FlashQuiz. All rights reserved.
//

#import "QuizSessionViewController.h"

#import "AppConfiguration.h"
#import "NetworkSessionManager.h"
#import "QuizSession.h"
#import "Question.h"
#import "AnswerCell.h"

#define kPadding 40.0

@interface QuizSessionViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic, nonnull) QuizSession *quizSession;
@property (strong, nonatomic, nonnull) NetworkSessionManager *networkSessionManager;

@property (strong, nonatomic) NSMutableDictionary *tasks;

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fullImageView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic, nullable) IBOutlet UICollectionView *collectionView;

@end

@implementation QuizSessionViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSAssert(self.collectionView, @"Outlet is required");
    NSAssert(self.collectionView.dataSource == self, @"DataSource must be set to self");
    NSAssert(self.collectionView.delegate == self, @"Delegate must be set to self");

    self.submitButton.layer.cornerRadius = 10.0;
    self.promptLabel.text = nil;
    self.fullImageView.image = nil;

    self.title = [AppConfiguration bundleDisplayName];
    self.networkSessionManager = [NetworkSessionManager new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self displayCurrentQuestion];
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)submitButtonTapped:(id)sender {
    NSArray<NSIndexPath *> *indexPaths = [self.collectionView indexPathsForSelectedItems];
    if (indexPaths.count) {
        NSIndexPath *indexPath = indexPaths.firstObject;
        Question *question = self.quizSession.currentQuestion;
        NSAssert(question.answers.count > indexPath.item, @"Item must be in range");
        NSString *answer = question.answers[indexPath.item];
        [self submitAnswer:answer];
    }
}

#pragma mark - Public
#pragma mark -

- (void)startNewSession {
    if (!self.quizSession) {
        [self loadQuizSession];
    }
    NSTimeInterval timeout = 2 * 60;
    if ([AppConfiguration isDebuggingEnabled]) {
        timeout = 20; // while debugging manually make the timeout 20 seconds
    }
    [self performSelector:@selector(expireAfterTimeout) withObject:nil afterDelay:timeout];

    [self.quizSession startNewSession];
}

#pragma mark - Private
#pragma mark -

- (void)loadQuizSession {
    NSURL *fileURL = [AppConfiguration questionsFileURL];
    NSArray<Question *> *questions = [Question questionsWithFileURL:fileURL];

    if ([AppConfiguration isDebuggingEnabled]) {
        // trim the questions to just 3 for faster manual testing
        if (questions.count > 3) {
            questions = [questions subarrayWithRange:NSMakeRange(0, 3)];
        }
    }

    self.quizSession = [QuizSession quizSessionWithQuestions:questions];
}

- (void)displayCurrentQuestion {
    NSAssert(self.promptLabel, @"Outlet is required");
    Question *question = self.quizSession.currentQuestion;
    if (question) {
        self.promptLabel.text = question.prompt;
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self displayFullImageAtIndexPath:indexPath];
    }
}

- (void)displayFullImageAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(self.fullImageView, @"Outlet is required");

    Question *question = self.quizSession.currentQuestion;
    NSAssert(question, @"Question is required");
    NSAssert(question.answers.count > indexPath.item, @"Item must be in range");

    NSString *answer = question.answers[indexPath.item];
    if (answer) {
        NSURL *imageURL = [NSURL URLWithString:answer];
        [self.networkSessionManager fetchImageWithURL:imageURL params:nil withCompletionBlock:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (error) {
                // TODO: handle the error by logging to service
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else {
                self.fullImageView.image = image;
            }
        }];
    }
}

- (void)submitAnswer:(NSString *)answer {
    [self.quizSession submitAnswer:answer];
    if (self.quizSession.isSessionCompleted) {
        [self finishQuiz];
    }
    else {
        [self displayCurrentQuestion];
    }
}

- (void)expireAfterTimeout {
    NSUInteger count = [self.quizSession countCorrectAnswers];
    NSString *title = NSLocalizedString(@"Times Up!", @"");
    NSString *message = NSLocalizedString(@"Thanks for taking the quiz. You had %ld of %ld correct.", @"");
    message = [NSString stringWithFormat:message, count, (unsigned long)(unsigned long)self.quizSession.answers.count];
    [self endSessionWithTitle:title andMessage:message];
}

- (void)finishQuiz {
    // Show an alert view and once it is dismissed start a new session
    NSUInteger count = [self.quizSession countCorrectAnswers];
    NSString *title = NSLocalizedString(@"Completed!", @"");
    NSString *message = NSLocalizedString(@"Thanks for completing the quiz. You had %ld of %ld correct.", @"");
    message = [NSString stringWithFormat:message, count, (unsigned long)(unsigned long)self.quizSession.answers.count];
    [self endSessionWithTitle:title andMessage:message];
}

- (void)endSessionWithTitle:(NSString *)title andMessage:(NSString *)message {
    // Cancel the timeout so it does not fire later
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(expireAfterTimeout) object:nil];

    [self.quizSession completeCurrentSession];

    // Show the user that the session is over with their score
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self unwindToStart];
    }];
    [alertController addAction:okayAction];

    if ([AppConfiguration isUnitTesting]) {
        // Do not present the alert controller while unit testing.
        [self unwindToStart];
    }
    else {
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)unwindToStart {
    [self performSegueWithIdentifier:@"unwindToStart" sender:self];
}

#pragma mark - UICollectionViewDataSource
#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.quizSession.currentQuestion.answers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"AnswerCell" forIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate
#pragma mark -

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[AnswerCell class]]) {
        AnswerCell *answerCell = (AnswerCell *)cell;
        [answerCell startLoadingImage];

        Question *question = self.quizSession.currentQuestion;
        NSAssert(question.answers.count > indexPath.item, @"Item must be in range");
        NSURL *photoURL = [NSURL URLWithString:question.answers[indexPath.item]];

        __weak typeof(self) weakSelf = self;
        NSURLSessionTask *task = [self.networkSessionManager fetchImageWithURL:photoURL params:nil withCompletionBlock:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (error) {
                // Handle error by logging it to a backend service
                NSLog(@"Error: %@", error.localizedDescription);
            }
            else {
                [answerCell finishLoadingWithImage:image];
            }
            [weakSelf.tasks removeObjectForKey:indexPath];
        }];
        self.tasks[indexPath] = task;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSURLSessionTask *task = (NSURLSessionTask *)self.tasks[indexPath];
    [task cancel];
    [self.tasks removeObjectForKey:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self displayFullImageAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout
#pragma mark -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat length = MIN(CGRectGetWidth(self.collectionView.frame) / 4,
                         CGRectGetHeight(self.collectionView.frame));
    return CGSizeMake(length, length);
}

@end
