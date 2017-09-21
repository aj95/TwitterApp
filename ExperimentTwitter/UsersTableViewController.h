//
//  UsersTableViewController.h
//  ExperimentTwitter
//
//  Created by ayur.j on 07/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersTableViewController : UITableViewController

@property(strong, nonatomic) NSString *endPoint;
- (void)setRelationshipOnUsers:(NSArray *)users;
- (id)initWithUsers:(NSArray*)users;
@end
