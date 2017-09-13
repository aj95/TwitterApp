//
//  PostTweetViewController.h
//  ExperimentTwitter
//
//  Created by ayur.j on 05/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet+Twitter.h"

@interface PostTweetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
-(id) initForReplyToTweet:(Tweet*) tweet;
@end
