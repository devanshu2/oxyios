//
//  CoreDataModel.h
//  PVR
//
//  Created by Animesh Agarwal on 05/10/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "CoreDataModel.h"

static CoreDataModel *model = nil;

@implementation CoreDataModel

-(id)init
{	
	if (self = [super init])
	{		
		[self managedObjectContext];		
	}	
	return self;	
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext 
{
	if (managedObjectContext != nil) 
	{
		return managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) 
	{
		managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
		[managedObjectContext setPersistentStoreCoordinator: coordinator];
	}
	return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	// managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];  
	NSString *path = [[NSBundle mainBundle] pathForResource:@"OxyFryer" ofType:@"momd"];
	NSURL *momURL = [NSURL fileURLWithPath:path];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator 
{
	if (persistentStoreCoordinator != nil) 
	{
		return persistentStoreCoordinator;
	}	
	
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"OxyFryer.sqlite"];
	
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) 
	{
//		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"GroupOnGo" ofType:@"sqlite"];
//		if (false && defaultStorePath) 
//		{
//			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
////            [SharedFunctions addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:defaultStorePath]];
//		}
//		else {
//		}
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	NSError *error;
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle the error.
		//DLog(@"error: %@", [error localizedFailureReason]);
    }    
	
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark ---- singleton object methods ----

// See "Creating a Singleton Instance" in the Cocoa Fundamentals Guide for more info

+ (CoreDataModel *)sharedInstance {
    @synchronized(self) {
        if (model == nil) {
			model =  [[CoreDataModel alloc] init]; // assignment not done here
        }
    }
    return model;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (model == nil) {
            model = [super allocWithZone:zone];
            return model;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


@end
