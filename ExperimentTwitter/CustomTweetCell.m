//
//  CustomTweetCell.m
//  ExperimentTwitter
//
//  Created by ayur.j on 29/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "CustomTweetCell.h"
#import <QuartzCore/QuartzCore.h>

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
}

@end
