//
//  CustomUserCell.m
//  ExperimentTwitter
//
//  Created by ayur.j on 30/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "CustomUserCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface CustomUserCell ()
@property (weak, nonatomic, nullable) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic,nullable) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic,nullable) IBOutlet UIImageView *profileImageView;
@end

@implementation CustomUserCell

- (void) setUser:(User *)user {
    _user = user;
    [self updateUI];
}

- (void) updateUI {
    self.handleLabel.text = [NSString stringWithFormat: @"@%@", _user.screenName];
    self.userNameLabel.text = _user.name;
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:_user.profileImageUrl]];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.clipsToBounds = YES;
}

@end
