//
//  UsersTableViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 07/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "UsersTableViewController.h"
#import "CustomUserCell.h"
#import "TwitterClient.h"
#import "UserTweetsViewController.h"

@interface UsersTableViewController ()
@property (strong, nonatomic) NSMutableArray * users;
@property (strong, nonatomic) NSString *cursor;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@end

@implementation UsersTableViewController

@synthesize refreshControl;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    if(!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CustomUserCell" bundle:nil] forCellReuseIdentifier:@"userCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    }
    User *user = [self.users objectAtIndex:indexPath.row];
    cell.user = user;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.users count] - 5 && ![self.cursor isEqualToString:@"0"]) {
        [[TwitterClient sharedInstance]usersListWithParams:@{@"endPoint":[self getEndPoint]} completion:^(NSArray *users, NSString* cursor, NSError *error) {
            [self.users addObjectsFromArray:users];
            [self.tableView reloadData];
            self.cursor = cursor;
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User* user = [self.users objectAtIndex:indexPath.row];
    UserTweetsViewController *viewController = [[UserTweetsViewController alloc] initWithUser:user];
    [[self navigationController] pushViewController:viewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    self.cursor = @"-1";
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [[TwitterClient sharedInstance] usersListWithParams:@{@"endPoint":[self getEndPoint]} completion:^(NSArray *users, NSString* cursor, NSError *error) {
        self.users = [[NSMutableArray alloc]init];
        [self.users addObjectsFromArray:users];
        self.cursor = cursor;
        [self.tableView reloadData];
    }];
}


-(NSString*) getEndPoint {
    return [NSString stringWithFormat:@"%@?cursor=%@",self.endPoint, self.cursor];
}

- (void)refreshTable {
    self.cursor = @"-1";
    [[TwitterClient sharedInstance] usersListWithParams:@{@"endPoint":[self getEndPoint]} completion:^(NSArray *users, NSString* cursor, NSError *error) {
        [self.users removeAllObjects];
        [self.users addObjectsFromArray:users];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

@end
