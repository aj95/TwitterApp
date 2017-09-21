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
@property (strong, nonatomic) NSString *userScreenName;
@end

@implementation UserTimelineViewController

@synthesize userScreenName;

NSString *const twitterUserTimelineKey = @"1.1/statuses/user_timeline.json";

- (id)initWithUser:(User*)user {
    NSManagedObjectContext *managedObjectContext = [CoreDataHelper managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user.screenName = %@", user.screenName]];
    NSSortDescriptor *createdAtSortDescriptor;
    createdAtSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt"
                                                          ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:createdAtSortDescriptor, nil]];
    NSMutableArray *tweets = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    self = [super initWithTweets:tweets];
    self.userScreenName = user.screenName;
    NSLog(@"Loaded %ld tweets for %@ from coreData", tweets.count, self.userScreenName);
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

-(NSString*) getEndPointWithMaxIdParameter:(NSString*)maxId {
    if(maxId) {
        return [NSString stringWithFormat:@"%@?screen_name=%@&max_id=%@", twitterUserTimelineKey, self.userScreenName, maxId];
    }
    return [NSString stringWithFormat:@"%@?screen_name=%@", twitterUserTimelineKey, self.userScreenName];;
}

@end


