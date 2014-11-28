//
//  RecipeDetailBL.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/27/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "RecipeDetailBL.h"
#import "ModelRecipeDetail.h"
@implementation RecipeDetailBL
static RecipeDetailBL *RecipeDetailBLObj;

-(ModelRecipeDetail *)getRecipeDetailModel:(NSDictionary *)recipeDetailDict modelRecipeDetail:(ModelRecipeDetail *)model
{
    if(HAS_DATA(recipeDetailDict, KEY_rp_min_preparation_time))
      [model setRp_min_preparation_time:[recipeDetailDict objectForKey:KEY_rp_min_preparation_time]];
    if(HAS_DATA(recipeDetailDict, KEY_rp_max_preparation_time))
        [model setRp_max_preparation_time:[recipeDetailDict objectForKey:KEY_rp_max_preparation_time]];
    if(HAS_DATA(recipeDetailDict, KEY_rp_quantity))
        [model setRp_quantity:[recipeDetailDict objectForKey:KEY_rp_quantity]];
    if(HAS_DATA(recipeDetailDict, KEY_rp_max_cook_time))
        [model setRp_max_cook_time:[recipeDetailDict objectForKey:KEY_rp_max_cook_time]];
    if(HAS_DATA(recipeDetailDict, KEY_rp_category))
        [model setRp_category:[recipeDetailDict objectForKey:KEY_rp_category]];
    if(HAS_DATA(recipeDetailDict, KEY_rp_description))
        [model setRpHowToCook:[recipeDetailDict objectForKey:KEY_rp_description]];
    if(HAS_DATA(recipeDetailDict, KEY_rp_image_url))
        [model setRp_image_url:[recipeDetailDict objectForKey:KEY_rp_image_url]];
    if(HAS_DATA(recipeDetailDict, KEY_rp_ingredients))
        [model setRp_ingredients:[recipeDetailDict objectForKey:KEY_rp_ingredients]];
    if(HAS_DATA(recipeDetailDict, KEY_rp_type))
        [model setRp_type:[recipeDetailDict objectForKey:KEY_rp_type]];
    if(HAS_DATA(recipeDetailDict, KEY_rp_min_cook_time))
        [model setRp_min_cook_time:[recipeDetailDict objectForKey:KEY_rp_min_cook_time]];
    if(HAS_DATA(recipeDetailDict, KEY_rp_modified_on))
        [model setRp_modified_on:[recipeDetailDict objectForKey:KEY_rp_modified_on]];
    if(HAS_DATA(recipeDetailDict, KEY_rp_name))
        [model setRp_name:[recipeDetailDict objectForKey:KEY_rp_name]];
    if(HAS_DATA(recipeDetailDict, KEY_rp_id))
        [model setRp_id:[recipeDetailDict objectForKey:KEY_rp_id]];
    if(HAS_DATA(recipeDetailDict, KEY_rp_youtube_url))
        [model setRp_youtube_url:[recipeDetailDict objectForKey:KEY_rp_youtube_url]];
    if(HAS_DATA(recipeDetailDict, KEY_rp_temprature))
        [model setRp_temperature:[recipeDetailDict objectForKey:KEY_rp_temprature]];
    return model;
}

#pragma mark ---- singleton object methods ----

// See "Creating a Singleton Instance" in the Cocoa Fundamentals Guide for more info

+ (RecipeDetailBL *)sharedInstance {
    @synchronized(self) {
        if (RecipeDetailBLObj == nil) {
            RecipeDetailBLObj =  [[RecipeDetailBL alloc] init]; // assignment not done here
        }
    }
    return RecipeDetailBLObj;
}

@end
