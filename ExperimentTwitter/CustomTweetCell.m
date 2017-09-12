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

@implementation CustomTweetCell


- (void) setTweet:(Tweet *)tweet {
    _tweet = tweet;
    [self updateUI];
}

- (void) updateUI {
    self.tweetTextLabel.text = _tweet.text;
    self.userNameLabel.text = _tweet.user.name;
    
    //self.profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_tweet.user.profileImageUrl]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_tweet.user.profileImageUrl]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            //if([request.URL isEqual:_tweet.user.profileImageUrl]) {
                //NSLog(@"Finished downloading image");
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                //NSLog(@"Finished downloading image!");
                dispatch_async(dispatch_get_main_queue(), ^{self.profileImageView.image = image;});
           // }
        }
    }];
    [task resume];
    /*dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
    dispatch_async(queue, ^{
        NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:_tweet.user.profileImageUrl]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.profileImageView.image = [UIImage imageWithData:imageData];
        });
    });
    */
    self.profileImageView.layer.cornerRadius = 5.0;
    self.profileImageView.clipsToBounds = YES;
    self.handleLabel.text = [NSString stringWithFormat: @"@%@", _tweet.user.screenName];
    /*dispatch_async(queue, ^{
        NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:_tweet.mediaUrl]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.tweetImageView.image = [UIImage imageWithData:imageData];
        });
    });*/
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:_tweet.mediaUrl]];
    NSURLSessionConfiguration *configuration1 = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session1 = [NSURLSession sessionWithConfiguration:configuration1];
    NSURLSessionDownloadTask *task1 = [session1 downloadTaskWithRequest:request1 completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            //if([request.URL isEqual:_tweet.user.profileImageUrl]) {
            //NSLog(@"Finished downloading image");
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            //NSLog(@"Finished downloading image!");
            dispatch_async(dispatch_get_main_queue(), ^{self.tweetImageView.image = image;});
            // }
        }
    }];
    [task1 resume];

    //self.tweetImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_tweet.mediaUrl]]];
    NSTimeInterval timeSinceCreated = [[NSDate date] timeIntervalSinceDate:_tweet.createdAt];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    if(timeSinceCreated > 86400)
        dateFormatter.dateStyle = NSFormattingUnitStyleShort;
    else
        dateFormatter.timeStyle = NSFormattingUnitStyleShort;
    self.createdAtLabel.text = [dateFormatter stringFromDate:_tweet.createdAt];
    self.favouriteCountLabel.text = [NSString stringWithFormat:@"%lld",_tweet.favouriteCount];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%lld",_tweet.retweetedCount];
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
