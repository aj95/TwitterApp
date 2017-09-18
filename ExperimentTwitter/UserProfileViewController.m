//
//  UserProfileViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 04/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "UserProfileViewController.h"
#import "CustomTweetCell.h"
#import "TwitterClient.h"
#import "PostTweetViewController.h"
#import "UserTimelineViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UserHeaderView.h"

@interface UserProfileViewController ()
@property (strong, nonatomic, nullable) IBOutlet UserHeaderView *userHeaderView;
@end

@implementation UserProfileViewController

-(id) init {
    self = [super initWithUser:[User currentUser]];
    return self;
}

- (void)viewDidLoad {
    self.userHeaderView = [[UserHeaderView alloc] initWithFrame:CGRectMake(0, 60, 200, 100)];
    [self.navigationController.view addSubview:self.userHeaderView];
    [self.tableView setContentInset:UIEdgeInsetsMake(108, 0, 0, 0)];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(108, 0.0f, 0.0f, 0.0f);
    [self updateUI];
    [super viewDidLoad];
}

- (void) updateUI {
    User *currentUser = [User currentUser];
    self.userHeaderView.handleLabel.text = [NSString stringWithFormat: @"@%@", currentUser.screenName];
    self.userHeaderView.userNameLabel.text = currentUser.name;
    self.userHeaderView.userNameLabel.font = [UIFont boldSystemFontOfSize:20];
    self.userHeaderView.handleLabel.font = [UIFont systemFontOfSize:15];
    [self.userHeaderView.profileImageView sd_setImageWithURL:[NSURL URLWithString:currentUser.profileImageUrl]];
    self.userHeaderView.profileImageView.layer.cornerRadius = self.userHeaderView.profileImageView.frame.size.height/2;
    self.userHeaderView.profileImageView.clipsToBounds = YES;
}

@end
