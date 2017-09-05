//
//  Tweet.m
//  ExperimentTwitter
//
//  Created by ayur.j on 25/08/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        self.tweetId = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [dateFormatter dateFromString:dictionary[@"created_at"]];
        NSDictionary *entities = dictionary[@"entities"];
        NSArray *media = entities[@"media"];
        self.mediaUrl = media.firstObject[@"media_url_https"];
        self.retweetedCount = [NSString stringWithFormat:@"%@", dictionary[@"retweet_count"]];
        self.favouriteCount = [NSString stringWithFormat:@"%@", dictionary[@"favorite_count"]];
        self.isFavourited = [NSString stringWithFormat:@"%@", dictionary[@"favorited"]];
        self.isRetweeted = [NSString stringWithFormat:@"%@", dictionary[@"retweeted"]];
    }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for(NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

@end
