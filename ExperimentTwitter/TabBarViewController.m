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

@interface TabBarViewController ()
@property(strong, nonatomic) UINavigationController * HomeNavigationController;
@property(strong, nonatomic) UINavigationController * FollowersNavigationController;
@property(strong, nonatomic) UINavigationController * FollowingNavigationController;
@property(strong, nonatomic) UINavigationController * ProfileNavigationController;
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *homeTimelineTab = [[HomeTimelineViewController alloc] init];
    UIViewController *followingTab = [[FollowingViewController alloc] init];
    UIViewController *followersTab = [[FollowersViewController alloc] init];
    UIViewController *profileTab = [[UserProfileViewController alloc] init];
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    self.HomeNavigationController = [[UINavigationController alloc] initWithRootViewController: homeTimelineTab];
    self.FollowingNavigationController = [[UINavigationController alloc] initWithRootViewController: followingTab];
    self.FollowersNavigationController = [[UINavigationController alloc] initWithRootViewController: followersTab];
    self.ProfileNavigationController = [[UINavigationController alloc] initWithRootViewController: profileTab];
    //[tabViewControllers addObject:self.HomeNavigationController];
    //[tabViewControllers addObject:self.FollowingNavigationController];
    //[tabViewControllers addObject:self.FollowersNavigationController];
    [tabViewControllers addObject:self.ProfileNavigationController];
    [self setViewControllers:tabViewControllers];
    homeTimelineTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image: [UIImage imageNamed:@"HomeButton"] tag:1];
    followingTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Following" image: [UIImage imageNamed:@"FollowingButton"] tag:2];
    followersTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Followers" image: [UIImage imageNamed:@"FollowingButton"] tag:3];
    profileTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image: [UIImage imageNamed:@"MyProfile"] tag:4];
}

@end
