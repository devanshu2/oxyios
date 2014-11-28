//
//  RecipeDetailBL.h
//  OxyFryer
//
//  Created by Richa Goyal on 9/27/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ModelRecipeDetail;
@interface RecipeDetailBL : NSObject
-(ModelRecipeDetail *)getRecipeDetailModel:(NSDictionary *)recipeDetailDict modelRecipeDetail:(ModelRecipeDetail *)modelRecipeDetail;
+ (RecipeDetailBL *)sharedInstance;
@end
