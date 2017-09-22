//
//  UsersTableViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 07/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "UsersTableViewController.h"
#import "UserTimelineViewController.h"
#import "PostTweetViewController.h"
#import "CustomUserCell.h"
#import "TwitterClient.h"
#import "User+Twitter.h"
#import "TweetsSearchViewController.h"

@interface UsersTableViewController ()
@property (strong, nonatomic, readonly) NSMutableArray *users;
@property (nonatomic) NSString *cursor;
@end

@implementation UsersTableViewController

-(id) initWithUsers:(NSArray *)users {
    self = [super init];
    if(self) {
        if(users == nil) {
            _users = [NSMutableArray array];
        } else {
            NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            _users = [[users sortedArrayUsingDescriptors:@[nameSortDescriptor]] mutableCopy];
        }
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CustomUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
  User *user = self.users[indexPath.row];
  cell.user = user;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == (self.users.count - 5) && ![self.cursor isEqualToString:@"0"]) {
    [[TwitterClient sharedInstance] usersListWithParams:@{@"endPoint":[self getEndPoint]}
                                             completion:^(NSArray *users, NSString *cursor, NSError *error) {
      if (error == nil) {
        [self loadNewUsers:users];
        self.cursor = cursor;
        [self.tableView reloadData];
      } else {
          NSLog(@"Unable to load more users!");
      }
    }];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = self.users[indexPath.row];
    UserTimelineViewController *viewController = [[UserTimelineViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomUserCell" bundle:nil] forCellReuseIdentifier:@"userCell"];
    self.cursor = @"-1";
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [[TwitterClient sharedInstance] usersListWithParams:@{@"endPoint":[self getEndPoint]}
                                             completion:^(NSArray *users, NSString *cursor, NSError *error) {
        if (error == nil) {
            [self.users removeAllObjects];
            [self loadNewUsers:users];
            self.cursor = cursor;
            [self.tableView reloadData];
        }
    }];
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Tweet"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onTweetButtonPress)];
    self.navigationItem.rightBarButtonItem = tweetButton;
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Search"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(onSearchButtonPress)];
    self.navigationItem.leftBarButtonItem = searchButton;
}

- (IBAction)onTweetButtonPress {
    PostTweetViewController *viewController = [[PostTweetViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (IBAction)onSearchButtonPress {
    TweetsSearchViewController *viewController = [[TweetsSearchViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)refreshTable {
    self.cursor = @"-1";
    [[TwitterClient sharedInstance] usersListWithParams:@{@"endPoint":[self getEndPoint]}
                                             completion:^(NSArray *users, NSString *cursor,NSError *error) {
        if (error == nil) {
          [self.users removeAllObjects];
          [self loadNewUsers:users];
          self.cursor = cursor;
        }
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

- (NSString*)getEndPoint {
    return [NSString stringWithFormat:@"%@?cursor=%@",self.endPoint, self.cursor];
}

- (void)setRelationshipOnUsers:(NSArray*)users {
    // Implemented in subclasses
}

- (NSArray*)sortUsersListByFirstName:(NSArray*)users {
  NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  users = [NSMutableArray arrayWithArray:[users sortedArrayUsingDescriptors:@[nameSortDescriptor]]];
  return users;
}

- (void)loadNewUsers:(NSArray*)users {
  users = [self sortUsersListByFirstName:users];
  [self.users addObjectsFromArray:users];
  [self setRelationshipOnUsers:users];
}

@end
