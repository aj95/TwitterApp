//
//  LogInViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 25/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "LogInViewController.h"
#import "TwitterClient.h"
#import "TabBarViewController.h"

@implementation LogInViewController

- (IBAction)onLogin:(id)sender {
   [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
       if (user != nil) {
           NSLog(@"%@ logged in", user.name);
           [self presentViewController:[[TabBarViewController alloc] init] animated:NO completion:nil];
       } else {
           NSLog(@"Failed to login");
       }
   }];
}


@end
