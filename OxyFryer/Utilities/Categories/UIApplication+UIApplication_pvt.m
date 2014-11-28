//
//  UIApplication+UIApplication_pvt.m
//  GroupOnGo
//
//  Created by Richa Goyal1 on 5/8/14.
//  Copyright (c) 2014 Richa Goyal1. All rights reserved.
//

#import "UIApplication+UIApplication_pvt.h"

@implementation UIApplication (UIApplication_pvt)
- (NSString*)getUUID {
    
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    
    static NSString *uuid = nil;
    
    // try to get the NSUserDefault identifier if exist
    if (uuid == nil) {
        
        uuid = [standardUserDefault objectForKey:@"UniversalUniqueIdentifier"];
    }
    
    // if there is not NSUserDefault identifier generate one and store it
    if (uuid == nil) {
        
        uuid = UUID ();
        [standardUserDefault setObject:uuid forKey:@"UniversalUniqueIdentifier"];
        [standardUserDefault synchronize];
    }
    
    return uuid;
}

NSString* UUID () {
    
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge NSString *)uuidStringRef;
}
@end
