//
//  UIView+ResignResponder.m
//
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import "UIView+ResignResponder.h"


@implementation UIView (ResignFirstResponder)

- (BOOL)resignFirstResonder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in self.subviews) {
        if ([subView resignFirstResonder])
            return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self resignFirstResonder];
	[super touchesBegan:touches withEvent:event];
}



@end

