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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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

@end
