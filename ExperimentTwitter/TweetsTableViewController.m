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

@interface TweetsTableViewController ()<CustomTweetCellDelegate>

@property (strong, nonatomic, readonly) NSMutableArray *tweets;
@property (nonatomic) BOOL loadMoreData;
@end

@implementation TweetsTableViewController

- (id)initWithTweets:(NSArray *)tweets {
    self = [super init];
    if(self) {
        if(tweets == nil) {
            _tweets = [NSMutableArray array];
        } else {
            NSSortDescriptor *createdAtSortDescriptor = [[NSSortDescriptor alloc]
                                                         initWithKey:@"createdAt" ascending:NO];
            _tweets = [[tweets sortedArrayUsingDescriptors:@[createdAtSortDescriptor]] mutableCopy];
        }
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    cell.tweet = tweet;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == (self.tweets.count - 5) && self.loadMoreData) {
        [[TwitterClient sharedInstance] tweetsWithParams: @{@"endPoint":[self getEndPointWithMaxIdParameter:[self getMaxIdParameterFromLastTweet]]}
                                             completion:^(NSArray *tweets, NSError *error) {
            if (error == nil) {
                if ([tweets count] > 0) {
                    [self addNewTweets:tweets];
                    [self.tableView reloadData];
                }
                else {
                    self.loadMoreData = NO;
                }
            }
        }];
    }
}

- (void)fetchMoreTweets {
    [[TwitterClient sharedInstance]tweetsWithParams:
  @{@"endPoint":[self getEndPointWithMaxIdParameter:[self getMaxIdParameterFromLastTweet]]}
                                         completion:^(NSArray *tweets, NSError *error) {
        if (error == nil) {
            if ([tweets count] > 0) {
                [self addNewTweets:tweets];
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
    if ([self getEndPointWithMaxIdParameter:nil] != nil) {
        [[TwitterClient sharedInstance]tweetsWithParams:@{@"endPoint":[self getEndPointWithMaxIdParameter:nil]}
                                             completion:^(NSArray *tweets, NSError *error) {
            if (error == nil) {
                [self.tweets removeAllObjects];
                if ([tweets count] > 0) {
                    [self addNewTweets:tweets];
                    [self.tableView reloadData];
                } else {
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

- (IBAction)onTweetButtonPress {
    PostTweetViewController *viewController = [[PostTweetViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onSearchButtonPress {
    TweetsSearchViewController *viewController = [[TweetsSearchViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)customTweetCell:(CustomTweetCell *)customTweetCell
pressedFavoriteButtonWithSelectionState:(BOOL)isSelected {
    if(isSelected) {
        [customTweetCell changeFavoriteButtonImageForUnlikedTweet];
        [customTweetCell changeFavoriteCountForUnLikedTweet];
        [[TwitterClient sharedInstance] unlikeTweetWithId : customTweetCell.tweet.tweetId];
    } else {
        [customTweetCell changeFavoriteButtonImageForLikedTweet];
        [customTweetCell changeFavoriteCountForLikedTweet];
        [[TwitterClient sharedInstance] likeTweetWithId : customTweetCell.tweet.tweetId];
    }
}

- (void)customTweetCell:(CustomTweetCell *)customTweetCell
pressedRetweetButtonWithSelectionState:(BOOL)isSelected {
    if(isSelected) {
        [customTweetCell changeRetweetButtonImageForUnRetweetedTweet];
        [customTweetCell changeRetweetCountForForUnRetweetedTweet];
        [[TwitterClient sharedInstance] untweetTweetWithId : customTweetCell.tweet.tweetId];
    } else {
        [customTweetCell changeRetweetButtonImageForRetweetedTweet];
        [customTweetCell changeRetweetCountForRetweetedTweet];
        [[TwitterClient sharedInstance] retweetTweetWithId : customTweetCell.tweet.tweetId];
    }
}

- (void)customTweetCellPressedReplyButton:(CustomTweetCell *)customTweetCell {
    PostTweetViewController *viewController = [[PostTweetViewController alloc] initForReplyToTweet:customTweetCell.tweet];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)refreshTable {
    [[TwitterClient sharedInstance]tweetsWithParams:@{@"endPoint":[self getEndPointWithMaxIdParameter:nil]}
                                         completion:^(NSArray *tweets, NSError *error) {
         if (error == nil) {
             [self.tweets removeAllObjects];
             [self addNewTweets:tweets];
             [self.refreshControl endRefreshing];
             [self.tableView reloadData];
         }
    }];

}

- (NSString*) getEndPointWithMaxIdParameter:(NSString*)maxId {
    // OVERRIDDEN BY SUBCLASSES
    return NULL;
}

- (NSString*)getMaxIdParameterFromLastTweet {
    Tweet *tweet = [self.tweets lastObject];
    NSString *maxId = [NSString stringWithFormat:@"%ld",[tweet.tweetId integerValue] - 1];
    return maxId;
}

- (NSArray*)sortTweetsListByCreatedAt:(NSArray*)tweets {
    NSSortDescriptor *createdAtSortDescriptor;
    createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    tweets = [NSMutableArray arrayWithArray:[tweets sortedArrayUsingDescriptors:@[createdAtSortDescriptor]]];
    return tweets;
}

- (void)addNewTweets:(NSArray*)tweets {
    tweets = [self sortTweetsListByCreatedAt:tweets];
    [self.tweets addObjectsFromArray:tweets];
}

@end
