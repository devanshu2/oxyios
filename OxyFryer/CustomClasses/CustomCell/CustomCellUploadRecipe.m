//
//  CustomCellUploadRecipe.m
//  OxyFryer
//
//  Created by Richa Goyal on 10/10/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "CustomCellUploadRecipe.h"

@implementation CustomCellUploadRecipe
@synthesize titleLbl, txtFld1, txtFld2;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, screenSize.width-30, 12)];
        [titleLbl setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
        [titleLbl setTextColor:Gray_Color];
        [titleLbl setBackgroundColor:[UIColor clearColor]];
        [self addSubview:titleLbl];
        
        txtFld1 = [[UITextField alloc] initWithFrame:CGRectMake(15, 35, (screenSize.width-30-15)/2, 23)];
        [txtFld1 setBackgroundColor:[UIColor colorWithRed:241/255.f green:243/255.f blue:242/255.f alpha:1.f]];
        [txtFld1 setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
        [txtFld1 setTextColor:Gray_Color];
        UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 23)];
        [txtFld1 setLeftView:vw];
        [txtFld1 setLeftViewMode:UITextFieldViewModeAlways];
        [txtFld1.layer setBorderWidth:1];
        [txtFld1.layer setBorderColor:[UIColor colorWithRed:227/255.f green:227/255.f blue:227/255.f alpha:1.f].CGColor];
        [self addSubview:txtFld1];
        
        
        txtFld2 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(txtFld1.frame)+15, 35, (screenSize.width-30-30)/2, 23)];
        [txtFld2 setBackgroundColor:[UIColor colorWithRed:241/255.f green:243/255.f blue:242/255.f alpha:1.f]];
        [txtFld2 setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
        [txtFld2 setTextColor:Gray_Color];
        UIView *vw2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 23)];
        [txtFld2 setLeftView:vw2];
        [txtFld2 setLeftViewMode:UITextFieldViewModeAlways];
        [txtFld2.layer setBorderWidth:1];
        [txtFld2.layer setBorderColor:[UIColor colorWithRed:227/255.f green:227/255.f blue:227/255.f alpha:1.f].CGColor];
        [self addSubview:txtFld2];
      
    }
    return self;
}

@end
