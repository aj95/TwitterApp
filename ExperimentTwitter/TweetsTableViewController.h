//
//  TweetsViewController.h
//  ExperimentTwitter
//
//  Created by ayur.j on 25/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+Twitter.h"

@interface TweetsTableViewController : UITableViewController
@property(strong, nonatomic) NSString *endPoint;
@property (strong, nonatomic) NSMutableArray* tweets;
@property (strong, nonatomic) NSString* userScreenName;
- (void) setUserForTimeline : (User *)user;
@end
