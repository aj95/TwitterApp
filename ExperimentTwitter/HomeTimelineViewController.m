//
//  HomeTimelineViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 08/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "HomeTimelineViewController.h"
#import "CoreDataHelper.h"

@implementation HomeTimelineViewController

- (void)viewDidLoad {
    self.endPoint = @"1.1/statuses/home_timeline.json";
    self.navigationItem.title = @"Home";
    [self loadTweetsFromCoreData];
    [super viewDidLoad];
}


- (void) loadTweetsFromCoreData {
    User* currentUser = [User currentUser];
    NSManagedObjectContext *managedObjectContext = [CoreDataHelper managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user.userId in %@.userId",currentUser.following]];
    NSSortDescriptor * createdAtSortDescriptor;
    createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
                                                        ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:createdAtSortDescriptor, nil]];
    self.tweets = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"Fetched %ld tweets for home timeline", [self.tweets count]);
    [self.tableView reloadData];
}

@end
