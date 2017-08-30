//
//  CustomUserCell.h
//  ExperimentTwitter
//
//  Created by ayur.j on 30/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface CustomUserCell : UITableViewCell

@property (strong, nonatomic, nullable) User* follower;
@property (weak, nonatomic, nullable) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic,nullable) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic,nullable) IBOutlet UIImageView *profileImageView;

@end
