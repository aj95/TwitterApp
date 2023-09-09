//
//  Tweet+CoreDataProperties.h
//  ExperimentTwitter
//
//  Created by ayur.j on 12/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "Tweet+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Tweet (CoreDataProperties)

+ (NSFetchRequest<Tweet *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *tweetId;
@property (nullable, nonatomic, copy) NSString *text;
@property (nullable, nonatomic, copy) NSDate *createdAt;
@property (nonatomic) int64_t retweetedCount;
@property (nullable, nonatomic, copy) NSString *mediaUrl;
@property (nonatomic) int64_t favouriteCount;
@property (nonatomic) BOOL isFavourited;
@property (nonatomic) BOOL isRetweeted;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
