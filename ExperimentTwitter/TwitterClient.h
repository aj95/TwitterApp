//
//  TwitterClient.h
//  ExperimentTwitter
//
//  Created by ayur.j on 25/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "User+Twitter.h"

@interface TwitterClient : BDBOAuth1SessionManager

+ (TwitterClient*) sharedInstance;
- (void)loginWithCompletion:(void (^)(User *user, NSError *error)) completion;
- (void)openURL:(NSURL*)url;
- (void)likeTweetWithId:(NSString*)tweetId;
- (void)unlikeTweetWithId:(NSString*)tweetId;
- (void)retweetTweetWithId:(NSString*)tweetId;
- (void)untweetTweetWithId:(NSString*)tweetId;
- (void)postTweet:(NSString*)tweetText;
- (void)replyToTweetWithId:(NSString*)tweetId
                 tweetText:(NSString*)tweetText;
- (void)usersListWithParams:(NSDictionary*)params
                 completion:(void (^)(NSArray *users, NSString *cursor, NSError *error))completion;
- (void)tweetsWithParams:(NSDictionary*)params
              completion:(void (^)(NSArray *users,NSError *error))completion;
@end
