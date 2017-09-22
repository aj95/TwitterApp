//
//  TabBarViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 29/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "TabBarViewController.h"
#import "FollowersViewController.h"
#import "HomeTimelineViewController.h"
#import "UserProfileViewController.h"
#import "PostTweetViewController.h"
#import "FollowingViewController.h"

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *homeTimelineTab = [[HomeTimelineViewController alloc] init];
    UIViewController *followingTab = [[FollowingViewController alloc] init];
    UIViewController *followersTab = [[FollowersViewController alloc] init];
    UIViewController *profileTab = [[UserProfileViewController alloc] init];
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController: homeTimelineTab];
    UINavigationController *followingNavigationController = [[UINavigationController alloc] initWithRootViewController: followingTab];
    UINavigationController *followersNavigationController = [[UINavigationController alloc] initWithRootViewController: followersTab];
    UINavigationController *profileNavigationController = [[UINavigationController alloc] initWithRootViewController: profileTab];
    [tabViewControllers addObject:homeNavigationController];
    [tabViewControllers addObject:followingNavigationController];
    [tabViewControllers addObject:followersNavigationController];
    [tabViewControllers addObject:profileNavigationController];
    [self setViewControllers:tabViewControllers];
    homeTimelineTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image: [UIImage imageNamed:@"HomeButton"] tag:1];
    followingTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Following" image: [UIImage imageNamed:@"FollowingButton"] tag:2];
    followersTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Followers" image: [UIImage imageNamed:@"FollowingButton"] tag:3];
    profileTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image: [UIImage imageNamed:@"MyProfile"] tag:4];
}

@end
