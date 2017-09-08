//
//  UserTweetsViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 04/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "UserTimelineViewController.h"


@implementation UserTimelineViewController

- (id) initWithUser : (User *)user {
    self = [super init];
    [self setUserForTimeline:user];
    return self;
}

- (void)viewDidLoad {
    self.endPoint = @"1.1/statuses/user_timeline.json";
    [super viewDidLoad];
}

@end


