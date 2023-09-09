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
#import "PostTweetViewController.h"
#import "AFHTTPSessionManager.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface CustomTweetCell ()
@property (weak, nonatomic, nullable) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic, nullable) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic,nullable) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic,nullable) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic, nullable) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic, nullable) IBOutlet UIImageView *tweetImageView;
@property (weak, nonatomic, nullable) IBOutlet UILabel *favouriteCountLabel;
@property (weak, nonatomic, nullable) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@end

@implementation CustomTweetCell


- (void) setTweet:(Tweet *)tweet {
    _tweet = tweet;
    [self updateUI];
}

- (void) updateUI {
    self.tweetTextLabel.text = _tweet.text;
    self.userNameLabel.text = _tweet.user.name;
    self.profileImageView.layer.cornerRadius = 5.0;
    self.profileImageView.clipsToBounds = YES;
    self.handleLabel.text = [NSString stringWithFormat: @"@%@", _tweet.user.screenName];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:_tweet.user.profileImageUrl]];
    [self.tweetImageView sd_setImageWithURL:[NSURL URLWithString:_tweet.mediaUrl]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSFormattingUnitStyleShort;
    self.createdAtLabel.text = [dateFormatter stringFromDate:_tweet.createdAt];
    self.favouriteCountLabel.text = [NSString stringWithFormat:@"%lld",_tweet.favouriteCount];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%lld",_tweet.retweetedCount];
    self.favoriteButton.selected = _tweet.isFavourited;
    self.retweetButton.selected = _tweet.isRetweeted;
}

- (IBAction)onPressingFavouriteButton:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *favoriteButton = (UIButton *)sender;
        [self.delegate      customTweetCell:self
    pressedFavoriteButtonWithSelectionState:favoriteButton.isSelected];
    }
}

- (IBAction)onPressingRetweetButton:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *retweetButton = (UIButton *)sender;
        [self.delegate      customTweetCell:self
    pressedRetweetButtonWithSelectionState:retweetButton.isSelected];
    }
}

- (IBAction)onPressingReplyButton:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        [self.delegate customTweetCellPressedReplyButton:self];
    }
}

- (void)changeFavoriteButtonImageForLikedTweet {
    [self.favoriteButton setImage:[UIImage imageNamed:@"icon-heart-selected"] forState:UIControlStateNormal];
    self.favoriteButton.selected = YES;
}
- (void)changeFavoriteButtonImageForUnlikedTweet {
    [self.favoriteButton setImage:[UIImage imageNamed:@"icon-heart"] forState:UIControlStateNormal];
    self.favoriteButton.selected = NO;
}
- (void)changeFavoriteCountForLikedTweet {
    _favouriteCountLabel.text = [NSString stringWithFormat:@"%ld",[_favouriteCountLabel.text integerValue] + 1];
}
- (void)changeFavoriteCountForUnLikedTweet {
    _favouriteCountLabel.text = [NSString stringWithFormat:@"%ld",[_favouriteCountLabel.text integerValue] - 1];
}
- (void)changeRetweetButtonImageForRetweetedTweet {
    [self.retweetButton setImage:[UIImage imageNamed:@"icon-retweet-selected"] forState:UIControlStateSelected];
    self.retweetButton.selected = YES;
}
- (void)changeRetweetButtonImageForUnRetweetedTweet {
    [self.retweetButton setImage:[UIImage imageNamed:@"icon-retweet"] forState:UIControlStateSelected];
    self.retweetButton.selected = YES;
}
- (void)changeRetweetCountForRetweetedTweet {
    _retweetCountLabel.text = [NSString stringWithFormat:@"%ld",[_retweetCountLabel.text integerValue] + 1];
}
- (void)changeRetweetCountForForUnRetweetedTweet {
    _retweetCountLabel.text = [NSString stringWithFormat:@"%ld",[_retweetCountLabel.text integerValue] - 1];
}

@end
