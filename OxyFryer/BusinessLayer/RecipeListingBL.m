//
//  RecipeListingBL.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/18/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "RecipeListingBL.h"
#import "RecipeListing.h"
#import "CoreDataModel.h"
static RecipeListingBL *recipeListingBLObj;
@implementation RecipeListingBL

-(void)saveRecipeListing:(NSArray *) recipeListingArr
{
    CoreDataModel *delegate = [CoreDataModel sharedInstance];
    if([delegate.managedObjectContext tryLock])
        [delegate.managedObjectContext lock];
    [self deleteAllItems];
    for (NSDictionary *recipeDict in recipeListingArr) {
         RecipeListing *recipeListingmodel = (RecipeListing *)[NSEntityDescription insertNewObjectForEntityForName:@"RecipeListing" inManagedObjectContext:delegate.managedObjectContext];
        if(HAS_DATA(recipeDict, KEY_ID))
            [recipeListingmodel setRecipe_id:[recipeDict objectForKey:KEY_ID]];
        if(HAS_DATA(recipeDict, KEY_featured_image_url))
            [recipeListingmodel setRecipe_img_url:[recipeDict objectForKey:KEY_featured_image_url]];
        if(HAS_DATA(recipeDict, KEY_recipe_category))
            [recipeListingmodel setRecipe_category:[recipeDict objectForKey:KEY_recipe_category]];
        if(HAS_DATA(recipeDict, KEY_recipe_title))
            [recipeListingmodel setRecipe_title:[recipeDict objectForKey:KEY_recipe_title]];
        if(HAS_DATA(recipeDict, KEY_recipe_type))
            [recipeListingmodel setRecipe_type:[recipeDict objectForKey:KEY_recipe_type]];
        if(HAS_DATA(recipeDict, KEY_recipe_youtube_url))
            [recipeListingmodel setRecipe_youtube_url:[recipeDict objectForKey:KEY_recipe_youtube_url]];
        if(HAS_DATA(recipeDict, KEY_rp_max_cook_time))
            [recipeListingmodel setRp_max_cook_time:[recipeDict objectForKey:KEY_rp_max_cook_time]];
        if(HAS_DATA(recipeDict, KEY_rp_max_preparation_time))
            [recipeListingmodel setRp_max_preparation_time:[recipeDict objectForKey:KEY_rp_max_preparation_time]];
        if(HAS_DATA(recipeDict, KEY_rp_min_cook_time))
            [recipeListingmodel setRp_min_cook_time:[recipeDict objectForKey:KEY_rp_min_cook_time]];
        if(HAS_DATA(recipeDict, KEY_rp_min_preparation_time))
            [recipeListingmodel setRp_min_preparation_time:[recipeDict objectForKey:KEY_rp_min_preparation_time]];
        if(HAS_DATA(recipeDict, KEY_rp_quantity))
            [recipeListingmodel setRp_quantity:[recipeDict objectForKey:KEY_rp_quantity]];
        if(HAS_DATA(recipeDict, KEY_rp_temprature))
            [recipeListingmodel setRp_teperature:[recipeDict objectForKey:KEY_rp_temprature]];
    }
    NSError *error;
    if (![delegate.managedObjectContext save:&error]) {
        DLog(@"Save Error when updating: %@", [error localizedDescription]);
        
    }
    
    [delegate.managedObjectContext unlock];
}

-(void)deleteAllItems
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    CoreDataModel *delegate = [CoreDataModel sharedInstance];
    if([delegate.managedObjectContext tryLock])
        [delegate.managedObjectContext lock];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecipeListing" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    
    
    // Execute the fetch -- create a mutable copy of the result.
    NSError *error = nil;
    NSArray *mutableFetchResults = [delegate.managedObjectContext executeFetchRequest:request error:&error] ;
    if (mutableFetchResults == nil) {
        DLog(@"No Option schedulded with this type");
    }
    
    for (RecipeListing *recipeListingObjObj in mutableFetchResults) {
        [delegate.managedObjectContext deleteObject:recipeListingObjObj];
        NSError *error;
        if (![delegate.managedObjectContext save:&error]) {
            DLog(@"Error d eleting - error:%@", error);
        }
        
    }
    
    [delegate.managedObjectContext unlock];
    
  
}


-(NSArray *)fetchRecipeListingData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	CoreDataModel *delegate = [CoreDataModel sharedInstance];
	if([delegate.managedObjectContext tryLock])
        [delegate.managedObjectContext lock];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecipeListing" inManagedObjectContext:delegate.managedObjectContext];
    [request setEntity:entity];
    
    
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSArray *mutableFetchResults = [delegate.managedObjectContext executeFetchRequest:request error:&error] ;
    
	if (mutableFetchResults == nil) {
		DLog(@"No Option schedulded with this type");
	}
    
    [delegate.managedObjectContext unlock];
    return mutableFetchResults;

}

#pragma mark ---- singleton object methods ----

// See "Creating a Singleton Instance" in the Cocoa Fundamentals Guide for more info

+ (RecipeListingBL *)sharedInstance {
    @synchronized(self) {
        if (recipeListingBLObj == nil) {
			recipeListingBLObj =  [[RecipeListingBL alloc] init];
        }
    }
    return recipeListingBLObj;
}

@end
