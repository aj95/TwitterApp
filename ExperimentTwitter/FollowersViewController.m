//
//  FollowersViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 30/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "FollowersViewController.h"
#import "User+Twitter.h"

@implementation FollowersViewController

- (void)viewDidLoad {
    self.endPoint = @"1.1/followers/list.json";
    self.navigationItem.title = @"Followers";
    User *currentUser = [User currentUser];
    self.users = [NSMutableArray arrayWithArray:[currentUser.followers allObjects]];
    //NSSortDescriptor * createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    //self.users = [self.users sortedArrayUsingDescriptors:@[createdAtSortDescriptor]];
    [super viewDidLoad];
}


- (void)setRelationshipOnUsers:(NSArray *)users {
    if (!users) {
        users = self.users;
        [[User currentUser] addFollowers:[NSSet setWithArray:self.users]];
    }
}

@end
