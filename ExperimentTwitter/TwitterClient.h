//
//  TwitterClient.h
//  ExperimentTwitter
//
//  Created by ayur.j on 25/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "User.h"

@interface TwitterClient : BDBOAuth1SessionManager

+ (TwitterClient *) sharedInstance;
- (void)loginWithCompletion:(void (^)(User *user, NSError *error)) completion;
- (void)openURL:(NSURL *)url;
- (void)homeTimelineWithParams:(NSDictionary*)params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)followersListWithParams:(NSDictionary*)params completion:(void (^)(NSArray *followers, NSString* cursor, NSError *error))completion;
@end
