//
//  FAQBL.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/26/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "FAQBL.h"
#import "ModelFAQ.h"
static FAQBL *FAQBLObj;

@implementation FAQBL

-(NSArray *)faqModelDataArray:(NSArray *)dataArr
{
    NSMutableArray *modelArr = [NSMutableArray array];
    
    for (NSDictionary *dict in dataArr) {
        ModelFAQ *modFaq = [[ModelFAQ alloc] init];
        if(HAS_DATA(dict, KEY_faq_category))
            [modFaq setFaq_category:[dict objectForKey:KEY_faq_category]];
        if(HAS_DATA(dict, KEY_faq_question))
            [modFaq setFaq_question:[dict objectForKey:KEY_faq_question]];
        if(HAS_DATA(dict, KEY_faq_answer))
            [modFaq setFaq_answer:[dict objectForKey:KEY_faq_answer]];
        [modelArr addObject:modFaq];
    }
    return modelArr;
}

#pragma mark ---- singleton object methods ----

// See "Creating a Singleton Instance" in the Cocoa Fundamentals Guide for more info

+ (FAQBL *)sharedInstance {
    @synchronized(self) {
        if (FAQBLObj == nil) {
            FAQBLObj =  [[FAQBL alloc] init]; // assignment not done here
        }
    }
    return FAQBLObj;
}

@end
