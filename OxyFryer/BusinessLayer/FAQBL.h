//
//  FAQBL.h
//  OxyFryer
//
//  Created by Richa Goyal on 9/26/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAQBL : NSObject
-(NSArray *)faqModelDataArray:(NSArray *)dataArr;
+ (FAQBL *)sharedInstance;
@end
