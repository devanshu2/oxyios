//
//  ModelRecipeDetail.h
//  OxyFryer
//
//  Created by Richa Goyal on 9/27/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelRecipeDetail : NSObject
@property(nonatomic, strong)NSNumber *rp_min_preparation_time;
@property(nonatomic, strong)NSNumber *rp_max_preparation_time;
@property(nonatomic, strong)NSNumber *rp_quantity;
@property(nonatomic, strong)NSNumber *rp_max_cook_time;
@property(nonatomic, strong)NSNumber *rp_category;
@property(nonatomic, strong)NSString *RpHowToCook;
@property(nonatomic, strong)NSString *rp_image_url;
@property(nonatomic, strong)NSString *rp_ingredients;
@property(nonatomic, strong)NSNumber *rp_type;
@property(nonatomic, strong)NSNumber *rp_min_cook_time;
@property(nonatomic, strong)NSString *rp_modified_on;
@property(nonatomic, strong)NSString *rp_name;
@property(nonatomic, strong)NSNumber *rp_id;
@property(nonatomic, strong)NSString *rp_youtube_url;
@property(nonatomic, strong)NSString *rp_temperature;
@end
