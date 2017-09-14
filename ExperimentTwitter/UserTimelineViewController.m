//
//  UserTweetsViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 04/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "UserTimelineViewController.h"
#import "CoreDataHelper.h"

@implementation UserTimelineViewController

- (id) initWithUser : (User *)user {
    self = [super init];
    [self setUserForTimeline:user];
    return self;
}

- (void)viewDidLoad {
    self.endPoint = @"1.1/statuses/user_timeline.json";
    [self loadTweetsFromCoreData:self.userScreenName];
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void) loadTweetsFromCoreData:(NSString*)userScreenName{
    NSManagedObjectContext *managedObjectContext = [CoreDataHelper managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user.screenName = %@",userScreenName]];
    NSSortDescriptor * createdAtSortDescriptor;
    createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
                                            ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:createdAtSortDescriptor, nil]];
    self.tweets = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"Loaded %ld tweets for %@ from coreData",[self.tweets count], userScreenName);
    [self.tableView reloadData];
}

@end


