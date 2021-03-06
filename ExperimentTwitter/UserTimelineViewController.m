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
@property (nonatomic) NSString *userScreenName;
@end

@implementation UserTimelineViewController

@synthesize userScreenName;

NSString *const TwitterUserTimelineKey = @"1.1/statuses/user_timeline.json";

- (id)initWithUser:(User*)user {
    NSManagedObjectContext *managedObjectContext = [CoreDataHelper managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user.screenName = %@", user.screenName]];
    NSArray *tweets = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
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

- (NSString*)getEndPointWithMaxIdParameter:(NSString*)maxId {
    return (maxId != nil) ? [NSString stringWithFormat:@"%@?screen_name=%@&max_id=%@", TwitterUserTimelineKey, self.userScreenName, maxId] : [NSString stringWithFormat:@"%@?screen_name=%@", TwitterUserTimelineKey, self.userScreenName];;
}

@end


