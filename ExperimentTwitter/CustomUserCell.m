//
//  CustomUserCell.m
//  ExperimentTwitter
//
//  Created by ayur.j on 30/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "CustomUserCell.h"

@implementation CustomUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setFollower:(User *)follower {
    _follower = follower;
    [self updateUI];
}

- (void) updateUI {
    _handleLabel.text = [NSString stringWithFormat: @"@%@", _follower.screenName];
    _userNameLabel.text = _follower.name;
    _profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_follower.profileImageUrl]]];
    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.height/2;
    _profileImageView.clipsToBounds = YES;
}


@end
