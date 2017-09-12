//
//  User+Twitter.h
//  ExperimentTwitter
//
//  Created by ayur.j on 11/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "User+CoreDataClass.h"

extern NSString * const UserDidLogInNotification;
extern NSString * const UserDidLogOutNotification;

@interface User (Twitter)
+ (User*) userWithTwitterInfo:(NSDictionary*) dictionary inManagedObjectContext:(NSManagedObjectContext*) context;
+(User *)currentUser;
+(void)setCurrentUser:currentUser;
+(void)logout;
@end
