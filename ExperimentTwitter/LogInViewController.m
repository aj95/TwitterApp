//
//  LogInViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 25/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "LogInViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController
- (IBAction)onLogin:(id)sender {
   [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
       if(user!=nil) {
           NSLog(@"Welcome to %@", user.name);
           [self presentViewController:[[TweetsViewController alloc] init] animated:NO completion:nil];
       } else {
           NSLog(@"Error");
       }
   }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
