//
//  TweetsViewController.h
//  ExperimentTwitter
//
//  Created by ayur.j on 25/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface TweetsTableViewController : UITableViewController
@property(strong, nonatomic) NSString *endPoint;
- (void) setUserForTimeline : (User *)user;
@end
