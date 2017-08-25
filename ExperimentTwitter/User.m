//
//  User.m
//  ExperimentTwitter
//
//  Created by ayur.j on 25/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLogInNotification = @"UserDidLoginNotification";
NSString * const UserDidLogOutNotification = @"UserDidLogoutNotification";

@interface User()
@property (nonatomic, strong) NSDictionary *dictionary;
@end

@implementation User

- (id) initWithDictionary : (NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        self.dictionary = dictionary;
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url_https"];
        self.userId = dictionary[@"id_str"];
    }
    return self;
}

static User *_currentUser = nil;
NSString * const currentUserKey = @"currentUserKey";

+(User *)currentUser {
    if(_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:currentUserKey];
        if(data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}
+(void)setCurrentUser:currentUser {
    _currentUser = currentUser;
    if(_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:currentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:currentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)logout {
    [self setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    NSLog(@"Logged out successfully");
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogOutNotification object:nil];
}
@end
