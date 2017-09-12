//
//  CoreDataHelper.m
//  ExperimentTwitter
//
//  Created by ayur.j on 12/09/17.
//  Copyright © 2017 ayur.j. All rights reserved.
//

#import "CoreDataHelper.h"
#import "UIKit/UIKit.h"

@implementation CoreDataHelper

+ (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate respondsToSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


+ (void)saveManagedObjectContext {
    NSError *error = nil;
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    if (![context save:&error]) {
        NSLog(@"Failed to save! %@ %@", error, [error localizedDescription]);
    }
}

@end
