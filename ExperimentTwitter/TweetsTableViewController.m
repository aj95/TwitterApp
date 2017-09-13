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


@interface TweetsTableViewController ()
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (nonatomic) BOOL loadMoreData;
@end

@implementation TweetsTableViewController

@synthesize refreshControl;

- (void) setUserForTimeline:(User *)user {
    self.userScreenName = user.screenName;
}
/*
- (NSMutableArray*) tweets {
    if(!self.tweets) {
        self.tweets = [[NSMutableArray alloc]init];
    }
    return self.tweets;
}
*/
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
    cell.replyButton.tag = indexPath.row;
    [cell.replyButton addTarget:self action:@selector(onReplyButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.tweets count] - 5 && self.loadMoreData) {
        [[TwitterClient sharedInstance]tweetsWithParams:@{@"endPoint":[self getEndPointWithMaxId]}  completion:^(NSArray *tweets, NSError *error) {
            if(!error) {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 333;
    self.loadMoreData = YES;
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [[TwitterClient sharedInstance]tweetsWithParams:@{@"endPoint":[self getEndPoint]} completion:^(NSArray *tweets, NSError *error) {
        if(!error) {
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

-(IBAction)onReplyButtonPress:(UIButton*)sender {
    PostTweetViewController *viewController = [[PostTweetViewController alloc] initForReplyToTweet:[self.tweets objectAtIndex:sender.tag]];
    [[self navigationController] pushViewController:viewController animated:YES];
}

- (void)refreshTable {
    [[TwitterClient sharedInstance]tweetsWithParams:@{@"endPoint":[self getEndPoint]} completion:^(NSArray *tweets, NSError *error) {
         if(!error) {
             [self.tweets removeAllObjects];
             [self sortTweetsListByCreatedAt:&tweets];
             [self.tweets addObjectsFromArray:tweets];
             [self.refreshControl endRefreshing];
             [self.tableView reloadData];
         }
    }];

}

-(NSString*) getEndPoint {
    if(self.userScreenName != nil) {
        return [NSString stringWithFormat:@"%@?screen_name=%@", self.endPoint, self.userScreenName];
    }
    else {
        return self.endPoint;
    }
}

-(NSString*) getEndPointWithMaxId {
    Tweet *tweet = [self.tweets lastObject];
    NSString* maxId = [NSString stringWithFormat:@"%ld",[tweet.tweetId integerValue] - 1];
    if(self.userScreenName != nil) {
        return [NSString stringWithFormat:@"%@?screen_name=%@&max_id=%@", self.endPoint, self.userScreenName, maxId];
    }
    else {
        return [NSString stringWithFormat:@"%@?max_id=%@", self.endPoint,maxId];
    }
}

-(void)sortTweetsListByCreatedAt:(NSArray**)tweets {
    NSSortDescriptor * createdAtSortDescriptor;
    createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
                                                          ascending:NO];
    *tweets = [NSMutableArray arrayWithArray:[*tweets sortedArrayUsingDescriptors:@[createdAtSortDescriptor]]];
}



@end
