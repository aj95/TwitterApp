//
//  FollowersViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 30/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "FollowersViewController.h"
#import "CustomUserCell.h" 
#import "User.h"
#import "TwitterClient.h"

@interface FollowersViewController ()
@property (strong, nonatomic) NSArray * followers;
@end

@implementation FollowersViewController

@synthesize followers = _followers;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.followers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    if(!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CustomUserCell" bundle:nil] forCellReuseIdentifier:@"userCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
        
    }
    User *follower = [self.followers objectAtIndex:indexPath.row];
    cell.follower = follower;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.tableFooterView = [UIView new];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 200;
    [[TwitterClient sharedInstance] followersListWithParams:nil completion:^(NSArray *followers, NSError *error) {
        self.followers = followers;
        for(User *follower in _followers) {
            //NSLog(@"Text = %@, CreatedAt: %@", tweet.text, tweet.createdAt);
            NSLog(@"Follwer Name = %@", follower.name);
        }
        [self.tableView reloadData];
    }];
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
