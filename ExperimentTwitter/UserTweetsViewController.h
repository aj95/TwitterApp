//
//  UserTweetsViewController.h
//  ExperimentTwitter
//
//  Created by ayur.j on 04/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserTweetsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (id) initWithUser : (User *)user;
@end
