//
//  ModelRecipeDetail.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/27/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "ModelRecipeDetail.h"

@implementation ModelRecipeDetail
@synthesize rp_min_preparation_time;
@synthesize rp_max_preparation_time;
@synthesize rp_quantity;
@synthesize rp_max_cook_time;
@synthesize rp_category;
@synthesize RpHowToCook;
@synthesize rp_image_url;
@synthesize rp_ingredients;
@synthesize rp_type;
@synthesize rp_min_cook_time;
@synthesize rp_modified_on;
@synthesize rp_name;
@synthesize rp_id;
@synthesize rp_youtube_url;
@synthesize rp_temperature;
-(id)init
{
    self= [super init];
    if(self)
    {
        self.rp_min_preparation_time = [NSNumber numberWithInt:0];
        self.rp_max_preparation_time = [NSNumber numberWithInt:0];
        self.rp_max_cook_time = [NSNumber numberWithInt:0];
        self.rp_max_preparation_time = [NSNumber numberWithInt:0];
        self.rp_category = [NSNumber numberWithInt:0];
        self.rp_type = [NSNumber numberWithInt:0];
        self.rp_quantity = [NSNumber numberWithInt:0];
        self.rp_id = [NSNumber numberWithInt:0];
        self.rp_youtube_url = @"";
        self.RpHowToCook = @"";
        self.rp_image_url = @"";
        self.rp_ingredients = @"";
        self.rp_name = @"";
        self.rp_modified_on = @"";
        self.rp_temperature = @"";
    }
    return self;
}



@end


