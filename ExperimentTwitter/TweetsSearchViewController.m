//
//  TweetsSearchViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 14/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "TweetsSearchViewController.h"
#import "CoreDataHelper.h"
#import "CustomTweetCell.h"
#import "CustomUserCell.h"
#import "PostTweetViewController.h"
#import "TwitterClient.h"

@interface TweetsSearchViewController ()<CustomTweetCellDelegate>
@property(strong, nonatomic) UISearchController *searchController;
@property(strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) NSArray *users;
@end

@implementation TweetsSearchViewController

- (void)viewDidLoad {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 333;
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomUserCell" bundle:nil] forCellReuseIdentifier:@"userCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTweetCell" bundle:nil] forCellReuseIdentifier:@"tweetCell"];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.dimsBackgroundDuringPresentation = YES;
    self.navigationItem.titleView = _searchController.searchBar;
    _searchController.searchBar.placeholder = @"Search Twitter";
    _searchController.searchBar.delegate = self;

    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar {
    if (searchBar == _searchController.searchBar) {
        searchBar.placeholder = @"Search Twitter";
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    if (searchBar == _searchController.searchBar) {
        NSLog(@"Search Button Pressed with query %@", _searchController.searchBar.text);
        self.searchText = _searchController.searchBar.text;
        _searchController.active = NO;
    }
}

- (void)setSearchText:(NSString *)searchText {
    [self fetchUsers:searchText];
    [self fetchTweets:searchText];
    [self.tableView reloadData];
}

- (void)dealloc {
    [_searchController.view removeFromSuperview];
}


- (void)fetchTweets:(NSString *)searchText {
    NSManagedObjectContext *managedObjectContext = [CoreDataHelper managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"text CONTAINS [cd] %@",searchText]];
    NSSortDescriptor *createdAtSortDescriptor;
    createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
                                                          ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:createdAtSortDescriptor, nil]];
    self.tweets = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    NSLog(@"Fetched %ld tweets for search query %@", [self.tweets count], searchText);
}


- (void)fetchUsers:(NSString *)searchText {
    NSManagedObjectContext *managedObjectContext = [CoreDataHelper managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name CONTAINS [cd] %@",searchText]];
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:nameSortDescriptor, nil]];
    self.users = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    NSLog(@"Fetched %ld users for search query %@", self.users.count, searchText);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? self.users.count : self.tweets.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
         return nil;
    } else {
       return (section == 0) ? @"Users" : @"Tweets";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CustomUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
        User *user = self.users[indexPath.row];
        cell.user = user;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        CustomTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
        Tweet *tweet = self.tweets[indexPath.row];
        cell.tweet = tweet;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
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

@end
