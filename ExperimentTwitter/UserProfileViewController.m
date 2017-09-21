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

- (id)init {
    self = [super initWithUser:User.currentUser];
    return self;
}

- (void)viewDidLoad {
    self.userHeaderView = [[UserHeaderView alloc] initWithFrame: CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, self.navigationController.navigationBar.frame.size.width, 100)];
    [self.navigationController.view addSubview:self.userHeaderView];
    [self.tableView setContentInset:UIEdgeInsetsMake(108, 0, 0, 0)];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(108, 0.0f, 0.0f, 0.0f);
    [self.userHeaderView setHeaderViewForUser:User.currentUser];
    [super viewDidLoad];
}

@end
