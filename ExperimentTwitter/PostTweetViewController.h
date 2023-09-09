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
-(id) initForReplyToTweet:(Tweet*) tweet;
@end
