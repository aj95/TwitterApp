//
//  CustomUserCell.m
//  ExperimentTwitter
//
//  Created by ayur.j on 30/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "CustomUserCell.h"

@implementation CustomUserCell

- (void) setUser:(User *)user {
    _user = user;
    [self updateUI];
}

- (void) updateUI {
    self.handleLabel.text = [NSString stringWithFormat: @"@%@", self.user.screenName];
    self.userNameLabel.text = self.user.name;
    self.profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.user.profileImageUrl]]];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.clipsToBounds = YES;
}

@end
