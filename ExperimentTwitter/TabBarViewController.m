//
//  TabBarViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 29/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "TabBarViewController.h"
#import "FollowersViewController.h"
#import "TweetsViewController.h"
#import "UserProfileViewController.h"
#import "PostTweetViewController.h"
#import "FollowingTableViewController.h"

@interface TabBarViewController ()
@property(strong, nonatomic) UINavigationController * FollowersNavigationController;
@property(strong, nonatomic) UINavigationController * HomeNavigationController;
@property(strong, nonatomic) UINavigationController * FollowingNavigationController;
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIViewController *homeTimelineTab = [[TweetsViewController alloc] init];
    UIViewController *followersTab = [[FollowersViewController alloc] init];
    UIViewController *followingTab = [[FollowingTableViewController alloc] init];
    UIViewController *profileViewTab = [[UserProfileViewController alloc] init];
    
   // UIViewController *postTweetTab = [[PostTweetViewController alloc] init];
    
    
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    self.FollowersNavigationController = [[UINavigationController alloc] initWithRootViewController: followersTab];
     self.FollowingNavigationController = [[UINavigationController alloc] initWithRootViewController: followingTab];
    self.HomeNavigationController = [[UINavigationController alloc] initWithRootViewController: homeTimelineTab];
   // [tabViewControllers addObject:homeTimelineTab];
//[tabViewControllers addObject:postTweetTab];
    [tabViewControllers addObject:self.HomeNavigationController];
    [tabViewControllers addObject:self.FollowingNavigationController];
    [tabViewControllers addObject:self.FollowersNavigationController];
    [tabViewControllers addObject:profileViewTab];
    [self setViewControllers:tabViewControllers];
    
    homeTimelineTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image: [UIImage imageNamed:@"HomeButton"] tag:1];
    followingTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Following" image: [UIImage imageNamed:@"FollowingButton"] tag:2];
    followersTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Followers" image: [UIImage imageNamed:@"FollowingButton"] tag:3];
    profileViewTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me" image: [UIImage imageNamed:@"MyProfile"] tag:4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
