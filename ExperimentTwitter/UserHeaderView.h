//
//  UserHeaderView.h
//  ExperimentTwitter
//
//  Created by ayur.j on 18/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeaderView : UIView
@property (strong, nonatomic, nullable) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic, nullable) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic, nullable) IBOutlet UILabel *handleLabel;
@end
