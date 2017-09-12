//
//  Tweet+Twitter.m
//  ExperimentTwitter
//
//  Created by ayur.j on 11/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "Tweet+Twitter.h"
#import "User+Twitter.h"
#import "CoreDataHelper.h"

@implementation Tweet (Twitter)

+ (Tweet*) tweetWithTwitterInfo:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Tweet *tweet = nil;
    NSString* tweetId = dictionary[@"id_str"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    request.predicate = [NSPredicate predicateWithFormat:@"tweetId = %@", tweetId];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if(!matches || error || [matches count] > 1) {
        //
    } else if([matches count]) {
        tweet = [matches firstObject];
    } else {
        tweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:context];
        tweet.tweetId = dictionary[@"id_str"];
        tweet.text = dictionary[@"text"];
        tweet.user = [User userWithTwitterInfo:dictionary[@"user"] inManagedObjectContext:context];
        [tweet.user addTweetsObject:tweet];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        tweet.createdAt = [dateFormatter dateFromString:dictionary[@"created_at"]];
        NSDictionary *entities = dictionary[@"entities"];
        NSArray *media = entities[@"media"];
        tweet.mediaUrl = media.firstObject[@"media_url_https"];
        tweet.retweetedCount = [[NSString stringWithFormat:@"%@", dictionary[@"retweet_count"]] longLongValue];
        tweet.favouriteCount = [[NSString stringWithFormat:@"%@", dictionary[@"favorite_count"]] longLongValue];
        tweet.isFavourited = [[NSString stringWithFormat:@"%@", dictionary[@"favorited"]] boolValue];
        tweet.isRetweeted = [[NSString stringWithFormat:@"%@", dictionary[@"retweeted"]] boolValue];
        [CoreDataHelper saveManagedObjectContext];
    }
    return tweet;
}

+ (NSArray*) loadTweetsFromArray:(NSArray *)array inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableArray *tweets = [NSMutableArray array];
    for(NSDictionary *dictionary in array) {
        [tweets addObject:[self tweetWithTwitterInfo:dictionary inManagedObjectContext:context]];
    }
    return tweets;
}

@end
