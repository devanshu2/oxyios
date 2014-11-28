//
//  CoreDataModel.h
//  CRM
//
//  Created by Animesh Agarwal on 05/10/12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/*!
 @class			CoreDataModel
 @abstract		An instance of NSObject class
 @discussion	Class creates and manages the persistent store coordinator for the application
 */
@interface CoreDataModel : NSObject 
{		
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/*!
    @function	
    @abstract It returns the shared instance of Core Data Model
    @result	Returns the shared instance of Core Data Model
*/
+ (CoreDataModel *)sharedInstance;

/*!
 @function	
 @abstract	It returns the path to the application's documents directory.
 @result		Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory;

@end
