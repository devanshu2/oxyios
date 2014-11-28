//
//  PlayerControllerVC.m
//  OxyFryer
//
//  Created by Richa Goyal on 9/30/14.
//  Copyright (c) 2014 Richa Goyal. All rights reserved.
//

#import "PlayerControllerVC.h"

@implementation PlayerControllerVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    [APP_DELEGATE setIsMoviePlayerOpened:YES];
   
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                            object:nil];
    [self.navigationController setNavigationBarHidden:YES];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        //        if(UIDeviceOrientationIsLandscape(self.interfaceOrientation))
        //           {
        //             objc_msgSend([UIDevice currentDevice], @selector(setOrientation:),self.interfaceOrientation );
        //           }
        //           else
        //            objc_msgSend([UIDevice currentDevice], @selector(setOrientation:),    UIDeviceOrientationLandscapeRight);
        //        objc_msgSend([UIDevice currentDevice], @selector(setOrientation:),    UIDeviceOrientationLandscapeRight);
        objc_msgSend([UIDevice currentDevice], @selector(setOrientation:),    UIDeviceOrientationLandscapeLeft);
    }
}
-(void)moviePlayBackDidFinish:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
     [APP_DELEGATE setIsMoviePlayerOpened:NO];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        objc_msgSend([UIDevice currentDevice], @selector(setOrientation:),    UIInterfaceOrientationPortrait );
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
}
//- (BOOL)shouldAutorotate 
//{
//    return NO;
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationLandscapeLeft;
//}

@end
