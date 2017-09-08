//
//  FollowingViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 07/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "FollowingViewController.h"

@implementation FollowingViewController

- (void)viewDidLoad {
    self.endPoint = @"1.1/friends/list.json";
    self.navigationItem.title = @"Following";
    [super viewDidLoad];
}

@end
