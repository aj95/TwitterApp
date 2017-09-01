//
//  TweetsViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 25/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "CustomTweetCell.h"

@interface TweetsViewController ()
@property (strong, nonatomic) NSMutableArray* tweets;
@end

@implementation TweetsViewController

@synthesize tweets = _tweets;

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
   /* BOOL lastItemReached = [tweet isEqual:[self.tweets lastObject]];
    if(indexPath.row == ([self.tweets count] - 1))
        NSLog(@"%ld %lu %d",(long)indexPath.row, (unsigned long)[self.tweets count], lastItemReached);
    if(!lastItemReached)
        NSLog(@"%ld %lu %d",(long)indexPath.row, (unsigned long)[self.tweets count], lastItemReached);
    if (!lastItemReached && indexPath.row == ([self.tweets count] - 1))
    {
        NSLog(@"YES");
        [self launchReload];
    }*/
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // check if indexPath.row is last row
    // Perform operation to load new Cell's.
   // NSLog(@"!");
    //NSLog(@"%d %d", indexPath.row, [self.tweets count]);
    if(indexPath.row == [self.tweets count] - 1) {
        NSLog(@"I'm Here!");
        Tweet *tweet = [self.tweets lastObject];
        NSDictionary *params = [NSDictionary dictionaryWithObject:tweet.tweetId forKey: @"maxId"];
        [[TwitterClient sharedInstance]homeTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
            [self.tweets addObjectsFromArray:tweets];
            [self.tableView reloadData];
        }];
    }
}

/*
- (void)launchReload {
    [[TwitterClient sharedInstance]homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        _tweets = [[NSMutableArray alloc]init];
        [_tweets addObjectsFromArray:tweets];
       // for(Tweet *tweet in _tweets) {
            //NSLog(@"Text = %@, CreatedAt: %@", tweet.text, tweet.createdAt);
            //   NSLog(@"Media = %@", tweet.mediaUrl);
       // }
        [self.tableView reloadData];
    }];
 }*/

- (IBAction)onLogOut:(id)sender {
    [User logout];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tableView.tableFooterView = [UIView new];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 333;
    [[TwitterClient sharedInstance]homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweets = [[NSMutableArray alloc]init];
        [self.tweets addObjectsFromArray:tweets];
      //  for(Tweet *tweet in self.tweets) {
            //NSLog(@"Text = %@, CreatedAt: %@", tweet.text, tweet.createdAt);
         //   NSLog(@"Media = %@", tweet.mediaUrl);
      // }
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
