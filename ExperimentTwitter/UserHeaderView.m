//
//  UserHeaderView.m
//  ExperimentTwitter
//
//  Created by ayur.j on 18/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "UserHeaderView.h"
#import "User+Twitter.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface UserHeaderView ()
@property (strong, nonatomic, nullable) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic, nullable) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic, nullable) IBOutlet UILabel *handleLabel;
@end

@implementation UserHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:self options:nil];
        UIView *mainView = subviewArray[0];
        [self addSubview:mainView];
        [self setFrame:frame];
    }
    return self;
}

- (IBAction)onLogoutPress:(id)sender {
    [User logout];
}

- (void) setHeaderViewForUser:(User *)user {
    self.handleLabel.text = [NSString stringWithFormat: @"@%@", user.screenName];
    self.userNameLabel.text = user.name;
    self.userNameLabel.font = [UIFont boldSystemFontOfSize:20];
    self.handleLabel.font = [UIFont systemFontOfSize:15];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.clipsToBounds = YES;
}

@end
