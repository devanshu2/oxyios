//
//  CustomCellFAQ.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/26/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "CustomCellFAQ.h"

@implementation CustomCellFAQ
@synthesize questionLbl, answerLbl, expandBtn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        questionLbl = [[UILabel alloc] init];
        [questionLbl setBackgroundColor:[UIColor clearColor]];
        [questionLbl setTextColor:Dark_Gray_Color];
        [questionLbl setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
        [questionLbl setNumberOfLines:0];
        [self addSubview:questionLbl];
        
        answerLbl = [[UILabel alloc] init];
        [answerLbl setBackgroundColor:[UIColor clearColor]];
        [answerLbl setFont:[UIFont fontWithName:MyriadPro_Regular size:14]];
        [answerLbl setTextColor:Gray_Color];
        [answerLbl setNumberOfLines:0];
        [self addSubview:answerLbl];
        
        expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:expandBtn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
    CGRect questionlblRect = [questionLbl.text boundingRectWithSize:CGSizeMake(screenSize.width-30, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:questionLbl.font forKey:NSFontAttributeName] context:nil];
    [questionLbl setFrame:CGRectMake(15, 10, questionlblRect.size.width, questionlblRect.size.height)];
    
    CGRect answerLblRect = [answerLbl.text boundingRectWithSize:CGSizeMake(screenSize.width-30, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:answerLbl.font forKey:NSFontAttributeName] context:nil];
    [answerLbl setFrame:CGRectMake(15, CGRectGetMaxY(questionLbl.frame)+15, answerLblRect.size.width, answerLblRect.size.height)];
    }
//    else
//    {
//        CGSize questionlblRect = [questionLbl.text sizeWithFont:questionLbl.font constrainedToSize:CGSizeMake(screenSize.width-30, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//        [questionLbl setFrame:CGRectMake(15, 10, questionlblRect.width, questionlblRect.height)];
//        
//        ;
//        CGSize answerLblRect = [answerLbl.text sizeWithFont:answerLbl.font constrainedToSize:CGSizeMake(screenSize.width-30, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//        [answerLbl setFrame:CGRectMake(15, CGRectGetMaxY(questionLbl.frame)+15, answerLblRect.width, answerLblRect.height)];
//    }
    [expandBtn setFrame:questionLbl.frame];
    
}
@end
