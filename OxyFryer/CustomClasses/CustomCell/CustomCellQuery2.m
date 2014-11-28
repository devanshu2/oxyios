//
//  CustomCellQuery2.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/26/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "CustomCellQuery2.h"

@implementation CustomCellQuery2
@synthesize titleLbl, txtVw;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, screenSize.width-30, 12)];
        [titleLbl setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
        [titleLbl setTextColor:Gray_Color];
        [titleLbl setBackgroundColor:[UIColor clearColor]];
        [self addSubview:titleLbl];
        
        txtVw = [[UITextView alloc] initWithFrame:CGRectMake(15, 35, screenSize.width-30, 100)];
        [txtVw setBackgroundColor:[UIColor colorWithRed:241/255.f green:243/255.f blue:242/255.f alpha:1.f]];
        [txtVw setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
        [txtVw setTextColor:Gray_Color];
        [txtVw.layer setBorderWidth:1];
        [txtVw.layer setBorderColor:[UIColor colorWithRed:227/255.f green:227/255.f blue:227/255.f alpha:1.f].CGColor];
        [self addSubview:txtVw];
        
    }
    return self;
}


@end
