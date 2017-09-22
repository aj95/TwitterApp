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

NSString *const UserDidLogInNotification = @"UserDidLoginNotification";
NSString *const UserDidLogOutNotification = @"UserDidLogoutNotification";

@interface User()
@end

@implementation User (Twitter)


+(User*) userWithTwitterInfo:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    NSString *userId = dictionary[@"id_str"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"userId = %@", userId];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || error || [matches count] > 1) {
       //
    } else if ([matches count]) {
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
NSString *const currentUserKey = @"currentUserKey";

+ (User *)currentUser {
    
    if (_currentUser == nil) {
        NSString *loggedInUserId = [[NSUserDefaults standardUserDefaults] stringForKey:currentUserKey];
        if (loggedInUserId != nil) {
            NSManagedObjectContext *managedObjectContext = [CoreDataHelper managedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"userId = %@",loggedInUserId]];
            [fetchRequest setReturnsObjectsAsFaults:NO];
            _currentUser = [[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy] firstObject];
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:currentUser {
    _currentUser = currentUser;
    if (_currentUser != nil) {
        NSString *userId = _currentUser.userId;
        [[NSUserDefaults standardUserDefaults]setObject:userId forKey:currentUserKey];
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
