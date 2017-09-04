//
//  TwitterClient.m
//  ExperimentTwitter
//
//  Created by ayur.j on 25/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const twitterConsumerKey = @"2RV0vPnG8lbcdOqDL9nBl9y0E";
NSString * const twitterConsumerSecret = @"1ua0pfkMArkBzuHxQhpAK4MQda7AhSs2n4g6BxQVLbAIyifRRo";
NSString * const twitterBaseURL = @"https://api.twitter.com";

@interface TwitterClient()
@property (nonatomic, strong) void(^loginCompletion)(User *user, NSError *error);
@end


@implementation TwitterClient
+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL: [NSURL URLWithString:twitterBaseURL] consumerKey:twitterConsumerKey consumerSecret: twitterConsumerSecret];
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
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"Fetching user");
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            User* user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"Current User : %@",user.name);
            self.loginCompletion(user, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Failed to get current user");
            self.loginCompletion(nil, error);
        }];
    }failure:^(NSError *error) {
        NSLog(@"Failed to get access token");
        self.loginCompletion(nil, error);
    }];
}

- (void)homeTimelineWithParams:(NSDictionary*)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    NSLog(@"Hi");
    NSString* maxId = [NSString stringWithFormat:@"%ld",[params[@"maxId"] integerValue] - 1];
    NSString *endPoint = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"1.1/statuses/home_timeline.json%@",[params objectForKey:@"maxId"] != nil ? [NSString stringWithFormat:@"?max_id=%@",maxId] : @""]];
    [self GET:endPoint parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"Fetching user");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)followersListWithParams:(NSDictionary*)params completion:(void (^)(NSArray *followers, NSString* cursor, NSError *error))completion {
    NSLog(@"%@", params[@"cursor"]);
    [self GET:[NSString stringWithFormat:@"1.1/friends/list.json?cursor=%@",params[@"cursor"]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"Fetching followers");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *followers = [[NSMutableArray alloc] init];
        //NSLog(@"List of Followers : %@", [responseObject[@"users"] firstObject]);
        for(NSDictionary *dictionary in responseObject[@"users"]) {
            [followers addObject:[[User alloc] initWithDictionary:dictionary]];
        }
        //NSLog(@"Your Followers : %@", ((User*)[followers firstObject]).name);
        completion(followers,responseObject[@"next_cursor_str"], nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, nil, error);
    }];
}

- (void)userTimelineWithParams:(NSDictionary*)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    NSLog(@"Hi");
    NSString* maxId = [NSString stringWithFormat:@"%ld",[params[@"maxId"] integerValue] - 1];
    NSString *endPoint = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"1.1/statuses/user_timeline.json?screen_name=%@%@",[params objectForKey:@"screenName"], [params objectForKey:@"maxId"] != nil ? [NSString stringWithFormat:@"&max_id=%@",maxId] : @""]];
    NSLog(@"%@", endPoint);
    [self GET:endPoint parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"Fetching user");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}




@end
