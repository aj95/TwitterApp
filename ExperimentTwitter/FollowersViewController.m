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

-(id) init {
    User *currentUser = User.currentUser;
    NSMutableArray *users = [NSMutableArray arrayWithArray:[currentUser.followers allObjects]];
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    users = [NSMutableArray arrayWithArray:[users sortedArrayUsingDescriptors:@[nameSortDescriptor]]];
    NSLog(@"Fetched %ld followers from coredata",users.count);
    self = [super initWithUsers:users];
    return self;
}

- (void)viewDidLoad {
    self.endPoint = @"1.1/followers/list.json";
    self.navigationItem.title = @"Followers";
    [super viewDidLoad];
}

- (void)setRelationshipOnUsers:(NSArray *)users {
    [User.currentUser addFollowers:[NSSet setWithArray:users]];
}


@end
