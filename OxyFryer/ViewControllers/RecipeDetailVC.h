//
//  RecipeDetailVC.h
//  OxyFryer
//
//  Created by Richa Goyal on 9/27/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModelRecipeDetail;
@interface RecipeDetailVC : UIViewController
{
    BOOL videoPlaying;
    BOOL isFromPush;
}
@property(nonatomic, strong)ModelRecipeDetail *recipeModel;
@property(nonatomic, assign)BOOL isFromPush;
@end
