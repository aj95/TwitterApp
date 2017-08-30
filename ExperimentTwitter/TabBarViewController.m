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

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIViewController *homeTimelineTab = [[TweetsViewController alloc] init];
    UIViewController *followersTab = [[FollowersViewController alloc] init];
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] init];
    [tabViewControllers addObject:homeTimelineTab];
    [tabViewControllers addObject:followersTab];
    [self setViewControllers:tabViewControllers];
    homeTimelineTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image: [UIImage imageNamed:@"HomeButton"] tag:1];
    followersTab.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Followers" image:nil tag:2];
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
