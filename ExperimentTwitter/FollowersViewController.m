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
#import "UserTweetsViewController.h"

@interface FollowersViewController ()
@property (strong, nonatomic) NSMutableArray * followers;
@property (strong, nonatomic) NSString *cursor;
@end

@implementation FollowersViewController

@synthesize followers = _followers;
@synthesize cursor = _cursor;

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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // check if indexPath.row is last row
    // Perform operation to load new Cell's.
    // NSLog(@"!");
    //NSLog(@"%d %d", indexPath.row, [self.tweets count]);
    if(indexPath.row == [self.followers count] - 1 && ![self.cursor isEqualToString:@"0"]) {
        NSLog(@"I'm Here!");
        NSDictionary *param = [NSDictionary dictionaryWithObject: self.cursor forKey: @"cursor"];
        [[TwitterClient sharedInstance]followersListWithParams:param completion:^(NSArray *followers, NSString* cursor, NSError *error) {
            [self.followers addObjectsFromArray:followers];
            [self.tableView reloadData];
            self.cursor = cursor;
        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Followers";
    // Do any additional setup after loading the view from its nib.
    _tableView.tableFooterView = [UIView new];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 200;
    NSDictionary *param = [NSDictionary dictionaryWithObject: @"-1" forKey: @"cursor"];
    [[TwitterClient sharedInstance] followersListWithParams:param completion:^(NSArray *followers, NSString* cursor, NSError *error) {
        self.followers = [[NSMutableArray alloc]init];
        [self.followers addObjectsFromArray:followers];
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
    User* user =[self.followers objectAtIndex:indexPath.row];
    NSLog(@"%@", user.screenName);
    UserTweetsViewController *viewController = [[UserTweetsViewController alloc] initWithUser:user];
    NSLog(@"YES I AM HERE");
    //NSLog(@"%@", [self navigationController]);
    [[self navigationController] pushViewController:viewController animated:YES];
    //[self presentModalViewController:viewController animated:YES];
    NSLog(@"PUSHED");
}

@end
