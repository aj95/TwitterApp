//
//  CustomTweetCell.h
//  ExperimentTwitter
//
//  Created by ayur.j on 29/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet+Twitter.h"

@interface CustomTweetCell : UITableViewCell

@property (strong, nonatomic, nullable) Tweet* tweet;
@property (weak, nonatomic, nullable) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic, nullable) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic, nullable) IBOutlet UIButton *replyButton;

@end
