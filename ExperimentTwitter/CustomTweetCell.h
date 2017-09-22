//
//  CustomTweetCell.h
//  ExperimentTwitter
//
//  Created by ayur.j on 29/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet+Twitter.h"

@protocol CustomTweetCellDelegate;

@interface CustomTweetCell : UITableViewCell

@property (nonatomic, weak) id<CustomTweetCellDelegate> delegate;

@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@end

@protocol CustomTweetCellDelegate <NSObject>

- (void)customTweetCell:(CustomTweetCell *)customTweetCell
pressedFavoriteButtonWithSelectionState:(BOOL)isSelected;
- (void)customTweetCell:(CustomTweetCell *)customTweetCell
pressedRetweetButtonWithSelectionState:(BOOL)isSelected;
- (void)customTweetCell:(CustomTweetCell *)customTweetCell
pressedReplyButtonWithSelectionState:(BOOL)isSelected;

@end
