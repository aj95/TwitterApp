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
@property (strong, nonatomic) NSArray * tweets;
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
    return cell;
    
}

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
        self.tweets = tweets;
        for(Tweet *tweet in _tweets) {
         //NSLog(@"Text = %@, CreatedAt: %@", tweet.text, tweet.createdAt);
            NSLog(@"Media = %@", tweet.mediaUrl);
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
