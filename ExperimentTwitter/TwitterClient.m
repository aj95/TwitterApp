//
//  TwitterClient.m
//  ExperimentTwitter
//
//  Created by ayur.j on 25/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet+Twitter.h"
#import "User+Twitter.h"
#import "CoreDataHelper.h"
#import "Tweet+Twitter.h"

NSString *const twitterConsumerKey = @"2RV0vPnG8lbcdOqDL9nBl9y0E";
NSString *const twitterConsumerSecret = @"1ua0pfkMArkBzuHxQhpAK4MQda7AhSs2n4g6BxQVLbAIyifRRo";
NSString *const twitterBaseURL = @"https://api.twitter.com";

@interface TwitterClient()
@property (nonatomic, strong) void(^loginCompletion)(User *user, NSError *error);
@end


@implementation TwitterClient
+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:twitterBaseURL]
                                                  consumerKey:twitterConsumerKey
                                               consumerSecret:twitterConsumerSecret];
        }
    });
    return instance;
}

- (void)loginWithCompletion:(void(^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"twitterapp://oauth"] scope: nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Sucessfully obtained token");
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat : @"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL options: @{} completionHandler:nil];
    } failure:^(NSError *error) {
        NSLog(@"Failed to obtain request token");
        self.loginCompletion(nil, error);
    }];
}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"Got the access token");
        [self.requestSerializer saveAccessToken: accessToken];
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
            NSLog(@"Fetching user");
            
        } success:^(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject) {
            User *user = [User userWithTwitterInfo:responseObject inManagedObjectContext:[CoreDataHelper managedObjectContext]];
            [User setCurrentUser:user];  //IMPORTANT UNCOMMENT THIS
            NSLog(@"Current User : %@",user.name);
            self.loginCompletion(user, nil);
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSLog(@"Failed to get current user");
            self.loginCompletion(nil, error);
        }];
    }failure:^(NSError *error) {
        NSLog(@"Failed to get access token");
        self.loginCompletion(nil, error);
    }];
}

- (void)likeTweetWithId:(NSString*)tweetId {
    NSString *endPoint = [NSString stringWithFormat:@"1.1/favorites/create.json?id=%@",tweetId];
    [self POST:endPoint parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Successfully Liked");
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"Failed to Like");
    }];
}

- (void)unlikeTweetWithId:(NSString*)tweetId {
    NSString *endPoint = [NSString stringWithFormat:@"1.1/favorites/destroy.json?id=%@",tweetId];
    [self POST:endPoint parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Successfully unliked");
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"Failed to unlike");
    }];
}


- (void)retweetTweetWithId:(NSString*)tweetId {
    NSString *endPoint = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json",tweetId];
    [self POST:endPoint parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {;
    } success:^(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Successfully retweetes");
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"Failed to retweet");
    }];
}

- (void)untweetTweetWithId:(NSString*)tweetId {
    NSString *endPoint = [NSString stringWithFormat:@"1.1/statuses/unretweet/%@.json",tweetId];
    [self POST:endPoint parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Successfully untweeted");
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"Failed to untweet");
    }];
}

- (void)replyToTweetWithId:(NSString*)tweetId andTweetText:(NSString*)tweetText {
    NSString *endPoint = [[NSString stringWithFormat:@"1.1/statuses/update.json?status=%@&in_reply_to_status_id=%@",tweetText, tweetId] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [self POST:endPoint parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Successfully replied");
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"Failed to reply");
    }];
}


- (void)postTweet:(NSString*)tweetText {
    NSString *endPoint = [[NSString stringWithFormat:@"1.1/statuses/update.json?status=%@",tweetText] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"%@",endPoint);
    [self POST:endPoint parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Successfully tweeted");
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"Failed to tweet");
    }];
}


- (void)usersListWithParams:(NSDictionary*)params completion:(void (^)(NSArray *users, NSString*cursor, NSError *error))completion {
    NSString *endPoint = params[@"endPoint"];
    [self GET:endPoint parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
        NSLog(@"Fetching users");
    } success:^(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *users = [[NSMutableArray alloc] init];
        for(NSDictionary *dictionary in responseObject[@"users"]) {
            [users addObject:[User userWithTwitterInfo:dictionary inManagedObjectContext:[CoreDataHelper managedObjectContext]]];
        }
        completion(users,responseObject[@"next_cursor_str"], nil);
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"Failed to fetch users!");
        completion(nil, nil, error);
    }];
}

- (void)tweetsWithParams:(NSDictionary*)params completion:(void (^)(NSArray *users,NSError *error))completion {
    NSString *endPoint = params[@"endPoint"];
    NSLog(@"%@", endPoint);
    if(endPoint) {
        [self GET:endPoint parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
            NSLog(@"Downloading tweets");
        } success:^(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject) {
            NSArray *tweets = [Tweet loadTweetsFromArray:responseObject inManagedObjectContext:[CoreDataHelper managedObjectContext]];
            completion(tweets, nil);
        } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
            NSLog(@"Failed to download tweets!");
            NSLog(@"%@", endPoint);
            completion(nil, error);
        }];
    }
}

@end
