//
//  RecipeListingBL.h
//  OxyFryer
//
//  Created by Richa Goyal on 9/18/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeListingBL : NSObject
-(void)saveRecipeListing:(NSArray *) recipeListingArr;
-(NSArray *)fetchRecipeListingData;
+ (RecipeListingBL *)sharedInstance;
@end
