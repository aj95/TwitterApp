//
//  FollowingViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 07/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "FollowingViewController.h"
#import "User+Twitter.h"
#import "CoreDataHelper.h"
@implementation FollowingViewController

- (void)viewDidLoad {
    self.endPoint = @"1.1/friends/list.json";
    self.navigationItem.title = @"Following";
    User *currentUser = [User currentUser];
    self.users = [NSMutableArray arrayWithArray:[currentUser.following allObjects]];
    NSSortDescriptor * nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    self.users = [NSMutableArray arrayWithArray:[self.users sortedArrayUsingDescriptors:@[nameSortDescriptor]]];
    NSLog(@"Fetched %ld following from coredata",[self.users count]);
    [self.tableView reloadData];
    [super viewDidLoad];
}

- (void)setRelationshipOnUsers:(NSArray *)users {
    //NSLog(@"%@", users);
    //if (!users) {
    //    users = self.users;
   // }
    [[User currentUser] addFollowing:[NSSet setWithArray:users]];
}

@end
