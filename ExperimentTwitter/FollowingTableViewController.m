//
//  FollowingTableViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 07/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "FollowingTableViewController.h"
#import "CustomUserCell.h"
#import "User.h"
#import "TwitterClient.h"
#import "UserTweetsViewController.h"

@interface FollowingTableViewController ()
@property (strong, nonatomic) NSMutableArray * following;
@property (strong, nonatomic) NSString *cursor;
@end

@implementation FollowingTableViewController

@synthesize following = _following;
@synthesize cursor = _cursor;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.following count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    if(!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CustomUserCell" bundle:nil] forCellReuseIdentifier:@"userCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    }
    User *follower = [self.following objectAtIndex:indexPath.row];
    cell.follower = follower;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // check if indexPath.row is last row
    // Perform operation to load new Cell's.
    // NSLog(@"!");
    //NSLog(@"%d %d", indexPath.row, [self.tweets count]);
    if(indexPath.row == [self.following count] - 1 && ![self.cursor isEqualToString:@"0"]) {
        NSLog(@"I'm Here!");
        NSDictionary *param = [NSDictionary dictionaryWithObject: self.cursor forKey: @"cursor"];
        [[TwitterClient sharedInstance]followingListWithParams:param completion:^(NSArray *following, NSString* cursor, NSError *error) {
            [self.following addObjectsFromArray:following];
            [self.tableView reloadData];
            self.cursor = cursor;
        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Followers";
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    NSDictionary *param = [NSDictionary dictionaryWithObject: @"-1" forKey: @"cursor"];
    [[TwitterClient sharedInstance] followingListWithParams:param completion:^(NSArray *following, NSString* cursor, NSError *error) {
        self.following = [[NSMutableArray alloc]init];
        [self.following addObjectsFromArray:following];
        self.cursor = cursor;
        //        for(User *follower in _followers) {
        //NSLog(@"Text = %@, CreatedAt: %@", tweet.text, tweet.createdAt);
        //          NSLog(@"Follwer Name = %@", follower.name);
        //      }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User* user =[self.following objectAtIndex:indexPath.row];
    NSLog(@"%@", user.screenName);
    UserTweetsViewController *viewController = [[UserTweetsViewController alloc] initWithUser:user];
    NSLog(@"YES I AM HERE");
    //NSLog(@"%@", [self navigationController]);
    [[self navigationController] pushViewController:viewController animated:YES];
    //[self presentModalViewController:viewController animated:YES];
    NSLog(@"PUSHED");
}

@end