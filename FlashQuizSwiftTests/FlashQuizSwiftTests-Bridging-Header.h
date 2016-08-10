//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import "FlashQuiz-Bridging-Header.h"

@interface QuizSession (QuizSessionTests)

- (void)shuffleQuestions;
- (nullable Question *)questionForPrompt:(nonnull NSString *)prompt;
- (nonnull NSString *)uuidString;

@end

@interface QuizSession<__covariant ObjectType> (Shuffling)

- (nonnull NSArray<ObjectType> *)shuffleArray:(nonnull NSArray<ObjectType> *)array;

@end

@interface QuizSessionViewController (QuizSessionViewControllerTests)

@property (weak, nonatomic, nullable) IBOutlet UIButton *submitButton;
@property (weak, nonatomic, nullable) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic, nonnull) QuizSession *quizSession;

- (IBAction)submitButtonTapped:(nullable id)sender;

- (void)submitAnswer:(nonnull NSString *)answer;
- (void)expireAfterTimeout;
- (void)finishQuiz;

@end