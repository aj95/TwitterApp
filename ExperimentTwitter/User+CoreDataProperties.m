//
//  User+CoreDataProperties.m
//  ExperimentTwitter
//
//  Created by ayur.j on 12/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic name;
@dynamic userId;
@dynamic screenName;
@dynamic profileImageUrl;
@dynamic tweets;
@dynamic followers;
@dynamic following;

@end
