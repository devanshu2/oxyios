//
//  CustomCellQuey1.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/26/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "CustomCellQuey1.h"

@implementation CustomCellQuey1
@synthesize titleLbl, txtFld;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, screenSize.width-30, 12)];
        [titleLbl setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
        [titleLbl setTextColor:Gray_Color];
        [titleLbl setNumberOfLines:0];
        [titleLbl setBackgroundColor:[UIColor clearColor]];
        [self addSubview:titleLbl];
        
        txtFld = [[UITextField alloc] initWithFrame:CGRectMake(15, 35, screenSize.width-30, 23)];
        [txtFld setBackgroundColor:[UIColor colorWithRed:241/255.f green:243/255.f blue:242/255.f alpha:1.f]];
        [txtFld setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
        [txtFld setTextColor:Gray_Color];
        UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 23)];
        [txtFld setLeftView:vw];
        [txtFld setLeftViewMode:UITextFieldViewModeAlways];
        [txtFld.layer setBorderWidth:1];
        [txtFld.layer setBorderColor:[UIColor colorWithRed:227/255.f green:227/255.f blue:227/255.f alpha:1.f].CGColor];
        [self addSubview:txtFld];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [txtFld setFrame:CGRectMake(15, self.frame.size.height-23, screenSize.width-30, 23)];
    [titleLbl setFrame:CGRectMake(15, 15, screenSize.width-30, self.frame.size.height-15-23-6)];
}

@end
