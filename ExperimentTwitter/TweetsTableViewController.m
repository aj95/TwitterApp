//
//  TweetsViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 25/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "TweetsTableViewController.h"
#import "PostTweetViewController.h"
#import "CustomTweetCell.h"
#import "TwitterClient.h"
#import "Tweet+Twitter.h"
#import "TweetsSearchViewController.h"

@interface TweetsTableViewController ()
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL loadMoreData;
@end

@implementation TweetsTableViewController

- (id) initWithTweets:(NSArray *)tweets {
    self = [super init];
    self.tweets = [NSMutableArray arrayWithArray:tweets];
    return self;
}

@synthesize refreshControl;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CustomTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    cell.tweet = tweet;
    cell.replyButton.tag = indexPath.row;
    [cell.replyButton addTarget:self action:@selector(onReplyButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == (self.tweets.count - 5) && self.loadMoreData) {
        [[TwitterClient sharedInstance]tweetsWithParams:@{@"endPoint":[self getEndPointWithMaxIdParameter:[self getMaxIdParameterFromLastTweet]]}
                                             completion:^(NSArray *tweets, NSError *error) {
            if(error == nil) {
                if([tweets count] > 0) {
                    [self sortTweetsListByCreatedAt:&tweets];
                    [self.tweets addObjectsFromArray:tweets];
                    [self.tableView reloadData];
                }
                else {
                    self.loadMoreData = NO;
                }
            }
        }];
    }
}

- (void) fetchMoreTweets {
    [[TwitterClient sharedInstance]tweetsWithParams:@{@"endPoint":[self getEndPointWithMaxIdParameter:[self getMaxIdParameterFromLastTweet]]}
                                         completion:^(NSArray *tweets, NSError *error) {
        if(error == nil) {
            if([tweets count] > 0) {
                [self sortTweetsListByCreatedAt:&tweets];
                [self.tweets addObjectsFromArray:tweets];
                [self.tableView reloadData];
            }
            else {
                self.loadMoreData = NO;
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 333;
    self.loadMoreData = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTweetCell" bundle:nil] forCellReuseIdentifier:@"tweetCell"];
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    if([self getEndPointWithMaxIdParameter:nil] != nil) {
        [[TwitterClient sharedInstance]tweetsWithParams:@{@"endPoint":[self getEndPointWithMaxIdParameter:nil]}
                                             completion:^(NSArray *tweets, NSError *error) {
            if(error == nil) {
                self.tweets = [[NSMutableArray alloc]init];
                if([tweets count] > 0) {
                    [self sortTweetsListByCreatedAt:&tweets];
                    [self.tweets addObjectsFromArray:tweets];
                    [self.tableView reloadData];
                }
                else {
                    self.loadMoreData = NO;
                }
            }
        }];
    }
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

-(IBAction)onTweetButtonPress {
    PostTweetViewController *viewController = [[PostTweetViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)onSearchButtonPress {
    TweetsSearchViewController *viewController = [[TweetsSearchViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)onReplyButtonPress:(UIButton*)sender {
    PostTweetViewController *viewController = [[PostTweetViewController alloc] initForReplyToTweet:self.tweets[sender.tag]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)refreshTable {
    [[TwitterClient sharedInstance]tweetsWithParams:@{@"endPoint":[self getEndPointWithMaxIdParameter:nil]}
                                         completion:^(NSArray *tweets, NSError *error) {
         if(error == nil) {
             [self.tweets removeAllObjects];
             [self sortTweetsListByCreatedAt:&tweets];
             [self.tweets addObjectsFromArray:tweets];
             [self.refreshControl endRefreshing];
             [self.tableView reloadData];
         }
    }];

}

-(NSString*) getEndPointWithMaxIdParameter:(NSString*)maxId {
    // OVERRIDDEN BY SUBCLASSES
    return NULL;
}

-(NSString*) getMaxIdParameterFromLastTweet {
    Tweet *tweet = [self.tweets lastObject];
    NSString *maxId = [NSString stringWithFormat:@"%ld",[tweet.tweetId integerValue] - 1];
    return maxId;
}

-(void)sortTweetsListByCreatedAt:(NSArray**)tweets {
    NSSortDescriptor *createdAtSortDescriptor;
    createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    *tweets = [NSMutableArray arrayWithArray:[*tweets sortedArrayUsingDescriptors:@[createdAtSortDescriptor]]];
}

@end
