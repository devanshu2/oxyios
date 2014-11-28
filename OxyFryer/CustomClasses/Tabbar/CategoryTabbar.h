//
//  CategoryTabbar.h
//  OxyFryer
//
//  Created by Richa Goyal on 9/25/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    CategorySelectedAll,
    CategorySelectedVeg,
    CategorySelectedNonVeg,
    CategorySelectedStarter,
    CategorySelectedMainCourse,
    CategorySelectedDessert
}CategorySelected;

@protocol CategoryTabBarDelegate <NSObject>

-(void)categoryButtonTapped:(NSDictionary *)catDict;


@end

@interface CategoryTabbar : UIView <UIScrollViewDelegate>
{
    CategorySelected categorySelected;
    UIButton *selectedBtn;
    UIScrollView *scrollVw;
    id<CategoryTabBarDelegate> delegate;
}
@property (nonatomic, assign)CategorySelected categorySelected;
@property (nonatomic, strong)id<CategoryTabBarDelegate> delegate;
-(void)createTabBar:(CGRect)frame;
-(void)tapAllButton;
@end
