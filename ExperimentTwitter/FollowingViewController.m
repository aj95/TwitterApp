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

- (id)init {
    User *currentUser = User.currentUser;
    NSMutableArray *users = [NSMutableArray arrayWithArray:[currentUser.following allObjects]];
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    users = [NSMutableArray arrayWithArray:[users sortedArrayUsingDescriptors:@[nameSortDescriptor]]];
    self = [super initWithUsers:users];
    NSLog(@"Fetched %ld following from coredata",users.count);
    return self;
}
- (void)viewDidLoad {
    self.endPoint = @"1.1/friends/list.json";
    self.navigationItem.title = @"Following";
    [super viewDidLoad];
}

- (void)setRelationshipOnUsers:(NSArray *)users {
    [User.currentUser addFollowing:[NSSet setWithArray:users]];
}

@end
