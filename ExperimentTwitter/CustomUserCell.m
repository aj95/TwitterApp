//
//  CustomUserCell.m
//  ExperimentTwitter
//
//  Created by ayur.j on 30/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "CustomUserCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation CustomUserCell

- (void) setUser:(User *)user {
    _user = user;
    [self updateUI];
}

- (void) updateUI {
    self.handleLabel.text = [NSString stringWithFormat: @"@%@", self.user.screenName];
    self.userNameLabel.text = self.user.name;
    /*dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
    dispatch_async(queue, ^{
        NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:self.user.profileImageUrl]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.profileImageView.image = [UIImage imageWithData:imageData];
        });
    });*//*
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            //if([request.URL isEqual:_tweet.user.profileImageUrl]) {
           // NSLog(@"Finished downloading image");
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            // NSLog(@"Finished downloading image!");
            dispatch_async(dispatch_get_main_queue(), ^{self.profileImageView.image = image;});
            // }
        }
    }];
    [task resume];*/
    //self.profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.user.profileImageUrl]]];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.clipsToBounds = YES;
}

@end
