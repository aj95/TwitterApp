//
//  Tweet+CoreDataProperties.m
//  ExperimentTwitter
//
//  Created by ayur.j on 12/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "Tweet+CoreDataProperties.h"

@implementation Tweet (CoreDataProperties)

+ (NSFetchRequest<Tweet *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Tweet"];
}

@dynamic tweetId;
@dynamic text;
@dynamic createdAt;
@dynamic retweetedCount;
@dynamic mediaUrl;
@dynamic favouriteCount;
@dynamic isFavourited;
@dynamic isRetweeted;
@dynamic user;

@end
