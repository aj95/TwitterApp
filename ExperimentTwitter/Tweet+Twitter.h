//
//  Tweet+Twitter.h
//  ExperimentTwitter
//
//  Created by ayur.j on 11/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "Tweet+CoreDataClass.h"

@interface Tweet (Twitter)

+ (Tweet*)tweetWithTwitterInfo:(NSDictionary*)dictionary inManagedObjectContext:(NSManagedObjectContext*)context;
+ (NSArray*)loadTweetsFromArray:(NSArray*)array inManagedObjectContext:(NSManagedObjectContext*) context;

@end
