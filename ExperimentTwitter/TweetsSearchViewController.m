//
//  TweetsSearchViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 14/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "TweetsSearchViewController.h"
#import "CoreDataHelper.h"

@interface TweetsSearchViewController ()
@property(strong, nonatomic) UISearchController* searchController;
@property(strong, nonatomic) NSString* searchText;
@end

@implementation TweetsSearchViewController

- (void)viewDidLoad {
    self.endPoint = nil;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.dimsBackgroundDuringPresentation = YES;
    self.navigationItem.titleView = _searchController.searchBar;
    _searchController.searchBar.placeholder = @"Search Twitter";
    _searchController.searchBar.delegate = self;
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if(searchBar == _searchController.searchBar) {
        searchBar.placeholder = @"Search Twitter";
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if(searchBar == _searchController.searchBar) {
        NSLog(@"Search Button Pressed with query %@", _searchController.searchBar.text);
        self.searchText = _searchController.searchBar.text;
        _searchController.active = NO;
    }
}

- (void) setSearchText:(NSString *)searchText {
    NSManagedObjectContext *managedObjectContext = [CoreDataHelper managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"text CONTAINS [cd] %@",searchText]];
    NSSortDescriptor * createdAtSortDescriptor;
    createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
                                                          ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:createdAtSortDescriptor, nil]];
    self.tweets = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"Fetched %ld tweets for search query %@", [self.tweets count], searchText);
    [self.tableView reloadData];
}

-(void)dealloc {
    [_searchController.view removeFromSuperview];
}

@end
