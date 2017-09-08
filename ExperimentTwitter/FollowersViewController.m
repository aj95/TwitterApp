//
//  FollowersViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 30/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "FollowersViewController.h"

@implementation FollowersViewController

- (void)viewDidLoad {
    self.endPoint = @"1.1/followers/list.json";
    self.navigationItem.title = @"Followers";
    [super viewDidLoad];
}

@end
