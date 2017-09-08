//
//  HomeTimelineViewController.m
//  ExperimentTwitter
//
//  Created by ayur.j on 08/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "HomeTimelineViewController.h"

@implementation HomeTimelineViewController

- (void)viewDidLoad {
    self.endPoint = @"1.1/statuses/home_timeline.json";
    [super viewDidLoad];
}

@end
