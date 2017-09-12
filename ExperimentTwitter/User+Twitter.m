//
//  User+Twitter.m
//  ExperimentTwitter
//
//  Created by ayur.j on 11/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "User+Twitter.h"
#import "TwitterClient.h"
#import "CoreDataHelper.h"

NSString * const UserDidLogInNotification = @"UserDidLoginNotification";
NSString * const UserDidLogOutNotification = @"UserDidLogoutNotification";

@interface User()
@property (nonatomic, strong) NSDictionary *dictionary;
@end


@implementation User (Twitter)

+(User*) userWithTwitterInfo:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    NSString* userId = dictionary[@"id_str"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"userId = %@", userId];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if(!matches || error || [matches count] > 1) {
       //
    } else if([matches count]) {
        user = [matches firstObject];
    } else {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        user.name = dictionary[@"name"];
        user.screenName = dictionary[@"screen_name"];
        user.profileImageUrl = dictionary[@"profile_image_url_https"];
        user.userId = dictionary[@"id_str"];
        [CoreDataHelper saveManagedObjectContext];
    }
    return user;
}

static User *_currentUser = nil;
NSString * const currentUserKey = @"currentUserKey";


+ (User *)currentUser {
    if(_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:currentUserKey];
        if(data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"%@",dictionary);
            _currentUser = [User userWithTwitterInfo:dictionary inManagedObjectContext:[CoreDataHelper managedObjectContext]];
            
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:currentUser {
    _currentUser = currentUser;
    NSLog(@"%@",_currentUser.dictionary);
    if(_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:currentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:currentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (void)logout {
    [self setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    NSLog(@"Logged out successfully");
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogOutNotification object:nil];
}

@end
