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

NSString *const TwitterHomeTimelineKey = @"1.1/statuses/home_timeline.json";

-(id)init {
    User *currentUser = User.currentUser;
    NSManagedObjectContext *managedObjectContext = [CoreDataHelper managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user.userId in %@.userId", currentUser.following]];
    NSArray *tweets = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    self = [super initWithTweets:tweets];
    NSLog(@"Fetched %ld tweets for home timeline", tweets.count);
    return self;
}

- (void)viewDidLoad {
    self.navigationItem.title = @"Home";
    [super viewDidLoad];
}

- (NSString*)getEndPointWithMaxIdParameter:(NSString*)maxId {
    return (maxId != nil) ? [NSString stringWithFormat:@"%@?max_id=%@", TwitterHomeTimelineKey, maxId] : TwitterHomeTimelineKey;
}

@end
