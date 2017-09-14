//
//  FollowersViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 30/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "FollowersViewController.h"
#import "User+Twitter.h"
#import "CoreDataHelper.h"
@implementation FollowersViewController

- (void)viewDidLoad {
    self.endPoint = @"1.1/followers/list.json";
    self.navigationItem.title = @"Followers";
    User *currentUser = [User currentUser];
    self.users = [NSMutableArray arrayWithArray:[currentUser.followers allObjects]];
    NSSortDescriptor * nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.users = [NSMutableArray arrayWithArray:[self.users sortedArrayUsingDescriptors:@[nameSortDescriptor]]];
    NSLog(@"Fetched %ld followers from coredata",[self.users count]);
    [self.tableView reloadData];
    [super viewDidLoad];
}

- (void)setRelationshipOnUsers:(NSArray *)users {
    [[User currentUser] addFollowers:[NSSet setWithArray:users]];
}


@end
