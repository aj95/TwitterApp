//
//  PostTweetViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 05/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "PostTweetViewController.h"
#import "TwitterClient.h"

@interface PostTweetViewController ()
@property (strong, nonatomic) Tweet* inReplyToTweet;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *charactersLeftLabel;
@end

@implementation PostTweetViewController


-(id) initForReplyToTweet:(Tweet *)tweet {
    self = [super init];
    self.inReplyToTweet = tweet;
    //NSLog(@"%@ %@", self.inReplyToTweet.tweetId, self.inReplyToTweet.user.screenName);
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetText.text = @"";
    self.tweetText.layer.borderWidth = 1.0f;
    self.tweetText.layer.borderColor = [[UIColor blackColor] CGColor];
    self.tweetText.layer.cornerRadius = 8;
    self.tweetButton.layer.cornerRadius = 8;
    [self.tweetText scrollRangeToVisible:NSMakeRange(0, 1)];
    if(self.inReplyToTweet != nil)
        [self.tweetButton setTitle:@"Reply" forState:UIControlStateNormal];
    else
        [self.tweetButton setTitle:@"Tweet" forState:UIControlStateNormal];
}

- (IBAction)onTweetPress:(id)sender {
    NSString *text = _tweetText.text;
    if(self.inReplyToTweet == nil)
        [[TwitterClient sharedInstance] postTweet:text];
    else  {
        text = [NSString stringWithFormat:@"@%@ %@", self.inReplyToTweet.user.screenName, text];
        //NSLog(@"%@", text);
        [[TwitterClient sharedInstance] replyToTweetWithId:self.inReplyToTweet.tweetId andTweetText:text];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    unsigned long len = textView.text.length + (text.length - range.length);
    if(len <= 140) {
        self.charactersLeftLabel.text = [NSString stringWithFormat:@"%lu characters left", (140-len)];
        return YES;
    }
    return NO;
}

- (void)viewDidLayoutSubviews {
    [self.tweetText setContentOffset:CGPointZero animated:NO];
}

@end
