//
//  Tweet.h
//  ExperimentTwitter
//
//  Created by ayur.j on 25/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *mediaUrl;
@property (nonatomic, strong) NSString *retweetedCount;
@property (nonatomic, strong) NSString *favouriteCount;
@property (nonatomic, strong) NSString* isFavourited;
@property (nonatomic, strong) NSString* isRetweeted;

- (id) initWithDictionary : (NSDictionary *)dictionary;
+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
