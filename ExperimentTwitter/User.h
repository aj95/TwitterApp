//
//  User.h
//  ExperimentTwitter
//
//  Created by ayur.j on 25/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLogInNotification;
extern NSString * const UserDidLogOutNotification;

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *profileImageUrl;


- (id) initWithDictionary : (NSDictionary *)dictionary;
+(User *)currentUser;
+(void)setCurrentUser:currentUser;
+(void)logout;
@end
