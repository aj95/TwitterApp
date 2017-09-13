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
@property (weak, nonatomic) IBOutlet UITextView *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *charactersLeftLabel;
@end

@implementation PostTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetText.text = @"";
    self.tweetText.layer.borderWidth = 1.0f;
    self.tweetText.layer.borderColor = [[UIColor blackColor] CGColor];
    self.tweetText.layer.cornerRadius = 8;
    [self.tweetText scrollRangeToVisible:NSMakeRange(0, 1)];

}

- (IBAction)onTweetPress:(id)sender {
    NSString *text = _tweetText.text;
    [[TwitterClient sharedInstance] postTweet:text];
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
