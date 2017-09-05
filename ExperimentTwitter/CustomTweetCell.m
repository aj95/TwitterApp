//
//  CustomTweetCell.m
//  ExperimentTwitter
//
//  Created by ayur.j on 29/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "CustomTweetCell.h"
#import <QuartzCore/QuartzCore.h>
#import "TwitterClient.h"

@implementation CustomTweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTweet:(Tweet *)tweet {
    _tweet = tweet;
    [self updateUI];
}

- (void) updateUI {
    _tweetTextLabel.text = _tweet.text;
    _userNameLabel.text = _tweet.user.name;
    _profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_tweet.user.profileImageUrl]]];
    _profileImageView.layer.cornerRadius = 5.0;
    _profileImageView.clipsToBounds = YES;
    _handleLabel.text = [NSString stringWithFormat: @"@%@", _tweet.user.screenName];
    _tweetImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_tweet.mediaUrl]]];
    NSTimeInterval timeSinceCreated = [[NSDate date] timeIntervalSinceDate:_tweet.createdAt];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    if(timeSinceCreated > 86400)
        dateFormatter.dateStyle = NSFormattingUnitStyleShort;
    else
        dateFormatter.timeStyle = NSFormattingUnitStyleShort;
    _createdAtLabel.text = [dateFormatter stringFromDate:_tweet.createdAt];
    _favouriteCountLabel.text = _tweet.favouriteCount;
    _retweetCountLabel.text = _tweet.retweetedCount;
}
- (IBAction)onPressingFavouriteButton:(id)sender {
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"icon-heart"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        _favouriteCountLabel.text = [NSString stringWithFormat:@"%ld",[_favouriteCountLabel.text integerValue] - 1];
         [[TwitterClient sharedInstance] unlikeTweetWithId : _tweet.tweetId];
    } else {
        [sender setImage:[UIImage imageNamed:@"icon-heart-selected"] forState:UIControlStateSelected];
        [sender setSelected:YES];
         _favouriteCountLabel.text = [NSString stringWithFormat:@"%ld",[_favouriteCountLabel.text integerValue] + 1];
        [[TwitterClient sharedInstance] likeTweetWithId : _tweet.tweetId];
        
    }
}

- (IBAction)onPressingRetweetButton:(id)sender {
    if ([sender isSelected]) {
        [sender setImage:[UIImage imageNamed:@"icon-retweet"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        _retweetCountLabel.text = [NSString stringWithFormat:@"%ld",[_retweetCountLabel.text integerValue] - 1];
        [[TwitterClient sharedInstance] untweetTweetWithId : _tweet.tweetId];
    } else {
        [sender setImage:[UIImage imageNamed:@"icon-retweet-selected"] forState:UIControlStateSelected];
        [sender setSelected:YES];
        _retweetCountLabel.text = [NSString stringWithFormat:@"%ld",[_retweetCountLabel.text integerValue] + 1];
        [[TwitterClient sharedInstance] retweetTweetWithId : _tweet.tweetId];
    }
}


@end
