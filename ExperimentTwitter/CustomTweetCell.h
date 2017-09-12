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
@property (weak, nonatomic, nullable) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic, nullable) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic,nullable) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic,nullable) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic, nullable) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic, nullable) IBOutlet UIImageView *tweetImageView;
@property (strong, nonatomic, nullable) Tweet* tweet;
@property (strong, nonatomic, nullable) NSString* cellTag;
@property (weak, nonatomic, nullable) IBOutlet UILabel *favouriteCountLabel;
@property (weak, nonatomic, nullable) IBOutlet UILabel *retweetCountLabel;
@end
