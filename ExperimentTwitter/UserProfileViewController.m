//
//  UserProfileViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 04/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "UserProfileViewController.h"
#import "CustomTweetCell.h"
#import "TwitterClient.h"
#import "PostTweetViewController.h"
#import "UserTimelineViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
/*
@interface UserProfileViewController ()
@property (strong, nonatomic) NSMutableArray* tweets;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (nonatomic) BOOL loadMoreData;
@end

@implementation UserProfileViewController


@synthesize refreshControl;

-(id) init {
    self = [super init];
    self.user = [User currentUser];
    return self;
}

- (NSMutableArray*) tweets {
    if(!_tweets) {
        _tweets = [[NSMutableArray alloc]init];
    }
    return _tweets;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    if(!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CustomTweetCell" bundle:nil] forCellReuseIdentifier:@"tweetCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    }
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    cell.tweet = tweet;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.tweets count] - 5 && self.loadMoreData) {
        [[TwitterClient sharedInstance]tweetsWithParams:@{@"endPoint":[self getEndPointWithMaxId]}  completion:^(NSArray *tweets, NSError *error) {
            if([tweets count] > 0) {
                [self.tweets addObjectsFromArray:tweets];
                [self.tableView reloadData];
            }
            else {
                self.loadMoreData = NO;
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 333;
    self.loadMoreData = YES;
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [[TwitterClient sharedInstance]tweetsWithParams:@{@"endPoint":[self getEndPoint]} completion:^(NSArray *tweets, NSError *error) {
        if([tweets count] > 0) {
            [self.tweets addObjectsFromArray:tweets];
            [self.tableView reloadData];
        }
        else {
            self.loadMoreData = NO;
        }
    }];
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Tweet"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onTweetButtonPress)];
    self.navigationItem.rightBarButtonItem = tweetButton;
}


-(IBAction)onTweetButtonPress {
    PostTweetViewController *viewController = [[PostTweetViewController alloc]init];
    [[self navigationController] pushViewController:viewController animated:YES];
}

- (void)refreshTable {
    [[TwitterClient sharedInstance]tweetsWithParams:@{@"endPoint":[self getEndPoint]} completion:^(NSArray *tweets, NSError *error) {
        [self.tweets removeAllObjects];
        [self.tweets addObjectsFromArray:tweets];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
    
}

-(NSString*) getEndPoint {
    return [NSString stringWithFormat:@"1.1/statuses/user_timeline.json?screen_name=%@", self.user.screenName];

}

-(NSString*) getEndPointWithMaxId {
    Tweet *tweet = [self.tweets lastObject];
    NSString* maxId = [NSString stringWithFormat:@"%ld",[tweet.tweetId integerValue] - 1];
   return [NSString stringWithFormat:@"1.1/statuses/user_timeline.json?screen_name=%@&max_id=%@",self.user.screenName, maxId];

}


- (void) updateUI {
    self.handleLabel.text = [NSString stringWithFormat: @"@%@", self.user.screenName];
    self.userNameLabel.text = self.user.name;
    self.profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.user.profileImageUrl]]];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.clipsToBounds = YES;
}


- (IBAction)onLogoutPress:(id)sender {
    [User logout];
}

*/

@interface UserProfileViewController ()
@property (strong, nonatomic) UserTimelineViewController* myProfileViewController;
@end

@implementation UserProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _myProfileViewController = [[UserTimelineViewController alloc] initWithUser:[User currentUser]];
    self.tableView.dataSource = _myProfileViewController;
    self.tableView.delegate = _myProfileViewController;
    [self updateUI];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 333;
    [_myProfileViewController viewDidLoad];
    
}

- (void) updateUI {
    User *currentUser = [User currentUser];
    self.handleLabel.text = [NSString stringWithFormat: @"@%@", currentUser.screenName];
    self.userNameLabel.text = currentUser.name;
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:currentUser.profileImageUrl]];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.clipsToBounds = YES;
}


- (IBAction)onLogoutPress:(id)sender {
    [User logout];
}

@end
