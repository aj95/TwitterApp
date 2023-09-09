//
//  CoreDataHelper.h
//  ExperimentTwitter
//
//  Created by ayur.j on 12/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData/CoreData.h"

@interface CoreDataHelper : NSObject
+ (NSManagedObjectContext *)managedObjectContext;
+ (void)saveManagedObjectContext;
@end
