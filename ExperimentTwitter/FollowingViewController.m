//
//  FollowingViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 07/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "FollowingViewController.h"
#import "User+Twitter.h"

@implementation FollowingViewController

- (void)viewDidLoad {
    self.endPoint = @"1.1/friends/list.json";
    self.navigationItem.title = @"Following";
    User *currentUser = [User currentUser];
    self.users = [NSMutableArray arrayWithArray:[currentUser.followers allObjects]];
    [super viewDidLoad];
}

- (void)setRelationshipOnUsers:(NSArray *)users {
    if (!users) {
        users = self.users;
        [[User currentUser] addFollowing:[NSSet setWithArray:self.users]];
    }
}

@end
