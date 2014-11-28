//
//  RecipeListing.h
//  OxyFryer
//
//  Created by Richa Goyal on 9/30/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RecipeListing : NSManagedObject

@property (nonatomic, retain) NSNumber * recipe_category;
@property (nonatomic, retain) NSNumber * recipe_id;
@property (nonatomic, retain) NSString * recipe_img_url;
@property (nonatomic, retain) NSString * recipe_title;
@property (nonatomic, retain) NSNumber * recipe_type;
@property (nonatomic, retain) NSString * recipe_youtube_url;
@property (nonatomic, retain) NSNumber * rp_max_cook_time;
@property (nonatomic, retain) NSNumber * rp_max_preparation_time;
@property (nonatomic, retain) NSNumber * rp_min_cook_time;
@property (nonatomic, retain) NSNumber * rp_min_preparation_time;
@property (nonatomic, retain) NSNumber * rp_quantity;
@property (nonatomic, retain) NSString * rp_teperature;

@end
