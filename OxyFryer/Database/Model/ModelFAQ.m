//
//  ModelFAQ.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/26/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "ModelFAQ.h"

@implementation ModelFAQ
@synthesize faq_question;
@synthesize faq_answer;
@synthesize faq_category;

-(id)init
{
    self= [super init];
    if(self)
    {
        self.faq_category = [NSNumber numberWithInt:0];
        self.faq_question = @"";
        self.faq_answer =@"";
    }
    return self;
}

@end
