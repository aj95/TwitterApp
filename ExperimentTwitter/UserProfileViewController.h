//
//  UserProfileViewController.h
//  ExperimentTwitter
//
//  Created by ayur.j on 04/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "UserTimelineViewController.h"

@interface UserProfileViewController : UIViewController

@property (strong, nonatomic, nullable) User* user;
@property (weak, nonatomic, nullable) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic, nullable) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic, nullable) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic, nullable) IBOutlet UITableView *tableView;

@end
