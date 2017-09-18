//
//  UserTweetsViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 04/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "UserTimelineViewController.h"
#import "CoreDataHelper.h"

@interface TweetsTableViewController ()
@property (strong, nonatomic) NSString* userScreenName;
@end

@implementation UserTimelineViewController

@synthesize userScreenName;

NSString * const twitterUserTimelineKey = @"1.1/statuses/user_timeline.json";

- (id) initWithUser : (User *)user {
    self = [super init];
    self.userScreenName = user.screenName;
    return self;
}

- (void)viewDidLoad {
    [self loadTweetsFromCoreData];
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void) loadTweetsFromCoreData{
    NSManagedObjectContext *managedObjectContext = [CoreDataHelper managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user.screenName = %@",self.userScreenName]];
    NSSortDescriptor * createdAtSortDescriptor;
    createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
                                            ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:createdAtSortDescriptor, nil]];
    self.tweets = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"Loaded %ld tweets for %@ from coreData",[self.tweets count], self.userScreenName);
    [self.tableView reloadData];
}

-(NSString*) getEndPointWithMaxIdParameter:(NSString*)maxId {
    if(maxId) {
        return [NSString stringWithFormat:@"%@?screen_name=%@&max_id=%@", twitterUserTimelineKey, self.userScreenName, maxId];
    }
    else {
        return [NSString stringWithFormat:@"%@?screen_name=%@", twitterUserTimelineKey, self.userScreenName];;
    }
}

@end


